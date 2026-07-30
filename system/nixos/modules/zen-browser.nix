{ lib, pkgs, inputs, isWorkstation, ... }:

let
  system = pkgs.stdenv.hostPlatform.system;

  extension = shortId: guid: {
    name = guid;
    value = {
      install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
      installation_mode = "normal_installed";
    };
  };

  extensions = [
    (extension "ublock-origin" "uBlock0@raymondhill.net")
    (extension "bitwarden-password-manager" "{446900e4-71c2-419f-a6a7-df9c091e268b}")
  ];

  zen-browser = pkgs.wrapFirefox
    inputs.zen-browser.packages.${system}.zen-browser-unwrapped
    {
      extraPrefs = lib.concatLines (
        lib.mapAttrsToList (
          name: value: ''lockPref(${lib.strings.toJSON name}, ${lib.strings.toJSON value});''
        ) {
          "extensions.autoDisableScopes" = 0;
          "extensions.pocket.enabled" = false;
        }
      );

      extraPolicies = {
        DisableTelemetry = true;
        ExtensionSettings = builtins.listToAttrs extensions;
        SearchEngines = {
          Default = "ddg";
        };
      };
    };
in

lib.mkIf (isWorkstation && pkgs.stdenv.isLinux) {
  environment.systemPackages = [ zen-browser ];
}
