{
  lib,
  config,
  ...
}:
{
programs.helix = {
  defaultEditor = true;
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
        name = "typst";
        formatter = {
          command = "typstfmt";
          args = [ "." ];
        };
      }
     {
        name = "json";
        formatter = {
              command = "jaq";
          args = [ "." ];
        };
      }
  ];
};
}





