default:
    @just --list

host := `hostname`
dir := justfile_directory()

switch flake=host: 
    sudo nixos-rebuild switch --flake "{{dir}}#{{flake}}" --impure

test flake=host:
    sudo nixos-rebuild test --flake "{{dir}}#{{flake}}" --impure

clean-generations x="3":
    #!/usr/bin/env bash
    set -euo pipefail
    if uname -a | grep -q Darwin; then
        just clean-generations-macos {{x}}
    else
        just clean-generations-nixos {{x}}
    fi

clean-generations-nixos x="3":
    sudo nix-env --delete-generations +{{x}} --profile /nix/var/nix/profiles/system
    sudo nix-collect-garbage -d

clean-generations-macos x="3":
    sudo nix-env --delete-generations +{{x}} --profile /nix/var/nix/profiles/system
    sudo nix-collect-garbage -d
