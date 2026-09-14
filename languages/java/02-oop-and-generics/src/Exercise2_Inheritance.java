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

    public void dailyRoutine() {
        eat();
        sleep();
    }

    public String getName() { return name; }
}

class Dog extends Animal {
    private String breed;

    public Dog(String name, int age, String breed) {
        super(name, age);
        this.breed = breed;
    }

    @Override
    public void eat() {
        System.out.println(name + " (a " + breed + ") is eating dog food");
    }

    public void bark() {
        System.out.println(name + " says: Woof!");
    }

    @Override
    public String toString() {
        return "Dog{name='" + name + "', breed='" + breed + "'}";
    }
}

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

        dog.eat();
        cat.eat();

        dog.sleep();
        cat.sleep();

        dog.bark();
        cat.purr();

        Animal myPet = dog;
        myPet.eat();
        System.out.println("Is dog a Dog? " + (myPet instanceof Dog));
        System.out.println("Is dog an Animal? " + (myPet instanceof Animal));

        if (myPet instanceof Dog) {
            Dog realDog = (Dog) myPet;
            realDog.bark();
        }

        Animal[] pets = {dog, cat};
        System.out.println();
        System.out.println("All pets daily routine:");
        for (Animal pet : pets) {
            pet.dailyRoutine();
        }
    }
}
