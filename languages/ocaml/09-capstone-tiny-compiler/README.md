# 09 — Capstone: Tiny Compiler

**Difficulty:** advanced  
**Prerequisites:** 01, 02, 03, 04, 05, 06

## Goals

- Design and build a small expression language.
- Write a lexer/tokenizer.
- Write a parser using recursive descent or parser combinators.
- Build an abstract syntax tree (AST).
- Implement an evaluator/interpreter.
- Handle errors gracefully.
- Demonstrate all prior concepts in an integrated project.

## Concepts

- **Lexing:** breaking source code into tokens.
- **Parsing:** assembling tokens into an abstract syntax tree.
- **AST:** tree representation of a program.
- **Evaluation:** executing an AST to compute a result.
- **Error handling:** reporting meaningful errors.
- **Composable parsers:** building complex grammars from simple pieces.

## Completion checklist

- [ ] You can lex a simple expression into tokens.
- [ ] You can parse tokens into an AST.
- [ ] You can evaluate an AST.
- [ ] Your parser handles operator precedence.
- [ ] Your parser recovers from or reports errors clearly.
- [ ] You have comprehensive tests for lexer, parser, and evaluator.
- [ ] You can extend the language with new operators/constructs.
- [ ] You understand how lexer → parser → evaluator pipeline works.

## Starter files

| File | Topic |
|------|-------|
| [`lexer.ml`](lexer.ml) | tokenization |
| [`parser.ml`](parser.ml) | parsing tokens into AST |
| [`ast.ml`](ast.ml) | abstract syntax tree definitions |
| [`evaluator.ml`](evaluator.ml) | interpreting the AST |
| [`compiler.ml`](compiler.ml) | putting it all together |
| [`test_tiny_compiler.ml`](test_tiny_compiler.ml) | comprehensive tests |

### How to run

```sh
dune build
dune exec compiler
dune runtest
```

### Tests

```sh
dune runtest
```

## Hints

- Start with a minimal language: integers, +, -, *, /.
- Use a result type to propagate errors through lexer → parser → evaluator.
- Test each stage (lexer, parser, evaluator) in isolation.
- Use ADTs for the AST and tokens; pattern matching makes evaluation clean.
- Add features incrementally: variables, if/then/else, functions, etc.
- Think about operator precedence early; recursive descent makes it natural.
