default:
    @just --list

# "macos" or "nixos": picks which variant of each recipe to run
platform := if `uname` == "Darwin" { "macos" } else { "nixos" }
# acro is the only darwin host
host := if platform == "macos" { "acro" } else { `hostname` }
dir := justfile_directory()

switch flake=host:
    just switch-{{platform}} {{flake}}

switch-nixos flake=host:
    sudo nixos-rebuild switch --flake "{{dir}}#{{flake}}" --impure

switch-macos flake="acro":
    sudo darwin-rebuild switch --flake "{{dir}}#{{flake}}" --impure

test flake=host:
    just test-{{platform}} {{flake}}

test-nixos flake=host:
    sudo nixos-rebuild test --flake "{{dir}}#{{flake}}" --impure

# darwin-rebuild has no `test`, so build and run activation checks without switching
test-macos flake="acro":
    sudo darwin-rebuild check --flake "{{dir}}#{{flake}}" --impure

clean-generations x="3":
    just clean-generations-{{platform}} {{x}}

clean-generations-nixos x="3":
    sudo nix-env --delete-generations +{{x}} --profile /nix/var/nix/profiles/system
    sudo nix-collect-garbage -d

clean-generations-macos x="3":
    sudo nix-env --delete-generations +{{x}} --profile /nix/var/nix/profiles/system
    sudo nix-collect-garbage -d
