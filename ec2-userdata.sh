#!/bin/bash

#  Environment Variables usage:
#
#  - TELEGRAM_TOKEN required
#  - TELEGRAM_CHAT_ID required
#  - EXCHANGE_NAME default: binance
#  - EXCHANGE_KEY
#  - EXCHANGE_SECRET
#  - MAX_OPEN_TRADES default: 10
#  - FIAT_DISPLAY_CURRENCY default: USD
#  - STARTKIT_REPOSITORY_URL default: https://github.com/ftgibran/freqtrade-startkit.git
#  - STRATEGY default: StandardStrategy
#  - DRY_RUN default: true
#  - DRY_RUN_WALLET default: 1000
#  - PROCESS_THROTTLE_SECS: 5
#  - WEBHOOK_MODE: false
#  - WEBHOOK_URL

echo "export LC_ALL=en_US.UTF-8" >> ~/.bash_profile
echo "export LANG=en_US.UTF-8" >> ~/.bash_profile
source ~/.bash_profile

yum update -y
amazon-linux-extras install docker -y

# Install json editor
yum install jq -y

# Install git
yum install git -y

# Install docker
yum install docker -y
service docker start
usermod -a -G docker ec2-user

# Install docker-compose
curl -L https://github.com/docker/compose/releases/download/1.21.0/docker-compose-`uname -s`-`uname -m` | tee /usr/local/bin/docker-compose > /dev/null
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

su - ec2-user
cd /home/ec2-user/

# Gets EC2 instance Tags
get_instance_tags () {
    INSTANCE_ID=$(/usr/bin/curl --silent http://169.254.169.254/latest/meta-data/instance-id)
    EC2_AVAILABLE_ZONE=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
    EC2_REGION="`echo \"$EC2_AVAILABLE_ZONE\" | sed -e 's:\([0-9][0-9]*\)[a-z]*\$:\\1:'`"

    echo $(aws ec2 describe-tags --region $EC2_REGION --filters "Name=resource-id,Values=$INSTANCE_ID")
}

# Transforms EC2 instance Tags into environment variables
tags_to_env () {
    tags=$1

    for key in $(echo $tags | /usr/bin/jq -r ".[][].Key"); do
        value=$(echo $tags | /usr/bin/jq -r ".[][] | select(.Key==\"$key\") | .Value")
        key=$(echo $key | /usr/bin/tr '-' '_' | /usr/bin/tr '[:lower:]' '[:upper:]')
        if [[ $key =~ ^[a-zA-Z0-9_]+$ ]]; then
            export $key="$value"
        fi
    done
}

instance_tags=$(get_instance_tags)
tags_to_env "$instance_tags"

git clone ${STARTKIT_REPOSITORY_URL:-https://github.com/ftgibran/freqtrade-startkit.git} startkit

# Create director for freqtrade
mkdir ft_userdata
cd ft_userdata/

# Download the docker-compose file from the freqtrade repository
curl https://raw.githubusercontent.com/freqtrade/freqtrade/stable/docker-compose.yml -o docker-compose.yml

# Change strategy according to STRATEGY environment variable
if [ ${WEBHOOK_MODE:-false} = true ]; then
    sed -i "s/\(.*--strategy .*\)/      --strategy Webhook/g" ./docker-compose.yml
else
    sed -i "s/\(.*--strategy .*\)/      --strategy ${STRATEGY:-StandardStrategy}/g" ./docker-compose.yml
fi

# Pull the freqtrade image
docker-compose pull

# Copy user_data dir from startkit
cp -Rf ../startkit/user_data ./user_data/
rm -rf ../startkit

cd user_data

# Apply environment variables config.json
jq '.exchange.name = $newVal' --arg newVal ${EXCHANGE_NAME:-binance} config.json > tmp.$$.json && mv -f tmp.$$.json config.json
jq '.exchange.key = $newVal' --arg newVal ${EXCHANGE_KEY:-''} config.json > tmp.$$.json && mv -f tmp.$$.json config.json
jq '.exchange.secret = $newVal' --arg newVal ${EXCHANGE_SECRET:-''} config.json > tmp.$$.json && mv -f tmp.$$.json config.json

jq '.telegram.token = $newVal' --arg newVal ${TELEGRAM_TOKEN:-''} config.json > tmp.$$.json && mv -f tmp.$$.json config.json
jq '.telegram.chat_id = $newVal' --arg newVal ${TELEGRAM_CHAT_ID:-''} config.json > tmp.$$.json && mv -f tmp.$$.json config.json

jq '.max_open_trades = $newVal' --argjson newVal ${MAX_OPEN_TRADES:-10} config.json > tmp.$$.json && mv -f tmp.$$.json config.json
jq '.fiat_display_currency = $newVal' --arg newVal ${FIAT_DISPLAY_CURRENCY:-'USD'} config.json > tmp.$$.json && mv -f tmp.$$.json config.json

jq '.dry_run = $newVal' --argjson newVal ${DRY_RUN:-true} config.json > tmp.$$.json && mv -f tmp.$$.json config.json
jq '.dry_run_wallet = $newVal' --argjson newVal ${DRY_RUN_WALLET:-1000} config.json > tmp.$$.json && mv -f tmp.$$.json config.json

jq '.internals.process_throttle_secs = $newVal' --argjson newVal ${PROCESS_THROTTLE_SECS:-5} config.json > tmp.$$.json && mv -f tmp.$$.json config.json

cd ./strategies

if [ ${WEBHOOK_MODE:-false} = true ]; then
    WEBHOOK_URL=${WEBHOOK_URL//\//\\/}
    sed -i -- "s/# use your own webhook/'${WEBHOOK_URL:-}'/g" ./Webhook.py
    sed -i -- "s/StandardStrategy/${STRATEGY:-StandardStrategy}/g" ./Webhook.py
    rm -f ./Webhook.py--
fi

cd ../../

sudo chown -R ec2-user ./

docker-compose up -d
