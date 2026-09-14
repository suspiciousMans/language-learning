class Person {
    private String name;
    private int age;
    private String email;

    public Person(String name, int age, String email) {
        this.name = name;
        this.age = age;
        this.email = email;
    }

    public String getName() { return name; }
    public int getAge() { return age; }
    public String getEmail() { return email; }

    public void setAge(int age) {
        if (age < 0 || age > 150) {
            throw new IllegalArgumentException("Invalid age: " + age);
        }
        this.age = age;
    }

    public String getDescription() {
        return name + " is " + age + " years old, email: " + email;
    }

    @Override
    public String toString() {
        return "Person{name='" + name + "', age=" + age + "}";
    }

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
        Person alice = new Person("Alice", 30, "alice@example.com");
        Person bob = new Person("Bob", 25, "bob@example.com");

        System.out.println(alice.getName() + " is " + alice.getAge());
        System.out.println(alice.getDescription());

        alice.setAge(31);
        System.out.println("Alice is now " + alice.getAge());

        try {
            alice.setAge(-5);
        } catch (IllegalArgumentException e) {
            System.out.println("Caught: " + e.getMessage());
        }

        Person aliceCopy = new Person("Alice", 31, "alice@example.com");
        System.out.println("alice equals aliceCopy: " + alice.equals(aliceCopy));
        System.out.println("Debug: " + alice);
    }
}
