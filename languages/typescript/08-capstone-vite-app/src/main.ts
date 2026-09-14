/**
 * main.ts — capstone starter entry point (vanilla TS).
 *
 * Framework: vanilla TypeScript (no React).
 * If you prefer React, replace this file and install react/react-dom.
 */

import "./style.css";
import { TodoStore, Todo } from "./todo";

const store = new TodoStore();

const appEl = document.getElementById("app");
if (!appEl) throw new Error("app element not found");

function render() {
  appEl.innerHTML = "";

  const header = document.createElement("h1");
  header.textContent = "TypeScript Todo (Capstone)";
  appEl.appendChild(header);

  // Filter bar.
  const filterBar = document.createElement("div");
  filterBar.className = "filter-bar";

  const allBtn = makeFilterButton("All", () => store.setFilter("all"));
  const activeBtn = makeFilterButton("Active", () => store.setFilter("active"));
  const completedBtn = makeFilterButton("Completed", () => store.setFilter("completed"));

  filterBar.appendChild(allBtn);
  filterBar.appendChild(activeBtn);
  filterBar.appendChild(completedBtn);
  appEl.appendChild(filterBar);

  // Todo list.
  const list = document.createElement("ul");
  list.className = "todo-list";

  for (const todo of store.visibleTodos()) {
    list.appendChild(renderTodo(todo));
  }

  if (list.children.length === 0) {
    const empty = document.createElement("li");
    empty.className = "empty";
    empty.textContent = "No todos. Add one above!";
    list.appendChild(empty);
  }

  appEl.appendChild(list);

  // Add form.
  const form = document.createElement("form");
  form.className = "add-form";

  const input = document.createElement("input");
  input.type = "text";
  input.placeholder = "What needs to be done?";
  input.autofocus = true;

  const submitBtn = document.createElement("button");
  submitBtn.type = "submit";
  submitBtn.textContent = "Add";

  form.appendChild(input);
  form.appendChild(submitBtn);

  form.addEventListener("submit", (e: Event) => {
    e.preventDefault();
    const value = (input as HTMLInputElement).value.trim();
    if (value === "") return;
    store.add(value);
    input.value = "";
    render();
  });

  appEl.appendChild(form);

  // Store change listener.
  store.onChange(() => render());
}

function makeFilterButton(label: string, onClick: () => void): HTMLButtonElement {
  const btn = document.createElement("button");
  btn.textContent = label;
  btn.type = "button";
  btn.addEventListener("click", onClick);
  return btn;
}

function renderTodo(todo: Todo): HTMLLIElement {
  const li = document.createElement("li");
  li.className = `todo-item${todo.completed ? " completed" : ""}`;

  const checkbox = document.createElement("input");
  checkbox.type = "checkbox";
  checkbox.checked = todo.completed;
  checkbox.addEventListener("change", () => {
    store.toggle(todo.id);
  });

  const span = document.createElement("span");
  span.className = "todo-text";
  span.textContent = todo.title;
  span.style.textDecoration = todo.completed ? "line-through" : "none";

  const delBtn = document.createElement("button");
  delBtn.type = "button";
  delBtn.textContent = "Delete";
  delBtn.addEventListener("click", () => {
    store.remove(todo.id);
  });

  li.appendChild(checkbox);
  li.appendChild(span);
  li.appendChild(delBtn);

  return li;
}

render();
