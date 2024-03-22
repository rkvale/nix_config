{
  osConfig,
  inputs,
  pkgs,
  ...
}: {
  imports = [
#    ./common/gui.nix
#    ./common/wayland.nix
#
    ./waybar.nix
#
#    ./hyprland/theme-catppuccin-mocha.nix
    ./base.nix
    ./input.nix
  ];


  # Packages, programs, and services required for the configuration to work.
#  home.packages = with pkgs; [swaybg acpilight grim slurp tofi wdisplays];
  # Lock screen
  #
  # NOTE: This requires NixOS option `security.pam.services.swaylock` to exist.
#  programs.swaylock = {
#    enable = true;
#    package = pkgs.swaylock-effects;
#    settings = {
#      ignore-empty-password = true;
#      show-failed-attempts = true;
#      screenshots = true;
#      indicator = true;
#      clock = true;
#      inside-wrong-color = "fb4934";
#      line-wrong-color = "fb4934";
#      ring-wrong-color = "fb4934";
#      inside-clear-color = "8ec07c";
#      ring-clear-color = "8ec07c";
#      line-clear-color = "8ec07c";
#      inside-ver-color = "83a598";
#      ring-ver-color = "83a598";
#      line-ver-color = "83a598";
#      text-color = "fbf1c7";
#      indicator-radius = "120";
#      indicator-thickness = "16";
#      effect-blur = "10x10";
#      ring-color = "32302f";
#      key-hl-color = "d3869b";
#      line-color = "32302f";
#      inside-color = "32302f";
#      separator-color = "00000000";
#    };
#  };
  # Notification daemon
#  services.mako.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };
}
