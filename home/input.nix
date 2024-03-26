{
  osConfig,
  config,
  lib,
  ...
}: let
  xkb = osConfig.services.xserver.xkb;
  dispatchers =
    if (builtins.elem "split-monitor-workspaces" (map (p: lib.getName p.name) config.wayland.windowManager.hyprland.plugins))
    then {
      workspace = "split-workspace";
      movetoworkspacesilent = "split-movetoworkspacesilent";
      changemonitorsilent = "split-changemonitorsilent";
    }
    else {
      workspace = "workspace";
      movetoworkspacesilent = "movetoworkspacesilent";
      changemonitorsilent = "focusmonitor";
    };
in {
  wayland.windowManager.hyprland.settings = {
    input = {
      kb_model = xkb.model;
      kb_layout = xkb.layout;
      kb_variant = xkb.variant;
      kb_options = xkb.options;

      # Held keys repeat at 60Hz after 300ms
      repeat_delay = 300;
      repeat_rate = 60;

      # Workaround until HM fixes interop with new Hyprland format for device-specific settings.
      accel_profile = "flat";

      touchpad = {
        natural_scroll = true;
        scroll_factor = 0.4;
      };
    };

    "$MOD" = "SUPER";

    "$terminalcmd" = "alacritty";
    #"$runnercmd" = ''hyprctl dispatch exec "$(tofi-drun --width 40% --height 30%)"'';
    "$runnercmd" = ''hyprctl dispatch exec "$(wofi --show drun --width 40% --height 30%)"'';
    #"$scrotcmd" = ''grim -g "$(slurp -d)" - | wl-copy --type image/png'';
    "$scrotcmd" = ''slurp | grim -g - ~/Screenshots/$(date +'screenshot_%Y-%m-%d-%H%M%S.png')'';
    "$lockcmd" = "hyprlock";
    "$dismisscmd" = "makoctl dismiss -a";

    bind = let
      range = func: n: builtins.genList (i: func (toString (i + 1))) n;
    in
      with dispatchers;
        [
          "$MOD SHIFT, Q, exit"
          "$MOD,       Q, killactive"

          "$MOD,       RETURN, exec, $terminalcmd"
          "$MOD,       P,      exec, $runnercmd"
          "$MOD SHIFT, S,      exec, $scrotcmd"
          "$MOD SHIFT, L,      exec, $lockcmd"
          "$MOD SHIFT, D,      exec, $dismisscmd"

          # Windows
          "$MOD,           J,     layoutmsg,      cyclenext"
          "$MOD,           K,     layoutmsg,      cycleprev"
          "$MOD SHIFT,     J,     layoutmsg,      swapnext"
          "$MOD SHIFT,     K,     layoutmsg,      swapprev"
          "$MOD,           I,     layoutmsg,      addmaster"
          "$MOD,           D,     layoutmsg,      removemaster"
          "$MOD,           SPACE, togglefloating, active"
          "$MOD SHIFT,     P,     pin,            active"
          "$MOD,           M,     fullscreen,     1"
          "$MOD SHIFT,     M,     fullscreen,     0"
          "$MOD ALT SHIFT, M,     fakefullscreen"

          # Workspaces
          "$MOD, TAB, ${workspace}, previous"

          # Monitors
          "$MOD,       comma,  focusmonitor,              -1"
          "$MOD,       period, focusmonitor,              +1"
          "$MOD SHIFT, comma,  ${changemonitorsilent}, prev"
          "$MOD SHIFT, period, ${changemonitorsilent}, next"

          # Fn buttons
          ", XF86AudioMute, exec, pulsemixer --toggle-mute"
        ]
        ++ range (i: "$MOD, ${i}, ${dispatchers.workspace}, ${i}") 9
        ++ range (i: "$MOD SHIFT, ${i}, ${dispatchers.movetoworkspacesilent}, ${i}") 9;
    binde = [
      # Fn buttons
      ", XF86AudioRaiseVolume,  exec, pulsemixer --change-volume +5"
      ", XF86AudioLowerVolume,  exec, pulsemixer --change-volume -5"
      ", XF86MonBrightnessUp,   exec, xbacklight -inc 10"
      ", XF86MonBrightnessDown, exec, xbacklight -dec 10"
    ];
    bindm = [
      "$MOD, mouse:272, movewindow"
      "$MOD, mouse:273, resizewindow"
    ];
  };
  wayland.windowManager.hyprland.extraConfig = ''
    device {
      name = "logitech-usb-receiver"
      sensitivity = -0.5
      accel_profile = "flat"
    }
  '';
}
