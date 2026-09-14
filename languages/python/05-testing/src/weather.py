"""weather — example module with an external dependency for mocking practice."""

import requests


def get_weather(city: str) -> dict:
    """Fetch weather data for a city from httpbin (mocked in tests).

    In production this would call a real weather API.
    """
    resp = requests.get(
        "https://httpbin.org/get",
        params={"city": city},
        timeout=5,
    )
    resp.raise_for_status()
    data = resp.json()
    return {"city": city, "raw": data}
