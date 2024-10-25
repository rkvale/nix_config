#
# This has just become a catch-all for development tools at this point.
#
{pkgs, ...}: let
  fenix = pkgs.inputs.fenix;
  rustPlatform = let
    x = fenix.stable.withComponents ["rustc" "cargo"];
  in
    pkgs.makeRustPlatform {
      rustc = x;
      cargo = x;
    };
  rust = fenix.combine [
    (fenix.latest.withComponents [
      "rustc"
      "cargo"
      "clippy"
      "rustfmt"
      "rust-src"
    ])
    fenix.latest.miri

    # And of course ...
    fenix.rust-analyzer
  ];
in {
  programs = {
    neovim.enable = true;
    neovim.defaultEditor = true;
    fzf.enable = true;
    go.enable = true;
    ripgrep.enable = true;
  };

  # Managing Neovim configuration with Nix is a joke so instead I just copy it.
  # xdg.configFile."nvim" = {
  #   enable = true;
  #   recursive = true;
  #   source = "${inputs.dotfiles}/nvim/.config/nvim";
  # };
  home.packages = with pkgs; [
    # Toolchains
    gcc
    gnumake
    go
    rust
    mold

    # Language servers
    gopls
    lua-language-server
    markdown-oxide # PKM/wiki/notes stuff
    nil # nix
    taplo # TOML

    # Formatters
    alejandra

    # Other
    #(cargo-dist.override {inherit rustPlatform;})
    #(cargo-edit.override {inherit rustPlatform;})
    #(cargo-expand.override {inherit rustPlatform;})
  ];
}
