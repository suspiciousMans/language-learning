#!/usr/bin/env python3
"""Fetch https://httpbin.org/get and assert the response.

Demonstrates using the `requests` library to call an HTTP API,
parse JSON, and assert expected response structure.
"""

import requests


def fetch_and_assert():
    url = "https://httpbin.org/get"
    params = {"q": "python-learning"}

    resp = requests.get(url, params=params, timeout=10)

    # Assert the status code
    assert resp.status_code == 200, f"expected 200, got {resp.status_code}"

    data = resp.json()

    # Assert the response contains expected keys
    assert "args" in data, "response missing 'args' key"
    assert data["args"]["q"] == "python-learning", (
        f"expected args.q == 'python-learning', got {data['args']}"
    )
    assert "url" in data, "response missing 'url' key"
    assert data["url"].startswith(url), f"unexpected url: {data['url']}"

    # Print a friendly summary
    print("=== httpbin response ===")
    print(f"URL:      {data['url']}")
    print(f"Args:     {data['args']}")
    print(f"Origin:   {data.get('origin', 'N/A')}")
    print(f"Headers:  {data.get('headers', {})}")


if __name__ == "__main__":
    fetch_and_assert()
    print("\nAll assertions passed.")
