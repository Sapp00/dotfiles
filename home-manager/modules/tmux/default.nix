{ lib
, config
, pkgs
, ...
}:

with lib;

let
  cfg = config.module.tmux;
in {
  options = {
    module.tmux.enable = mkEnableOption "Enables tmux";
    module.tmux.nvim = mkEnableOption "Enable connection to neoVim";
  };

  config = mkIf cfg.enable {
    # dependencies
    programs.fzf.enable = true;

    programs.tmux = {
      enable = true;
      plugins = with pkgs.tmuxPlugins; [
        sensible
        fzf-tmux-url
        resurrect
        continuum
      ]
      ++ lib.optionals cfg.nvim [
        vim-tmux-navigator
      ];

      extraConfig = ''
        set -g default-terminal "screen-256color"

        set -g prefix C-a
        unbind C-b
        bind-key C-a send-prefix

        unbind %
        bind '#' split-window -h
        unbind '"'
        bind - split-window -v

        unbind r
        bind r source-file ~/.tmux.conf

        bind -r j resize-pane -D 5
        bind -r k resize-pane -U 5
        bind -r h resize-pane -L 5
        bind -r l resize-pane -R 5

        bind -r m resize-pane -Z


        set -g mouse on

        set-window-option -g mode-keys vi
        bind-key Enter copy-mode

        bind-key -T copy-mode-vi 'v' send -X begin-selection


        bind-key -T copy-mode-vi 'y' send -X copy-selection

        unbind -T copy-mode-vi MouseDragEnd1Pane

        set -g @resurrect-strategy-vim 'session'
        set -g @resurrect-strategy-nvim 'session'
        set -g @resurrect-capture-pane-contents 'on'
        set -g @resurrect-processes '~Vim -> vim'

        set -g @continuum-restore 'on'
        set -g @continuum-boot 'on'
        set -g @continuum-save-interval '1'

        resurrect_dir="$HOME/.tmux/resurrect"
        set -g @resurrect-dir $resurrect_dir
        set -g @resurrect-hook-post-save-all 'target=$(readlink -f $resurrect_dir/last); sed "s| --cmd .*-vim-pack-dir||g; s|/etc/profiles/per-user/$USER/bin/||g" $target | sponge $target'
      '';
    };
  };
}
