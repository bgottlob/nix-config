{ pkgs, ... }:

{
  programs.opencode = {
    enable = true;
    cli.theme = {
      name = "system";
      mode = "system";
    };
    settings = {
      autoupdate = false;
      # Ask before editing files so opencode.nvim can show each proposed edit
      # as a diff to accept or reject
      permissions = [
        { action = "edit"; resource = "*"; effect = "ask"; }
      ];
      agent = {
        build.color = "#d33682"; # solarized magenta
        plan.color = "#859900"; # solarized green
      };
    };
  };
}
