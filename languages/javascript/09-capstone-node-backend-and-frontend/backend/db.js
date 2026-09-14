// db.js
// Simple in-memory database (could be replaced with SQLite)

let todos = [
  { id: 1, title: 'Learn JavaScript', description: 'Complete projects 1-9', completed: false },
  { id: 2, title: 'Build a Todo App', description: 'Frontend and backend', completed: false },
];

let nextId = 3;

export async function getAllTodos() {
  return todos;
}

export async function getTodoById(id) {
  return todos.find((t) => t.id === id);
}

export async function createTodo(title, description = '') {
  const todo = {
    id: nextId++,
    title,
    description,
    completed: false,
    createdAt: new Date().toISOString(),
  };
  todos.push(todo);
  return todo;
}

export async function updateTodo(id, updates) {
  const todo = todos.find((t) => t.id === id);
  if (todo) {
    Object.assign(todo, updates);
    return todo;
  }
  return null;
}

export async function deleteTodo(id) {
  const index = todos.findIndex((t) => t.id === id);
  if (index !== -1) {
    todos.splice(index, 1);
    return true;
  }
  return false;
}
