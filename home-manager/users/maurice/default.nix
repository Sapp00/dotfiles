{ isWorkstation
, isLinux
, desktop
, ...
}:
{
  nixpkgs.overlays = [  ];

  module = {
 #   btop.enable           = true;
    go-task.enable          = true;
    eza.enable            = true;
    #git.enable            = true;
    #fzf.enable            = true;
    #htop.enable           = true;
    #ripgrep.enable        = true;
    #lazygit.enable        = true;
    nvim.enable           = true;
    fish.enable           = false;
    zsh.enable            = true;
    tmux.enable           = true;
    python.enable        = true;

    /*user = {
      packages.enable = true;
    };*/
  };
}
