{  inputs, config, pkgs, ...}: 
{
  imports = [
    #./hyprland.nix
    ./programs/swww.nix
    ./programs/neovim.nix
    ./programs/alacritty.nix
    ./programs/river.nix
    ./programs/kitty.nix
    ./programs/waybar02.nix
    #./programs/waybar.nix
    ./programs/zathura.nix
  ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "runek";
  home.homeDirectory = "/home/runek";
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    GOPRIVATE = "github.com/managenordic/*";
  };

  #wlogout config files
  home.file.".config/wlogout/" = {
    source = ./dotfiles/wlogout;
    recursive = true;
  };
  # programs.fish.shellAliases.nrs = "nh os switch ~/Documents/nix_config";

  home.keyboard.layout = "no";

  #hyprlock config file
  # home.file.".config/hypr/hyprlock.conf" = {
    # source = ./dotfiles/hypr/hyprlock.conf;
    #recursive = true;
    #executable = true;
  # };

  services.swww = {
    enable = true;
  };
 
  programs.git = {
    enable = true;
    userName = "rkvale";
    userEmail = "rune@kvale.io";
    extraConfig.url."ssh://git@github.com:managenordic/".insteadOf = "https://github.com/managenordic/";
  };
  programs.fish = {
    enable = true;
    functions = {
      fish_greeting.body = "";
      starship_transient_prompt_func.body = "starship module character";
    };
  };
  programs.starship = {
    enable = true;
    # settings = pkgs.lib.importTOML starship.toml;
    enableTransience = true;
    settings = {
      username = {
        show_always = true;
        #style_user = "bg:#9A348E";
        #style_root = "bg:#9A348E";
        #format = "[$user ]($style)";
        format = "[$user]($style)@";
        disabled = false;
      };
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[✖](bold red)";
      };
      cmd_duration = {
        format = "took [$duration]($style) ";
        style = "bold yellow";
        disabled = false;
      };

      hostname.format = "[$hostname]($style) in ";
      nix_shell = {
        format = "[$state$symbol]($style) ";
        symbol = "❄️";
        #symbol = "❄️";
        pure_msg = "pure ";
        impure_msg = "";
      };

      battery = {
        full_symbol = "🔋 ";
        charging_symbol = "⚡️ ";
        discharging_symbol = "💀 ";
      };  
      git_status = {
        format = "$all_status$ahead_behind ";
        ahead = "[⬆](bold purple) ";
        behind = "[⬇](bold purple) ";
        staged = "[✚](green) ";
        deleted = "[✖](red) ";
        renamed = "[➜](purple) ";
        stashed = "[✭](cyan) ";
        untracked = "[◼](white) ";
        modified = "[✱](blue)";
        conflicted = "[═](yellow)";
        diverged = "⇕ ";
        up_to_date = "";
      };



    };
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.catppuccin-cursors
  home.stateVersion = "23.11";

  home.pointerCursor = {
    gtk.enable = true;
    #package = pkgs.catppuccin-cursors.mochaMauve;
    #name = "MochaMauve";
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Amber";
    #name = "Bibata-Modern-Classic";
    size = 16;
  };

  gtk = {
    enable = true;

    font.name = "Iosevka Nerd Font";
    font.size = 11;

    theme.name = "Flat-Remix-GTK-Grey-Darkest";
    theme.package = pkgs.flat-remix-gtk;

    iconTheme.name = "Adwaita";
    iconTheme.package = pkgs.adwaita-icon-theme;
    #iconTheme.package = pkgs.gnome.adwaita-icon-theme;

    # Only available since 4.0 apparently.
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
  };
  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";

  # Let Home Manager install and manage itself.
  #programs.home-manager.enable = true;

  home.packages = [
    #ddpkgs.wireguard-tools
    pkgs.go
    pkgs.bruno
    pkgs.gcc
    pkgs.tidal-hifi
    pkgs.nh # for å rydde litt i nixos :-)
    pkgs.swappy # editere bilder
    #pkgs.zathura             	# command line pdf viewer
    pkgs.jq # json prettyfier
    pkgs.texliveFull
    #pkgs.hyprlock
    pkgs.hypridle
    #pkgs.hyprpaper
    #pkgs.flameshot
    pkgs.grim
    pkgs.slurp
    pkgs.obsidian
    pkgs.geeqie #image viewer
    pkgs.swappy
    #pkgs.hyprshot
    pkgs.openfortivpn
    pkgs.dnsutils
    pkgs.unzip
    pkgs.zip
    pkgs.p7zip
    pkgs.brightnessctl
    #pkgs.insomnia
    #pkgs.postman
    pkgs.signal-desktop
    pkgs.reveal-md
    pkgs.element-desktop
    # pkgs.swaybg
    pkgs.protonmail-desktop
    pkgs.tofi
    #pkgs.zulu
    pkgs.libreoffice-fresh    #add this again
    #pkgs.wleave
    #pkgs.waylogout
    pkgs.wlogout
    pkgs.virtio-win
    pkgs.remmina
    #pkgs.taskwarrior3
    #pkgs.virt-manager
    #pkgs.citrix_workspace
    # pkgs.cups
  ];
  #programs.taskwarrior.enable = true;
  #programs.tofi.enable = true;
  #programs.system-config-printer.enable = true;
  #services.printing.enable = true;
  #programs.alacritty.enable = true;
  # programs.alacritty.settings =
  #   {
  #     ipc_socket = false;
  # window = {
  #       padding.x = 2;
  #       padding.y = 0;
  #       decorations = "None";
  #       dynamic_title = true;
  #     };
  #     font.normal.family = "JetBrainsMono NF";
  #     font.size = 12.75;
  # };
}
