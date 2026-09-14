// index.js
// Frontend Todo App

const API_URL = 'http://localhost:3000/api';

const todoForm = document.getElementById('todoForm');
const todoList = document.getElementById('todoList');
const loading = document.getElementById('loading');
const error = document.getElementById('error');

// Load todos on page load
window.addEventListener('DOMContentLoaded', async () => {
  await loadTodos();
});

// Handle form submission
todoForm.addEventListener('submit', async (e) => {
  e.preventDefault();
  
  const title = document.getElementById('title').value;
  const description = document.getElementById('description').value;
  
  try {
    const response = await fetch(`${API_URL}/todos`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ title, description }),
    });
    
    if (response.ok) {
      todoForm.reset();
      await loadTodos();
    } else {
      showError('Failed to create todo');
    }
  } catch (err) {
    showError(`Error: ${err.message}`);
  }
});

// Load todos from API
async function loadTodos() {
  loading.style.display = 'block';
  error.style.display = 'none';
  todoList.innerHTML = '';
  
  try {
    const response = await fetch(`${API_URL}/todos`);
    if (!response.ok) throw new Error('Failed to fetch todos');
    
    const todos = await response.json();
    loading.style.display = 'none';
    
    if (todos.length === 0) {
      todoList.innerHTML = '<li class="empty">No todos yet. Add one above!</li>';
      return;
    }
    
    todos.forEach((todo) => {
      const li = document.createElement('li');
      li.className = 'todo-item';
      li.innerHTML = `
        <div class="todo-content">
          <h3>${escapeHtml(todo.title)}</h3>
          ${todo.description ? `<p>${escapeHtml(todo.description)}</p>` : ''}
        </div>
        <button class="delete-btn" data-id="${todo.id}">Delete</button>
      `;
      
      li.querySelector('.delete-btn').addEventListener('click', () => {
        deleteTodo(todo.id);
      });
      
      todoList.appendChild(li);
    });
  } catch (err) {
    loading.style.display = 'none';
    showError(`Error loading todos: ${err.message}`);
  }
}

// Delete a todo
async function deleteTodo(id) {
  try {
    const response = await fetch(`${API_URL}/todos/${id}`, {
      method: 'DELETE',
    });
    
    if (response.ok) {
      await loadTodos();
    } else {
      showError('Failed to delete todo');
    }
  } catch (err) {
    showError(`Error: ${err.message}`);
  }
}

// Show error message
function showError(msg) {
  error.textContent = msg;
  error.style.display = 'block';
}

// Escape HTML to prevent XSS
function escapeHtml(text) {
  const div = document.createElement('div');
  div.textContent = text;
  return div.innerHTML;
}
