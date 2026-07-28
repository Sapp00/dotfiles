{ lib
, config
, ...
}:

with lib;

let
  cfg = config.module.wofi;
  c = config.colorScheme.palette;
in {
  options.module.wofi.enable = mkEnableOption "Enables wofi";

  config = mkIf cfg.enable {
    programs.wofi = {
      enable = true;

      settings = {
        width = 500;
        height = 300;
        location = "center";
        show = "drun";
        prompt = "Search...";
        filter_rate = 100;
        allow_markup = true;
        no_actions = true;
        halign = "fill";
        orientation = "vertical";
        content_halign = "fill";
        insensitive = true;
        allow_images = true;
        image_size = 40;
        gtk_dark = true;
      };

      style = ''
        window {
          background-color: #${c.base00};
          color: #${c.base05};
          border-radius: 8px;
          border: 1px solid #${c.base03};
        }

        #input {
          background-color: #${c.base01};
          color: #${c.base05};
          border: 1px solid #${c.base03};
          border-radius: 4px;
          padding: 8px;
          margin: 4px;
        }

        #entry {
          padding: 4px 8px;
          border-radius: 4px;
        }

        #entry:selected {
          background-color: #${c.base02};
        }

        #text { color: #${c.base05}; }
        #text:selected { color: #${c.base05}; }
      '';
    };
  };
}
