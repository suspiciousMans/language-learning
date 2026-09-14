# Project 02: OOP and Generics — Java

**Difficulty:** beginner  
**Prerequisites:** Project 01 (Basics)

## Goals

- Create classes with fields, constructors, methods, and encapsulation
- Understand inheritance, polymorphism, and abstraction
- Use interfaces and abstract classes
- Write generic classes and methods
- Understand Java's type system: wildcards, bounds, type erasure

## Concepts

- **Class** — blueprint for objects; fields (state), methods (behavior), constructors
- **Encapsulation** — private fields + public getters/setters; `this` keyword
- **Inheritance** — `extends`; single inheritance; `super` to access parent
- **Polymorphism** — override methods; dynamic dispatch; `instanceof`
- **Abstract class** — partial implementation; can have fields and concrete methods
- **Interface** — pure contract (Java 8+ can have default/static methods)
- **Generics** — type parameters `<T>`; type safety without casting
- **Wildcards** — `? extends T` (producer), `? super T` (consumer)
- **Type erasure** — generics are compile-time only; runtime sees raw types

## Exercises

### Exercise 1: Classes and Encapsulation

Create `src/Exercise1_Classes.java`:

```java
// A simple Person class with encapsulation
class Person {
    // Private fields — encapsulation
    private String name;
    private int age;
    private String email;

    // Constructor
    public Person(String name, int age, String email) {
        this.name = name;
        this.age = age;
        this.email = email;
    }

    // Getters (read access)
    public String getName() { return name; }
    public int getAge() { return age; }
    public String getEmail() { return email; }

    // Setter with validation
    public void setAge(int age) {
        if (age < 0 || age > 150) {
            throw new IllegalArgumentException("Invalid age: " + age);
        }
        this.age = age;
    }

    // Behavior method
    public String getDescription() {
        return name + " is " + age + " years old, email: " + email;
    }

    // toString for debugging
    @Override
    public String toString() {
        return "Person{name='" + name + "', age=" + age + "}";
    }

    // equals and hashCode for value comparison
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (!(obj instanceof Person)) return false;
        Person other = (Person) obj;
        return age == other.age &&
               name.equals(other.name) &&
               email.equals(other.email);
    }

    @Override
    public int hashCode() {
        return name.hashCode() * 31 + age;
    }
}

public class Exercise1_Classes {
    public static void main(String[] args) {
        // Create persons
        Person alice = new Person("Alice", 30, "alice@example.com");
        Person bob = new Person("Bob", 25, "bob@example.com");

        // Access via getters
        System.out.println(alice.getName() + " is " + alice.getAge());
        System.out.println(alice.getDescription());

        // Setters with validation
        alice.setAge(31);
        System.out.println("Alice is now " + alice.getAge());

        // try-catch for invalid data
        try {
            alice.setAge(-5);
        } catch (IllegalArgumentException e) {
            System.out.println("Caught: " + e.getMessage());
        }

        // Equality
        Person aliceCopy = new Person("Alice", 31, "alice@example.com");
        System.out.println("alice equals aliceCopy: " + alice.equals(aliceCopy));

        // toString
        System.out.println("Debug: " + alice);
    }
}
```

Compile and run. **Expected output:**

```
Alice is 30
Alice is 30 years old, email: alice@example.com
Alice is now 31
Caught: Invalid age: -5
alice equals aliceCopy: true
Debug: Person{name='Alice', age=31}
```

### Exercise 2: Inheritance and Polymorphism

Create `src/Exercise2_Inheritance.java`:

