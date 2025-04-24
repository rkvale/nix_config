{ lib, config, ... }:
let
  inherit (lib) mkOption types;
  cfg = config.services.swww;
  setBackground = "${lib.getExe cfg.package} img -t none ${cfg.defaultImage}";
in
{
  options.services.swww = {
    defaultImage = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = lib.literalExpression ''"./wallpaper.png"'';
      description = "A default wallpaper to apply using `swww img` after starting the daemon.";
    };
  };
  config = lib.mkIf cfg.enable {
    systemd.user.services.swww = {
      Service = {
        Type = "notify";
        ExecStartPost = lib.mkIf (cfg.defaultImage != null) setBackground;
      };
    };
  };
}
