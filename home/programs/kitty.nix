{config, ...}: let
  font = "JetBrainsMono NF";
in {
  programs.kitty = {
    # catppuccin.enable = true;
    settings = {
      confirm_os_window_close = 0;
      enable_audio_bell = false;
      window_padding_width = "0 2";

      input_delay = 0;
      repaint_delay = 6;
      sync_to_monitor = "yes";
      wayland_enable_ime = "no";
    };
    font.name = font;
    font.size = 12.75;
    extraConfig = ''
      bold_font        ${font} Bold
      italic_font      ${font} Italic
      bold_italic_font ${font} Bold Italic

      # https://github.com/ryanoasis/nerd-fonts/wiki/Glyph-Sets-and-Code-Points
      symbol_map U+E5FA-U+E62B ${font}
      # Devicons
      symbol_map U+e700-U+e7c5 ${font}
      # Font Awesome
      symbol_map U+f000-U+f2e0 ${font}
      # Font Awesome Extension
      symbol_map U+e200-U+e2a9 ${font}
      # Material Design Icons
      symbol_map U+f0001-U+f1af0 ${font}
      # Weather
      symbol_map U+e300-U+e3e3 ${font}
      # Octicons
      symbol_map U+f400-U+f532 ${font}
      symbol_map U+2665 ${font}
      symbol_map U+26A1 ${font}
      # [Powerline Symbols]
      symbol_map U+e0a0-U+e0a2 ${font}
      symbol_map U+e0b0-U+e0b3 ${font}
      # Powerline Extra Symbols
      symbol_map U+e0b4-U+e0c8 ${font}
      symbol_map U+e0cc-U+e0d4 ${font}
      symbol_map U+e0a3 ${font}
      symbol_map U+e0ca ${font}
      # IEC Power Symbols
      symbol_map U+23fb-U+23fe ${font}
      symbol_map U+2b58 ${font}
      # Font Logos (Formerly Font Linux)
      symbol_map U+f300-U+f32f ${font}
      # Pomicons
      symbol_map U+e000-U+e00a ${font}
      # Codicons
      symbol_map U+ea60-U+ebeb ${font}
      # Heavy Angle Brackets
      symbol_map U+276c-U+2771 ${font}
      # Box Drawing
      symbol_map U+2500-U+259f ${font}

      clear_all_shortcuts yes

      map ctrl+shift+c copy_to_clipboard
      map ctrl+shift+v paste_from_clipboard
      map ctrl+shift+h show_scrollback
      map ctrl+shift+equal change_font_size current +1.0
      map ctrl+shift+minus change_font_size current -1.0
      map ctrl+shift+0 change_font_size current 0.0
    '';
  };
}
