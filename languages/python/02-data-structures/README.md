# 02 — Data Structures

## Goals

Master Python's built-in data structures: lists, dictionaries, sets, and tuples. Learn when to use each and how to manipulate them effectively.

## Concepts

- Lists: indexing, slicing, methods (`append`, `extend`, `insert`, `pop`, `remove`, `sort`), list comprehensions
- Dictionaries: key-value pairs, methods (`keys`, `values`, `items`, `get`), dict comprehensions
- Sets: uniqueness, set operations (union, intersection, difference), set comprehensions
- Tuples: immutability, unpacking, use as dict keys
- Choosing the right structure for the job
- Nested structures (list of dicts, dict of lists, etc.)

## Completion Checklist

- [ ] Each exercise file runs without errors when filled in
- [ ] Solutions in `solutions/solution.py` demonstrate idiomatic Python
- [ ] Exercises cover all four structure types (list, dict, set, tuple)

## Exercises

### exercise_1_lists.py

List manipulation and comprehensions.

Tasks:
1. Write a function `squares(n: int) -> list[int]` that returns a list of squares from 1 to n using a list comprehension.
2. Write a function `filter_even(numbers: list[int]) -> list[int]` that returns only the even numbers.
3. Write a function `running_sum(numbers: list[int]) -> list[int]` that returns a list where each element is the sum of all previous elements including itself (prefix sum).
4. Write a function `flatten(matrix: list[list]) -> list` that flattens a 2D list into a 1D list.

### exercise_2_dictionaries.py

Dictionary operations and counting patterns.

Tasks:
1. Write a function `word_count(text: str) -> dict[str, int]` that returns a dictionary mapping each word (lowercased) to its count in the text. Split on whitespace.
2. Write a function `invert_dict(d: dict) -> dict` that swaps keys and values. If multiple keys share a value, collect them in a list.
3. Write a function `merge_dicts(a: dict, b: dict) -> dict` that merges two dictionaries. For keys in both, the value from `b` wins.
4. Write a function `top_n(d: dict[str, int], n: int) -> list[tuple[str, int]]` that returns the top n key-value pairs sorted by value descending.

### exercise_3_sets_and_tuples.py

Set operations and tuple usage.

Tasks:
1. Write a function `common_elements(a: list, b: list) -> set` that returns the set of elements common to both lists.
2. Write a function `unique_words(sentences: list[str]) -> set[str]` that returns the set of all unique words across all sentences (lowercased, split on whitespace).
3. Write a function `categorize(numbers: list[int]) -> dict[str, set[int]]` that returns `{"positive": set_of_positives, "negative": set_of_negatives, "zero": set_of_zeros}`.
4. Write a function `swap_pairs(items: list) -> list` that swaps adjacent pairs: `[a, b, c, d]` → `[b, a, d, c]`. If odd length, last element stays in place. Use tuple unpacking.

## Solutions

See `solutions/solution.py` for reference implementations.
