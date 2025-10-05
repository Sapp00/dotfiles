{ lib
, config
, pkgs
, desktop
, ...
}:

with lib;

let
  cfg = config.module.kitty;


  inherit (pkgs.stdenv) isDarwin isLinux;

  # TODO: This does not work. It does not receive the desktop arguments somehow
  #background_opacity = ".8";
  background_opacity = if builtins.isString desktop && isLinux then "0.8" else "1.0";
in {
  options = {
    module.kitty.enable = mkEnableOption "Enables kitty";
  };

  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;

      settings = {
        ##############################
        ## template from nix-colors ##
        ##############################
        cursor = "#${config.colorScheme.palette.base09}";
        cursor_text_color = "background";

        url_color = "#${config.colorScheme.palette.base0D}";

        active_border_color = "#${config.colorScheme.palette.base0B}";
        inactive_border_color = "#${config.colorScheme.palette.base01}";
        bell_border_color = "#${config.colorScheme.palette.base09}";

        active_tab_foreground = "#${config.colorScheme.palette.base05}";
        active_tab_background = "#${config.colorScheme.palette.base00}";

        inactive_tab_foreground = "#${config.colorScheme.palette.base05}";
        inactive_tab_background = "#${config.colorScheme.palette.base01}";

        foreground = "#${config.colorScheme.palette.base05}";
        background = "#${config.colorScheme.palette.base00}";

        selection_foreground = "#${config.colorScheme.palette.base00}";
        selection_background = "#${config.colorScheme.palette.base0D}";

        color0 = "#${config.colorScheme.palette.base05}";
        color8 = "#${config.colorScheme.palette.base05}";

        color1 = "#${config.colorScheme.palette.base08}";
        color9 = "#c28091";

        color2 = "#${config.colorScheme.palette.base0B}";
        color10 = "#528598";

        color3 = "#${config.colorScheme.palette.base0A}";
        color11 = "#de9994";

        color4 = "#${config.colorScheme.palette.base0D}";
        color12 = "#a592b7";

        color5 = "#${config.colorScheme.palette.base0F}";
        color13 = "#d7d2d3";

        color6 = "#${config.colorScheme.palette.base0C}";
        color14 = "#77a7af";

        color7 = "#${config.colorScheme.palette.base02}";
        color15 = "#${config.colorScheme.palette.base01}";

        mark1_foreground = "#${config.colorScheme.palette.base00}";
        mark1_background = "#${config.colorScheme.palette.base0C}";

        mark2_foreground = "#${config.colorScheme.palette.base00}";
        mark2_background = "#${config.colorScheme.palette.base0F}";

        mark3_foreground = "#${config.colorScheme.palette.base00}";
        mark3_background = "#${config.colorScheme.palette.base0A}";
        #####################
        ## end of template ##
        #####################

        font_family	= "Iosevka Nerd Font";
        bold_font	= "Iosevka Nerd Font Bold";
        bold_italic_font = "Iosevka Nerd Font Bold Italic";
        italic_font	= "Iosevka Nerd Font Italic";
        font_size = "16.0";
        enable_audio_bell = false;

        copy_on_select = "clipboard";
        # skip_trailing_lines smart
        mouse_hide_wait = 0;

        open_url_with = "firefox";
        disable_ligatures = "never";

        #hide_window_decorations titlebar-only
        inherit background_opacity;

        window_padding_width = 5;
        tab_bar_margin_width = 5;

        macos_option_as_alt = "left";

        paste_actions = "replace-dangerous-control-codes,filter";
      };

      keybindings = {
        # used by fzf in vim
        #"ctrl+shift+v" = "no_op";
        #"ctrl+shift+s" = "no_op";
        #"alt+shift+p" = "no_op";

        # disable split-screen
        "cmd+enter" = "no_op";

        # custom commands
        "ctrl+shift+t" = "new_tab_with_cwd";
      };
    };

    home.packages = mkIf isLinux [ pkgs.xclip ];

    # Create desktop entry for WSL integration
    xdg.desktopEntries = mkIf isLinux {
      kitty = {
        name = "Kitty Terminal";
        comment = "Fast, feature-rich, GPU-accelerated terminal emulator";
        exec = "kitty";
        icon = "kitty";
        categories = [ "System" "TerminalEmulator" ];
        startupNotify = true;
      };
    };
  };

}
