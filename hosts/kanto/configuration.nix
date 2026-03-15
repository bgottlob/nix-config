{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/bluetooth.nix
      ../../modules/core-pkgs.nix
      ../../modules/enable-flakes.nix
      ../../modules/dropbox.nix
      ../../modules/gpg.nix
      ../../modules/locale.nix
      ../../modules/plasma.nix
      ../../modules/printing.nix
      ../../modules/sound.nix
      ../../modules/tailscale.nix
      ../../modules/virtualization.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "kanto";
  networking.networkmanager.enable = true;

  time.timeZone = "America/New_York";

  users.users.bgottlob = {
    isNormalUser = true;
    description = "Brandon Gottlob";
    extraGroups = [ "docker" "networkmanager" "wheel" "scanner" "lp" ];
    shell = pkgs.zsh;
  };
  programs.zsh.enable = true;

  home-manager.users.bgottlob = {
    imports = [
      ../../modules/home.nix
      ../../modules/home-manager/workstation.nix
      ../../modules/home-manager/productivity.nix
      ../../modules/home-manager/virtualization.nix
    ];
  };

  services.pcscd.enable = true;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?

  # Electron 27 is needed to build logseq until this issue is fixed:
  # https://github.com/NixOS/nixpkgs/issues/341683
  nixpkgs.config.permittedInsecurePackages = [
    "electron-27.3.11"
  ];
}
