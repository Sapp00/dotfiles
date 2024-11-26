{ isWorkstation
, isLinux
, hyprlandEnable ? false
, swayEnable ? false
, wmEnable ? false
, ...
}:
{
  nixpkgs.overlays = [  ];

  /*stylix.targets = {
    kitty.enable = true;
  };*/

  module = {
    #stylix.enable    = isWorkstation;
    #stylix.enable = true;

 #   btop.enable           = true;
    go-task.enable          = true;
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
