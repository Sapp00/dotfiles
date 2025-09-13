{ lib, config, pkgs, homeModules, inputs ? {}, ... }@args:

# assert builtins.trace "loading home manager blabla" true;
# assert builtins.trace "args keys: ${builtins.concatStringsSep ", " (builtins.attrNames args)}" true;

# assert builtins.trace "plugins: ${toString (builtins.attrNames pkgs.unstable.vimPlugins)}" true;

with lib;

let
  cfg = config.module.nvim;
  utils = inputs.nixCats.utils;
in 
{
  options = {
    module.nvim.enable = lib.mkEnableOption "Enables nvim";
  };

  config = mkIf cfg.enable {
    nixCats = {
      enable = true;

      addOverlays = [
        (utils.standardPluginOverlay inputs)
      ];
      packageNames = [ "myHomeModuleNvim" ];

      luaPath = ./.;

      # the .replace vs .merge options are for modules based on existing configurations,
      # they refer to how multiple categoryDefinitions get merged together by the module.
      # for useage of this section, refer to :h nixCats.flake.outputs.categories
      categoryDefinitions.replace = ({ pkgs, settings, categories, extra, name, mkNvimPlugin, ... }@packageDef: {
        # to define and use a new category, simply add a new list to a set here,
        # and later, you will include categoryname = true; in the set you
        # provide when you build the package using this builder function.
        # see :help nixCats.flake.outputs.packageDefinitions for info on that section.

        # lspsAndRuntimeDeps:
        # this section is for dependencies that should be available
        # at RUN TIME for plugins. Will be available to PATH within neovim terminal
        # this includes LSPs
        lspsAndRuntimeDeps = with pkgs; {
          general = [
            lazygit
            xclip
            bash-language-server
          ];
          C = [
            clang-tools
            valgrind
            cmake-language-server
            cpplint
            cmake
            cmake-format
          ];
          markdown = [
            marksman
            harper
          ];
          lua = [
            lua-language-server
            stylua
          ];
          nix = [
            nixd
            nix-doc
            nil
            nixfmt-rfc-style
          ];
          go = [
            gopls
            delve
            golint
            golangci-lint
            gotools
            go-tools
            go
          ];
          python = [
            python3
            python312Packages.python-lsp-server
            python312Packages.pytest
            python312Packages.debugpy
          ];
          rust = [
            cargo
            rust-analyzer
            clippy
          ];
          web = {
            templ = [
              templ
            ];
            tailwindcss = [
              tailwindcss-language-server
            ];
            HTMX = [
              htmx-lsp
            ];
            HTML = [
              vscode-langservers-extracted
            ];
            JS = with nodePackages; [
              typescript-language-server
              eslint
              prettier
            ];
          };
        };

        # This is for plugins that will load at startup without using packadd:
        startupPlugins = {
          general = with pkgs.unstable.vimPlugins; [
            # lazy loading isnt required with a config this small
            # but as a demo, we do it anyway.
            lze
            lzextras
            rose-pine
            oil-nvim
            baleia-nvim # potentially remove
            mini-nvim
            luasnip # potentially remove
            vim-sleuth # TODO
            snacks-nvim # fix slightly
          ];

          rust = [
            pkgs.unstable.vimPlugins.rustaceanvim
          ];
        };

        # not loaded automatically at startup.
        # use with packadd and an autocommand in config to achieve lazy loading
        optionalPlugins = with pkgs.unstable.vimPlugins; {
          go = [
            nvim-dap-go
          ];
          lua = [
            lazydev-nvim
          ];
          vimagePreview = [
            image-nvim
          ];
          C = [
            vim-cmake
            clangd_extensions-nvim
          ];
          python = [
            nvim-dap-python
          ];
          otter = [
            otter-nvim
          ];

          general = [
            neogen
            plenary-nvim
            lazygit-nvim
            which-key-nvim
            nvim-lspconfig
            vim-startuptime
            blink-cmp
            nvim-treesitter.withAllGrammars
            lualine-nvim
            lualine-lsp-progress
            gitsigns-nvim
            nvim-lint
            conform-nvim # TODO
            nvim-dap-ui
            nvim-dap-virtual-text
          ];

          debug = [
            nvim-dap
            nvim-dap-ui
            nvim-dap-virtual-text
          ];

          markdown = [
            render-markdown-nvim
            markdown-preview-nvim
          ];
        };

        # shared libraries to be added to LD_LIBRARY_PATH
        # variable available to nvim runtime
        sharedLibraries = {
          general = with pkgs; [ ];
        };

        # environmentVariables:
        # this section is for environmentVariables that should be available
        # at RUN TIME for plugins. Will be available to path within neovim terminal
        environmentVariables = {
          # test = {
          #   CATTESTVAR = "It worked!";
          # };
        };

        # categories of the function you would have passed to withPackages
        extraPython3Packages = {
          # test = [ (_:[]) ];
        };

        # If you know what these are, you can provide custom ones by category here.
        # If you dont, check this link out:
        # https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh
        extraWrapperArgs = {
          # test = [
          #   '' --set CATTESTVAR2 "It worked again!"''
          # ];
        };
      });

      # see :help nixCats.flake.outputs.packageDefinitions
      packageDefinitions.replace = {
        # These are the names of your packages
        # you can include as many as you wish.
        myHomeModuleNvim = {pkgs , ... }: {
          # they contain a settings set defined above
          # see :help nixCats.flake.outputs.settings
          settings = {
            wrapRc = true;
            # unwrappedCfgPath = "/path/to/here";
            # IMPORTANT:
            # your alias may not conflict with your other packages.
            aliases = [ "vim" "homeVim" ];

            neovim-unwrapped = pkgs.unstable.neovim-unwrapped;

            # neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
          };
          # and a set of categories that you want
          # (and other information to pass to lua)
          # and a set of categories that you want
          categories = {
            general = true;
            bash = true;
            debug = true;
            go = true;
            lua = true;
            markdown = true;
            nix = true;
            otter = true;
            other = true;
            python = true;
            rust = true;
            vimagePreview = true;
            web = true;
          };
          # anything else to pass and grab in lua with `nixCats.extra`
          extra = {
            nixdExtras.nixpkgs = ''import ${pkgs.path} {}'';
          };
        };
      };
    };
  };

  imports = [
    inputs.nixCats.homeModule
  ];
}
