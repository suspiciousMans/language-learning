/**
 * 02-types/exercises/04-narrowing.ts
 *
 * Narrow values using typeof, !== null, and the `in` operator.
 * Fill in the narrowing logic so that `npx tsc --noEmit` passes.
 */

// Narrow a string | number down to string with typeof.
function processValue(x: string | number | boolean): string {
  if (/* typeof x === ... */) {
    return `string: ${x.toUpperCase()}`;
  }
  if (/* typeof x === ... */) {
    return `number: ${x.toFixed(2)}`;
  }
  // x is boolean here
  return `boolean: ${x ? "yes" : "no"}`;
}

// Narrow a string | null down to string with a null check.
function handleNull(x: string | null): string {
  if (/* x !== null */) {
    return x.toUpperCase();
  }
  return "(null)";
}

// Use the `in` operator to narrow an unknown to an object with a label.
function hasLabel(obj: unknown): obj is { label: string } {
  return /* typeof obj === "object" && obj !== null && "label" in obj */;
}

function extractLabel(obj: unknown): string {
  if (hasLabel(obj)) {
    return obj.label;
  }
  return "(no label)";
}
