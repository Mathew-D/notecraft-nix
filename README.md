# NoteCraft Nix Flake

This repository provides a Nix flake for [NoteCraft](https://github.com/Mathew-D/notecraft), a note-taking and organization application written in pure Rust.

## Description

NoteCraft is an open-source, clean-room reimplementation of Microsoft OneNote. It stores notes as plain files in plain folders, making them accessible to any editor, searchable with grep, and version-controllable with git.

## Installation

### Using `nix run`

```bash
nix run github:Mathew-D/notecraft-nix
```

### Building from this repository

```bash
nix build
```

The built package will be available in the `result` symlink.

### Adding to your NixOS configuration

Add this flake to your `flake.nix` inputs:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    notecraft.url = "github:Mathew-D/notecraft-nix";
  };

  outputs = { self, nixpkgs, notecraft, ... }: {
    # Your configuration
  };
}
```

Then add NoteCraft to your system packages:

```nix
environment.systemPackages = [
  notecraft.packages.x86_64-linux.default
];
```

### Using with `nix shell`

```bash
nix shell github:Mathew-D/notecraft-nix
notecraft
```

## Version

Currently packages NoteCraft v0.0.3.1

## License

NoteCraft is licensed under MIT or Apache-2.0, at your option.
