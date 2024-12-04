# Installation
Enable flakes in the configuration.nix or /etc/nix/nix.conf.
Then clone the repository and run one of the following depending on the system:

## Home-Manager only:
```
    nix run .#homeConfigurations.desktop.activationPackage
    nix run .#homeConfigurations.darwin.activationPackage
```

## NixOS
```
    FLAKE="github:sapp00/dotfiles#devVM"
    DISK_DEVICE=/dev/sda
    sudo nix \
        --extra-experimental-features 'flakes nix-command' \
        run github:nix-community/disko#disko-install -- \
        --flake "$FLAKE" \
        --write-efi-boot-entries \
        --disk main "$DISK_DEVICE"
```

## NixOS Iso
```
    nix build .#nixosConfigurations.iso-console.config.system.build.isoImage
```


# Credits:
Partially based on https://github.com/TheMaxMur/NixOS-Configuration and https://github.com/wimpysworld/nix-config
