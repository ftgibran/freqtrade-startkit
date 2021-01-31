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

freqtrade download-data --timerange 20170101-20210131 -t 5m

freqtrade backtesting -s $STRATEGY --timerange 20170801-20210131 --export trades

mkdir -p ./user_data/plot/2017-08
mkdir -p ./user_data/plot/2017-09
mkdir -p ./user_data/plot/2017-10
mkdir -p ./user_data/plot/2017-11
mkdir -p ./user_data/plot/2017-12

mkdir -p ./user_data/plot/2018-01
mkdir -p ./user_data/plot/2018-02
mkdir -p ./user_data/plot/2018-03
mkdir -p ./user_data/plot/2018-04
mkdir -p ./user_data/plot/2018-05
mkdir -p ./user_data/plot/2018-06
mkdir -p ./user_data/plot/2018-07
mkdir -p ./user_data/plot/2018-08
mkdir -p ./user_data/plot/2018-09
mkdir -p ./user_data/plot/2018-10
mkdir -p ./user_data/plot/2018-11
mkdir -p ./user_data/plot/2018-12

mkdir -p ./user_data/plot/2019-01
mkdir -p ./user_data/plot/2019-02
mkdir -p ./user_data/plot/2019-03
mkdir -p ./user_data/plot/2019-04
mkdir -p ./user_data/plot/2019-05
mkdir -p ./user_data/plot/2019-06
mkdir -p ./user_data/plot/2019-07
mkdir -p ./user_data/plot/2019-08
mkdir -p ./user_data/plot/2019-09
mkdir -p ./user_data/plot/2019-10
mkdir -p ./user_data/plot/2019-11
mkdir -p ./user_data/plot/2019-12

mkdir -p ./user_data/plot/2020-01
mkdir -p ./user_data/plot/2020-02
mkdir -p ./user_data/plot/2020-03
mkdir -p ./user_data/plot/2020-04
mkdir -p ./user_data/plot/2020-05
mkdir -p ./user_data/plot/2020-06
mkdir -p ./user_data/plot/2020-07
mkdir -p ./user_data/plot/2020-08
mkdir -p ./user_data/plot/2020-09
mkdir -p ./user_data/plot/2020-10
mkdir -p ./user_data/plot/2020-11
mkdir -p ./user_data/plot/2020-12

mkdir -p ./user_data/plot/2021-01

# Plot dataframe

# 2017

freqtrade plot-dataframe -s $STRATEGY -p BTC/USDT --timerange 20170801-20170831
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2017-08/$PLOT_NAME"

freqtrade plot-dataframe -s $STRATEGY -p BTC/USDT --timerange 20170901-20170930
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2017-09/$PLOT_NAME"

freqtrade plot-dataframe -s $STRATEGY -p BTC/USDT --timerange 20171001-20171031
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2017-10/$PLOT_NAME"

freqtrade plot-dataframe -s $STRATEGY -p BTC/USDT --timerange 20171101-20171130
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2017-11/$PLOT_NAME"

freqtrade plot-dataframe -s $STRATEGY -p BTC/USDT --timerange 20171201-20171231
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2017-12/$PLOT_NAME"

# 2018

freqtrade plot-dataframe -s $STRATEGY -p BTC/USDT --timerange 20180101-20180131
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2018-01/$PLOT_NAME"

freqtrade plot-dataframe -s $STRATEGY -p BTC/USDT --timerange 20180201-20180228
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2018-02/$PLOT_NAME"

freqtrade plot-dataframe -s $STRATEGY -p BTC/USDT --timerange 20180301-20180331
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2018-03/$PLOT_NAME"

freqtrade plot-dataframe -s $STRATEGY -p BTC/USDT --timerange 20180401-20180430
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2018-04/$PLOT_NAME"

freqtrade plot-dataframe -s $STRATEGY -p BTC/USDT --timerange 20180501-20180531
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2018-05/$PLOT_NAME"

freqtrade plot-dataframe -s $STRATEGY -p BTC/USDT --timerange 20180601-20180630
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2018-06/$PLOT_NAME"

freqtrade plot-dataframe -s $STRATEGY -p BTC/USDT --timerange 20180701-20180731
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2018-07/$PLOT_NAME"

freqtrade plot-dataframe -s $STRATEGY -p BTC/USDT --timerange 20180801-20180831
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2018-08/$PLOT_NAME"

freqtrade plot-dataframe -s $STRATEGY -p BTC/USDT --timerange 20180901-20180930
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2018-09/$PLOT_NAME"

freqtrade plot-dataframe -s $STRATEGY -p BTC/USDT --timerange 20181001-20181031
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2018-10/$PLOT_NAME"

freqtrade plot-dataframe -s $STRATEGY -p BTC/USDT --timerange 20181101-20181130
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2018-11/$PLOT_NAME"

