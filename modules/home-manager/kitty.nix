{ lib, pkgs, ... }:

let
  # Exact colors from dexpota/kitty-themes Solarized_Dark_-_Patched.conf
  solarizedDarkColors = ''
    background            #001e26
    foreground            #708183
    cursor                #708183
    selection_background  #002731
    selection_foreground  #001e26
    color0  #002731
    color1  #d01b24
    color2  #728905
    color3  #a57705
    color4  #2075c7
    color5  #c61b6e
    color6  #259185
    color7  #e9e2cb
    color8  #465a61
    color9  #bd3612
    color10 #465a61
    color11 #52676f
    color12 #708183
    color13 #5856b9
    color14 #81908f
    color15 #fcf4dc
  '';

  # Exact colors from dexpota/kitty-themes Solarized_Light.conf
  solarizedLightColors = ''
    background            #fdf6e3
    foreground            #52676f
    cursor                #52676f
    selection_background  #e9e2cb
    selection_foreground  #fcf4dc
    color0  #e4e4e4
    color1  #d70000
    color2  #5f8700
    color3  #af8700
    color4  #0087ff
    color5  #af005f
    color6  #00afaf
    color7  #262626
    color8  #ffffd7
    color9  #d75f00
    color10 #585858
    color11 #626262
    color12 #808080
    color13 #5f5faf
    color14 #8a8a8a
    color15 #1c1c1c
  '';
in
{
  programs.kitty = {
    enable = true;
    settings = {
      allow_remote_control = "yes";
    };
    extraConfig = ''
      enable_audio_bell no
      include ~/.config/kitty/colormode.conf
    '';
  };

  # colormode.conf is intentionally not home-manager managed so the
  # light-mode/dark-mode shell functions can write to it freely at runtime.
  # This activation script seeds it with solarized dark on first deploy.
  home.activation.kittyColormodeDefault = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ ! -f "$HOME/.config/kitty/colormode.conf" ]; then
      $DRY_RUN_CMD cat > "$HOME/.config/kitty/colormode.conf" << 'CONF'
    ${solarizedDarkColors}CONF
    fi
  '';

  # Expose color definitions as files so the shell functions can copy them
  # into colormode.conf when toggling modes.
  home.file.".config/kitty/solarized-dark.conf".text = solarizedDarkColors;
  home.file.".config/kitty/solarized-light.conf".text = solarizedLightColors;
}
