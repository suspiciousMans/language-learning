"""Tests for the weather module — demonstrates mocking with pytest."""

import pytest
from unittest.mock import patch, MagicMock
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from weather import get_weather


def test_get_weather_mocked():
    """Test get_weather without making a real network call."""
    mock_response = MagicMock()
    mock_response.raise_for_status = MagicMock()
    mock_response.json.return_value = {"args": {"city": "Paris"}, "url": "https://httpbin.org/get?city=Paris"}

    with patch("weather.requests.get", return_value=mock_response) as mock_get:
        result = get_weather("Paris")

    mock_get.assert_called_once()
    mock_get.assert_called_with(
        "https://httpbin.org/get",
        params={"city": "Paris"},
        timeout=5,
    )
    mock_response.raise_for_status.assert_called_once()
    assert result["city"] == "Paris"
    assert result["raw"]["args"]["city"] == "Paris"


def test_get_weather_http_error():
    """Test that get_weather propagates HTTP errors."""
    import requests as req

    with patch("weather.requests.get", side_effect=req.HTTPError("500 Server Error")):
        with pytest.raises(req.HTTPError):
            get_weather("Nowhere")
