#!/usr/bin/env python3
from datetime import datetime
import polars as pl

gdp = pl.DataFrame(
    {
        "date": [
            datetime(2016, 1, 1),
            datetime(2017, 1, 1),
            datetime(2018, 1, 1),
            datetime(2019, 1, 1),
        ],  # note record date: Jan 1st (sorted!)
        "gdp": [4164, 4411, 4566, 4696],
    }
).set_sorted("date")

population = pl.DataFrame(
    {
        "date": [
            datetime(2016, 5, 12),
            datetime(2017, 5, 12),
            datetime(2018, 5, 12),
            datetime(2019, 5, 12),
        ],  # note record date: May 12th (sorted!)
        "population": [82.19, 82.66, 83.12, 83.52],
    }
).set_sorted("date")

population.join_asof(gdp, on="date", strategy="backward")
