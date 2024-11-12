{
  lib,
  config,
  ...
}: let
  style = builtins.concatStringsSep "\n" (
    [(builtins.readFile ./programs/waybar.css)]
     ''
      /* Tags */
      #tags button {
        padding-right: .4rem;
        padding-left: .4rem;
        padding-top: .1rem;
        padding-bottom: .1rem;
        color: @red;
        /* border: .2px solid transparent; */
        background: transparent;
      }

      #tags button.occupied {
        color: @pink;
      }
      #tags button.focused {
        font-weight: bold;
        color: @rosewater;
      }

      #tags button:hover {
        /* border: .2px solid transparent; */
        color: @rosewater;
      }

      #layout {
        padding-right: .4rem;
        padding-left: .4rem;
        padding-top: .1rem;
        padding-bottom: .1rem;
        color: @red;
        background: transparent;
      }
    ''
  );
in
  lib.mkMerge [
    ({
      programs.waybar = {
        inherit style;
        settings.mainBar = {
          layer = "top";
          modules-center = ["clock"];
          modules-right =
            (
              if config.gk.roles.music.enable
              then ["mpd"]
              else []
            )
            ++ [
              "wireplumber"
              "network"
              "temperature"
              "disk"
              "memory"
              "cpu"
              "battery"
              "tray"
            ];

          clock = {
            format = "{:%H:%M}";
            tooltip = true;
            tooltip-format = "{:%c}";
          };
          wireplumber = {
            format = "{icon} {volume}%";
            format-muted = "";
            format-icons.default = ["" "" ""];
            on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
            on-click-middle = "alacritty -e pulsemixer";
          };
          disk = {
            interval = 60;
            format = " {used}";
            path = "/home";
            tooltip = true;
            tooltip-format = "{path}: {used}/{total} = {percentage_used}%";
          };
          mpd = {
            max-length = 25;
            format = "<span foreground='#bb9af7'></span> {title}";
            format-paused = " {title}";
            format-stopped = "<span foreground='#bb9af7'></span>";
            format-disconnected = "";
            on-click = "mpc --quiet toggle";
            on-click-right = "mpc ls | mpc add";
            on-click-middle = "alacritty -e ncmpcpp";
            on-scroll-up = "mpc --quiet prev";
            on-scroll-down = "mpc --quiet next";
            smooth-scrolling-threshold = 5;
            tooltip-format = "{title} - {artist} ({elapsedTime:%M:%S}/{totalTime:%H:%M:%S})";
          };
          temperature = {
            interval = 1;
            hwmon-path-abs = "/sys/devices/pci0000:00/0000:00:18.3/hwmon";
            input-filename = "temp3_input";
            critical-threshold = 70;
            format = "{icon} {temperatureC}°C";
            format-critical = "󰸁 {temperatureC}°C";
            format-icons = ["󱃃" "󱃃" "󱃃" "󱃃" "󰔏" "󱃂"];
          };
          memory = {
            interval = 10;
            format = " {percentage}%";
            states.warning = 85;
            on-click-middle = "alacritty -e htop";
          };
          cpu = {
            interval = 1;
            format = " {usage}%";
            on-click-middle = "alacritty -e htop";
          };
          battery = {
            states = {
              warning = "25";
              critical = "10";
            };
            format = "{icon} {capacity}%";
            format-icons = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
            format-charging = "󰂄 {capacity}%";
          };
          network = {
            interval = 10;
            format-wifi = " {essid}";
            format-ethernet = "󰈀 {ifname} ({ipaddr})";
            format-disconnected = "Disconnected";
          };
          tray = {
            icon-size = 15;
            spacing = 5;
          };
        };
      };
    })
    ({
      programs.waybar.settings.mainBar = {
        modules-left = [
          "river/tags"
          "river/layout"
        ];
        "river/layout" = {
          format = "{}";
          on-click = "riverctl send-layout-cmd rivercarro 'main-location-cycle monocle,left'";
        };
      };
    })
  ]
