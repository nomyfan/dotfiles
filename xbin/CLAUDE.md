# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

`xbin` is a collection of cross-platform CLI utilities written in Rust, part of a dotfiles repository. The project contains standalone binary tools that enhance shell functionality across different environments (Unix/Linux/macOS/Windows).

## Build Commands

```bash
# Build all binaries
cargo build

# Build with optimizations
cargo build --release

# Check code without building
cargo check

# Run clippy for linting
cargo clippy

# Format code
cargo fmt
```

## Binaries

The project uses Cargo's `[[bin]]` configuration to define multiple independent binaries from separate source files:

- `src/open.rs` - Cross-platform file/URL opener
- `src/which.rs` - Command locator with PowerShell support
- `src/skills.rs` - Claude Code skills package manager
