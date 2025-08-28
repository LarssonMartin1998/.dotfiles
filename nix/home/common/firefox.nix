{
  pkgs,
  nur,
  ...
}:
let
  bookmarks_data = [
    [
      "Search NixOS"
      "https://search.nixos.org/"
    ]
    [
      "Github Atlas Engine"
      "https://www.github.com/LarssonMartin1998/atlas.git"
    ]
    [
      "neovim/nvim-lspconfig"
      "https://github.com/neovim/nvim-lspconfig/tree/master/lsp"
    ]
    [
      "YouTube"
      "https://www.youtube.com/"
    ]
    [
      "ChatGPT"
      "https://www.chatgpt.com/"
    ]
  ];

  extensions = with nur.repos.rycee.firefox-addons; [
    ublock-origin
    bitwarden
    vimium
    privacy-badger
    clearurls
    react-devtools
  ];
in
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
        "NoDefaultBookmarks" = false; # Without this, adding bookmarks declaratively doesnt work.
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

          bookmarks = {
            force = true;
            settings = map (entry: {
              name = builtins.elemAt entry 0;
              url = builtins.elemAt entry 1;
            }) bookmarks_data;
          };

          extensions = {
            packages = extensions;
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
