{
  osConfig,
  pkgs,
  ...
}: let
  catppuccin =
    pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "waybar";
      rev = "f74ab1eecf2dcaf22569b396eed53b2b2fbe8aff";
      hash = "sha256-WLJMA2X20E5PCPg0ZPtSop0bfmu+pLImP9t8A8V4QK8=";
    }
    + /themes/mocha.css;
in {
  programs.waybar.enable = true;
  programs.waybar.package = pkgs.waybar.override {wireplumberSupport = false;};
  programs.waybar.settings.mainBar = {
    layer = "top";
    # Layout
    #modules-left = ["hyprland/workspaces"];
    modules-left = ["river/tags"];
    modules-center = ["clock"];
    modules-right =
       [
        "pulseaudio"
        #"temperature"
        #"disk"
        "memory"
        #"cpu"
        "battery"
        #"tray"
        "network"
        "custom/power"
      ];

    "river/tags" ={
      programs.waybar.style = ''
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
          color: @red;
        }
        #tags button.focused {
          font-weight: bold;
          color: @green;
        }

        #tags button:hover {
          /* border: .2px solid transparent; */
          color: @red;
        }
      '';
    };

    # Module configuration
    "hyprland/workspaces" = {
      active-only = false;
      format = "{icon}";
      format-icons = let
        roman = ["1" "2" "3" "4" "5" "6" "7" "8" "9"];
        genWs = base:
          builtins.listToAttrs (builtins.genList (i: {
              name = toString (i + base);
              value = builtins.elemAt roman i;
            })
            9);
      in
        {
          "urgent" = "";
          "focused" = "";
          "default" = "";
        }
        // (genWs 1)
        // (genWs 11)
        // (genWs 21);
    };

    "custom/power" = {
      format = " ";
      on-click = "wlogout";
    };
    clock = {
      format = "{:%H:%M}";
      tooltip = true;
      tooltip-format = "{:%c}";
    };
    pulseaudio = {
      format = "{icon} {volume}%";
      format-muted = "muted";
      format-icons = {
        default = ["" "" ""];
      };
    };
    disk = {
      interval = 60;
      format = " {used}";
      path = "/home";
      tooltip = true;
      tooltip-format = "{path}: {used}/{total} = {percentage_used}%";
      on-click = "pulsemixer --toggle-mute";
    };
#    mpd = {
#      max-length = 25;
#      format = "<span foreground='#bb9af7'></span> {title}";
#      format-paused = " {title}";
#      format-stopped = "<span foreground='#bb9af7'></span>";
#      format-disconnected = "";
#      on-click = "mpc --quiet toggle";
#      on-click-right = "mpc ls | mpc add";
#      on-click-middle = "kitty ncmpcpp";
#      on-scroll-up = "mpc --quiet prev";
#      on-scroll-down = "mpc --quiet next";
#      smooth-scrolling-threshold = 5;
#      tooltip-format = "{title} - {artist} ({elapsedTime:%M:%S}/{totalTime:%H:%M:%S})";
#    };
    memory = {
      interval = 10;
      format = " {percentage}%";
      states.warning = 85;
    };
    cpu = {
      interval = 1;
      format = " {usage}%";
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
      #on-click = "alacritty -e nmtui";
      on-click = "kitty -e nmtui";
    };
    tray = {
      icon-size = 15;
      spacing = 5;
    };
  };
  programs.waybar.style =
    (builtins.readFile catppuccin)
    + ''
        /* Global */
      * {
        font-family: "JetBrainsMono NF";
        font-size: .9rem;
        border-radius: 1rem;
        transition-property: background-color;
        transition-duration: 0.5s;
        background-color: shade(@base, 0.9);
      }

      @keyframes blink_red {
        to {
          background-color: @red;
          color: @base;
        }
      }

      .warning, .critical, .urgent {
        animation-name: blink_red;
        animation-duration: 1s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }

      #mode, #clock, #memory, #temperature, #cpu, #custom-weather,
      #mpd, #idle_inhibitor, #backlight, #pulseaudio, #network,
      #battery, #custom-powermenu, #custom-cava-internal,
      #custom-launcher, #tray, #disk, #custom-pacman, #custom-scratchpad-indicator {
        padding-left: .6rem;
        padding-right: .6rem;
      }

      /* Bar */
      window#waybar {
        background-color: transparent;
      }

      window > box {
        background-color: transparent;
        margin: .3rem;
        margin-bottom: 0;
      }


      /* Workspaces */
      #workspaces:hover {
        background-color: @green;
      }

      #workspaces button {
        padding-right: .4rem;
        padding-left: .4rem;
        padding-top: .1rem;
        padding-bottom: .1rem;
        color: @red;
        /* border: .2px solid transparent; */
        background: transparent;
      }

      #workspaces button.focused {
        color: @blue;
      }

      #workspaces button.active {
	color: @green;
      }

      #workspaces button:hover {
        /* border: .2px solid transparent; */
        color: @rosewater;
      }

      /* Tooltip */
      tooltip {
        background-color: @base;
      }

      tooltip label {
        color: @rosewater;
      }

      /* battery */
      #battery {
        color: @mauve;
      }
      #battery.full {
        color: @green;
      }
      #battery.charging{
        color: @teal;
      }
      #battery.discharging {
        color: @peach;
      }
      #battery.critical:not(.charging) {
        color: @pink;
      }
      #custom-powermenu {
        color: @red;
      }

      /* mpd */
      #mpd.paused {
        color: @pink;
        font-style: italic;
      }
      #mpd.stopped {
        color: @rosewater;
        /* background: transparent; */
      }
      #mpd {
        color: @lavender;
      }

      /* Extra */
      #custom-cava-internal{
        color: @peach;
        padding-right: 1rem;
      }
      #custom-launcher {
        color: @yellow;
      }
      #memory {
        color: @peach;
      }
      #cpu {
        color: @blue;
      }
      #clock {
        color: @rosewater;
      }
      #idle_inhibitor {
        color: @green;
      }
      #temperature {
        color: @sapphire;
      }
      #backlight {
        color: @green;
      }
      #pulseaudio {
        color: @mauve;  /* not active */
      }
      #custom-power {
        color: @red;
      }
      #network {
        color: @pink; /* not active */
      }
      #network.disconnected {
        color: @foreground;  /* not active */
      }
      #disk {
        color: @maroon;
      }
      #custom-pacman{
        color: @sky;
      }
      #custom-scratchpad-indicator {
        color: @yellow
      }
      #custom-weather {
        color: @red;
      }
    '';
}