freqtrade plot-dataframe -s $STRATEGY -p BTC/USDT --timerange 20181201-20181231
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2018-12/$PLOT_NAME"

# 2019

freqtrade plot-dataframe -s $STRATEGY -p BTC/USDT --timerange 20190101-20190131
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2019-01/$PLOT_NAME"

freqtrade plot-dataframe -s $STRATEGY -p BTC/USDT --timerange 20190201-20190228
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2019-02/$PLOT_NAME"

freqtrade plot-dataframe -s $STRATEGY -p BTC/USDT --timerange 20190301-20190331
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2019-03/$PLOT_NAME"

freqtrade plot-dataframe -s $STRATEGY -p BTC/USDT --timerange 20190401-20190430
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2019-04/$PLOT_NAME"

freqtrade plot-dataframe -s $STRATEGY -p BTC/USDT --timerange 20190501-20190531
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2019-05/$PLOT_NAME"

freqtrade plot-dataframe -s $STRATEGY -p BTC/USDT --timerange 20190601-20190630
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2019-06/$PLOT_NAME"

freqtrade plot-dataframe -s $STRATEGY -p BTC/USDT --timerange 20190701-20190731
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2019-07/$PLOT_NAME"

freqtrade plot-dataframe -s $STRATEGY -p BTC/USDT --timerange 20190801-20190831
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2019-08/$PLOT_NAME"

freqtrade plot-dataframe -s $STRATEGY -p BTC/USDT --timerange 20190901-20190930
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2019-09/$PLOT_NAME"

freqtrade plot-dataframe -s $STRATEGY -p BTC/USDT --timerange 20191001-20191031
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2019-10/$PLOT_NAME"

freqtrade plot-dataframe -s $STRATEGY -p BTC/USDT --timerange 20191101-20191130
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2019-11/$PLOT_NAME"

freqtrade plot-dataframe -s $STRATEGY -p BTC/USDT --timerange 20191201-20191231
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2019-12/$PLOT_NAME"

# 2020

freqtrade plot-dataframe -s $STRATEGY -p BTC/USDT --timerange 20200101-20200131
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2020-01/$PLOT_NAME"

freqtrade plot-dataframe -s $STRATEGY -p BTC/USDT --timerange 20200201-20200229
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2020-02/$PLOT_NAME"

freqtrade plot-dataframe -s $STRATEGY -p BTC/USDT --timerange 20200301-20200331
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2020-03/$PLOT_NAME"

freqtrade plot-dataframe -s $STRATEGY -p BTC/USDT --timerange 20200401-20200430
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2020-04/$PLOT_NAME"

freqtrade plot-dataframe -s $STRATEGY -p BTC/USDT --timerange 20200501-20200531
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2020-05/$PLOT_NAME"

freqtrade plot-dataframe -s $STRATEGY -p BTC/USDT --timerange 20200601-20200630
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2020-06/$PLOT_NAME"

freqtrade plot-dataframe -s $STRATEGY -p BTC/USDT --timerange 20200701-20200731
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2020-07/$PLOT_NAME"

freqtrade plot-dataframe -s $STRATEGY -p BTC/USDT --timerange 20200801-20200831
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2020-08/$PLOT_NAME"

freqtrade plot-dataframe -s $STRATEGY -p BTC/USDT --timerange 20200901-20200930
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2020-09/$PLOT_NAME"

freqtrade plot-dataframe -s $STRATEGY -p BTC/USDT --timerange 20201001-20201031
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2020-10/$PLOT_NAME"

freqtrade plot-dataframe -s $STRATEGY -p BTC/USDT --timerange 20201101-20201130
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2020-11/$PLOT_NAME"

freqtrade plot-dataframe -s $STRATEGY -p BTC/USDT --timerange 20201201-20201231
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2020-12/$PLOT_NAME"

# 2021

freqtrade plot-dataframe -s $STRATEGY -p BTC/USDT --timerange 20210101-20210131
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2021-01/$PLOT_NAME"


## Plot profit

# 2017

freqtrade plot-profit -s $STRATEGY --timerange 20170801-20170831
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2017-08/$PLOT_NAME"

freqtrade plot-profit -s $STRATEGY --timerange 20170901-20170930
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2017-09/$PLOT_NAME"

freqtrade plot-profit -s $STRATEGY --timerange 20171001-20171031
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2017-10/$PLOT_NAME"

freqtrade plot-profit -s $STRATEGY --timerange 20171101-20171130
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2017-11/$PLOT_NAME"

freqtrade plot-profit -s $STRATEGY --timerange 20171201-20171231
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2017-12/$PLOT_NAME"

# 2018

freqtrade plot-profit -s $STRATEGY --timerange 20180101-20180131
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2018-01/$PLOT_NAME"

