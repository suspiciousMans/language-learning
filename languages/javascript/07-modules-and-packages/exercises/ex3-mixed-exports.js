// ex3-mixed-exports.js - Mixed default and named exports
export default function sayHello(name) {
  return `Hello, ${name}!`;
}

export const greet = (greeting, name) => `${greeting}, ${name}!`;
export const goodbye = (name) => `Goodbye, ${name}!`;
