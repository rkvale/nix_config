{pkgs, osConfig, ...}: {
  wayland.windowManager.hyprland.settings = {
    exec-once = [
      #"swaybg -i ~/.wallpaper/wallpaper02.png"
      "swww img ~/.wallpaper/dragon_kanji.jpg"
      #"${pkgs.hyprpaper}/bin/hyprpaper"
      "${pkgs.mako}/bin/mako"
      "waybar"
    ];
    master = {
      new_status = "master";
      new_on_top = true;
    };

    monitor = [
      ",highres,auto,1"
    ];

    general = {
      layout = "master";

      gaps_in = 4;
      gaps_out = 15;
      border_size = 2;
      "col.active_border" = "rgba(d82170ee)";
      "col.inactive_border" = "rgba(58c645ee)";
    };
    cursor.inactive_timeout = 5;
    decoration = {
      rounding = 6;
      blur = {
        enabled = true;
        size = 4;
        passes = 1;
        vibrancy = 0.1696;
        new_optimizations = true;
      };
      drop_shadow = true;
      shadow_range = 4;
      shadow_render_power = 3;
      # TODO: Actually do some testing with this cause I honestly can't tell.
      "col.shadow" = "rgba(000000ee)";
    };
    animations = {
      enabled = true;
      bezier = [
        "bouncy, 0.05, 0.9, 0.1, 1.05"
      ];
      animation = [
        "windows,     1, 4,  bouncy"
        "windowsOut,  1, 7,  default, popin 75%"
        "border,      1, 10, default"
        "borderangle, 1, 8,  default"
        "fade,        1, 4,  default"
        "workspaces,  1, 3,  default"
      ];
    };
    misc = {
      # Disable the anime cringe.
      disable_hyprland_logo = true;
      disable_splash_rendering = true;

      enable_swallow = true;
      swallow_regex = "^[Aa]lacritty$";
      swallow_exception_regex = "^(nr |nix run nixpkgs#)?wev.*";
    };
    windowrulev2 =
      [
        "suppressevent maximize, class:.*"
        # "nomaximizerequest, class:.*"
        "float, class:^wev$"
      ];
  };
}
