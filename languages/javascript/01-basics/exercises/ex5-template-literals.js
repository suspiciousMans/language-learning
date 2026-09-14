// ex5-template-literals.js
// Template literals: embedded expressions, multiline strings, tagged templates (concept).

const user = 'Alice';
const age = 30;
const city = 'London';

// Basic interpolation
const greeting = `Hello, ${user}!`;
console.log(greeting);

// Multiple interpolations
const bio = `Name: ${user}\nAge: ${age}\nCity: ${city}`;
console.log(bio);

// Multiline strings — no need for \n or concatenation
const multiline = `This is line one.
This is line two.
This is line three.`;
console.log(multiline);

// Expression interpolation — any expression works
const a = 10;
const b = 20;
console.log(`The sum of ${a} and ${b} is ${a + b}.`);
console.log(`Is ${a} greater than ${b}? ${a > b}`);

// Tagged template (advanced — see projects/05 for more)
function highlight(strings, ...values) {
  let result = '';
  strings.forEach((str, i) => {
    result += str;
    if (values[i] !== undefined) {
      result += `<mark>${values[i]}</mark>`;
    }
  });
  return result;
}

const tagged = highlight`Hello, ${user}! You are ${age} years old.`;
console.log('Tagged template result:', tagged);

// Escaping backticks and dollar-brace in template literals
const withBacktick = `This is a backtick: \``;
const withBrace = `This is a dollar brace: \${2 + 2}`;
console.log(withBacktick);
console.log(withBrace);
