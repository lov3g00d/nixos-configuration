{ ... }:
{
  home.file.".local/bin/bt-autoconnect" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      sleep 3
      BT_DEVICE="''${BT_HEADPHONES:-50:5E:5C:88:38:93}"
      [ -f ~/.config/bt-headphones ] && BT_DEVICE=$(cat ~/.config/bt-headphones)
      bluetoothctl connect "$BT_DEVICE"
    '';
  };

  home.file."Pictures/screenshots/.keep".text = "";

  # Suppress blueman's tray icon so only the bar's bluetooth widget shows.
  # blueman-manager auto-spawns blueman-applet, whose StatusNotifierItem plugin
  # registers a second bluetooth icon in the tray. Disabling just that plugin
  # drops the icon while keeping the applet (pairing agent, notifications).
  dconf.settings."org/blueman/general".plugin-list = [ "!StatusNotifierItem" ];
}
