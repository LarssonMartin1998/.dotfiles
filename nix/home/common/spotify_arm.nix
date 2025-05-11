{
  pkgs,
  config,
  lib,
  ...
}:
let
  # User-specific librespot settings
  librespot_device_name = "asahi-nixos-librespot";
  librespot_username = "martymeister98";
  librespot_bitrate = "320";

  # Construct librespot arguments
  librespot_args = ''
    --name ${librespot_device_name}
    --username ${librespot_username}
    --bitrate ${librespot_bitrate}
    --disable-audio-cache
    --initial-volume 50
  '';

  spotify_qt_initial_config = {
    General = {
      check_for_updates = false;
      close_to_tray = false;
      fallback_icons = false;
      native_window = false;
      notify_track_change = false;
      relative_added = true;
      show_changelog = false;
      style = "Fusion";
      style_palette = 2;
      track_list_resize_mode = 0;
      track_numbers = 1;
      tray_album_art = false;
      tray_icon = false;
      tray_light_icon = false;
    };
    Qt = {
      album_shape = 1;
      album_size = 1;
      library_layout = 1;
      mirror_title_bar = false;
      system_title_bar = true;
      toolbar_position = 1;
    };
    Spotify = {
      path = "${pkgs.librespot}/bin/librespot";
      client_arguments = librespot_args;
      always_start = true;
      bitrate = 320;
      disable_discovery = true;
      start_client = true;
    };
  };

  spotify_qt_initial_json = builtins.toJSON spotify_qt_initial_config;
in
{
  home = {
    packages = with pkgs; [
      librespot
      spotify-qt
    ];

    activation.conditionally_create_spotify-qt_config = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
      configFile="${config.home.homeDirectory}/.config/kraxarn/spotify-qt.json"
      configDir="$(dirname "$configFile")"
      if [ ! -f "$configFile" ]; then
        echo "Initial spotify-qt.json not found. Creating with declarative defaults."

        mkdir -p "$configDir"
        printf '%s' '${spotify_qt_initial_json}' > "$configFile"
        echo "Initial spotify-qt.json created at $configFile."
      else
        echo "spotify-qt.json already exists at $configFile. Skipping initial creation."
      fi
    '';
  };
}
