# pragma pylint: disable=missing-docstring, invalid-name, pointless-string-statement

# --- Do not remove these libs ---
import numpy as np  # noqa
import pandas as pd  # noqa
from pandas import DataFrame

from freqtrade.strategy.interface import IStrategy

# --------------------------------
# Add your lib to import here
import requests
import datetime
import talib.abstract as ta
import freqtrade.vendor.qtpylib.indicators as qtpylib
import sys
from pathlib import Path
sys.path.append(str(Path(__file__).parent))

from StandardStrategy import StandardStrategy


class Webhook(StandardStrategy):
    # Create custom dictionary
    custom_info = {}

    webhook_urls = [
        # use your own webhook
    ]

    def populate_indicators(self, dataframe: DataFrame, metadata: dict) -> DataFrame:
        # Check if the entry already exists
        if not metadata["pair"] in self.custom_info:
            # Create empty entry for this pair
            self.custom_info[metadata["pair"]] = {}

        self.custom_info[metadata["pair"]]["open"] = dataframe["open"]
        self.custom_info[metadata["pair"]]["high"] = dataframe["high"]
        self.custom_info[metadata["pair"]]["low"] = dataframe["low"]
        self.custom_info[metadata["pair"]]["close"] = dataframe["close"]
        self.custom_info[metadata["pair"]]["volume"] = dataframe["volume"]

        return super(Webhook, self).populate_indicators(dataframe, metadata)

    def populate_sell_trend(self, dataframe: DataFrame, metadata: dict) -> DataFrame:
        dataframe.loc[(), 'sell'] = 1
        return dataframe

    def confirm_trade_entry(self, pair: str, order_type: str, amount: float, rate: float, time_in_force: str, **kwargs) -> bool:
        open = self.custom_info[pair]['open']
        high = self.custom_info[pair]['high']
        low = self.custom_info[pair]['low']
        close = self.custom_info[pair]['close']
        volume = self.custom_info[pair]['volume']

        coin = pair.split('/')[0]
        stake = pair.split('/')[1]

        data = {
            'content': f'** Buy signal alert - {coin.upper()}**\n'
                       f'Disclaimer: this asset does not guarantee a profit. Don\'t risk all your money!\n'
                       f'Recommended to set 30% of stop-loss.',
            'embeds': [
                {
                    'author': {
                        'name': coin.upper(),
                        'url': f'https://www.binance.com/en/trade/{coin.upper()}_{stake.upper()}',
                        'icon_url': f'https://cryptoicons.org/api/icon/{coin.lower()}/600'
                    },
                    'fields': [
                        {
                            'name': 'Timeframe',
                            'value': self.timeframe,
                            'inline': True
                        },
                        {
                            'name': 'Open',
                            'value': f'{str(open.iloc[-1])} {stake.upper()}',
                            'inline': True
                        },
                        {
                            'name': 'Close',
                            'value': f'{str(close.iloc[-1])} {stake.upper()}',
                            'inline': True
                        },
                        {
                            'name': 'Volume',
                            'value': f'{str(volume.iloc[-1])} {stake.upper()}',
                            'inline': True
                        },
                        {
                            'name': 'High',
                            'value': f'{str(high.iloc[-1])} {stake.upper()}',
                            'inline': True
                        },
                        {
                            'name': 'Low',
                            'value': f'{str(low.iloc[-1])} {stake.upper()}',
                            'inline': True
                        },
                    ]
                }
            ]
        }

        try:
            now = datetime.datetime.now()
            future_1hour = now + datetime.timedelta(hours=1)

            # send once per hour
            if not 'next_webhook' in self.custom_info[pair] or now > self.custom_info[pair]['next_webhook']:
                for url in self.webhook_urls:
                    requests.post(url, json=data)

                self.custom_info[pair]['next_webhook'] = future_1hour
        except Exception:
            pass

        return False
