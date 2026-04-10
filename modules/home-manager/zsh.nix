{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    enableVteIntegration = true;
    defaultKeymap = "viins";
    initContent = ''
      [[ ! -f ${../../dotfiles/p10k.zsh} ]] || source ${../../dotfiles/p10k.zsh}
      [[ ! -f "$HOME/.zshrc.system" ]] || source "$HOME/.zshrc.system"

      light-mode() {
        mkdir -p "$HOME/.local/state"
        echo light > "$HOME/.local/state/colormode"
        cp "$HOME/.config/kitty/solarized-light.conf" "$HOME/.config/kitty/colormode.conf"
        kitty @ set-colors --all --configured "$HOME/.config/kitty/solarized-light.conf"
      }

      dark-mode() {
        mkdir -p "$HOME/.local/state"
        echo dark > "$HOME/.local/state/colormode"
        cp "$HOME/.config/kitty/solarized-dark.conf" "$HOME/.config/kitty/colormode.conf"
        kitty @ set-colors --all --configured "$HOME/.config/kitty/solarized-dark.conf"
      }
    '';
    plugins = with pkgs; [
      {
        name = "powerlevel10k";
        src = zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "autocomplete";
        src = zsh-autocomplete;
      }
    ];
  };
}
