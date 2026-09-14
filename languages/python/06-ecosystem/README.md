# 06 — Ecosystem and Dependencies

## Goals

Learn how to use third-party packages in Python: install them with `pip`, declare them in `requirements.txt`, read their documentation, and call external APIs.

## Concepts

- PyPI and pip
- `requirements.txt` and dependency pinning
- Virtual environments (recommended)
- Reading package documentation
- Using `requests` to call HTTP APIs
- JSON responses and data parsing
- Error handling for network calls (timeouts, status codes)

## Completion Checklist

- [ ] `pip install -r projects/06-ecosystem/requirements.txt` succeeds
- [ ] `python3 projects/06-ecosystem/fetch_httpbin.py` runs and prints a summary of the httpbin response
- [ ] The script asserts that the response is a 200 and contains expected keys

## Requirements

See `requirements.txt`.

## Script

### fetch_httpbin.py

Write a script that:

1. Calls `https://httpbin.org/get` with a query parameter `?q=python-learning`.
2. Asserts the response status code is 200.
3. Asserts the response JSON contains an `args` key with `q == "python-learning"`.
4. Asserts the response JSON contains a `url` key.
5. Prints a friendly summary of the response (URL, args, headers, origin).

## Requirements file

`requirements.txt` should contain:

```
requests>=2.31
```

## Running

```bash
pip install -r projects/06-ecosystem/requirements.txt
python3 projects/06-ecosystem/fetch_httpbin.py
```

## Notes

httpbin.org is a public test service. It may be slow or temporarily unavailable. If it fails, the script should fail cleanly with an assertion error, not a cryptic traceback.
