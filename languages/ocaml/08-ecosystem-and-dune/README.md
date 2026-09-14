# 08 — Ecosystem and Dune

**Difficulty:** intermediate  
**Prerequisites:** 01, 02, 03

## Goals

- Understand the Dune build system.
- Use opam to install and manage packages.
- Build libraries and expose them with public names.
- Use popular libraries (Core, Lwt, Yojson, etc.).
- Understand package metadata and versioning.
- Share code across multiple projects.

## Concepts

- **Dune:** OCaml's modern build system; declarative and fast.
- **Libraries:** reusable modules exposed via dune files.
- **Public libraries:** libraries with external names for other projects to use.
- **Opam:** OCaml's package manager; manages dependencies.
- **Package metadata:** version, maintainer, license, dependencies.
- **Vendoring:** including external code in your project.

## Completion checklist

- [ ] You can run `dune build`, `dune exec`, and `dune runtest`.
- [ ] You can write a library stanza in dune.
- [ ] You can depend on an installed library.
- [ ] You can understand a dune-project file.
- [ ] You can use opam to install a package.
- [ ] You can expose a library publicly with a public_name.
- [ ] You can build and run a project using multiple modules.
- [ ] You can read and understand a dune file with (executable), (library), and (test) stanzas.

## Starter files

| File | Topic |
|------|-------|
| [`string_utils.ml`](string_utils.ml) | utility library module |
| [`string_utils.mli`](string_utils.mli) | library interface |
| [`json_handler.ml`](json_handler.ml) | using Yojson library |
| [`cli_app.ml`](cli_app.ml) | command-line application |
| [`dune`](dune) | build configuration |
| [`dune-project`](dune-project) | project metadata |

### How to run

```sh
dune build
dune exec cli_app
dune runtest
```

### Tests

```sh
dune runtest
```

## Hints

- Use `(library)` to define a library; use `(name mylib)` to set the module name.
- Use `(public_name package.name)` to expose the library publicly.
- `(libraries ...)` lists dependencies.
- Run `opam list` to see installed packages; `opam install <pkg>` to add one.
- The dune-project file specifies the package version and description.
