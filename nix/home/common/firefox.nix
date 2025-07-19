{
  pkgs,
  nur,
  ...
}:
{
  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_USE_XINPUT2 = "1";
  };

  programs = {
    firefox = {
      enable = true;

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
              react-devtools
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
