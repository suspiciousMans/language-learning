// ex1-optional-chaining.js
// Safe property access with optional chaining.

const user = {
  name: 'Alice',
  address: {
    city: 'Portland',
    zip: '97201',
  },
};

const guest = null;

// Without optional chaining (risky)
// console.log(guest.name); // TypeError: Cannot read property 'name' of null

// With optional chaining (safe)
console.log('user.name:', user.name);
console.log('user.address?.city:', user.address?.city);
console.log('guest?.name:', guest?.name); // undefined

// Chaining deeply nested properties
console.log('user?.address?.city:', user?.address?.city);
console.log('guest?.address?.city:', guest?.address?.city); // undefined

// Optional chaining with function calls
const obj = {
  method() {
    return 'called';
  },
};

const objEmpty = null;

console.log('obj.method?.():', obj.method?.()); // 'called'
console.log('objEmpty.method?.():', objEmpty?.method?.()); // undefined

// Optional chaining with computed properties
const config = { settings: { theme: 'dark' } };
const key = 'theme';
console.log('config.settings?.[key]:', config.settings?.[key]); // 'dark'
