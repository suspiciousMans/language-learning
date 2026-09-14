// ex2-nullish-coalescing.js
// Provide defaults with nullish coalescing (??) vs logical OR (||).

// Difference: ?? only checks for null/undefined, not falsy
const name = undefined;
const color = '';
const count = 0;

console.log('With ?? (nullish coalescing):');
console.log('name ?? "Guest":', name ?? 'Guest'); // "Guest" (undefined → fallback)
console.log('color ?? "blue":', color ?? 'blue'); // "" (empty string is not nullish)
console.log('count ?? 1:', count ?? 1); // 0 (zero is not nullish)

console.log('\nWith || (logical OR):');
console.log('name || "Guest":', name || 'Guest'); // "Guest"
console.log('color || "blue":', color || 'blue'); // "blue" ('' is falsy)
console.log('count || 1:', count || 1); // 1 (0 is falsy)

// Use ?? for config defaults (preserves 0, '', false)
const config = {
  timeout: 0,
  retries: undefined,
};

const finalTimeout = config.timeout ?? 3000;
const finalRetries = config.retries ?? 3;

console.log('\nConfig defaults:');
console.log('timeout:', finalTimeout); // 0 (kept, not overridden)
console.log('retries:', finalRetries); // 3 (undefined → fallback)

// Nullish assignment operator (??=)
let x;
x ??= 10;
console.log('\nNullish assignment:');
console.log('x after x ??= 10:', x); // 10

let y = 5;
y ??= 20;
console.log('y after y ??= 20:', y); // 5 (not null/undefined)
