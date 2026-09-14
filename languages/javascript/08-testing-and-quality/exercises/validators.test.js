// validators.test.js
import test from 'node:test';
import assert from 'node:assert';
import { isEmail, isPhoneNumber, isStrongPassword } from './validators.js';

test('isEmail: valid emails', () => {
  assert(isEmail('test@example.com'));
  assert(isEmail('user.name@domain.co.uk'));
});

test('isEmail: invalid emails', () => {
  assert(!isEmail('invalid'));
  assert(!isEmail('@example.com'));
  assert(!isEmail('test@'));
});

test('isPhoneNumber: valid phone numbers', () => {
  assert(isPhoneNumber('5551234567'));
  assert(isPhoneNumber('555-123-4567'));
});

test('isPhoneNumber: invalid phone numbers', () => {
  assert(!isPhoneNumber('123'));
  assert(!isPhoneNumber('abcdefghij'));
});

test('isStrongPassword: valid passwords', () => {
  assert(isStrongPassword('SecurePass1'));
  assert(isStrongPassword('MyPassword123'));
});

test('isStrongPassword: invalid passwords', () => {
  assert(!isStrongPassword('weak'));
  assert(!isStrongPassword('nouppercase1'));
  assert(!isStrongPassword('NONUMBER'));
});
