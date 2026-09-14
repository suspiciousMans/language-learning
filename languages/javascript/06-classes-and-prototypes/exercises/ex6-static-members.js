// ex6-static-members.js
// Static methods and properties in classes.

class MathUtils {
  static PI = 3.14159;
  static E = 2.71828;

  static circleArea(radius) {
    return this.PI * radius * radius;
  }

  static circleCircumference(radius) {
    return 2 * this.PI * radius;
  }

  static isPrime(num) {
    if (num <= 1) return false;
    if (num === 2) return true;
    for (let i = 2; i < num; i++) {
      if (num % i === 0) return false;
    }
    return true;
  }
}

console.log('PI:', MathUtils.PI);
console.log('E:', MathUtils.E);
console.log('Circle area (r=5):', MathUtils.circleArea(5));
console.log('Circle circumference (r=5):', MathUtils.circleCircumference(5));

console.log('Is 17 prime?', MathUtils.isPrime(17));
console.log('Is 20 prime?', MathUtils.isPrime(20));

// Static members do not belong to instances
const instance = new MathUtils();
console.log('instance.PI:', instance.PI); // undefined
console.log('instance.circleArea:', instance.circleArea); // undefined
