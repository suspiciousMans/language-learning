// string-utils.js
export const uppercase = (str) => str.toUpperCase();
export const lowercase = (str) => str.toLowerCase();
export const capitalize = (str) => str.charAt(0).toUpperCase() + str.slice(1);
export const reverse = (str) => str.split('').reverse().join('');
