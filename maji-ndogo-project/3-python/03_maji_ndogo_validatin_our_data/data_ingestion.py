"""
Functions for loading data into pandas DataFrames from databases and CSV files.
"""
import logging

import pandas as pd
from sqlalchemy import create_engine, text

logger = logging.getLogger('data_ingestion')
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')


def create_db_engine(db_path):
    """
    Create a database engine and verify the connection.

    Args:
        db_path (str): Database connection URL.

    Returns:
        sqlalchemy.engine.Engine: The database engine.

    Raises:
        ImportError: If the required dependencies are missing.
        Exception: If the engine creation or connection fails.
    """
    try:
        engine = create_engine(db_path)
        with engine.connect():
            pass
        logger.info("Database engine created successfully.")
        return engine
    except ImportError as e:
        logger.error("SQLAlchemy is required to use this function. Please install it first.")
        raise e
    except Exception as e:
        logger.error(f"Failed to create database engine. Error: {e}")
        raise e


def query_data(engine, sql_query):
    """
    Execute a SQL query and return its results as a DataFrame.

    Args:
        engine (sqlalchemy.engine.Engine): The database engine.
        sql_query (str): The SQL query to execute.

    Returns:
        pandas.DataFrame: The query results.

    Raises:
        ValueError: If the query returns no rows.
        Exception: If the query execution fails.
    """
    try:
        with engine.connect() as connection:
            df = pd.read_sql_query(text(sql_query), connection)
        if df.empty:
            msg = "The query returned an empty DataFrame."
            logger.error(msg)
            raise ValueError(msg)
        logger.info("Query executed successfully.")
        return df
    except ValueError as e:
        logger.error(f"SQL query failed. Error: {e}")
        raise e
    except Exception as e:
        logger.error(f"An error occurred while querying the database. Error: {e}")
        raise e


def read_from_web_CSV(URL):
    """
    Load a CSV file from a URL or local path into a DataFrame.

    Args:
        URL (str): The URL or file path of the CSV file.

    Returns:
        pandas.DataFrame: The loaded data.

    Raises:
        pandas.errors.EmptyDataError: If the file is empty or invalid.
        Exception: If the file cannot be read.
    """
    try:
        df = pd.read_csv(URL)
        logger.info("CSV file read successfully from the web.")
        return df
    except pd.errors.EmptyDataError as e:
        logger.error("The URL does not point to a valid CSV file. Please check the URL and try again.")
        raise e
    except Exception as e:
        logger.error(f"Failed to read CSV from the web. Error: {e}")
        raise e