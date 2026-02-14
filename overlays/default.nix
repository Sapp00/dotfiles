# This file defines overlays
{ inputs, ... }:
{
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs final.pkgs;

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = _final: prev: {
    # TODO: upgrade-hint; Remove this for >= 24.11
    openasar = prev.openasar.overrideAttrs (_old: rec {
      pname = "openasar";
      version = "0-unstable-2024-09-06";
      src = prev.fetchFromGitHub {
        owner = "GooseMod";
        repo = "OpenAsar";
        rev = "f92ee8c3dc6b6ff9829f69a1339e0f82a877929c";
        hash = "sha256-V2oZ0mQbX+DHDZfTj8sV4XS6r9NOmJYHvYOGK6X/+HU=";
      };
    });

    hyprland = prev.hyprland.overrideAttrs (_old: rec {
      postPatch = _old.postPatch + ''
        sed -i 's|Exec=Hyprland|Exec=hypr-launch|' example/hyprland.desktop
      '';
    });
  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit (final) system;
      config.allowUnfree = true;
    };
  };
}
