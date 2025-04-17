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

## WSL
```
    nix-shell -p git
    git clone https://github.com/sapp00/dotfiles.git
    cd dotfiles
    sudo nixos-rebuild switch --flake .#WSL
```

## Corporate Proxies
In case you need to deal with corporate proxies on WSL, I can recommend the usage of [px](https://github.com/genotrance/px). In that case, use the #WSL-proxied flake.
Run `px` using `px --username=domain\username` within your Windows terminal. It will then act as an intermediary proxy that forwards requests using your Windows credentials.

## NixOS Iso
```
    nix build .#nixosConfigurations.iso-console.config.system.build.isoImage
```

# Misc

# Credits:
Partially based on https://github.com/TheMaxMur/NixOS-Configuration and https://github.com/wimpysworld/nix-config
