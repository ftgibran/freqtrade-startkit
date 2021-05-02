# pragma pylint: disable=missing-docstring, invalid-name, pointless-string-statement

# --- Do not remove these libs ---
import numpy as np  # noqa
import pandas as pd  # noqa
from pandas import DataFrame

from freqtrade.strategy.interface import IStrategy
from freqtrade.strategy import merge_informative_pair

# --------------------------------
# Add your lib to import here
from datetime import datetime, timedelta
from freqtrade.persistence import Trade
from freqtrade.strategy import stoploss_from_open
import talib.abstract as ta
import freqtrade.vendor.qtpylib.indicators as qtpylib


class StandardStrategy(IStrategy):
    # Strategy interface version - allow new iterations of the strategy interface.
    # Check the documentation or the Sample strategy to get the latest version.
    INTERFACE_VERSION = 2

    # Represent the most dominant pair which can represent the best influence of market cap
    MARKET_CAP_REFERENCE_PAIR = 'BTC/USDT'

    # Create custom dictionary
    custom_info = {}

    # Minimal ROI designed for the strategy.
    # This attribute will be overridden if the config file contains "minimal_roi".
    minimal_roi = {
        '0': 100
    }

    # Optimal stoploss designed for the strategy.
    # This attribute will be overridden if the config file contains "stoploss".
    stoploss = -0.30

    # Trailing stoploss
    use_custom_stoploss = True

    # Optimal ticker interval for the strategy.
    timeframe = '1h'

    # Run "populate_indicators()" only for new candle.
    process_only_new_candles = False

    # These values can be overridden in the "ask_strategy" section in the config.
    use_sell_signal = True
    sell_profit_only = True
    ignore_roi_if_buy_signal = False

    # Number of candles the strategy requires before producing valid signals
    startup_candle_count: int = 20

    # It will protect your strategy from unexpected events and market conditions by temporarily stop trading
    # for either one pair, or for all pairs.
    protections = []

    # Optional order type mapping.
    order_types = {
        'buy': 'market',
        'sell': 'market',
        'stoploss': 'market',
        'stoploss_on_exchange': True
    }

    # Optional order time in force.
    order_time_in_force = {
        'buy': 'gtc',
        'sell': 'gtc'
    }

    plot_config = {
        'main_plot': {
            'tema': {},
            'ema7': {},
            'sar': {'color': 'white'},
        },
        'subplots': {
            'MACD': {
                'macd': {'color': 'blue'},
                'macdsignal': {'color': 'orange'},
            },
            'RSI': {
                'rsi': {'color': 'red'},
            }
        }
    }

    def custom_stoploss(self, pair: str, trade: 'Trade', current_time: datetime,
                        current_rate: float, current_profit: float, **kwargs) -> float:
        is_bull_market = True

        if self.custom_info and self.MARKET_CAP_REFERENCE_PAIR in self.custom_info and trade:
            # using current_time directly (like below) will only work in backtesting.
            # so check "runmode" to make sure that it's only used in backtesting/hyperopt
            if self.dp and self.dp.runmode.value in ('backtest', 'hyperopt'):
                sar = self.custom_info[self.MARKET_CAP_REFERENCE_PAIR]['sar_1w'].loc[current_time]['sar_1w']
                tema = self.custom_info[self.MARKET_CAP_REFERENCE_PAIR]['tema_1w'].loc[current_time]['tema_1w']
            # in live / dry-run, it'll be really the current time
            else:
                # but we can just use the last entry from an already analyzed dataframe instead
                dataframe, last_updated = self.dp.get_analyzed_dataframe(pair=self.MARKET_CAP_REFERENCE_PAIR, timeframe=self.timeframe)
                # WARNING
                # only use .iat[-1] in live mode, not in backtesting/hyperopt
                # otherwise you will look into the future
                # see: https://www.freqtrade.io/en/latest/strategy-customization/#common-mistakes-when-developing-strategies
                sar = dataframe['sar_1w'].iat[-1]
                tema = dataframe['tema_1w'].iat[-1]

            if tema is not None and sar is not None:
                is_bull_market = tema > sar

        # evaluate highest to lowest, so that highest possible stop is used
        if current_profit > 5.00:
            return -0.2
        elif current_profit > 4.00:
            return stoploss_from_open(3.50, current_profit)
        elif current_profit > 3.50:
            return stoploss_from_open(3.00, current_profit)
        elif current_profit > 3.00:
            return stoploss_from_open(2.50, current_profit)
        elif current_profit > 2.50:
            return stoploss_from_open(2.00, current_profit)
        elif current_profit > 2.00:
            return stoploss_from_open(1.50, current_profit)
        elif current_profit > 1.50:
            return stoploss_from_open(1.25, current_profit)
        elif current_profit > 1.25:
            return stoploss_from_open(1.00, current_profit)
        elif current_profit > 1.00:
            return stoploss_from_open(0.75, current_profit)
        elif current_profit > 0.75:
            return stoploss_from_open(0.50, current_profit)
        elif current_profit > 0.50 and is_bull_market:
            return stoploss_from_open(0.25, current_profit)
        elif current_profit > 0.25 and is_bull_market:
            return stoploss_from_open(0.05, current_profit)
        elif -0.05 < current_profit < 0.05 and not is_bull_market:
            if current_time - timedelta(hours=24*7) > trade.open_date_utc:
                return -0.0125
            elif current_time - timedelta(hours=24*5) > trade.open_date_utc:
                return -0.025
            elif current_time - timedelta(hours=24*3) > trade.open_date_utc:
                return -0.05

        # return maximum stoploss value, keeping current stoploss price unchanged
        return -1

    def informative_pairs(self):
        # get access to all pairs available in whitelist.
        pairs = self.dp.current_whitelist()

        # Assign tf to each pair so they can be downloaded and cached for strategy.
        informative_pairs = [(pair, '1w') for pair in pairs]

        # Optionally Add additional "static" pairs
        informative_pairs += [(self.MARKET_CAP_REFERENCE_PAIR, '1w')]

        return informative_pairs

    def populate_indicators(self, dataframe: DataFrame, metadata: dict) -> DataFrame:
        if not self.dp:
            # Don't do anything if DataProvider is not available.
            return dataframe

        inf_tf = '1w'

        # Get the informative pair
        informative = self.dp.get_pair_dataframe(pair=metadata['pair'], timeframe=inf_tf)

        # Parabolic SAR
        informative['sar'] = ta.SAR(dataframe)

        # TEMA - Triple Exponential Moving Average
        informative['tema'] = ta.TEMA(dataframe, timeperiod=9)

        # Use the helper function merge_informative_pair to safely merge the pair
        # Automatically renames the columns and merges a shorter timeframe dataframe and a longer timeframe informative pair
        # use ffill to have the 1d value available in every row throughout the day.
        # Without this, comparisons between columns of the original and the informative pair would only work once per day.
        # Full documentation of this method, see below
        dataframe = merge_informative_pair(dataframe, informative, self.timeframe, inf_tf, ffill=True)

        # RSI
        dataframe['rsi'] = ta.RSI(dataframe, timeperiod=14)

        # Parabolic SAR
        dataframe['sar'] = ta.SAR(dataframe)

        # TEMA - Triple Exponential Moving Average
        dataframe['tema'] = ta.TEMA(dataframe, timeperiod=9)

        # EMA - Exponential Moving Average
        dataframe['ema7'] = ta.EMA(dataframe, timeperiod=7)

        # Bollinger Bands
        bollinger = qtpylib.bollinger_bands(qtpylib.typical_price(dataframe), window=20, stds=2)

        dataframe['bb_lowerband'] = bollinger['lower']
        dataframe['bb_middleband'] = bollinger['mid']
        dataframe['bb_upperband'] = bollinger['upper']

        dataframe['bb_width'] = (
                (dataframe['bb_upperband'] - dataframe['bb_lowerband']) / dataframe['bb_middleband']
        )

        dataframe['bb_width_past_1'] = (
                (dataframe['bb_upperband'].shift(1) - dataframe['bb_lowerband'].shift(1)) / dataframe['bb_middleband'].shift(1)
        )

        dataframe['bb_width_past_2'] = (
                (dataframe['bb_upperband'].shift(2) - dataframe['bb_lowerband'].shift(2)) / dataframe['bb_middleband'].shift(2)
        )

        dataframe['bb_width_past_3'] = (
                (dataframe['bb_upperband'].shift(3) - dataframe['bb_lowerband'].shift(3)) / dataframe['bb_middleband'].shift(3)
        )

        dataframe['bb_width_past_4'] = (
                (dataframe['bb_upperband'].shift(4) - dataframe['bb_lowerband'].shift(4)) / dataframe['bb_middleband'].shift(4)
        )

        dataframe['bb_width_past_5'] = (
                (dataframe['bb_upperband'].shift(5) - dataframe['bb_lowerband'].shift(5)) / dataframe['bb_middleband'].shift(5)
        )

        # Check if the entry already exists
        if not metadata['pair'] in self.custom_info:
            # Create empty entry for this pair
            self.custom_info[metadata['pair']] = {}

        if self.dp.runmode.value in ('backtest', 'hyperopt'):
            # add indicator mapped to correct DatetimeIndex to custom_info
            self.custom_info[metadata['pair']]['sar_1w'] = dataframe[['date', 'sar_1w']].set_index('date')
            self.custom_info[metadata['pair']]['tema_1w'] = dataframe[['date', 'tema_1w']].set_index('date')

        return dataframe

    def populate_buy_trend(self, dataframe: DataFrame, metadata: dict) -> DataFrame:
        dataframe.loc[
            (
                    (dataframe['tema'] > dataframe['sar']) &
                    (dataframe['rsi'] > 70) &
                    (dataframe['rsi'] < 90) &
                    (dataframe['rsi'] > dataframe['rsi'].shift(1)) &
                    ((dataframe['bb_width_past_1'] / dataframe['bb_width_past_2']) > 0.975) &
                    ((dataframe['bb_width_past_2'] / dataframe['bb_width_past_1']) < 1.0257) &
                    ((dataframe['bb_width_past_2'] / dataframe['bb_width_past_3']) > 0.975) &
                    ((dataframe['bb_width_past_3'] / dataframe['bb_width_past_2']) < 1.0257) &
                    ((dataframe['bb_width_past_3'] / dataframe['bb_width_past_4']) > 0.975) &
                    ((dataframe['bb_width_past_4'] / dataframe['bb_width_past_3']) < 1.0257) &
                    ((dataframe['bb_width_past_4'] / dataframe['bb_width_past_5']) > 0.975) &
                    ((dataframe['bb_width_past_5'] / dataframe['bb_width_past_4']) < 1.0257) &
                    (dataframe['bb_width'] / dataframe['bb_width_past_1'] > 1.14) &
                    (dataframe['bb_width'] / dataframe['bb_width_past_1'] < 2.00) &
                    (dataframe['volume'] > 0)
            ),
            'buy'] = 1

        return dataframe

    def populate_sell_trend(self, dataframe: DataFrame, metadata: dict) -> DataFrame:
        dataframe.loc[
            (
                    (dataframe['tema'] < dataframe['sar']) &
                    (qtpylib.crossed_above(dataframe['ema7'], dataframe['tema'])) &
                    (dataframe['bb_width_past_1'] / dataframe['bb_width'] > 1.20) &
                    (dataframe['volume'] > 0)
            ),
            'sell'] = 1

        return dataframe
