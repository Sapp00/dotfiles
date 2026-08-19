{ lib, config, pkgs, inputs, ... }:

{
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    pkgs.unstable.nerd-fonts.iosevka
  ] ++ lib.optionals pkgs.stdenv.isLinux [
    thunar
    loupe
  ];

  programs.yazi = {
    plugins = {
      clipboard = inputs.clipboard-yazi;
    };
    settings = lib.mkIf pkgs.stdenv.isLinux {
      opener = {
        image = [{ run = ''loupe "$@"''; orphan = true; desc = "Loupe"; }];
      };
      open.rules = [
        { mime = "image/*"; use = "image"; }
      ];
    };
    keymap.mgr.prepend_keymap = [
      {
        on = "y";
        run = [ "yank" "plugin clipboard -- --action=copy" ];
        desc = "Yank and copy to system clipboard";
      }
      {
        on = "p";
        run = "plugin clipboard -- --action=paste";
        desc = "Paste from system clipboard";
      }
    ];
  };
}
