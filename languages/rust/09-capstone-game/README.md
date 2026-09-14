# 09 — Capstone: 2D Game

**Difficulty:** advanced · **Prerequisites:** all previous projects

## Goals

- Build a real, playable 2D game from scratch.
- Open a window, run a render loop, handle input, and manage game state.
- Ship something to a clear end state (win/lose/score).

## Concepts

- Game loop: input → update → render
- Windowing and rendering via a game library (learner picks one)
- Input handling: keyboard / mouse / gamepad
- State management: entity positions, scores, game-over conditions
- Asset loading (optional): sprites, sounds

## Library choice

The learner picks one of:

- **macroquad** — minimal, immediate-mode, great for quick prototypes (ship in a single file)
- **bevy** — full ECS engine, more structure, more to learn

Add the chosen library as a dependency yourself in `Cargo.toml`. This project's `Cargo.toml` is a skeleton — no game lib is pre-declared.

## Acceptance criteria

- [ ] The game opens a window.
- [ ] The render loop runs (you see something animate or redraw).
- [ ] Input is handled (keyboard at minimum; mouse/gamepad optional).
- [ ] The game manages state (e.g. player position, enemy positions, score, lives).
- [ ] The game is playable to a clear end state (win, lose, or score target).
- [ ] `cargo run` launches the game.

## Suggested game ideas

- **Asteroids**: ship moves, asteroids float and split, shooting removes them, collision ends the game.
- **Snake**: snake grows on eating food, colliding with self or walls ends the game, score increases.
- **Pong**: two paddles, a ball, score when the opponent misses.

Pick one. Implement the minimum viable version first, then iterate.

## Starter files

- `Cargo.toml` — skeleton; learner adds the game library dependency
- `src/main.rs` — a minimal main that opens a window and runs a loop (library-specific; learner fills)
- `README.md` — this file
