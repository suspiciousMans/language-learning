abstract class Shape {
    protected String color;

    public Shape(String color) {
        this.color = color;
    }

    public void describe() {
        System.out.println("A " + color + " shape");
    }

    public abstract double area();
    public abstract double perimeter();
}

interface Drawable {
    void draw();
}

interface Measurable {
    double getMeasurement();
}

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
        return area();
    }
}

public class Exercise3_AbstractAndInterface {
    public static void main(String[] args) {
        Circle circle = new Circle("red", 5.0);
        Rectangle rect = new Rectangle("blue", 4.0, 6.0);

        circle.describe();
        System.out.println("Circle area: " + circle.area());
        System.out.println("Circle perimeter: " + circle.perimeter());

        rect.describe();
        System.out.println("Rectangle area: " + rect.area());
        System.out.println("Rectangle perimeter: " + rect.perimeter());

        Drawable[] drawableThings = {circle, rect};
        System.out.println();
        System.out.println("Drawing everything:");
        for (Drawable d : drawableThings) {
            d.draw();
        }

        printMeasurable(circle);
        printMeasurable(rect);

        Measurable m = circle;
        System.out.println();
        System.out.println("Circle measurement (radius): " + m.getMeasurement());
        m = rect;
        System.out.println("Rectangle measurement (area): " + m.getMeasurement());
    }

    private static void printMeasurable(Measurable m) {
        System.out.println("Measurement: " + m.getMeasurement());
    }
}
