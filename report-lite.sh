#!/bin/bash
#encoding=utf8

mkdir -p report
cd ./report

read -p "What's the name of your Strategy? "

STRATEGY=$(echo $REPLY)

mkdir -p $STRATEGY
cd $STRATEGY

[ ! -d "user_data" ] && freqtrade create-userdir --userdir user_data

rm -f ./user_data/strategies/sample_strategy.py

echo ""
echo "Place your config.json in $PWD/user_data"
read -r -s -p $"Press enter when it is done"
echo ""

echo ""
echo "Place your strategy in $PWD/user_data/strategies"
read -r -s -p $"Press enter when it is done"
echo ""

freqtrade download-data --days 365 -t 5m

freqtrade backtesting -s $STRATEGY --export trades

freqtrade plot-dataframe -s $STRATEGY
freqtrade plot-profit -s $STRATEGY

freqtrade backtesting -s $STRATEGY
