# Installation
Enable flakes in the configuration.nix or /etc/nix/nix.conf.
Then clone the repository and run one of the following depending on the system:

```
    nix run .#homeConfigurations.desktop.activationPackage
    nix run .#homeConfigurations.darwin.activationPackage
    nix run .#nixos
```


# Credits:
Partially based on https://github.com/TheMaxMur/NixOS-Configuration and https://github.com/wimpysworld/nix-config
