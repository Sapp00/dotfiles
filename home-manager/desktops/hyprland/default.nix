{ isWorkstation
, isLinux
, pkgs
, lib
, vm ? false
, ...
}:
let
  # Helper to inject raw Lua code cleanly via Home Manager
  lua = lib.generators.mkLuaInline;

  # Bind abstractions wrapping hl.bind() mapping
  bind = key: action: { _args = [ key (lua action) ]; };
  bindRepeat = key: action: { _args = [ key (lua action) (lua ''{ repeating = true }'') ]; };
  bindMouse = key: action: { _args = [ key (lua action) (lua ''{ mouse = true }'') ]; };
  
  # Dispatcher commands modeled after the Hyprland 0.55 Lua API
  exec = cmd: ''hl.dsp.exec_cmd("${cmd}")'';
  close = ''hl.dsp.window.close()'';
  exit = ''hl.dsp.exit()'';
  fullscreen = ''hl.dsp.window.fullscreen()'';
  toggleFloat = ''hl.dsp.window.float({ action = "toggle" })'';
  focusDir = dir: ''hl.dsp.focus({ direction = "${dir}" })'';
  moveDir = dir: ''hl.dsp.window.move({ direction = "${dir}" })'';
  focusWs = ws: ''hl.dsp.focus({ workspace = "${ws}" })'';
  moveWs = ws: ''hl.dsp.window.move({ workspace = "${ws}" })'';
  
  # The resize dispatcher takes a Lua table of relative coordinates
  resizeActive = x: y: ''hl.dsp.window.resize({ x = ${x}, y = ${y}, relative = true })''; 
in
{
  home.packages = [ pkgs.wl-clipboard ];

  module = {
    kitty.enable = true;
    nerdfonts.enable = true;
    waybar.enable = true;
    wofi.enable = true;
  };

  wayland.windowManager.hyprland = {
    enable = true;

    # 1. Inform Home Manager to generate a Lua config instead of hyprlang
    configType = "lua";

    settings = {
      # 2. General settings must now sit under a nested `config` block
      config = {
        monitor = [ "Virtual-1,1920x1080,0x0,1" ];
        input = {
          kb_layout = "de";
        };
        env = lib.optionals vm [ "WLR_NO_HARDWARE_CURSORS,1" ];
      };

      # 3. Autostart lifecycle hooks translate to hl.on() via the `on` mapping
      on = [
        {
          _args = [ "hyprland.start" (lua ''
            function()
              hl.exec_cmd("waybar")
              ${lib.optionalString vm ''hl.exec_cmd("spice-vdagent")''}
            end
          '') ];
        }
      ];

      # 4. Binds
      bind = [
        # Applications
        (bind "SUPER + Return" (exec "${lib.optionalString vm "env LIBGL_ALWAYS_SOFTWARE=1 "}kitty"))
        (bind "SUPER + Space" (exec "wofi --show drun"))
        (bind "SUPER + Q" close)
        (bind "SUPER + F" fullscreen)
        (bind "SUPER + V" toggleFloat)
        (bind "SUPER + M" exit)

        # Focus (hjkl)
        (bind "SUPER + h" (focusDir "l"))
        (bind "SUPER + l" (focusDir "r"))
        (bind "SUPER + k" (focusDir "u"))
        (bind "SUPER + j" (focusDir "d"))

        # Move windows (hjkl)
        (bind "SUPER + SHIFT + h" (moveDir "l"))
        (bind "SUPER + SHIFT + l" (moveDir "r"))
        (bind "SUPER + SHIFT + k" (moveDir "u"))
        (bind "SUPER + SHIFT + j" (moveDir "d"))

        # Scroll through workspaces
        (bind "SUPER + mouse_down" (focusWs "e+1"))
        (bind "SUPER + mouse_up" (focusWs "e-1"))
      ] 
      # Dynamically generate workspace binds (1-10) using our helper
      ++ builtins.concatLists (builtins.genList (x:
        let
          ws = let c = (x + 1) / 10; in builtins.toString (x + 1 - (c * 10));
          wsId = builtins.toString (x + 1);
        in [
          (bind "SUPER + ${ws}" (focusWs wsId))
          (bind "SUPER + SHIFT + ${ws}" (moveWs wsId))
        ]
      ) 10)
      # Repeating resize bindings and mouse dragging
      ++ [
        (bindRepeat "SUPER + CTRL + h" (resizeActive "-40" "0"))
        (bindRepeat "SUPER + CTRL + l" (resizeActive "40" "0"))
        (bindRepeat "SUPER + CTRL + k" (resizeActive "0" "-40"))
        (bindRepeat "SUPER + CTRL + j" (resizeActive "0" "40"))

        # Mouse bindings (requires { mouse = true } flag)
        (bindMouse "SUPER + mouse:272" ''hl.dsp.window.drag()'')
        (bindMouse "SUPER + mouse:273" ''hl.dsp.window.resize()'')
      ];
    };
  };
}
