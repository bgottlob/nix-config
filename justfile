default:
    @just --list

host := `hostname`
dir := justfile_directory()

switch flake=host: 
    sudo nixos-rebuild switch --flake "{{dir}}#{{flake}}" --impure

test flake=host: 
    sudo nixos-rebuild test --flake "{{dir}}#{{flake}}" --impure
