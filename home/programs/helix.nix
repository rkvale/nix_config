{
  lib,
  config,
  ...
}:
{
programs.helix = {
  enable = true;
  languages.language = [
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





