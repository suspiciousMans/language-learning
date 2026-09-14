# Project 08: Capstone — SwiftUI App or Vapor Server — Swift

**Difficulty:** advanced  
**Prerequisites:** All previous projects (00–07), especially Project 03 (Collections, Closures, and Protocols), Project 05 (Protocol-Oriented Programming and Generics), and Project 06 (Concurrency)

## Goals

- Build a complete Swift application to consolidate everything you've learned
- Choose your path: a SwiftUI iOS/macOS app or a Vapor web server
- Apply protocol-oriented design, generics, async/await, and proper architecture
- Ship something real — a working app or server that does something useful

## Concepts

- **SwiftUI** — declarative UI framework; `@State`, `@Binding`, `@ObservedObject`, `@EnvironmentObject`, `@StateObject`
- **Vapor** — server-side Swift web framework; routing, controllers, Fluent ORM, leaf templating
- **MVVM / MVC** — architectural patterns for organizing your code
- **Dependency injection** — passing dependencies rather than creating them internally
- **Error handling across boundaries** — propagating errors from models to UI or HTTP responses
- **Persistence** — `UserDefaults` / `Codable` for apps; Fluent + SQLite/Postgres for servers
- **Testing a full app** — UI tests (XCTest) or integration tests (Vapor's test facilities)

## Choose Your Track

### Track A: SwiftUI App

Build a small but complete iOS/macOS app. Examples:
- **Task Manager** — CRUD for todo items, persistence with `Codable` + `UserDefaults`
- **Expense Tracker** — add/edit/delete expenses, category breakdown, charts
- **Recipe Book** — search/filter recipes, ingredient lists, scaling servings
- **Weather Dashboard** — fetch from a public API, display forecast, cache results

### Track B: Vapor Server

Build a REST API or web service. Examples:
- **Blog API** — posts, comments, users; CRUD endpoints; Fluent models
- **URL Shortener** — create short codes, redirect, stats; SQLite storage
- **Todo API** — full REST API with authentication, validation, persistence
- **Chat Backend** — WebSocket endpoints, messages, rooms

## Requirements (both tracks)

### Minimum Viable Product

1. **At least 3 model types** conforming to protocols (e.g., `Identifiable`, `Codable`)
2. **At least 2 async operations** — API calls, database queries, or file I/O
3. **At least 1 actor or thread-safe type** — shared state protection
4. **At least 3 unit tests** — test your models/business logic
5. **Proper error handling** — custom `Error` enums, `do-catch` or `try?` where appropriate
6. **A README** in your project folder explaining how to run it

### Track A-Specific (SwiftUI)

- Use `@State` / `@Binding` / `@StateObject` for state management
- Use `List` / `ForEach` / `NavigationView` for navigation and collections
- Persist data (UserDefaults, file, or CoreData)
- At least one sheet or navigation push

### Track B-Specific (Vapor)

- Define at least 2 `Collection` routes (e.g., `/posts`, `/users`)
- Use Fluent models with SQLite or PostgreSQL
- At least one `POST` and one `GET` endpoint
- Return proper HTTP status codes (200, 201, 404, 400)

## Example: Task Manager App (SwiftUI Track A)

### Model

```swift
import Foundation

// Protocol for anything that has an ID
protocol IdentifiableItem: Identifiable {
    var title: String { get }
}

struct Task: IdentifiableItem, Codable, Equatable {
    let id: UUID
    var title: String
    var isCompleted: Bool
    var dueDate: Date?

    init(title: String, dueDate: Date? = nil) {
        self.id = UUID()
        self.title = title
        self.isCompleted = false
        self.dueDate = dueDate
    }
}
```

### ViewModel

```swift
import Foundation
import SwiftUI

@MainActor
class TaskStore: ObservableObject {
    @Published var tasks: [Task] = []
    private let saveKey = "tasks"

    init() {
        load()
    }

    func add(_ task: Task) {
        tasks.append(task)
        save()
    }

    func toggle(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
            save()
        }
    }

    func delete(_ task: Task) {
        tasks.removeAll { $0.id == task.id }
        save()
    }

    private func save() {
        if let data = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(data, forKey: saveKey)
        }
    }

    private func load() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([Task].self, from: data) {
            tasks = decoded
        }
    }
}
```

### View

```swift
import SwiftUI

struct TaskListView: View {
    @StateObject private var store = TaskStore()
    @State private var newTaskTitle = ""

    var body: some View {
        NavigationView {
            List {
                ForEach(store.tasks) { task in
                    HStack {
                        Toggle(isOn: Binding(
                            get: { task.isCompleted },
                            set: { _ in store.toggle(task) }
                        )) {
                            Text(task.title)
                                .strikethrough(task.isCompleted)
                        }
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        store.delete(store.tasks[index])
                    }
                }
            }
            .navigationTitle("Tasks")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") { addTask() }
                }
            }
            .sheet(isPresented: .constant(false)) {
                // Task detail sheet
            }
        }
    }

    private func addTask() {
        let task = Task(title: newTaskTitle)
        store.add(task)
        newTaskTitle = ""
    }
}
```

## Example: Blog API (Vapor Track B)

### Model

```swift
import Fluent
import Vapor

final class Post: Model, Content, Identifiable {
    @ID(key: .id) var id: UUID?
    @Field(key: "title") var title: String
    @Field(key: "body") var body: String
    @Parent(key: "author_id") var author: User

    init() {}

    init(id: UUID? = nil, title: String, body: String, authorID: UUID) {
        self.id = id
        self.title = title
        self.body = body
        self.$author.id = authorID
    }
}

extension Post {
    static func migrations() -> [Migration] {
        return [Post.migration()]
    }
}
```

### Controller

```swift
import Vapor

struct PostController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let posts = routes.grouped("posts")
        posts.get(use: index)
        posts.post(use: create)
        posts.on(.GET, ":id", use: show)
        posts.on(.PUT, ":id", use: update)
        posts.on(.DELETE, ":id", use: delete)
    }

    func index(req: Request) throws -> EventLoopFuture<[Post]> {
        return Post.query(on: req.db).all()
    }

    func create(req: Request) throws -> EventLoopFuture<Post> {
        return req.content.decode(Post.self).flatMap { post in
            return post.save(on: req.db).map { post }
        }
    }

    func show(req: Request) throws -> EventLoopFuture<Post> {
        return req.parameters.next(Post.self)
    }

    func update(req: Request) throws -> EventLoopFuture<Post> {
        return req.parameters.next(Post.self).flatMap { post in
            return req.content.decode(Post.self).flatMap { updated in
                post.title = updated.title
                post.body = updated.body
                return post.save(on: req.db).map { post }
            }
        }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return req.parameters.next(Post.self).flatMap { post in
            return post.delete(on: req.db).map { .noContent }
        }
    }
}
```

## Milestones

### Week 1: Design and Models

- Choose your track and idea
- Define your model types and protocols
- Write unit tests for your models

### Week 2: Core Logic

- Build the business logic / controller layer
- Implement persistence (UserDefaults/Fluent)
- Add async operations (API calls or DB queries)

### Week 3: UI or API Wiring

- Wire up SwiftUI views or Vapor routes
- Handle errors gracefully
- Add at least 3 integration-level tests

### Week 4: Polish

- Add persistence, caching, or performance improvements
- Write a README with setup instructions
- Clean up code, add comments, ensure SwiftLint-clean style

## Completion Checklist

- [ ] Chose a track (SwiftUI app or Vapor server)
- [ ] Defined at least 3 model types with protocol conformance
- [ ] Implemented CRUD operations (create, read, update, delete)
- [ ] Used async/await for at least 2 operations
- [ ] Protected shared state with an actor or thread-safe type
- [ ] Wrote at least 3 unit tests
- [ ] Handled errors with custom `Error` enums
- [ ] Wrote a README with run instructions
- [ ] Code compiles without warnings

## Hints

- Start small — a working minimal app beats a half-finished ambitious one
- Use protocols early — they make testing and swapping implementations easier
- Don't over-engineer: one actor, a few tests, and clean code is enough
- For SwiftUI: study Apple's SwiftUI documentation and WWDC samples
- For Vapor: read the Vapor documentation at https://docs.vapor.codes
- If stuck, simplify: strip features until the core works, then rebuild
