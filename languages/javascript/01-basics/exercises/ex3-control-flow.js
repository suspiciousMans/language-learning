// ex3-control-flow.js
// if/else, for, while, switch

// 1) if/else — classify a number
function classifyNumber(n) {
  if (n > 0) return 'positive';
  if (n < 0) return 'negative';
  return 'zero';
}

console.log('classify 5:', classifyNumber(5));
console.log('classify -3:', classifyNumber(-3));
console.log('classify 0:', classifyNumber(0));

// 2) for loop — sum 1..10
let sum = 0;
for (let i = 1; i <= 10; i++) {
  sum += i;
}
console.log('sum 1..10:', sum); // 55

// 3) while loop — count down from 5 to 1
let countdown = 5;
while (countdown > 0) {
  console.log('countdown:', countdown);
  countdown--;
}
console.log('blast off!');

// 4) switch — map day number to name
function dayName(day) {
  switch (day) {
    case 0:
      return 'Sunday';
    case 1:
      return 'Monday';
    case 2:
      return 'Tuesday';
    case 3:
      return 'Wednesday';
    case 4:
      return 'Thursday';
    case 5:
      return 'Friday';
    case 6:
      return 'Saturday';
    default:
      return 'invalid day';
  }
}

console.log('day 0:', dayName(0));
console.log('day 1:', dayName(1));
console.log('day 6:', dayName(6));
console.log('day 9:', dayName(9));

// switch with fall-through (intentional — cases share code)
function describeGrade(grade) {
  switch (grade) {
    case 'A':
    case 'B':
      return 'good';
    case 'C':
      return 'acceptable';
    case 'D':
    case 'F':
      return 'needs improvement';
    default:
      return 'unknown grade';
  }
}

console.log('grade A:', describeGrade('A'));
console.log('grade C:', describeGrade('C'));
