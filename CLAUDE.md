# Tool Usage

- Always use the **Grep** tool instead of `bash grep/rg`.
- Always use the **Glob** tool instead of `bash find/ls`.
- Always use the **Read** tool instead of `bash cat/head/tail`.
- Never use compound bash commands that chain multiple operations. Use the dedicated tools individually.
- Run git commands from the working directory directly. Never use `git -C`.

# Safety

- Never run `nixos-rebuild`, `nix flake update`, or `sudo` without explicit approval.
- Never run destructive commands like `rm -rf`, `dd`, or `mkfs`.
- This is a NixOS configuration repo at /etc/nixos. Edits to .nix files are expected, but never modify files outside this directory.
