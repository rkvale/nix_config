{
  pkgs,
  lib,
  config,
  ...
}:
{

  xdg.portal = {
    # enable = true;
    # xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
    ];
    config.niri = {  
      default = ["gnome" "gtk"];
      "org.freedesktop.impl.portal.Access" = "gtk";
      "org.freedesktop.impl.portal.FileChooser" = "gtk";
      "org.freedesktop.impl.portal.Notification" = "gtk";
    };
  };

}




