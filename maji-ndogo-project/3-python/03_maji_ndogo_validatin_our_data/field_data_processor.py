"""
Processes Maji Ndogo field survey data by loading it from a database,
cleaning the data, and mapping each field to its weather station.
"""

import logging

import pandas as pd

from data_ingestion import create_db_engine, query_data, read_from_web_CSV


class FieldDataProcessor:
    """
    Load, clean, and enrich field survey data.

    Attributes:
        db_path (str): Database connection URL.
        sql_query (str): SQL query used to retrieve field data.
        columns_to_rename (dict): Column names to swap.
        values_to_rename (dict): Incorrect values and their corrections.
        weather_map_data (str): Path or URL of the weather mapping CSV.
        df (pandas.DataFrame): Processed field data.
        engine: Database connection engine.
    """

    def __init__(self, config_params, logging_level="INFO"):
        """Initialize the processor using the provided configuration."""
        self.db_path = config_params['db_path']
        self.sql_query = config_params['sql_query']
        self.columns_to_rename = config_params['columns_to_rename']
        self.values_to_rename = config_params['values_to_rename']
        self.weather_map_data = config_params['weather_mapping_csv']

        self.initialize_logging(logging_level)

        self.df = None
        self.engine = None

    def initialize_logging(self, logging_level):
        """Configure the logging level for the processor."""
        logger_name = __name__ + ".FieldDataProcessor"
        self.logger = logging.getLogger(logger_name)
        self.logger.propagate = False

        if logging_level.upper() == "DEBUG":
            log_level = logging.DEBUG
        elif logging_level.upper() == "INFO":
            log_level = logging.INFO
        elif logging_level.upper() == "NONE":
            self.logger.disabled = True
            return
        else:
            log_level = logging.INFO

        self.logger.setLevel(log_level)

        if not self.logger.handlers:
            ch = logging.StreamHandler()
            formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
            ch.setFormatter(formatter)
            self.logger.addHandler(ch)

    def ingest_sql_data(self):
        """Load field data from the database using the configured SQL query."""
        self.engine = create_db_engine(self.db_path)
        self.df = query_data(self.engine, self.sql_query)
        self.logger.info("Sucessfully loaded data.")
        return self.df

    def rename_columns(self):
        """Swap the names of two columns according to the configuration."""
        column1, column2 = list(self.columns_to_rename.keys())[0], list(self.columns_to_rename.values())[0]

        temp_name = "__temp_name_for_swap__"
        while temp_name in self.df.columns:
            temp_name += "_"

        self.df = self.df.rename(columns={column1: temp_name, column2: column1})
        self.df = self.df.rename(columns={temp_name: column2})
        self.logger.info(f"Swapped columns: {column1} with {column2}")

    def apply_corrections(self, column_name='Crop_type', abs_column='Elevation'):
        """Correct elevation values and standardize crop names."""
        self.df[abs_column] = self.df[abs_column].abs()
        self.df[column_name] = self.df[column_name].apply(
            lambda crop: self.values_to_rename.get(crop.strip(), crop.strip())
        )

    def weather_station_mapping(self):
        """Merge weather station information into the field data using Field_ID."""
        weather_map_df = read_from_web_CSV(self.weather_map_data)
        self.df = self.df.merge(weather_map_df, on='Field_ID', how='left')
        self.df = self.df.drop(columns="Unnamed: 0")

    def process(self):
        """Execute all field-data processing steps in sequence."""
        self.ingest_sql_data()
        self.rename_columns()
        self.apply_corrections()
        self.weather_station_mapping()