{
  lib,
  config,
  ...
}:
{
programs.helix = {
  settings ={
    keys.normal = {
      "C-f" = ":format";
    };   
  };
  enable = true;
  languages.language = [
     {
        name = "nix";
        formatter = {
          command = "nixfmt";
          args = [ "-s" ];
        };
      }
     {
        name = "json";
        formatter = {
              command = "jq";
          args = [ "." ];
        };
      }
  ];
};
  .
}.





