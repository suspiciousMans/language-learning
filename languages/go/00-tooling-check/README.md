# Project 00 — Tooling Check

**Difficulty:** trivial  
**Prerequisites:** none

## Goals

- Confirm that Go is installed and that `go build`, `go test`, and `go run` work.
- Create your first Go module and your first Go program.
- Understand the basic project layout: `go.mod`, `.go` source files, tests.

## Concepts

- `go version` — check your toolchain.
- `go mod init <module>` — initialize a module.
- `go build` — compile a binary.
- `go run` — compile and run in one step.
- `go test` — run tests in the current package.
- A minimal Go program: `package main`, `func main()`.
- A minimal Go test: `package main`, `func TestXxx(t *testing.T)`.

## Completion Checklist

- [ ] `go version` prints a version ≥ 1.21.
- [ ] `go build` produces no errors.
- [ ] `go test` passes.
- [ ] Running the compiled binary prints `toolchain ok`.

## Starter Files

### `main.go`

```go
package main

import "fmt"

func main() {
	fmt.Println("toolchain ok")
}
```

### `main_test.go`

```go
package main

import (
	"encoding/exec"
	"testing"
)

func TestPrintsToolchainOk(t *testing.T) {
	out, err := exec.Command("go", "run", "main.go").Output()
	if err != nil {
		t.Fatalf("go run failed: %v", err)
	}
	if string(out) != "toolchain ok\n" {
		t.Errorf("expected 'toolchain ok\\n', got %q", string(out))
	}
}
```

> Tip: if `os/exec` is unfamiliar, you can also test by calling the `main`
> logic indirectly — but the canonical first exercise is to run the binary.
