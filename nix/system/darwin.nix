{
  pkgs,
  config,
  lib,
  self,
  ...
}:
let
  utils = import ../utils.nix;
in
{
  nix.gc.interval = {
    Weekday = 0;
    Hour = 0;
    Minute = 0;
  };

  environment.systemPackages = with pkgs; [
    home-manager
    mkalias
  ];

  homebrew = {
    enable = true;
    casks = [
      "ghostty"
      "karabiner-elements"
      "nextcloud"
    ];
    brews = [
      "bitwarden-cli"
    ];
    masApps = { };
    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
  };

  system = {
    configurationRevision = self.rev or self.dirtyRev or null;
    defaults = {
      dock = {
        autohide = true;
        persistent-apps = [ ];
        persistent-others = [ ];
        show-recents = false;
        static-only = true;
      };
      finder = {
        _FXShowPosixPathInTitle = true;
        _FXSortFoldersFirst = true;
        AppleShowAllFiles = true;
        AppleShowAllExtensions = true;
        ShowPathbar = true;
        ShowStatusBar = true;
        FXPreferredViewStyle = "clmv";
      };
      loginwindow.GuestEnabled = false;
      NSGlobalDomain = {
        AppleICUForce24HourTime = true;
        AppleInterfaceStyle = "Dark";
        KeyRepeat = 2;
      };
      trackpad = {
        Clicking = true;
        TrackpadThreeFingerDrag = true;
      };
      controlcenter = {
        BatteryShowPercentage = true;
      };
      hitoolbox.AppleFnUsageType = "Show Emoji & Symbols";
    };

    activationScripts.applications.text = utils.mkAppAliasSystem {
      derivationName = "system-applications";
      appsPath = config.environment.systemPackages;
      outputDir = "/Applications/Nix";
      pkgs = pkgs;
      lib = lib;
    };
  };
}
