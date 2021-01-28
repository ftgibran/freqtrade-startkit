#!/bin/bash
echo "export LC_ALL=en_US.UTF-8" >> ~/.bash_profile
echo "export LANG=en_US.UTF-8" >> ~/.bash_profile
source ~/.bash_profile

cd /home/ec2-user/

yum update -y
amazon-linux-extras install docker -y

# Install JQ
yum install jq -y

# Install docker
yum install docker
service docker start
usermod -a -G docker ec2-user

# Install docker-compose
curl -L https://github.com/docker/compose/releases/download/1.21.0/docker-compose-`uname -s`-`uname -m` | tee /usr/local/bin/docker-compose > /dev/null
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

get_instance_tags () {
    INSTANCE_ID=$(/usr/bin/curl --silent http://169.254.169.254/latest/meta-data/instance-id)
    EC2_AVAILABLE_ZONE=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
    EC2_REGION="`echo \"$EC2_AVAILABLE_ZONE\" | sed -e 's:\([0-9][0-9]*\)[a-z]*\$:\\1:'`"

    echo $(aws ec2 describe-tags --region $EC2_REGION --filters "Name=resource-id,Values=$INSTANCE_ID")
}

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

# Create director for freqtrade
mkdir ft_userdata
cd ft_userdata/

chown -R ec2-user ft_userdata/
chmod -R 755 ft_userdata/

# Download the docker-compose file from the repository
curl https://raw.githubusercontent.com/freqtrade/freqtrade/stable/docker-compose.yml -o docker-compose.yml
chown -R ec2-user docker-compose.yml
chmod -R 755 docker-compose.yml

# Pull the freqtrade image
docker-compose pull

# Create user directory structure
docker-compose run --rm freqtrade create-userdir --userdir user_data

cd user_data

curl https://raw.githubusercontent.com/ftgibran/freqtrade-startkit/master/user_data/config.json -o config.json

jq '.exchange.name = $newVal' --arg newVal ${EXCHANGE_NAME:-binance} config.json > tmp.$$.json && mv -f tmp.$$.json config.json
jq '.exchange.key = $newVal' --arg newVal ${EXCHANGE_KEY:-''} config.json > tmp.$$.json && mv -f tmp.$$.json config.json
jq '.exchange.secret = $newVal' --arg newVal ${EXCHANGE_SECRET:-''} config.json > tmp.$$.json && mv -f tmp.$$.json config.json

jq '.telegram.token = $newVal' --arg newVal ${TELEGRAM_TOKEN:-''} config.json > tmp.$$.json && mv -f tmp.$$.json config.json
jq '.telegram.chat_id = $newVal' --arg newVal ${TELEGRAM_CHAT_ID:-''} config.json > tmp.$$.json && mv -f tmp.$$.json config.json

chown -R ec2-user config.json
chmod -R 755 config.json

cd strategies/

curl https://raw.githubusercontent.com/ftgibran/freqtrade-startkit/master/user_data/strategies/standard.py -o standard.py

chown -R ec2-user standard.py
chmod -R 755 standard.py

cd ../../

docker-compose up -d

docker-compose run freqtrade trade --dry-run -s Standard
