# Project 09 — Capstone: Node Backend + Frontend

Build a real application with a Node.js backend API and a frontend that consumes it. Integrate everything you've learned.

## Goals

- Create a REST API with Node.js (using built-in `http` module or Express).
- Persist data to SQLite.
- Handle file I/O and error handling.
- Create a simple frontend that consumes the API.
- Use modern JavaScript features throughout.
- Write tests for the backend.
- Deploy locally and verify both frontend and backend work together.

## Project Structure

```
project-09/
├── backend/
│   ├── server.js          # HTTP server or Express app
│   ├── db.js              # SQLite database setup
│   ├── routes/            # API endpoint handlers
│   ├── utils/             # Helpers
│   ├── package.json       # Node dependencies
│   └── tests/             # Backend tests
├── frontend/
│   ├── index.html         # Main page
│   ├── index.js           # Frontend JavaScript
│   └── style.css          # Styling
└── README.md              # Documentation
```

## Backend Requirements

- REST API with at least 4 endpoints: GET (list), GET (single), POST (create), DELETE (delete).
- Use SQLite for persistence (or JSON file as fallback).
- Implement basic error handling and validation.
- Return JSON responses.
- CORS enabled (if needed for separate frontend server).
- Written tests for at least 50% of the code.

## Frontend Requirements

- HTML form to create items (POST).
- Display list of items (GET).
- Delete button for each item (DELETE).
- Fetch data from the backend API.
- Handle loading states and errors.
- Modern JavaScript (async/await, arrow functions, etc.).

## Suggested Domains

Choose one and build a small app:

- **Todo list**: Items with title, description, completed status.
- **Note app**: Notes with title, content, created/updated timestamps.
- **Product catalog**: Products with name, price, category.
- **Contact manager**: Contacts with name, email, phone.
- **Bookmark collection**: Bookmarks with title, URL, category.

## Prerequisites

All previous projects (01-08).

## Completion Checklist

- [ ] Create a Node backend with at least 4 REST endpoints.
- [ ] Store data in SQLite (or JSON).
- [ ] Write tests for the backend.
- [ ] Create an HTML page with a form and item list.
- [ ] Fetch data from the backend API using `fetch()`.
- [ ] Display items on the page.
- [ ] Add functionality to create new items.
- [ ] Add functionality to delete items.
- [ ] Handle errors and edge cases.
- [ ] Verify frontend and backend work together locally.

## Backend Implementation Steps

1. **Setup**: Create `backend/` directory, `package.json`.
2. **Database**: Set up SQLite connection, create schema.
3. **API routes**: GET /, GET /:id, POST /, DELETE /:id.
4. **Error handling**: Validate input, handle errors gracefully.
5. **Tests**: Write tests for routes and database functions.
6. **Server**: Start listening on localhost:3000.

## Frontend Implementation Steps

1. **HTML**: Create form and container for items.
2. **Fetch API data**: On load, fetch items from backend.
3. **Display items**: Render list of items.
4. **Create item**: Form submission creates new item via POST.
5. **Delete item**: Delete button sends DELETE request.
6. **Error handling**: Show messages for network errors.
7. **UI updates**: Update page after create/delete without full reload.

## Running the App

```bash
# Backend
cd backend
npm install
npm start      # or node server.js

# Frontend (in another terminal)
cd frontend
# Serve index.html (python3 -m http.server, or any static server)
python3 -m http.server 8000

# Visit http://localhost:8000 in your browser
```

## Running Tests

```bash
cd backend
npm test       # or node --test tests/*.test.js
```

## What "done" looks like

- Backend is running on localhost:3000 and responds to API requests.
- Frontend is running on localhost:8000 and displays items from the backend.
- You can create new items via the form.
- You can delete items and the list updates.
- Tests pass and cover the main functionality.
- No console errors or warnings.
- Code is organized, readable, and follows ES2022 standards.
