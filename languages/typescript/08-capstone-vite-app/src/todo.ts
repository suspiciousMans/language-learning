/**
 * todo.ts — typed todo domain logic for the capstone starter.
 *
 * Fully typed: no `any` in the domain layer. DOM types stay in main.ts.
 */

export interface Todo {
  id: string;
  title: string;
  completed: boolean;
  createdAt: number;
}

export type Filter = "all" | "active" | "completed";

export type ChangeCallback = () => void;

export class TodoStore {
  private todos: Todo[] = [];
  private filter: Filter = "all";
  private callbacks: Set<ChangeCallback> = new Set();

  constructor() {
    this.load();
  }

  /** Add a todo and persist. */
  add(title: string): void {
    const todo: Todo = {
      id: crypto.randomUUID(),
      title,
      completed: false,
      createdAt: Date.now(),
    };
    this.todos.push(todo);
    this.persist();
    this.emit();
  }

  /** Toggle completed status. */
  toggle(id: string): void {
    const todo = this.todos.find((t) => t.id === id);
    if (todo) {
      todo.completed = !todo.completed;
      this.persist();
      this.emit();
    }
  }

  /** Remove a todo by id. */
  remove(id: string): void {
    this.todos = this.todos.filter((t) => t.id !== id);
    this.persist();
    this.emit();
  }

  /** Set the active filter. */
  setFilter(filter: Filter): void {
    this.filter = filter;
    this.emit();
  }

  /** Current filter. */
  getFilter(): Filter {
    return this.filter;
  }

  /** All todos. */
  getAll(): Todo[] {
    return this.todos;
  }

  /** Todos visible under the current filter. */
  visibleTodos(): Todo[] {
    switch (this.filter) {
      case "all":
        return this.todos;
      case "active":
        return this.todos.filter((t) => !t.completed);
      case "completed":
        return this.todos.filter((t) => t.completed);
    }
  }

  /** Register a callback invoked on any state change. */
  onChange(cb: ChangeCallback): void {
    this.callbacks.add(cb);
  }

  private emit(): void {
    for (const cb of this.callbacks) {
      cb();
    }
  }

  private persist(): void {
    try {
      localStorage.setItem("capstone-todos", JSON.stringify(this.todos));
    } catch {
      // localStorage may be unavailable; silently ignore.
    }
  }

  private load(): void {
    try {
      const raw = localStorage.getItem("capstone-todos");
      if (raw) {
        const parsed = JSON.parse(raw) as unknown;
        if (Array.isArray(parsed)) {
          this.todos = parsed.map(
            (item): Todo => ({
              id: String(item.id),
              title: String(item.title),
              completed: Boolean(item.completed),
              createdAt: typeof item.createdAt === "number" ? item.createdAt : Date.now(),
            })
          );
        }
      }
    } catch {
      // Ignore corrupt data.
    }
  }
}
