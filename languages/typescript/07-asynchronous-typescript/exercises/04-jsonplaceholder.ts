/**
 * 04-jsonplaceholder.ts — project 07 exercise.
 *
 * Fetch from jsonplaceholder.typicode.com, assert the typed response,
 * and handle errors.
 *
 * Run: npx tsx exercises/04-jsonplaceholder.ts
 *
 * Endpoint: https://jsonplaceholder.typicode.com/todos/1
 */

// The shape of a jsonplaceholder todo.
interface JsonPlaceholderTodo {
  userId: number;
  id: number;
  title: string;
  completed: boolean;
}

const BASE_URL = "https://jsonplaceholder.typicode.com";

/**
 * Fetch a single todo by id and assert it matches JsonPlaceholderTodo.
 */
async function fetchTodo(id: number): Promise<JsonPlaceholderTodo> {
  const url = `${BASE_URL}/todos/${id}`;
  const response = await fetch(url);

  if (!response.ok) {
    throw new Error(`fetch todo ${id} failed: ${response.status} ${response.statusText}`);
  }

  const todo: JsonPlaceholderTodo = await response.json();
  return todo;
}

/**
 * Fetch a list of todos and assert the shape of each.
 */
async function fetchTodos(): Promise<JsonPlaceholderTodo[]> {
  const response = await fetch(`${BASE_URL}/todos`);

  if (!response.ok) {
    throw new Error(`fetch todos failed: ${response.status} ${response.statusText}`);
  }

  const todos: JsonPlaceholderTodo[] = await response.json();
  return todos;
}

async function main() {
  console.log("=== jsonplaceholder exercise ===");

  // Fetch one todo.
  try {
    const todo = await fetchTodo(1);
    console.log("single todo:");
    console.log(`  userId: ${todo.userId} (type: ${typeof todo.userId})`);
    console.log(`  id: ${todo.id} (type: ${typeof todo.id})`);
    console.log(`  title: ${todo.title} (type: ${typeof todo.title})`);
    console.log(`  completed: ${todo.completed} (type: ${typeof todo.completed})`);
  } catch (err) {
    if (err instanceof Error) {
      console.error("failed to fetch single todo:", err.message);
    } else {
      console.error("unexpected error:", err);
    }
  }

  // Fetch a list and assert the first item.
  try {
    const todos = await fetchTodos();
    console.log("\nfetched", todos.length, "todos");

    if (todos.length > 0) {
      const first = todos[0];
      console.log("first todo title:", first.title);
      console.log("first todo completed:", first.completed);

      // Assert: every item in the list should have the expected shape.
      for (const t of todos) {
        if (typeof t.userId !== "number") {
          throw new Error("userId is not a number");
        }
        if (typeof t.id !== "number") {
          throw new Error("id is not a number");
        }
        if (typeof t.title !== "string") {
          throw new Error("title is not a string");
        }
        if (typeof t.completed !== "boolean") {
          throw new Error("completed is not a boolean");
        }
      }
      console.log("all assertions passed: every todo matches JsonPlaceholderTodo");
    }
  } catch (err) {
    if (err instanceof Error) {
      console.error("failed to fetch todos:", err.message);
    } else {
      console.error("unexpected error:", err);
    }
  }
}

main();
