# Tool Usage

- Always use the **Grep** tool instead of `bash grep/rg`.
- Always use the **Glob** tool instead of `bash find/ls`.
- Always use the **Read** tool instead of `bash cat/head/tail`.
- Never use compound bash commands that chain multiple operations. Use the dedicated tools individually.

# Safety

- Never run `nixos-rebuild`, `nix flake update`, or `sudo` without explicit approval.
- Never run destructive commands like `rm -rf`, `dd`, or `mkfs`.
- This is a NixOS configuration repo at /etc/nixos. Edits to .nix files are expected, but never modify files outside this directory.

# Architecture

This repo uses the **dendritic flake-parts pattern**: every `.nix` file is a flake-parts module.

- **Module files** live in `modules/{system,programs,profiles,hardware}/` and define `flake.nixosModules.<name>` and/or `flake.homeModules.<name>`.
- **Host files** live in `hosts/` and define `flake.nixosConfigurations.<hostname>`.
- **Auto-import**: `flake.nix` auto-discovers and imports all `.nix` files from these directories. Adding a new module requires no changes to import lists.
- **Aggregation**: `nixosModules.default` and `homeModules.default` aggregate all named modules so hosts get all options.
- **Profiles** enable groups of programs via `custom.*.enable` options.
- See `README.md` for full documentation of the architecture and conventions.
