{ pkgs, ... }:

{
  systemd.user.services.maestral = {
    description = "Maestral Dropbox client";
    wantedBy = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.maestral-gui}/bin/maestral_qt";
      ExecReload = "${pkgs.maestral}/bin/maestral stop";
      Restart = "on-failure";
    };
  };
}
