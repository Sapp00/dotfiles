{ isWorkstation
, isLinux
, pkgs
, lib
, vm ? false
, ...
}:
{
  home.packages = [ pkgs.wl-clipboard ];

  module = {
    kitty.enable = true;
    nerdfonts.enable = true;
    waybar.enable = true;
    wofi.enable = true;
  };

  wayland.windowManager.hyprland = {
    enable = true;

    extraConfig = ''
      hl.on("hyprland.start", function()
        hl.exec_cmd("waybar")
        ${lib.optionalString vm ''hl.exec_cmd("spice-vdagent")''}
      end)
    '';

    settings = {
      monitor = [ "Virtual-1,1920x1080,0x0,1" ];

      input.kb_layout = "de";

      env = lib.optionals vm [ "WLR_NO_HARDWARE_CURSORS,1" ];

      bind = [
        # Applications
        "SUPER, Return, exec, ${lib.optionalString vm "env LIBGL_ALWAYS_SOFTWARE=1 "}kitty"
        "SUPER, Space, exec, wofi --show drun"
        "SUPER, Q, killactive"
        "SUPER, F, fullscreen"
        "SUPER, V, togglefloating"
        "SUPER, M, exit"

        # Focus (hjkl)
        "SUPER, h, movefocus, l"
        "SUPER, l, movefocus, r"
        "SUPER, k, movefocus, u"
        "SUPER, j, movefocus, d"

        # Move windows (hjkl)
        "SUPER SHIFT, h, movewindow, l"
        "SUPER SHIFT, l, movewindow, r"
        "SUPER SHIFT, k, movewindow, u"
        "SUPER SHIFT, j, movewindow, d"

        # Workspaces
        "SUPER, 1, workspace, 1"
        "SUPER, 2, workspace, 2"
        "SUPER, 3, workspace, 3"
        "SUPER, 4, workspace, 4"
        "SUPER, 5, workspace, 5"
        "SUPER, 6, workspace, 6"
        "SUPER, 7, workspace, 7"
        "SUPER, 8, workspace, 8"
        "SUPER, 9, workspace, 9"
        "SUPER, 0, workspace, 10"

        # Move window to workspace
        "SUPER SHIFT, 1, movetoworkspace, 1"
        "SUPER SHIFT, 2, movetoworkspace, 2"
        "SUPER SHIFT, 3, movetoworkspace, 3"
        "SUPER SHIFT, 4, movetoworkspace, 4"
        "SUPER SHIFT, 5, movetoworkspace, 5"
        "SUPER SHIFT, 6, movetoworkspace, 6"
        "SUPER SHIFT, 7, movetoworkspace, 7"
        "SUPER SHIFT, 8, movetoworkspace, 8"
        "SUPER SHIFT, 9, movetoworkspace, 9"
        "SUPER SHIFT, 0, movetoworkspace, 10"

        # Scroll through workspaces
        "SUPER, mouse_down, workspace, e+1"
        "SUPER, mouse_up, workspace, e-1"
      ];

      # Resize windows with SUPER + CTRL + hjkl (like tmux pane resize)
      binde = [
        "SUPER CTRL, h, resizeactive, -40 0"
        "SUPER CTRL, l, resizeactive, 40 0"
        "SUPER CTRL, k, resizeactive, 0 -40"
        "SUPER CTRL, j, resizeactive, 0 40"
      ];

      # Mouse bindings
      bindm = [
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
      ];
    };
  };
}
