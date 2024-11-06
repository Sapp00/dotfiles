{ lib
, config
, pkgs
, homeModules
, ...
}:

with lib;

let
  cfg = config.module.nvim;
in {
  options = {
    module.nvim.enable = mkEnableOption "Enables nvim";
  };

  config = mkIf cfg.enable {
    xdg.configFile."nvim" = {
      source = "${homeModules}/neovim/config";
      recursive = true;
    };

    programs.neovim = {
      package = pkgs.unstable.neovim-unwrapped;
      enable = true;
      viAlias = true;
      vimAlias = true;
      defaultEditor = true;

      extraPackages = with pkgs; [
        fzf
        lazygit
        readline
        # compiler / interpreter
        gcc
        clang
        llvm
        cmake
        nodejs_22
        go
        # lsp
        yaml-language-server
        gopls
        dockerfile-language-server-nodejs
        docker-compose-language-service
        cmake-language-server
        helm-ls
        nil
        nixd
        lua-language-server
        stylua
        pyright
      ];
    };
  };
}
