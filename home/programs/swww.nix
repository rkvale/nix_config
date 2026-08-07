{ lib, config, ... }:
let
  inherit (lib) mkOption types;
  cfg = config.services.awww;
  setBackground = "${lib.getExe cfg.package} img -t none ${cfg.defaultImage}";
in
{
  options.services.awww = {
    defaultImage = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = lib.literalExpression ''"./wallpaper.png"'';
      description = "A default wallpaper to apply using `awww img` after starting the daemon.";
    };
  };
  config = lib.mkIf cfg.enable {
    systemd.user.services.awww = {
      Service = {
        Type = "notify";
        ExecStartPost = lib.mkIf (cfg.defaultImage != null) setBackground;
      };
    };
  };
}
