/**
 * 03-arrays-tuples.solution.ts — reference solution for project 01, exercise 03.
 */

function first<T>(arr: T[]): T | undefined {
  return arr[0];
}

function second<T>(arr: T[]): T | undefined {
  return arr[1];
}

function toPairs<T>(arr: T[]): [T, T][] {
  const pairs: [T, T][] = [];
  for (let i = 0; i < arr.length - 1; i += 2) {
    pairs.push([arr[i], arr[i + 1]]);
  }
  return pairs;
}

const rgb: [number, number, number] = [255, 128, 0];
