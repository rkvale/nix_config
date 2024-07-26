{
  programs.alacritty.enable = true;
  programs.alacritty.settings = {
    ipc_socket = false;
    window = {
      padding.x = 2;
      padding.y = 0;
      decorations = "None";
      dynamic_title = true;
    };
    font.normal.family = "JetBrainsMono NF";
    font.size = 12.75;

    # Just passthroughs.
    keyboard.bindings = [
      {
        chars = "\\u001B[70;5u";
        key = "F";
        mods = "Control|Shift";
      }
      {
        chars = "/";
        key = "Key7";
        mods = "Control";
      }
    ];
  };
}