freqtrade plot-profit -s $STRATEGY --timerange 20180201-20180228
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2018-02/$PLOT_NAME"

freqtrade plot-profit -s $STRATEGY --timerange 20180301-20180331
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2018-03/$PLOT_NAME"

freqtrade plot-profit -s $STRATEGY --timerange 20180401-20180430
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2018-04/$PLOT_NAME"

freqtrade plot-profit -s $STRATEGY --timerange 20180501-20180531
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2018-05/$PLOT_NAME"

freqtrade plot-profit -s $STRATEGY --timerange 20180601-20180630
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2018-06/$PLOT_NAME"

freqtrade plot-profit -s $STRATEGY --timerange 20180701-20180731
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2018-07/$PLOT_NAME"

freqtrade plot-profit -s $STRATEGY --timerange 20180801-20180831
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2018-08/$PLOT_NAME"

freqtrade plot-profit -s $STRATEGY --timerange 20180901-20180930
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2018-09/$PLOT_NAME"

freqtrade plot-profit -s $STRATEGY --timerange 20181001-20181031
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2018-10/$PLOT_NAME"

freqtrade plot-profit -s $STRATEGY --timerange 20181101-20181130
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2018-11/$PLOT_NAME"

freqtrade plot-profit -s $STRATEGY --timerange 20181201-20181231
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2018-12/$PLOT_NAME"

# 2019

freqtrade plot-profit -s $STRATEGY --timerange 20190101-20190131
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2019-01/$PLOT_NAME"

freqtrade plot-profit -s $STRATEGY --timerange 20190201-20190228
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2019-02/$PLOT_NAME"

freqtrade plot-profit -s $STRATEGY --timerange 20190301-20190331
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2019-03/$PLOT_NAME"

freqtrade plot-profit -s $STRATEGY --timerange 20190401-20190430
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2019-04/$PLOT_NAME"

freqtrade plot-profit -s $STRATEGY --timerange 20190501-20190531
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2019-05/$PLOT_NAME"

freqtrade plot-profit -s $STRATEGY --timerange 20190601-20190630
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2019-06/$PLOT_NAME"

freqtrade plot-profit -s $STRATEGY --timerange 20190701-20190731
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2019-07/$PLOT_NAME"

freqtrade plot-profit -s $STRATEGY --timerange 20190801-20190831
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2019-08/$PLOT_NAME"

freqtrade plot-profit -s $STRATEGY --timerange 20190901-20190930
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2019-09/$PLOT_NAME"

freqtrade plot-profit -s $STRATEGY --timerange 20191001-20191031
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2019-10/$PLOT_NAME"

freqtrade plot-profit -s $STRATEGY --timerange 20191101-20191130
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2019-11/$PLOT_NAME"

freqtrade plot-profit -s $STRATEGY --timerange 20191201-20191231
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2019-12/$PLOT_NAME"

# 2020

freqtrade plot-profit -s $STRATEGY --timerange 20200101-20200131
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2020-01/$PLOT_NAME"

freqtrade plot-profit -s $STRATEGY --timerange 20200201-20200229
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2020-02/$PLOT_NAME"

freqtrade plot-profit -s $STRATEGY --timerange 20200301-20200331
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2020-03/$PLOT_NAME"

freqtrade plot-profit -s $STRATEGY --timerange 20200401-20200430
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2020-04/$PLOT_NAME"

freqtrade plot-profit -s $STRATEGY --timerange 20200501-20200531
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2020-05/$PLOT_NAME"

freqtrade plot-profit -s $STRATEGY --timerange 20200601-20200630
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2020-06/$PLOT_NAME"

freqtrade plot-profit -s $STRATEGY --timerange 20200701-20200731
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2020-07/$PLOT_NAME"

freqtrade plot-profit -s $STRATEGY --timerange 20200801-20200831
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2020-08/$PLOT_NAME"

freqtrade plot-profit -s $STRATEGY --timerange 20200901-20200930
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2020-09/$PLOT_NAME"

freqtrade plot-profit -s $STRATEGY --timerange 20201001-20201031
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2020-10/$PLOT_NAME"

freqtrade plot-profit -s $STRATEGY --timerange 20201101-20201130
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2020-11/$PLOT_NAME"

freqtrade plot-profit -s $STRATEGY --timerange 20201201-20201231
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2020-12/$PLOT_NAME"

# 2021

freqtrade plot-profit -s $STRATEGY --timerange 20210101-20210131
PLOT_PATH=$(find ./user_data/plot -maxdepth 1 -name '*.html')
PLOT_NAME=$(basename $PLOT_PATH)
mv -f $PLOT_PATH "./user_data/plot/2021-01/$PLOT_NAME"

# Delete data cache
rm -rf ./user_data/data
mkdir -p ./user_data/data

# Summary
freqtrade backtesting -s $STRATEGY --timerange 20170801-20210131
