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
      agent = {
        build.color = "#d33682"; # solarized magenta
        plan.color = "#859900"; # solarized green
      };
    };
  };
}
