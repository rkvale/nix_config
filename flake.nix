{
  description = "en liten beskrivelse";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    #Hyprland
    # Do not override nixpkgs input as Hyprland has its own binary cache.
    hyprland.url = "github:hyprwm/Hyprland/v0.37.1";
#    hyprland-split-monitor-workspaces = {
#      url = "github:Duckonaut/split-monitor-workspaces";
#      inputs.hyprland.follows = "hyprland";
#    };
  };

  outputs = inputs @ {self, hyprland, nixpkgs, home-manager, ...}: {
    # BYTT "nixos" TIL DIN HOSTNAME HVIS DU HAR ENDRET DET.
    nixosConfigurations.nixos = inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./configuration.nix
        #hyprland.nixosModules.default{
        #  programs.hyprland.enable = true;
        #}
        home-manager.nixosModules.home-manager
      
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.runek = import ./home/home.nix;

          # Optionally, use home-manager.extraSpecialArgs to pass
          # arguments to home.nix
        }
    ];
   };
  };
}
