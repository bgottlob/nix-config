{ pkgs, ... }:

{
  programs.virt-manager.enable = true;

  users.groups.libvirtd.members = [ "bgottlob" ];

  virtualisation = {
    docker.enable = true;
    spiceUSBRedirection.enable = true;
    libvirtd.enable = true;
  };
}