```java
// Base class (superclass)
class Animal {
    protected String name;
    protected int age;

    public Animal(String name, int age) {
        this.name = name;
        this.age = age;
    }

    public void eat() {
        System.out.println(name + " is eating");
    }

    public void sleep() {
        System.out.println(name + " is sleeping");
    }

    // Template method pattern
    public void dailyRoutine() {
        eat();
        sleep();
    }

    public String getName() { return name; }
}

// Subclass — extends Animal
class Dog extends Animal {
    private String breed;

    public Dog(String name, int age, String breed) {
        super(name, age);  // Call parent constructor
        this.breed = breed;
    }

    // Override — polymorphism
    @Override
    public void eat() {
        System.out.println(name + " (a " + breed + ") is eating dog food");
    }

    // New method specific to Dog
    public void bark() {
        System.out.println(name + " says: Woof!");
    }

    @Override
    public String toString() {
        return "Dog{name='" + name + "', breed='" + breed + "'}";
    }
}

// Subclass — extends Animal
class Cat extends Animal {
    public Cat(String name, int age) {
        super(name, age);
    }

    @Override
    public void eat() {
        System.out.println(name + " is eating fish");
    }

    public void purr() {
        System.out.println(name + " is purring");
    }
}

public class Exercise2_Inheritance {
    public static void main(String[] args) {
        Dog dog = new Dog("Rex", 5, "German Shepherd");
        Cat cat = new Cat("Whiskers", 3);

        // Polymorphic calls
        dog.eat();   // Dog's version
        cat.eat();   // Cat's version

        // Parent methods inherited
        dog.sleep();
        cat.sleep();

        // Subclass-specific methods
        dog.bark();
        cat.purr();

        // Polymorphism via supertype reference
        Animal myPet = dog;  // Upcasting
        myPet.eat();  // Still calls Dog's eat() — dynamic dispatch!
        System.out.println("Is dog a Dog? " + (myPet instanceof Dog));
        System.out.println("Is dog an Animal? " + (myPet instanceof Animal));

        // Downcasting (must check first)
        if (myPet instanceof Dog) {
            Dog realDog = (Dog) myPet;
            realDog.bark();
        }

        // Array of Animals — polymorphic array
        Animal[] pets = {dog, cat};
        System.out.println("\nAll pets daily routine:");
        for (Animal pet : pets) {
            pet.dailyRoutine();
        }
    }
}
```

Compile and run. **Expected output:**

```
Rex (a German Shepherd) is eating dog food
Whiskers is eating fish
Rex is sleeping
Whiskers is sleeping
Rex says: Woof!
Whiskers is purring
Rex (a German Shepherd) is eating dog food
Is dog a Dog? true
Is dog an Animal? true
Rex says: Woof!

All pets daily routine:
Rex (a German Shepherd) is eating dog food
Rex is sleeping
Whiskers is eating fish
Whiskers is sleeping
```

### Exercise 3: Interfaces and Abstract Classes

Create `src/Exercise3_AbstractAndInterface.java`:

```java
// Abstract class — partial implementation
abstract class Shape {
    protected String color;

    public Shape(String color) {
        this.color = color;
    }

    // Concrete method — all shapes have this
    public void describe() {
        System.out.println("A " + color + " shape");
    }

    // Abstract methods — must be implemented by subclasses
    public abstract double area();
    public abstract double perimeter();
}

// Interface — pure contract
interface Drawable {
    void draw();
}

interface Measurable {
    double getMeasurement();
}

// Class implementing multiple interfaces + extending abstract class
class Circle extends Shape implements Drawable, Measurable {
    private double radius;

    public Circle(String color, double radius) {
        super(color);
        this.radius = radius;
    }

    @Override
    public double area() {
        return Math.PI * radius * radius;
    }

    @Override
    public double perimeter() {
        return 2 * Math.PI * radius;
    }

    @Override
    public void draw() {
        System.out.println("Drawing a " + color + " circle with radius " + radius);
    }

    @Override
    public double getMeasurement() {
        return radius;
    }
}

class Rectangle extends Shape implements Drawable, Measurable {
    private double width;
    private double height;

    public Rectangle(String color, double width, double height) {
        super(color);
        this.width = width;
        this.height = height;
    }

    @Override
    public double area() {
        return width * height;
    }

    @Override
    public double perimeter() {
        return 2 * (width + height);
    }

    @Override
    public void draw() {
        System.out.println("Drawing a " + color + " rectangle " + width + "x" + height);
    }

    @Override
    public double getMeasurement() {
        return area();  // Return area as measurement
    }
}

public class Exercise3_AbstractAndInterface {
    public static void main(String[] args) {
        Circle circle = new Circle("red", 5.0);
        Rectangle rect = new Rectangle("blue", 4.0, 6.0);

        // Abstract class features
        circle.describe();
        System.out.println("Circle area: " + circle.area());
        System.out.println("Circle perimeter: " + circle.perimeter());

        rect.describe();
        System.out.println("Rectangle area: " + rect.area());
        System.out.println("Rectangle perimeter: " + rect.perimeter());

        // Interface polymorphism
        Drawable[] drawableThings = {circle, rect};
        System.out.println("\nDrawing everything:");
        for (Drawable d : drawableThings) {
            d.draw();
        }

        // Interface as parameter type
        printMeasurable(circle);
        printMeasurable(rect);

        // Multiple interfaces on one object
        Measurable m = circle;
        System.out.println("\nCircle measurement (radius): " + m.getMeasurement());
        m = rect;
        System.out.println("Rectangle measurement (area): " + m.getMeasurement());
    }

    private static void printMeasurable(Measurable m) {
        System.out.println("Measurement: " + m.getMeasurement());
    }
}
```

