// ex7-custom-iterables.js
// Create custom iterable objects with Symbol.iterator.

// Custom iterable: range
const range = {
  start: 1,
  end: 5,
  [Symbol.iterator]() {
    let current = this.start;
    const end = this.end;
    return {
      next() {
        if (current <= end) {
          return { value: current++, done: false };
        } else {
          return { done: true };
        }
      },
    };
  },
};

console.log('Custom iterable (range 1..5):');
for (const num of range) {
  console.log('  ', num);
}

// Custom iterable: repeat string
const repeater = {
  text: 'Hi',
  times: 3,
  [Symbol.iterator]() {
    let count = 0;
    const text = this.text;
    const times = this.times;
    return {
      next() {
        if (count < times) {
          count++;
          return { value: text, done: false };
        } else {
          return { done: true };
        }
      },
    };
  },
};

console.log('Custom iterable (repeat string):');
for (const word of repeater) {
  console.log('  ', word);
}

// Spread on custom iterable
const rangeArray = [...range];
console.log('Spread custom iterable:', rangeArray);
