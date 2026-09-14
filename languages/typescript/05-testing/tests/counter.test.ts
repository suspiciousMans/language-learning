/**
 * counter.test.ts — Vitest test suite for the counter module.
 *
 * Run with: npx vitest run
 */

import { describe, it, expect, beforeEach } from "vitest";
import { createCounter } from "../src/counter";

describe("createCounter", () => {
  it("starts at the given initial value", () => {
    const c = createCounter({ initial: 10 });
    expect(c.value).toBe(10);
  });

  it("defaults to 0 when no initial value is given", () => {
    const c = createCounter();
    expect(c.value).toBe(0);
  });

  it("increments the value by 1", () => {
    const c = createCounter({ initial: 5 });
    c.increment();
    expect(c.value).toBe(6);
  });

  it("decrements the value by 1", () => {
    const c = createCounter({ initial: 5 });
    c.decrement();
    expect(c.value).toBe(4);
  });

  it("respects a max bound — incrementing past max is a no-op", () => {
    const c = createCounter({ initial: 9, max: 10 });
    c.increment();
    c.increment();
    expect(c.value).toBe(10);
  });

  it("respects a min bound — decrementing below min is a no-op", () => {
    const c = createCounter({ initial: 0, min: 0 });
    c.decrement();
    c.decrement();
    expect(c.value).toBe(0);
  });

  it("reset returns the counter to its initial value", () => {
    const c = createCounter({ initial: 7 });
    c.increment();
    c.increment();
    c.reset();
    expect(c.value).toBe(7);
  });

  it("type check: counter object matches the Counter interface", () => {
    const c = createCounter({ initial: 1, min: 0, max: 5 });
    expect(c).toBeTypeOf("object");
    expect(c.value).toBeTypeOf("number");
  });
});