Compile and run. **Expected output:**

```
A red shape
Circle area: 78.53981633974483
Circle perimeter: 31.41592653589793
A blue shape
Rectangle area: 24.0
Rectangle perimeter: 20.0

Drawing everything:
Drawing a red circle with radius 5.0
Drawing a blue rectangle 4.0x6.0

Measurement: 5.0
Measurement: 24.0

Circle measurement (radius): 5.0
Rectangle measurement (area): 24.0
```

### Exercise 4: Generics — Generic Classes and Methods

Create `src/Exercise4_Generics.java`:

```java
// Generic class — type parameter T
class Box<T> {
    private T content;

    public void set(T content) { this.content = content; }
    public T get() { return content; }

    public String describe() {
        return "Box containing a " + (content != null ? content.getClass().getSimpleName() : "null");
    }
}

// Generic method — type parameter on method
class Utils {
    // Returns the first element, or null if empty
    public static <T> T first(List<T> list) {
        if (list == null || list.isEmpty()) return null;
        return list.get(0);
    }

    // Swap two elements in an array
    public static <T> void swap(T[] array, int i, int j) {
        T temp = array[i];
        array[i] = array[j];
        array[j] = temp;
    }

    // Generic with bounded type parameter
    public static <T extends Comparable<T>> T min(T a, T b) {
        return a.compareTo(b) < 0 ? a : b;
    }
}

public class Exercise4_Generics {
    public static void main(String[] args) {
        // Box<String>
        Box<String> stringBox = new Box<>();
        stringBox.set("Hello, Generics!");
        System.out.println(stringBox.describe());
        System.out.println("Content: " + stringBox.get());

        // Box<Integer>
        Box<Integer> intBox = new Box<>();
        intBox.set(42);
        System.out.println(intBox.describe());
        System.out.println("Content: " + intBox.get());

        // Diamond operator (Java 7+) — type inferred from context
        Box<Double> doubleBox = new Box<>();
        doubleBox.set(3.14);
        System.out.println("Double box: " + doubleBox.get());

        // Generic methods
        List<String> names = Arrays.asList("Alice", "Bob", "Charlie");
        String first = Utils.first(names);
        System.out.println("First name: " + first);

        Integer[] numbers = {5, 2, 8, 1, 9};
        System.out.println("Before swap: " + Arrays.toString(numbers));
        Utils.swap(numbers, 0, 3);
        System.out.println("After swap (0 <-> 3): " + Arrays.toString(numbers));

        // Bounded generics
        System.out.println("Min of 10 and 20: " + Utils.min(10, 20));
        System.out.println("Min of 'z' and 'a': " + Utils.min("z", "a"));
    }
}
