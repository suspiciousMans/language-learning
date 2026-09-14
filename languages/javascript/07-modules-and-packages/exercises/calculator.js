// calculator.js - Default export module
export default function calculate(a, op, b) {
  switch (op) {
    case '+':
      return a + b;
    case '-':
      return a - b;
    case '*':
      return a * b;
    case '/':
      return b !== 0 ? a / b : 'Cannot divide by zero';
    default:
      return 'Unknown operator';
  }
}
