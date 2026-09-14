#!/usr/bin/env python3
"""Reference solutions for the 02-data-structures exercises."""

# --- Exercise 1: Lists ---


def squares(n: int) -> list[int]:
    return [i * i for i in range(1, n + 1)]


def filter_even(numbers: list[int]) -> list[int]:
    return [x for x in numbers if x % 2 == 0]


def running_sum(numbers: list[int]) -> list[int]:
    result = []
    total = 0
    for x in numbers:
        total += x
        result.append(total)
    return result


def flatten(matrix: list[list]) -> list:
    return [item for row in matrix for item in row]


# --- Exercise 2: Dictionaries ---


def word_count(text: str) -> dict[str, int]:
    counts: dict[str, int] = {}
    for word in text.lower().split():
        counts[word] = counts.get(word, 0) + 1
    return counts


def invert_dict(d: dict) -> dict:
    result: dict = {}
    for key, value in d.items():
        if value in result:
            if isinstance(result[value], list):
                result[value].append(key)
            else:
                result[value] = [result[value], key]
        else:
            result[value] = key
    return result


def merge_dicts(a: dict, b: dict) -> dict:
    result = dict(a)
    result.update(b)
    return result


def top_n(d: dict[str, int], n: int) -> list[tuple[str, int]]:
    return sorted(d.items(), key=lambda item: item[1], reverse=True)[:n]


# --- Exercise 3: Sets and tuples ---


def common_elements(a: list, b: list) -> set:
    return set(a) & set(b)


def unique_words(sentences: list[str]) -> set[str]:
    words: set[str] = set()
    for sentence in sentences:
        words.update(sentence.lower().split())
    return words


def categorize(numbers: list[int]) -> dict[str, set[int]]:
    result: dict[str, set[int]] = {"positive": set(), "negative": set(), "zero": set()}
    for n in numbers:
        if n > 0:
            result["positive"].add(n)
        elif n < 0:
            result["negative"].add(n)
        else:
            result["zero"].add(n)
    return result


def swap_pairs(items: list) -> list:
    result = list(items)
    for i in range(0, len(result) - 1, 2):
        result[i], result[i + 1] = result[i + 1], result[i]
    return result


if __name__ == "__main__":
    print("=== Exercise 1: Lists ===")
    print(squares(5))
    print(filter_even([1, 2, 3, 4, 5, 6]))
    print(running_sum([1, 2, 3, 4]))
    print(flatten([[1, 2], [3, 4], [5]]))

    print("\n=== Exercise 2: Dictionaries ===")
    print(word_count("hello world hello"))
    print(invert_dict({"a": 1, "b": 2, "c": 1}))
    print(merge_dicts({"a": 1, "b": 2}, {"b": 3, "c": 4}))
    print(top_n({"apple": 5, "banana": 3, "cherry": 7}, 2))

    print("\n=== Exercise 3: Sets and tuples ===")
    print(common_elements([1, 2, 3], [2, 3, 4]))
    print(unique_words(["hello world", "hello there"]))
    print(categorize([1, -2, 0, 3, -4, 0]))
    print(swap_pairs([1, 2, 3, 4, 5]))
