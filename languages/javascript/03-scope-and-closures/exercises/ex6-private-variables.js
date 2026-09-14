// ex6-private-variables.js
// Use closures to create private variables.

function createUser(initialName) {
  let name = initialName;
  let age = 0;
  
  return {
    getName() {
      return name;
    },
    setName(newName) {
      name = newName;
    },
    getAge() {
      return age;
    },
    birthday() {
      age++;
    },
  };
}

const user = createUser('Alice');
console.log('Name:', user.getName());
console.log('Age:', user.getAge());

user.setName('Alicia');
console.log('Updated name:', user.getName());

user.birthday();
user.birthday();
console.log('After 2 birthdays, age:', user.getAge());

console.log('\nPrivate variables not accessible:');
console.log('user.name:', user.name);
console.log('user.age:', user.age);
