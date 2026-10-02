"""
Automated tests for validating processed field and weather data.
Run with: pytest validate_data.py -v
"""

import pandas as pd
import pytest


@pytest.fixture
def field_df():
    """Load the processed field data."""
    return pd.read_csv('sampled_field_df.csv')


@pytest.fixture
def weather_df():
    """Load the processed weather data."""
    return pd.read_csv('sampled_weather_df.csv')


def test_read_weather_DataFrame_shape(weather_df):
    """Verify the weather data dimensions."""
    assert weather_df.shape == (1843, 4)


def test_read_field_DataFrame_shape(field_df):
    """Verify the field data dimensions."""
    assert field_df.shape == (5654, 19)


def test_weather_DataFrame_columns(weather_df):
    """Check that the weather data contains the expected columns."""
    assert list(weather_df.columns) == ['Weather_station_ID', 'Message', 'Measurement', 'Value']


def test_field_DataFrame_columns(field_df):
    """Check that the field data contains the expected columns."""
    expected_columns = ['Field_ID', 'Elevation', 'Latitude', 'Longitude', 'Location', 'Slope',
                        'Rainfall', 'Min_temperature_C', 'Max_temperature_C', 'Ave_temps',
                        'Soil_fertility', 'Soil_type', 'pH', 'Pollution_level', 'Plot_size',
                        'Annual_yield', 'Crop_type', 'Standard_yield', 'Weather_station']
    assert list(field_df.columns) == expected_columns


def test_field_DataFrame_non_negative_elevation(field_df):
    """Ensure all elevation values are non-negative."""
    assert (field_df['Elevation'] >= 0).all()


def test_crop_types_are_valid(field_df):
    """Verify that all crop names match the expected values."""
    valid_crops = {'cassava', 'tea', 'wheat', 'potato', 'banana', 'coffee', 'rice', 'maize'}
    assert set(field_df['Crop_type'].unique()) == valid_crops


def test_positive_rainfall_values(field_df):
    """Ensure all rainfall values are non-negative."""
    assert (field_df['Rainfall'] >= 0).all()