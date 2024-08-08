{
  pkgs,
  lib,
  config,
  ...
}:
{
  #
  # First off.
  #
  wayland.windowManager.river.enable = true;

  #
  # Dependencies.
  #
  programs = {
    hyprlock.enable = true; # screen lock
    kitty.enable = true; # terminal
    tofi.enable = true; # menu
    waybar.enable = true; # status bar
  };
  services = {
    mako.enable = true; # notifications
    # swww.enable = true; # wallpapers
    #swww.defaultImage = ../assets/wallpaper.png;
    #udiskie.enable = false; # automatic mounting
  };

  home.packages = with pkgs; [acpilight imv wl-clipboard wlr-randr];

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
    ];
    config.river.default = ["wlr" "gtk"];
  };

  #
  # Configuration.
  #
  wayland.windowManager.river = {
    # DOES NOT WORK AND IDK WHY
    extraSessionVariables = {
      XDG_CURRENT_DESKTOP = "river";

      GDK_BACKEND = "wayland";
      QT_QPA_PLATFORM = "wayland";
      SDL_VIDEODRIVER = "wayland";
      CLUTTER_BACKEND = "wayland";

      QT_QPA_PLATFORMTHEME = "qt5ct";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    };

    # Putting it in extraConfig writes it at the end of the file.
    extraConfig = ''
      riverctl default-layout rivertile
      riverctl spawn rivertile
    '';

    settings = let
      pow = b: n:
        if n != 0
        then b * (pow b (n - 1))
        else 1;

      genWith = map: builtins.genList map 10;
      tagMasks = map toString ([4294967295] ++ genWith (pow 2));
    in
      lib.mkMerge [
        {
          #
          # Environment
          #
          spawn = map (s: "'${s}'") [
            # Considered running this with systemd, but after much trial and error it
            # turns out that it's pretty fucking stupid to do so. Actually, no matter
            # what, user units are kinda broken when using multiple window managers
            # anyway cause they overwrite each other's dbus activation environment.
            "waybar"

            # Workaround that forwards the clipboard from X11 to Wayland.
            "wl-paste -t text/plain -w ${lib.getExe pkgs.xclip} -selection clipboard"
          ];

          #
          # Appearance.
          #
          border-width = 2;

          #
          # Input devices.
          #
          set-repeat = "60 200"; # 60Hz after 200ms

          input."'pointer-*'" = {
            accel-profile = "flat"; # mouse acceleration disabled
            pointer-accel = "-0.5"; # "half" mouse sensitivity
          };
          input."'pointer-1739-52745-SYNA30D3:00_06CB:CE09'" = {
            pointer-accel = "0";
            tap = true;
          };
          input."'pointer-1133-16489-Logitech_MX_Master_2S'".pointer-accel = "1.0";
          #
          keyboard-layout = let
            xkb = config.home.keyboard;
          in
            builtins.concatStringsSep " " (
              lib.optional (xkb.model != null) "-model ${xkb.model}"
              ++ lib.optional (xkb.variant != null) "-variant ${xkb.variant}"
              ++ lib.optional (xkb.options != []) "-options ${builtins.concatStringsSep "," xkb.options}"
              ++ [xkb.layout]
            );
          #
          # Mouse/cursor related.
          focus-follows-cursor = "normal"; # on entering views
          hide-cursor = {
            timeout = 5000;
            when-typing = true;
          };
          set-cursor-warp = "on-output-change";

          xcursor-theme = let cfg = config.home.pointerCursor; in "${cfg.name} ${toString cfg.size}";

          #
          # Keymaps
          #
          declare-mode = ["passthrough"]; # "normal" and "locked" are built in

          # Enter and exit passthrough.
          # map.normal."Super F11" = "enter-mode passthrough";
          # map.passthrough."Super F11" = "enter-mode normal";

          # Working with floating windows.
           map-pointer.normal = {
             "Super BTN_LEFT" = "move-view";
             "Super BTN_RIGHT" = "resize-view";
             "Super BTN_MIDDLE" = "toggle-float";
           };
           map.normal."Super Space" = "toggle-float";

          # General stuff
          map.normal = {
            "Super+Shift Q" = "spawn 'systemctl stop --user river-session.target && riverctl exit'";
            "Super C" = "close";
          };

          #
          # Rules
          #
          rule-add = [
            "ssd"
            "-app-id WebCord tags ${builtins.elemAt tagMasks 9}"
            "-app-id steam tags ${builtins.elemAt tagMasks 8}"
          ];
        }

        #
        # Spawn bindings
        #
        {
          map.normal = builtins.mapAttrs (_: command: "spawn '${command}'") {
            # Essential shortcuts, tampering with these in any way is sacrilege and
            # subject to punishment by death penalty + life in prison, in that order.
            "Super Return" = "kitty --single-instance --instance-group river";
            "Super P" = "riverctl spawn \"$(tofi-drun)\"";

            # Same as Hyprland, this is temporary until I find something else.
            "Super+Shift L" = "hyprlock";

            # Stuff
            "$scrotcmd" = ''slurp | grim -g - ~/Screenshots/$(date +'screenshot_%Y-%m-%d-%H%M%S.png')'';
            # "Super+Shift S" = lib.getExe pkgs.inputs.self.snipping-tool;
            "Super+Shift S" = 
            "Super+Shift D" = "makoctl dismiss -a";

            #"None Pause" = lib.getExe pkgs.inputs.self.toggle-mute;
          };
        }

        #
        # DWM bindings
        #
        {
          map.normal =
            {
              # Windows
               "Super J" = "focus-view next";
               "Super K" = "focus-view previous";
               "Super+Shift J" = "swap next";
               "Super+Shift K" = "swap previous";
               "Super+Alt H" = "move left 100";
               "Super+Alt J" = "move down 100";
               "Super+Alt K" = "move up 100";
               "Super+Alt L" = "move right 100";
               "Super+Alt+Shift H" = "resize horizontal -100";
               "Super+Alt+Shift J" = "resize vertical +100";
               "Super+Alt+Shift K" = "resize vertical -100";
               "Super+Alt+Shift L" = "resize horizontal +100";
              #
              # # Layout
               "Super Tab" = "focus-previous-tags";
              #
               "Super H" = "send-layout-cmd rivertile 'main-ratio -0.05'";
               "Super L" = "send-layout-cmd rivertile 'main-ratio +0.05'";
               "Super I" = "send-layout-cmd rivertile 'main-count +1'";
               "Super D" = "send-layout-cmd rivertile 'main-count -1'";
              #
               "Super M" = "toggle-fullscreen";
              #
              # Monitors
              "Super Comma" = "focus-output left";
              "Super+Shift Comma" = "send-to-output -current-tags left";
              "Super Period" = "focus-output right";
              "Super+Shift Period" = "send-to-output -current-tags right";
            }
            # Tag keys
            // (
              lib.mergeAttrsList (genWith (i: let
                key = toString i;
                mask = builtins.elemAt tagMasks i;
              in {
                "Super ${key}" = "set-focused-tags ${mask}";
                "Super+Shift ${key}" = "set-view-tags ${mask}";
                "Super+Control ${key}" = "toggle-focused-tags ${mask}";
                "Super+Shift+Control ${key}" = "toggle-view-tags ${mask}";
              }))
            );
        }

        # Most function keys are available in both normal and locked mode.
        {
          map = lib.genAttrs ["normal" "locked"] (_: {
            "None XF86AudioMute" = "spawn 'wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle'";
            "None XF86AudioRaiseVolume" = "spawn 'wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+'";
            "None XF86AudioLowerVolume" = "spawn 'wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-'";
            "None XF86MonBrightnessUp" = "spawn 'xbacklight -inc 10'";
            "None XF86MonBrightnessDown" = "spawn 'xbacklight -dec 10'";
          });
        }

        # Disable internal display when laptop lid is closed.
        {
          map-switch = lib.genAttrs ["normal" "locked" "passthrough"] (_: {
            lid.close = "spawn 'wlr-randr --output eDP-1 --off'";
            lid.open = "spawn 'wlr-randr --output eDP-1 --on'";
          });
        }
      ];
  };
}

