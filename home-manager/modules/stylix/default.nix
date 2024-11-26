{ pkgs
, lib
, self
, config
, hostname
, desktop
, isWorkstation
, ...
}: 

with lib;

let
  cfg = config.module.stylix;

  theme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
  wallpaper = "${self}/assets/grey_gradient.png";
  cursorSize = if hostname == "nbox" then 24 else 14;
in {
  options = {
    module.stylix.enable = mkEnableOption "Enables stylix";
  };
  config = mkIf cfg.enable {
    #  programs.stylix.enable = isWorkstation && desktop != "osx";
    
    stylix = {
      enable = true;
      base16Scheme = ./style.yaml;
    };
  };
}
