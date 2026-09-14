// server.js
// Simple HTTP server for Todo API

import http from 'node:http';
import url from 'node:url';
import { getAllTodos, getTodoById, createTodo, deleteTodo } from './db.js';

const PORT = 3000;

const server = http.createServer(async (req, res) => {
  // Enable CORS
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, DELETE, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
  res.setHeader('Content-Type', 'application/json');

  if (req.method === 'OPTIONS') {
    res.writeHead(200);
    res.end();
    return;
  }

  const parsedUrl = url.parse(req.url, true);
  const pathname = parsedUrl.pathname;
  const query = parsedUrl.query;

  try {
    if (pathname === '/api/todos' && req.method === 'GET') {
      const todos = await getAllTodos();
      res.writeHead(200);
      res.end(JSON.stringify(todos));
    } else if (pathname.startsWith('/api/todos/') && req.method === 'GET') {
      const id = parseInt(pathname.split('/')[3]);
      const todo = await getTodoById(id);
      if (todo) {
        res.writeHead(200);
        res.end(JSON.stringify(todo));
      } else {
        res.writeHead(404);
        res.end(JSON.stringify({ error: 'Todo not found' }));
      }
    } else if (pathname === '/api/todos' && req.method === 'POST') {
      let body = '';
      req.on('data', (chunk) => {
        body += chunk;
      });
      req.on('end', async () => {
        const data = JSON.parse(body);
        const todo = await createTodo(data.title, data.description || '');
        res.writeHead(201);
        res.end(JSON.stringify(todo));
      });
    } else if (pathname.startsWith('/api/todos/') && req.method === 'DELETE') {
      const id = parseInt(pathname.split('/')[3]);
      await deleteTodo(id);
      res.writeHead(204);
      res.end();
    } else {
      res.writeHead(404);
      res.end(JSON.stringify({ error: 'Not found' }));
    }
  } catch (error) {
    console.error(error);
    res.writeHead(500);
    res.end(JSON.stringify({ error: 'Internal server error' }));
  }
});

server.listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}`);
  console.log(`API endpoints:`);
  console.log(`  GET /api/todos`);
  console.log(`  GET /api/todos/:id`);
  console.log(`  POST /api/todos`);
  console.log(`  DELETE /api/todos/:id`);
});
