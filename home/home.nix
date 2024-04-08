{ inputs, config, pkgs, ... }:

{


  imports = [
    ./hyprland.nix
  ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "runek";
  home.homeDirectory = "/home/runek";

  programs.bash.enable = true;
  home.sessionVariables.NIXOS_OZONE_WL = "1";

  #wlogout config files
  home.file.".config/wlogout/" = {
    source = ./dotfiles/wlogout;
    recursive = true;
  };

  #hyprlock config file
  home.file.".config/hypr/hyprlock.conf" = {
    source = ./dotfiles/hypr/hyprlock.conf;
    #recursive = true;
    #executable = true;
  };

  programs.git = {
    enable = true;
    userName  = "rhkvale";
    userEmail = "rune@kvale.io";
  };
  
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = "$shlvl$shell$username$hostname$nix_shell$git_branch$git_commit$git_state$git_status$directory$jobs$cmd_duration$character";
      shlvl = {
        disabled = false;
        symbol = "ﰬ";
        style = "bright-red bold";
      };
      shell = {
        disabled = false;
        format = "$indicator";
        fish_indicator = "";
        bash_indicator = "[BASH](bright-white) ";
        zsh_indicator = "[ZSH](bright-white) ";
      };
      username = {
        style_user = "bright-red bold";
        style_root = "bright-red bold";
      };
      hostname = {
        style = "bright-green bold";
        ssh_only = true;
      };
      nix_shell = {
        symbol = "";
        format = "[$symbol$name]($style) ";
        style = "bright-purple bold";
      };
      git_branch = {
        only_attached = true;
        format = "[$symbol$branch]($style) ";
        symbol = "שׂ";
        style = "bright-yellow bold";
      };
      git_commit = {
        only_detached = true;
        format = "[ﰖ$hash]($style) ";
        style = "bright-yellow bold";
      };
      git_state = {
        style = "bright-purple bold";
      };
      git_status = {
        style = "bright-green bold";
      };
      directory = {
        read_only = " ";
        truncation_length = 0;
      };
      cmd_duration = {
        format = "[$duration]($style) ";
        style = "bright-blue";
      };
      jobs = {
        style = "bright-green bold";
      };
      character = {
        success_symbol = "[\\$](bright-green bold)";
        error_symbol = "[\\$](bright-red bold)";
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
    iconTheme.package = pkgs.gnome.adwaita-icon-theme;

    # Only available since 4.0 apparently.
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
  };
  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";

  # Let Home Manager install and manage itself.
  #programs.home-manager.enable = true;
  
  home.packages = [
    pkgs.hyprlock
    pkgs.hypridle
    #pkgs.hyprpaper
    #pkgs.flameshot
    pkgs.nh
    pkgs.grim
    pkgs.slurp
    pkgs.obsidian
    pkgs.swappy
    #pkgs.hyprshot
    pkgs.openfortivpn
    pkgs.dnsutils
    pkgs.unzip
    pkgs.zip
    pkgs.p7zip
    pkgs.brightnessctl
    pkgs.insomnia
    pkgs.postman
    pkgs.signal-desktop
    pkgs.element-desktop
    pkgs.swaybg
    pkgs.protonmail-desktop
    pkgs.tofi
    #pkgs.wleave
    #pkgs.waylogout
    pkgs.wlogout
    pkgs.virtio-win
    #pkgs.virt-manager
    #pkgs.citrix_workspace
    #pkgs.cups
  ];
  
  #programs.system-config-printer.enable = true;  
  #services.printing.enable = true;
  programs.alacritty.enable = true;
  programs.alacritty.settings =
    {
      ipc_socket = false;
      window = {
        padding.x = 2;
        padding.y = 0;
        decorations = "None";
        dynamic_title = true;
      };
      font.normal.family = "JetBrainsMono NF";
      font.size = 12.75;
  };

}




