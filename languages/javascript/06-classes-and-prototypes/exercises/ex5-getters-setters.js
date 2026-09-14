// ex5-getters-setters.js
// Getters and setters in classes.

class Rectangle {
  constructor(width, height) {
    this._width = width;
    this._height = height;
  }

  get width() {
    return this._width;
  }

  set width(value) {
    if (value <= 0) {
      throw new Error('Width must be positive');
    }
    this._width = value;
  }

  get height() {
    return this._height;
  }

  set height(value) {
    if (value <= 0) {
      throw new Error('Height must be positive');
    }
    this._height = value;
  }

  get area() {
    return this._width * this._height;
  }

  get perimeter() {
    return 2 * (this._width + this._height);
  }
}

const rect = new Rectangle(10, 20);
console.log('Width:', rect.width);
console.log('Height:', rect.height);
console.log('Area:', rect.area);
console.log('Perimeter:', rect.perimeter);

rect.width = 15;
console.log('Updated area:', rect.area);

try {
  rect.height = -5;
} catch (error) {
  console.log('Error:', error.message);
}
