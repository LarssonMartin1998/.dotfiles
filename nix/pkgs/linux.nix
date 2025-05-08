{
  pkgs,
  config,
  nur,
  ...
}:

let
  pythonEnv = pkgs.python3.withPackages (
    ps: with ps; [
      i3ipc
    ]
  );

  cursorName = "Banana-Blue";
  cursorBaseSize = 32;

  bananaCursorBlueTarball = pkgs.fetchurl {
    url = "https://github.com/ful1e5/banana-cursor/releases/download/v2.0.0/Banana-Blue.tar.xz";
    sha256 = "sha256-mpTrvgYiMfamMebtytY0bLouSbaP3qEqP8pgCFl+xPQ=";
  };

  bananaCursorBlue = pkgs.stdenv.mkDerivation {
    pname = "banana-cursor-blue";
    version = "2.0.0";
    src = bananaCursorBlueTarball;
    nativeBuildInputs = [ pkgs.xz ];

    dontBuild = true;

    installPhase = ''
      runHook preInstall
      # Define shell variable using Nix interpolation for $out and the outer Nix var cursorName
      local themeInstallDir="$out/share/icons/${cursorName}"
      mkdir -p "$themeInstallDir"
      # Use the outer Nix var cursorName and the builder's $version shell variable
      echo "Unpacking and installing pre-built theme ${cursorName} (v$version) to $themeInstallDir"

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
      maintainers = with maintainers; [ eelco ]; # Original nixpkgs maintainer
      platforms = platforms.linux;
    };
  };

  cursorPackage = bananaCursorBlue;

  effectiveCursorSizeStr = toString cursorBaseSize;

  firefox-nordic-theme-src = pkgs.fetchFromGitHub {
    owner = "EliverLara";
    repo = "firefox-nordic-theme";
    rev = "21b79cca716af87b8a2b9e420c0e1d3d08b67414";
    sha256 = "sha256-2xP9tHCmOM35fxFMbABUhHHnefv2sSCwhnYpjbHM/V0=";
  };
in
{
  wayland.windowManager.sway = {
    config = {
      seat = {
        "*" = {
          # Sway uses this for its own cursor and for XWayland applications.
          # It takes the theme name and base size. Sway should scale this based on output settings.
          xcursor_theme = "${cursorName} ${effectiveCursorSizeStr}";
        };
      };
    };
  };

  # Home Manager Pointer Configuration
  # This makes the theme available and sets X11/GTK defaults via Home Manager mechanisms.
  home.pointerCursor = {
    name = cursorName;
    size = cursorBaseSize;
    package = cursorPackage;
    x11.enable = true;
    gtk.enable = true;
    x11.defaultCursor = "left_ptr";
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "Nordic";
  };

  gtk = {
    enable = true;
    cursorTheme = {
      name = cursorName;
      size = cursorBaseSize; # GTK applications will use this base size.
      package = cursorPackage;
    };
    theme = {
      package = pkgs.nordic;
      name = "Nordic";
    };
  };

  xresources.properties = {
    "Xcursor.theme" = cursorName;
  };

  home = {
    sessionVariables = {
      XCURSOR_THEME = cursorName;
    };
    packages = with pkgs; [
      (cursorPackage)
      pythonEnv
      wl-clipboard-rs
      clang
      clang-tools
      gimp3
      ghostty
      mullvad
      thunderbird
      wofi
    ];

    file = {
      ".config/sway".source = config.lib.file.mkOutOfStoreSymlink ../../sway;
      ".config/wofi".source = config.lib.file.mkOutOfStoreSymlink ../../wofi;
      "${config.home.homeDirectory}/.mozilla/firefox/hm-profile-default/chrome/firefox-nordic-theme" = {
        source = firefox-nordic-theme-src;
        recursive = true;
      };
    };
  };

  programs = {
    firefox = {
      enable = true;
      package = pkgs.firefox-wayland;

      policies = {
        "DisableFirefoxStudies" = true;
        "DisableTelemetry" = true;
      };

      profiles = {
        default = {
          isDefault = true;
          name = "DefaultProfile";
          userChrome = ''
            @import "theme/nordic-theme.css";
            @import "theme/hide-single-tab.css";
            @import "theme/matching-autocomplete-width.css";
            @import "theme/system-icons.css";
            @import "theme/symbolic-tab-icons.css";

            @import "customChrome.css";
          '';

          extensions = {
            packages = with nur.repos.rycee.firefox-addons; [
              ublock-origin
              bitwarden
              vimium
              privacy-badger
              clearurls
              darkreader
            ];
          };

          settings = {
            "browser.startup.homepage" = "https://search.nixos.org";
            "browser.shell.checkDefaultBrowser" = false;
            "privacy.resistFingerprinting" = false;
            "dom.security.https_only_mode" = true;
            "browser.tabs.warnOnClose" = false;
            "extensions.pocket.enabled" = false;
            "browser.search.defaultenginename" = "ddg";
            "gfx.webrender.all" = true;
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            "browser.tabs.allow_transparent_browser" = true;
          };

          search = {
            force = true;
            default = "ddg";
            order = [
              "ddg"
              "google"
            ];
            engines = {
              "ddg".metaData = {
                alias = "@d";
                hidden = false;
              };
              "google".metaData = {
                alias = "@g";
                hidden = false;
              };
              "Nix Packages" = {
                urls = [
                  {
                    template = "https://search.nixos.org/packages";
                    params = [
                      {
                        name = "type";
                        value = "packages";
                      }
                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@np" ];
              };
            };
          };
        };
      };
    };
  };
}
