{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.services.swww;
in {
  options.services.swww = {
    enable = lib.mkEnableOption "swww";
    package = lib.mkPackageOption pkgs "swww" {};
    systemd.enable = lib.mkEnableOption "swww user service" // {default = true;};
    systemd.targets = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = ["graphical-session.target"];
      defaultText = lib.literalExpression ''[ "graphical-session.target" ]'';
      example = lib.literalExpression ''[ "river-session.target" ]'';
      description = "Specifies which systemd target that should automatically start swww.";
    };
    defaultImage = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = lib.literalExpression "./wallpaper.png";
      description = "A default wallpaper to apply using `swww img` after starting the daemon.";
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = [cfg.package];
    systemd.user.services.swww = lib.mkIf cfg.systemd.enable {
      Unit = {
        Description = "A Solution to your Wayland Wallpaper Woes";
        PartOf = ["graphical-session.target"];
        After = [
          "graphical-session-pre.target"
        ];
      };
      Service = {
        Type = "notify";
        ExecStart = "${cfg.package}/bin/swww-daemon";
        ExecStartPost = lib.mkIf (cfg.defaultImage != null) "${cfg.package}/bin/swww img ${cfg.defaultImage}";
      };
      Install.WantedBy = cfg.systemd.targets;
    };
  };
}

