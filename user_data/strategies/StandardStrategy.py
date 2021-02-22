# pragma pylint: disable=missing-docstring, invalid-name, pointless-string-statement

# --- Do not remove these libs ---
import numpy as np  # noqa
import pandas as pd  # noqa
from pandas import DataFrame

from freqtrade.strategy.interface import IStrategy

# --------------------------------
# Add your lib to import here
import talib.abstract as ta
import freqtrade.vendor.qtpylib.indicators as qtpylib


class StandardStrategy(IStrategy):
    # Strategy interface version - allow new iterations of the strategy interface.
    # Check the documentation or the Sample strategy to get the latest version.
    INTERFACE_VERSION = 2

    # Minimal ROI designed for the strategy.
    # This attribute will be overridden if the config file contains "minimal_roi".
    minimal_roi = {
        "0": 100
    }

    # Optimal stoploss designed for the strategy.
    # This attribute will be overridden if the config file contains "stoploss".
    stoploss = -0.30

    # Trailing stoploss
    # trailing_stop = True
    # trailing_only_offset_is_reached = True
    # trailing_stop_positive_offset = 0.50
    # trailing_stop_positive = 0.40

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
            'sar': {'color': 'white'},
        },
        'subplots': {
            "MACD": {
                'macd': {'color': 'blue'},
                'macdsignal': {'color': 'orange'},
            },
            "RSI": {
                'rsi': {'color': 'red'},
            }
        }
    }

    def informative_pairs(self):
        return []

    def populate_indicators(self, dataframe: DataFrame, metadata: dict) -> DataFrame:
        # RSI
        dataframe['rsi'] = ta.RSI(dataframe, timeperiod=14)

        # Parabolic SAR
        dataframe['sar'] = ta.SAR(dataframe)

        # TEMA - Triple Exponential Moving Average
        dataframe['tema'] = ta.TEMA(dataframe, timeperiod=9)

        # Bollinger Bands
        bollinger = qtpylib.bollinger_bands(qtpylib.typical_price(dataframe), window=20, stds=2)

        dataframe['bb_lowerband'] = bollinger['lower']
        dataframe['bb_middleband'] = bollinger['mid']
        dataframe['bb_upperband'] = bollinger['upper']

        dataframe["bb_width"] = (
                (dataframe["bb_upperband"] - dataframe["bb_lowerband"]) / dataframe["bb_middleband"]
        )

        dataframe["bb_width_past_1"] = (
                (dataframe["bb_upperband"].shift(1) - dataframe["bb_lowerband"].shift(1)) / dataframe["bb_middleband"].shift(1)
        )

        dataframe["bb_width_past_2"] = (
                (dataframe["bb_upperband"].shift(2) - dataframe["bb_lowerband"].shift(2)) / dataframe["bb_middleband"].shift(2)
        )

        dataframe["bb_width_past_3"] = (
                (dataframe["bb_upperband"].shift(3) - dataframe["bb_lowerband"].shift(3)) / dataframe["bb_middleband"].shift(3)
        )

        dataframe["bb_width_past_4"] = (
                (dataframe["bb_upperband"].shift(4) - dataframe["bb_lowerband"].shift(4)) / dataframe["bb_middleband"].shift(4)
        )

        dataframe["bb_width_past_5"] = (
                (dataframe["bb_upperband"].shift(5) - dataframe["bb_lowerband"].shift(5)) / dataframe["bb_middleband"].shift(5)
        )

        return dataframe

    def populate_buy_trend(self, dataframe: DataFrame, metadata: dict) -> DataFrame:
        dataframe.loc[
            (
                    (dataframe['tema'] > dataframe['sar']) &
                    (qtpylib.crossed_above(dataframe['rsi'], 70)) &
                    ((dataframe['bb_width_past_1'] / dataframe['bb_width_past_2']) > 0.975) &
                    ((dataframe['bb_width_past_2'] / dataframe['bb_width_past_1']) < 1.0257) &
                    ((dataframe['bb_width_past_2'] / dataframe['bb_width_past_3']) > 0.975) &
                    ((dataframe['bb_width_past_3'] / dataframe['bb_width_past_2']) < 1.0257) &
                    ((dataframe['bb_width_past_3'] / dataframe['bb_width_past_4']) > 0.975) &
                    ((dataframe['bb_width_past_4'] / dataframe['bb_width_past_3']) < 1.0257) &
                    ((dataframe['bb_width_past_4'] / dataframe['bb_width_past_5']) > 0.975) &
                    ((dataframe['bb_width_past_5'] / dataframe['bb_width_past_4']) < 1.0257) &
                    (dataframe['bb_width'] / dataframe['bb_width_past_1'] > 1.14) &
                    (dataframe['bb_width'] / dataframe['bb_width_past_1'] < 1.30) &
                    (dataframe['volume'] > 0)
            ),
            'buy'] = 1

        return dataframe

    def populate_sell_trend(self, dataframe: DataFrame, metadata: dict) -> DataFrame:
        dataframe.loc[
            (
                    (dataframe['tema'] < dataframe['sar']) &
                    (dataframe['bb_width_past_1'] / dataframe['bb_width'] > 1.40) &
                    (dataframe['volume'] > 0)
            ),
            'sell'] = 1
        return dataframe
