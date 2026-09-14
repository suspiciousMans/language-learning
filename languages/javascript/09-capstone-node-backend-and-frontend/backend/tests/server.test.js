// tests/server.test.js
import test from 'node:test';
import assert from 'node:assert';
import { getAllTodos, createTodo, deleteTodo, getTodoById } from '../db.js';

test('getAllTodos returns array', async () => {
  const todos = await getAllTodos();
  assert(Array.isArray(todos));
  assert(todos.length > 0);
});

test('createTodo creates a new todo', async () => {
  const todo = await createTodo('Test Todo', 'Test Description');
  assert(todo.id);
  assert.strictEqual(todo.title, 'Test Todo');
  assert.strictEqual(todo.description, 'Test Description');
  assert.strictEqual(todo.completed, false);
});

test('getTodoById returns correct todo', async () => {
  const created = await createTodo('Find Me', 'Description');
  const found = await getTodoById(created.id);
  assert.strictEqual(found.id, created.id);
  assert.strictEqual(found.title, 'Find Me');
});

test('deleteTodo removes todo', async () => {
  const created = await createTodo('Delete Me', 'Soon');
  const deleted = await deleteTodo(created.id);
  assert.strictEqual(deleted, true);
  const notFound = await getTodoById(created.id);
  assert.strictEqual(notFound, undefined);
});
