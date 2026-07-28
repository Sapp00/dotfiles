{ lib
, config
, ...
}:

with lib;

let
  cfg = config.module.waybar;
  c = config.colorScheme.palette;
in {
  options.module.waybar.enable = mkEnableOption "Enables waybar";

  config = mkIf cfg.enable {
    programs.waybar = {
      enable = true;

      settings = [{
        layer = "top";
        position = "top";
        height = 32;
        spacing = 4;

        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [ "cpu" "memory" ];

        "hyprland/workspaces" = {
          format = "{id}";
          on-click = "activate";
        };

        clock = {
          format = "󱑁 {:%H:%M}";
          format-alt = "󱑁 {:%Y-%m-%d %H:%M}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        cpu = {
          format = "󰻠 {usage}%";
          tooltip = false;
        };

        memory = {
          format = "󰍛 {}%";
        };
      }];

      style = ''
        * {
          font-family: "FiraCode Nerd Font Mono";
          font-size: 13px;
          min-height: 0;
        }

        window#waybar {
          background-color: #${c.base00};
          color: #${c.base05};
        }

        #workspaces button {
          padding: 0 8px;
          color: #${c.base04};
          background: transparent;
          border: none;
          border-radius: 0;
        }

        #workspaces button.active {
          color: #${c.base05};
          background-color: #${c.base02};
        }

        #workspaces button:hover {
          background-color: #${c.base01};
        }

        #clock { padding: 0 12px; }
        #cpu   { padding: 0 12px; color: #${c.base0B}; }
        #memory { padding: 0 12px; color: #${c.base0D}; }
      '';
    };
  };
}
