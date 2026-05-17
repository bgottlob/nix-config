{ pkgs, ... }:

{
  programs.opencode = {
    enable = true;
    tui.theme = "system";
    settings = {
      autoupdate = false;
    };
  };
}
