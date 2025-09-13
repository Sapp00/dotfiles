{ 
  lib
, config
, username
, pkgs
, homeModules
, ...
}:

with lib;

let
  cfg = config.module.zsh;
in {
  options = {
    module.zsh.enable = mkEnableOption "Enables Zsh";
  };

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      
      # Enable useful zsh options
      enableCompletion = true;
      enableAutosuggestions = true;
      syntaxHighlighting.enable = true;
      
      # Oh My Zsh configuration
      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = [
          "git"
          "docker"
          "kubectl"
          "golang"
          "rust"
          "node"
          "python"
          "pip"
          "sudo"
          "history"
          "command-not-found"
        ];
      };

      # Shell aliases - keeping your existing ones
      shellAliases = {
        "h" = "history";
        "c" = "clear";
        "s" = "sudo su";

        # Git
        "gs" = "git status";
        "ga" = "git add";
        "ga." = "git add .";
        "gch" = "git checkout";
        "gchb" = "git checkout -b";
        "gc" = "git commit";
        "gcm" = "git commit -m";
        "gb" = "git branch";
        "mergemaster" = "git checkout master; git pull; git merge develop; git push; git checkout develop";
        "gfr" = "git fetch upstream && git rebase upstream/master";

        # Docker
        "di" = "docker images";
        "dr" = "docker run";
        "db" = "docker build";
        "dp" = "docker ps";
        "dps" = "docker ps -a";
        "drmi" = "docker rmi";
        "drm" = "docker rm";

        # Kubernetes
        "k" = "kubectl";

        # Pass
        "passc" = "pass -c";
        "upass" = "pass git pull; pass git push";

        # Others
        "fuck" = "_ !!";
        "ll" = "ls -la";
        "la" = "ls -la";
      };

      # History configuration
      history = {
        size = 10000;
        save = 10000;
        ignoreDups = true;
        share = true;
      };

      # Custom initialization
      initExtra = ''
        # Set better prompt if oh-my-zsh theme doesn't work
        autoload -U promptinit
        promptinit
        
        # Enable colors
        autoload -U colors
        colors
        
        # Improved tab completion
        zstyle ':completion:*' menu select
        zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
        zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
        
        # Key bindings for history search
        bindkey "^[[A" history-beginning-search-backward
        bindkey "^[[B" history-beginning-search-forward
        
        # Better directory navigation
        setopt AUTO_CD
        setopt AUTO_PUSHD
        setopt PUSHD_IGNORE_DUPS
        
        # Glob options
        setopt EXTENDED_GLOB
        setopt NO_CASE_GLOB
        
        # History options
        setopt HIST_VERIFY
        setopt HIST_EXPIRE_DUPS_FIRST
        setopt HIST_IGNORE_SPACE
      '';
    };

    # Also enable starship for a modern prompt (as alternative to oh-my-zsh theme)
    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        format = "$username[@](bold blue)$hostname$directory$git_branch$git_status$character";
        
        character = {
          success_symbol = "[❯](bold green)";
          error_symbol = "[❯](bold red)";
        };
        
        username = {
          show_always = true;
          format = "[$user]($style)";
          style_user = "blue bold";
          disabled = false;
        };
        
        hostname = {
          ssh_only = false;
          format = "[$hostname]($style) ";
          style = "green bold";
          disabled = false;
        };
        
        directory = {
          format = "[$path]($style) ";
          style = "cyan bold";
          truncation_length = 3;
        };
        
        git_branch = {
          format = "on [$symbol$branch]($style) ";
          style = "purple bold";
        };
        
        git_status = {
          format = "[$all_status$ahead_behind]($style) ";
          style = "red bold";
        };
      };
    };
  };
}