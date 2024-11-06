{ isWorkstation
, isLinux
, hyprlandEnable ? false
, swayEnable ? false
, wmEnable ? false
, ...
}:
{
  nixpkgs.overlays = [  ];
/*
  stylix.targets = {
    vscode.enable = false;
    helix.enable = false;
  };*/

  module = {
    #stylix.enable    = isWorkstation;

 #   btop.enable           = true;
    eza.enable            = true;
    #git.enable            = true;
    #fzf.enable            = true;
    #htop.enable           = true;
    #ripgrep.enable        = true;
    #lazygit.enable        = true;
    nvim.enable           = true;
    fish.enable           = true;
    tmux.enable           = true;

    /*user = {
      packages.enable = true;
    };*/
  };
}
