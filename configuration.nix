# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
{

  sops.secrets."wg0_key" = {
    sopsFile = ./secrets.yml;
    group = "systemd-network";
    mode = "0440";
  };

  sops.secrets."wg0_psk" = {
    sopsFile = ./secrets.yml;
    group = "systemd-network";
    mode = "0440";
  };

  sops.secrets."tarsnap" = {
    sopsFile = ./secrets.yml;
    # group = "systemd-network";
    # mode = "0440";
  };

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./vm.nix

    inputs.sops-nix.nixosModules.default
  ];
  nix.settings = {
    substituters = [
      "https://nix-community.cachix.org"
      "https://cache.kylling.io?priority=100"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "titan-1:5jJME9Ak4MIkgK3RHG0AwCv0c81mFcPBrlRbswkM6aI="
    ];
  };
  # roflolmapcopter
  nixpkgs.overlays = [
    (_: _: {
      inputs = builtins.mapAttrs (
        _: input: (input.packages or inputs.legacyPackages).${pkgs.system} or { }
      ) inputs;
    })
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  sops.secrets.test = { };
  environment.etc.test.text = config.sops.secrets.test.path;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  # ********************************************************************
  networking = {
    hostName = "nixos"; # Define your hostname.

    nftables.enable = true;
    firewall = {
      enable = true;
      # allowedTCPPorts = [ 46725 ];
      # allowedUDPPorts = [ 46725 ];
    };

  };

  systemd.network = {
    enable = true;
    networks."10-nic" = {
      matchConfig.PermanentMACAddress = "14:13:33:15:e0:29";
      networkConfig = {
        DHCP = "ipv4";
        # Address = "2a01:4f9:3070:1c9e::2/64";

        # IPv6AcceptRA = "no";
        # Gateway = "fe80::1";

        DNS = [
          "192.168.1.2"
          "1.1.1.1"
          "1.0.0.1"
          # "2606:4700:4700::1111"
          # "2606:4700:4700::1001"
        ];
      };
    };
    netdevs."11-wg0" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg0";
      };
      wireguardConfig = {
        PrivateKeyFile = config.sops.secrets."wg0_key".path;
        RouteTable = "main";
      };
      wireguardPeers = [
        {
          Endpoint = "wireguard.kvale.io:51820";
          AllowedIPs = "10.0.0.0/24,192.168.1.0/24";
          PublicKey = "rDnFQoUfoisyH+HvIHiiQjeIcGPbXO2ufgYQAhBfKH8=";
          PresharedKeyFile = config.sops.secrets."wg0_psk".path;
          PersistentKeepalive = 30;
        }
      ];
    };
    networks."11-wg0" = {
      matchConfig.Name = "wg0";
      networkConfig.Address = "10.0.0.3/32";
    };
  };

  # ********************************************************************

  #docker testing
  virtualisation.docker.enable = true;

  # Enable networking
  networking.networkmanager.enable = true;

  # networking.nftables.enable = true;
  # networking.firewall = {
  #   enable = true;
  #   allowedTCPPorts = [ 46725 ];
  #   allowedUDPPorts = [ 46725 ];
  # };

  # denne setter opp br0 men får ikke brukt enp4s0f4u1u4
  # networking.useDHCP = false;
  # networking.bridges."br0".interfaces = ["enp4s0f4u1u4"];
  # networking.interfaces."br0".useDHCP = true;
  # networking.interfaces."enp4s0f4u1u4".useDHCP = true;

  # networking ={
  #   interfaces.br0.useDHCP = true;
  #   bridges ={
  #     br0 = {
  #       interfaces = ["enp4s0f4u1u4"];
  #     };
  #   };
  # };

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

  # Configure Tarsnap
  services.tarsnap = {
    enable = false;
    keyfile = config.sops.secrets."tarsnap".path;

    archives = {
      test = {
        directories = [ "/home/runek/vaultwarden" ];
        period = "*-*-* 03:00:00";
      };
    };

  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "no";
    variant = "";
    options = "caps:swapescape";
  };

  #antivirus
  services.clamav = {
    daemon.enable = true;
    updater.enable = true;
  };

  #fingerprint reader
  # services.fprintd.enable = true;

  nix = {
    package = lib.mkDefault pkgs.nixVersions.latest;
  };

  # adding flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Configure console keymap
  console.keyMap = "no";

  nixpkgs.config.allowUnfree = true;
  # nixpkgs.config.allowUnsupportedSystem = true;
  #
  programs.hyprlock.enable = true;

  programs.river-classic.enable = true;
  programs.thunar.enable = true;
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    # Certain features, including CLI integration and system authentication support,
    # require enabling PolKit integration on some desktop environments (e.g. Plasma).
    # polkitPolicyOwners = [ "yourUsernameHere" ];
  };

  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "JetBrainsMono NF:size=12.75,DejaVu Sans Mono:size=12.75,Unifont:size=12.75";
        pad = "4x0";
      };
    };
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = lib.mkForce pkgs.pinentry-curses;
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
    extraConfig.pipewire = {
      "10-quantum"."context.properties" = {
        # Lower quantums improve latency (quantum / rate = seconds) but can introduce buffer xruns,
        # noticeable as pops or crackles. Any reasonably powerful modern personal computer should
        # be more than capable of servicing high resolution sample rates in this range of quantums,
        # even when under load.
        #
        # These settings are recommendations to clients, most clients will stay within them but
        # some may explicitly request smaller or larger quantums, limited by `floor` and `limit`.
        "default.clock.max-quantum" = "1024";
        "default.clock.min-quantum" = "256";
        # The buffer size to use when no active client (audio source) specifies one.
        "default.clock.quantum" = "1024";
        # Allow an application to explicitly request quantums outside the
        # recommended range, keep the floor somewhat high to avoid xruns.
        "default.clock.quantum-floor" = "64";
        "default.clock.quantum-limit" = "2048";
      };
    };
    wireplumber.extraConfig = {
      "10-wooaudio-wa7-gen2" = {
        "monitor.alsa.rules" = [
          {
            matches = [
              {
                "node.name" =
                  "alsa_output.usb-GuangZhou_FiiO_Electronics_Co._Ltd_FiiO_Q3_FA300009-00.iec958-stereo";
              }
            ];
            actions = [
              {
                update-props = {
                  # Important: unlocks direct output through the DAC at any of its supported
                  # sample rates instead of unnecessarily resampling everything to 48kHz with
                  # the default settings. PipeWire will automatically choose the highest rate
                  # that can currently be played given all audio sources in the graph.
                  "audio.allowed-rates" = "[ 44100 48000 88200 96000 176400 192000 352800 384000 ]";
                };
              }
            ];
          }
        ];
      };
      "99-no-suspend" = {
        "monitor.alsa.rules" = [
          {
            matches = [
              { "node.name" = "~alsa_input.*"; }
              { "node.name" = "~alsa_output.*"; }
            ];
            actions = [
              {
                update-props = {
                  "node.pause-on-idle" = false;
                  "session.suspend-timeout-seconds" = 0;
                };
              }
            ];
          }
        ];
        "monitor.bluez.rules" = [
          {
            matches = [
              { "node.name" = "~bluez_input.*"; }
              { "node.name" = "~bluez_output.*"; }
            ];
            actions = [
              {
                update-props = {
                  "node.pause-on-idle" = false;
                  "session.suspend-timeout-seconds" = 0;
                };
              }
            ];
          }
        ];
      };
    };
  };

  # trenger denne for at waylock skal kunne unlocke
  security.pam.services.waylock = { };

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

  services.greetd = {
    enable = true;
    settings.default_session.command = "${lib.getExe pkgs.tuigreet} -t -g 'Access restricted to authorized personnel only.' --remember --remember-user-session";
  };

  # networking.wg-quick.interfaces.wg0.configFile = "/home/runek/.config/wireguard/wg0.conf";
  # Enable WireGuard
  # networking.wireguard.enable = true;
  # networking.wireguard.interfaces = {
  #     # "wg0" is the network interface name. You can name the interface arbitrarily.
  # wg0 = {
  #       # Determines the IP address and subnet of the client's end of the tunnel interface.
  # ips = [ "10.0.0.22/32" ];
  # listenPort = 51820; # to match firewall allowedUDPPorts (without this wg uses random port numbers)
  #
  #       # Path to the private key file.
  #       #
  #       # Note: The private key can also be included inline via the privateKey option,
  #       # but this makes the private key world-readable; thus, using privateKeyFile is
  #       # recommended.
  #       # privateKey = "";
  # privateKeyFile = "/home/runek/.config/wireguard/private.key";
  #
  # peers = [
  #         # For a client configuration, one peer entry for the server will suffice.
  #
  # {
  #           # Public key of the server (not a file path).
  # publicKey = "rDnFQoUfoisyH+HvIHiiQjeIcGPbXO2ufgYQAhBfKH8=";
  #
  #           # Forward all the traffic via VPN.
  # allowedIPs = [ "0.0.0.0/0" ];
  #           # Or forward only particular subnets
  #           #allowedIPs = [ "10.100.0.1" "91.108.12.0/22" ];
  #
  #           # Set this to the server IP and port.
  # endpoint = "wireguard.kvale.io:51820"; # ToDo: route to endpoint not automatically configured https://wiki.archlinux.org/index.php/WireGuard#Loop_routing https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577
  #
  #           # Send keepalives every 25 seconds. Important to keep NAT tables alive.
  # persistentKeepalive = 25;
  # }
  # ];
  # };
  # };
  #
  # #  programs.waybar = {
  # #    enable = true;
  # #    package = pkgs.waybar;
  # #  };

  # programs.hyprland = {
  #   enable = true;
  #   package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  #   portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
  # };

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

    #må ha med dette for Kitty skal fungere som den skal i ssh sessjoner
    extraConfig = ''
      SetEnv TERM=xterm-256color;
    '';

  };

  #  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
  #   "1password-gui"
  #    "1password"
  #  ];

  #Tailscale
  # services.tailscale.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vscode-langservers-extracted
    blueman
    jaq
    # typstfmt # typst formatter for Helix
    typstyle
    swappy
    #helix
    scrcpy
    # moreutils
    # jq
    bruno
    wl-clipboard
    # wireguard-tools
    # kanskje fjerne firefox
    firefox
    brave
    # librewolf
    # mullvad-browser
    mako
    #fish
    #alacritty
    #hyprland
    #wofi
    slack
    simplex-chat-desktop
    session-desktop
    #zulu
    _1password-cli
    #libreoffice-qt
    poppler-utils # pdf utils
    #waybar
    #starship
    git
    jujutsu # istedenfor git - kanskje
    wl-mirror
    chromium # add this again
    graphviz
    pulsemixer
    ltunify # for å pair unifying receiver
    protonmail-desktop
    #  wget
    gnupg
    sqlite-interactive
    sqlpage
    zoxide
    zellij
    csvlens
    # ente-auth
    rclone # backup til S3
    kanshi
    proton-pass
    bitwarden-desktop
    dust
    xwayland-satellite
    tarsnap
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.runek = {
    isNormalUser = true;
    description = "Rune Kvale";
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
      "docker"
    ];
    packages = with pkgs; [ ];
    shell = pkgs.fish;
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    # nerd-fonts.FiraCode
    # nerd-fonts.DroidSansMono
    # nerd-fonts.Iosevka
  ];
  #  fonts.packages = with pkgs; [
  #    (nerd-fonts.override { fonts = [ "JetBrainsMono" "FiraCode" "DroidSansMono" "Iosevka"]; })
  # ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.niri = {
    enable = true;
  };

  sops.defaultSopsFile = ./secrets.yml;
  sops.age.keyFile = "/var/lib/sops/key";

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
