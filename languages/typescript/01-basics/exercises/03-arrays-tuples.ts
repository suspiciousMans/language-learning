/**
 * 03-arrays-tuples.ts — exercise for project 01.
 *
 * Work with arrays, tuples, and array typing. Fill in the missing
 * type annotations so that tsc --noEmit passes with zero errors.
 */

// Generic helpers — annotate T and the return types.
function first(arr) {
  return arr[0];
}

function second(arr) {
  return arr[1];
}

function toPairs(arr) {
  const pairs = [];
  for (let i = 0; i < arr.length - 1; i += 2) {
    pairs.push([arr[i], arr[i + 1]]);
  }
  return pairs;
}

// Tuple literal — annotate the type.
const rgb = [255, 128, 0];

// Hint: first and second should be generic over T and return T | undefined.
//       toPairs takes T[] and returns [T, T][].
//       rgb is a [number, number, number].
