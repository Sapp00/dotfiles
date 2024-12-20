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
      source = ./config;
      recursive = true;
    };

    programs.neovim = {
      package = pkgs.unstable.neovim-unwrapped;
      enable = true;
      viAlias = true;
      vimAlias = true;
      defaultEditor = true;

/*
      plugins = with pkgs.vimPlugins; [
        lazy-nvim
      ];*/

      extraPackages = with pkgs; [
        fzf
        lazygit
        readline
        ripgrep
        # compiler / interpreter
        gcc
        clang
        llvm
        cmake
        nodejs_22
        rust-analyzer
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
