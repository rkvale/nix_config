# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, lib, config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./vm.nix
    ];

  # roflolmapcopter
  nixpkgs.overlays = [
    (_: _: {
      inputs = builtins.mapAttrs (_: input: (input.packages or inputs.legacyPackages).${pkgs.system} or {}) inputs;
    })
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Oslo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nb_NO.UTF-8";
    LC_IDENTIFICATION = "nb_NO.UTF-8";
    LC_MEASUREMENT = "nb_NO.UTF-8";
    LC_MONETARY = "nb_NO.UTF-8";
    LC_NAME = "nb_NO.UTF-8";
    LC_NUMERIC = "nb_NO.UTF-8";
    LC_PAPER = "nb_NO.UTF-8";
    LC_TELEPHONE = "nb_NO.UTF-8";
    LC_TIME = "nb_NO.UTF-8";
  };

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "no";
    xkb.variant = "";
  };

  #antivirus
  services.clamav = {
    daemon.enable = true;
    updater.enable = true;
  };

 nix = {
  package = lib.mkDefault pkgs.nixVersions.latest;
 };

  # adding flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];


  # Configure console keymap
  console.keyMap = "no";
  
  nixpkgs.config.allowUnfree = true;
  
  programs.thunar.enable = true;
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    # Certain features, including CLI integration and system authentication support,
    # require enabling PolKit integration on some desktop environments (e.g. Plasma).
    # polkitPolicyOwners = [ "yourUsernameHere" ];
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  # trenger denne for at waylock skal kunne unlocke  
  security.pam.services.waylock = {};

  # Some Hyprland stuff
  #hardware.opengl.enable = true;
  hardware.graphics.enable = true;
 
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];
  
  virtualisation.libvirtd.enable = true;  
  programs.xfconf.enable = true;
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images
  services.printing.enable = true;


#  programs.waybar = {
#    enable = true;
#    package = pkgs.waybar;
#  };
 
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
  };
  
  programs.fish.enable = true;

  programs.ssh = {
    ciphers = [
      "chacha20-poly1305@openssh.com"
      "aes256-gcm@openssh.com"
      "aes128-gcm@openssh.com"
    ];
    kexAlgorithms = [
     "sntrup761x25519-sha512@openssh.com"
     "curve25519-sha256@libssh.org"
    ];
    macs = [
     "hmac-sha2-512-etm@openssh.com"
     "hmac-sha2-256-etm@openssh.com"
    ];
  };

#  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
#   "1password-gui"
#    "1password"
#  ];

 #Tailscale 
  services.tailscale.enable = true;


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wl-clipboard
    firefox
    #librewolf
    _1password
    mako
    #fish
    #alacritty
    #hyprland
    #wofi
    slack
    #zulu
    #libreoffice-qt
    poppler_utils  #pdf utils 
    #waybar
    #starship
    #git
    chromium   #add this again
    graphviz
    pulsemixer
    ltunify #for å pair unifying receiver
   # protonmail-desktop
  #  wget
  ];


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.runek = {
    isNormalUser = true;
    description = "Rune Kvale";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
    packages = with pkgs; [];
    shell = pkgs.fish;
  };

    fonts.packages = with pkgs; [
      (nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode" "DroidSansMono" "Iosevka"]; })
   ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
