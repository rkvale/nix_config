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
        name = "json";
        formatter = {
          command = "jq";
          args = [ "." ];
        };
      }
  ];
};
  
}





