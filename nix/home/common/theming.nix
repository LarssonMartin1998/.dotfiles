{
  pkgs,
  ...
}:

let
  cursor_name = "Banana-Blue";
  cursor_base_size = 32;

  bananaCursorBlueTarball = pkgs.fetchurl {
    url = "https://github.com/ful1e5/banana-cursor/releases/download/v2.0.0/Banana-Blue.tar.xz";
    sha256 = "sha256-mpTrvgYiMfamMebtytY0bLouSbaP3qEqP8pgCFl+xPQ=";
  };

  banana_cursor_blue = pkgs.stdenv.mkDerivation {
    pname = "banana-cursor-blue";
    version = "2.0.0";
    src = bananaCursorBlueTarball;
    nativeBuildInputs = [ pkgs.xz ];

    dontBuild = true;

    installPhase = ''
      runHook preInstall
      # Define shell variable using Nix interpolation for $out and the outer Nix var cursorName
      local themeInstallDir="$out/share/icons/${cursor_name}"
      mkdir -p "$themeInstallDir"
      # Use the outer Nix var cursorName and the builder's $version shell variable
      echo "Unpacking and installing pre-built theme ${cursor_name} (v$version) to $themeInstallDir"

      if tar -xJf $src --strip-components=1 -C "$themeInstallDir"; then
        echo "Unpacked successfully with --strip-components=1."
      else
        echo "-----------------------------------------------------"
        echo "WARNING: Unpacking with --strip-components=1 failed (archive might not have a single top-level dir)."
        echo "Listing archive contents:"
        tar -tf $src || echo "Failed to list archive contents."
        echo "Attempting unpack without --strip-components=1..."
        rm -rf "$themeInstallDir"; mkdir -p "$themeInstallDir" # Clean and recreate before retry
        if tar -xJf $src -C "$themeInstallDir"; then
           echo "Unpacked successfully without --strip-components=1."
        else
           echo "ERROR: Failed to unpack archive even without --strip-components=1."
           exit 1
        fi
        echo "-----------------------------------------------------"
      fi
      runHook postInstall
    '';

    meta = with pkgs.lib; {
      description = "Banana Cursor Theme (Pre-built Blue variant v2.0.0)";
      homepage = "https://github.com/ful1e5/banana-cursor";
      license = licenses.gpl3Only;
      maintainers = with maintainers; [ eelco ];
      platforms = platforms.linux;
    };
  };

  cursor_package = banana_cursor_blue;

  effective_cursor_size_str = toString cursor_base_size;
in
{
  wayland.windowManager.sway = {
    config = {
      seat = {
        "*" = {
          # Sway uses this for its own cursor and for XWayland applications.
          # It takes the theme name and base size. Sway should scale this based on output settings.
          xcursor_theme = "${cursor_name} ${effective_cursor_size_str}";
        };
      };
    };
  };

  # Home Manager Pointer Configuration
  # This makes the theme available and sets X11/GTK defaults via Home Manager mechanisms.
  home = {
    pointerCursor = {
      name = cursor_name;
      size = cursor_base_size;
      package = cursor_package;
      x11.enable = true;
      gtk.enable = true;
      x11.defaultCursor = "left_ptr";
    };
    packages = with pkgs; [
      (cursor_package)
    ];
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "Nordic";
  };

  gtk = {
    enable = true;
    cursorTheme = {
      name = cursor_name;
      size = cursor_base_size; # GTK applications will use this base size.
      package = cursor_package;
    };
    theme = {
      package = pkgs.nordic;
      name = "Nordic";
    };
  };

  xresources.properties = {
    "Xcursor.theme" = cursor_name;
  };

  home.sessionVariables = {
    XCURSOR_THEME = cursor_name;
  };
}
