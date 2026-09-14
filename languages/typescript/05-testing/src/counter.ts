/**
 * counter.ts — a small typed module under test (project 05).
 *
 * A bounded counter: it has a min and max; incrementing past max
 * and decrementing below min are no-ops.
 */

export interface Counter {
  /** Current value of the counter. */
  value: number;
  /** Increment by 1, capped at max. */
  increment(): void;
  /** Decrement by 1, capped at min. */
  decrement(): void;
  /** Reset to the initial value. */
  reset(): void;
}

export interface CreateCounterOptions {
  initial?: number;
  min?: number;
  max?: number;
}

export function createCounter(opts?: CreateCounterOptions): Counter {
  const initial = opts?.initial ?? 0;
  const min = opts?.min ?? -Infinity;
  const max = opts?.max ?? Infinity;

  let value = initial;

  return {
    get value() {
      return value;
    },
    increment() {
      const next = value + 1;
      if (next <= max) {
        value = next;
      }
    },
    decrement() {
      const next = value - 1;
      if (next >= min) {
        value = next;
      }
    },
    reset() {
      value = initial;
    },
  };
}
