#!/usr/bin/env python3
"""Exercise: asyncio — fetch many URLs concurrently.

Demonstrates:
- async/await
- asyncio.gather for concurrent coroutines
- asyncio.to_thread for bridging sync I/O into async code
  (no extra dependency required; uses requests via threads)
"""

import asyncio
import time
import requests


async def fetch_one(url: str) -> dict:
    """Fetch a single URL using asyncio.to_thread (brings blocking requests into async)."""

    def _get():
        resp = requests.get(url, timeout=10)
        resp.raise_for_status()
        return resp.json()

    data = await asyncio.to_thread(_get)
    return {"url": url, "status": 200, "data": data}


async def fetch_many(urls: list[str]) -> list[dict]:
    """Fetch many URLs concurrently."""
    tasks = [fetch_one(url) for url in urls]
    return await asyncio.gather(*tasks)


async def main():
    urls = [
        "https://httpbin.org/get",
        "https://httpbin.org/headers",
        "https://httpbin.org/ip",
    ]

    start = time.monotonic()
    results = await fetch_many(urls)
    elapsed = time.monotonic() - start

    for r in results:
        print(f"URL: {r['url']}")
        print(f"  args: {r['data'].get('args', {})}")
        print()

    print(f"Fetched {len(results)} URLs in {elapsed:.3f}s")


if __name__ == "__main__":
    asyncio.run(main())
