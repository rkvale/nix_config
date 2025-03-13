{
  description = "en liten beskrivelse";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Sops
    sops-nix.url = "github:Mic92/sops-nix"; # secrets
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";


    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";

     fenix = {
       url = "github:nix-community/fenix";
       inputs.nixpkgs.follows = "nixpkgs";
     };
  };

  outputs = inputs @ {self, hyprland, nixpkgs, home-manager, ...}: {
  # f = inputs:
  # let
  #   inherit (inputs) self hyprland nixpkgs home-manager;
  # in
  # {
  #   inherit self hyprland nixpkgs home-manager;
  # };

    # BYTT "nixos" TIL DIN HOSTNAME HVIS DU HAR ENDRET DET.
    nixosConfigurations.nixos = inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
	        home-manager.extraSpecialArgs = {inherit inputs;};
          home-manager.users.runek = import ./home/home.nix;
          home-manager.backupFileExtension = "backup003"; 
        }
    ];
   };
  };
}
