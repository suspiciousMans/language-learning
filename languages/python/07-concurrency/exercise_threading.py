#!/usr/bin/env python3
"""Exercise: threading — download many URLs concurrently.

Demonstrates:
- threading.Thread for concurrent I/O
- threading.Lock for shared state
- measuring elapsed time to show concurrency gain
"""

import time
import random
import threading
from concurrent.futures import ThreadPoolExecutor, as_completed


def simulate_download(url: str) -> int:
    """Simulate downloading a URL (sleeps, then returns 200)."""
    delay = random.uniform(0.1, 0.5)
    time.sleep(delay)
    return 200


def download_many_lock(urls: list[str]) -> dict[str, int]:
    """Download many URLs concurrently using threads and a Lock.

    Returns {url: status_code}.
    """
    results: dict[str, int] = {}
    lock = threading.Lock()

    def worker(url: str):
        status = simulate_download(url)
        with lock:
            results[url] = status

    threads = []
    for url in urls:
        t = threading.Thread(target=worker, args=(url,))
        threads.append(t)
        t.start()

    for t in threads:
        t.join()

    return results


def download_many_executor(urls: list[str]) -> dict[str, int]:
    """Download many URLs concurrently using ThreadPoolExecutor.

    Returns {url: status_code}.
    """
    results: dict[str, int] = {}
    lock = threading.Lock()

    def worker(url: str):
        status = simulate_download(url)
        with lock:
            results[url] = status

    with ThreadPoolExecutor(max_workers=len(urls)) as executor:
        futures = [executor.submit(worker, url) for url in urls]
        for future in as_completed(futures):
            future.result()  # raise if the worker raised

    return results


if __name__ == "__main__":
    urls = [f"https://example.com/page/{i}" for i in range(5)]

    # Pick one implementation to run
    impl = download_many_executor  # or download_many_lock

    start = time.monotonic()
    results = impl(urls)
    elapsed = time.monotonic() - start

    print(f"Downloaded {len(results)} URLs in {elapsed:.3f}s")
    for url, status in results.items():
        print(f"  {url} -> {status}")

    # Assert concurrency: elapsed should be less than sum of all sleeps
    # (each sleep is 0.1-0.5s, 5 URLs -> sum is 0.5-2.5s; concurrent should be ~0.5s max)
    total_sleep = sum(random.uniform(0.1, 0.5) for _ in urls)
    print(f"Total sleep if sequential would be ~{total_sleep:.3f}s")
    assert elapsed < total_sleep, (
        f"Expected concurrent time ({elapsed:.3f}s) < sequential ({total_sleep:.3f}s)"
    )
    print("Concurrency check passed.")
