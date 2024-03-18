{ config, pkgs, ... }:

{


  imports = [
    ./hyprland.nix
  ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "runek";
  home.homeDirectory = "/home/runek";

  programs.git = {
    enable = true;
    userName  = "rhkvale";
    userEmail = "rune@kvale.io";
  };
  #testing
  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";

  # Let Home Manager install and manage itself.
  #programs.home-manager.enable = true;
  
  home.packages = [
    pkgs.hyprlock
    pkgs.hypridle
    pkgs.hyprpaper
    #pkgs.flameshot
    pkgs.nh
    pkgs.grim
    pkgs.slurp
    pkgs.obsidian
    pkgs.swappy
    pkgs.hyprshot
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




