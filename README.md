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
FLAKE="github:sapp00/dotfiles#dev-vm"
DISK_DEVICE=/dev/sda

# Step 1: Format and mount the target disk
sudo nix \
    --extra-experimental-features 'flakes nix-command' \
    run github:nix-community/disko -- \
    --mode disko \
    --flake "$FLAKE" \
    --disk main "$DISK_DEVICE"
```
Step 2: Install directly onto the mounted target disk
```
# Step 2: Install directly onto the mounted target disk
sudo nixos-install \
    --root /mnt \
    --flake "$FLAKE" \
    --no-root-passwd
```

Step 3: Install EFI boot entries manually
```
sudo bootctl --path=/mnt/boot install
```

### ARM64 (nixos-anywhere):
Requires the `nix.linux-builder` to be enabled on the build machine (see `system/darwin/default.nix`)
for cross-compilation from aarch64-darwin to aarch64-linux.

Step 1: Generate a hashed password (stored on the target only, never in the repo):
```
mkdir -p /tmp/extra-files/etc/passwords
mkpasswd | tr -d '\n' > /tmp/extra-files/etc/passwords/maurice
```

Step 2: Install via nixos-anywhere:
```
nix run github:nix-community/nixos-anywhere -- \
    --extra-files /tmp/extra-files \
    --flake "github:sapp00/dotfiles#dev-vm-arm64" \
    nixos@<target-ip>
```

The password file is written to `/etc/passwords/maurice` on the target and persists across
`nixos-rebuild switch` runs since it is not managed by Nix. To change the password after
install, run `passwd maurice` directly on the machine.

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
