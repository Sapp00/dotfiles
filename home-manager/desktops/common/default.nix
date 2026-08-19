{ lib, config, pkgs, inputs, ... }:

{
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    pkgs.unstable.nerd-fonts.iosevka
    thunar
    loupe
  ];

  programs.yazi = {
    plugins = {
      clipboard = inputs.clipboard-yazi;
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
