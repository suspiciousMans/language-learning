# Project 02 — Arrays, Slices, Maps, and Structs

**Difficulty:** beginner→intermediate  
**Prerequisites:** 01 (basics)

## Goals

- Master Go's primary collection types: arrays, slices, maps.
- Understand how slices work under the hood (underlying array, capacity, `append`).
- Define structs and attach methods — both value and pointer receivers.
- Learn the simplest form of interface satisfaction.

## Concepts

- **Arrays:** fixed-size, value types. `[3]int{1,2,3}`.
- **Slices:** dynamic view into an array. `[]T`, `make([]T, len, cap)`, `append`, slicing `s[i:j]`, underlying array, `cap` vs `len`.
- **Maps:** `map[K]V`, `make(map[K]V)`, insertion/lookup/delete, comma-ok idiom `v, ok := m[k]`.
- **Structs:** `type Point struct { X, Y int }`, field tags, struct literals.
- **Methods:** value receiver `(p Point) Distance() float64` vs pointer receiver `(p *Point) Move(dx, dy int)`.
- **Interfaces (preview):** a type satisfies an interface by implementing its methods — no `implements` keyword.

## Completion Checklist

- [ ] You can create a slice with `make` and append to it.
- [ ] You understand that slicing shares the underlying array and that `append` may reallocate.
- [ ] You can create, read, update, and delete map entries.
- [ ] You can define a struct and attach both value and pointer methods.
- [ ] You can explain when you'd use a pointer receiver vs a value receiver.

## Exercises

### ex01_arrays_slices.go + ex01_arrays_slices_test.go

Create arrays and slices; demonstrate `len`, `cap`, `append`, slicing.

### ex02_maps.go + ex02_maps_test.go

Word frequency counter using a map.

### ex03_structs.go + ex03_structs_test.go

Define a `Rectangle` struct with `Area()` and `Perimeter()` methods.
Define a `Person` struct and demonstrate value vs pointer method receivers.

### ex04_interfaces_basics.go + ex04_interfaces_basics_test.go

Define a `Stringer`-like interface and show two different types satisfying it.
Use the empty interface `any` to hold different types (we'll go deeper in 04).

## Hints

- Slices: a nil slice has len 0 and cap 0 but can be appended to.
- Maps: a nil map can be read but not written to — use `make`.
- Use `range` to iterate over slices, arrays, and maps.
