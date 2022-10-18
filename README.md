# dolphin-emu-nix

dolphin-emu-nix implements a Nix expression for the Dolphin Gamecube Emulator which is updated every 40 minutes. CI then performs a build, and if this build succeeds, it pushes the results to matthewcroughan.cachix.org which can be used as a Nix substituter.

This flake effectively implements https://dolphin-emu.org/download/ but for Linux.

Inspired by [Colemickens' flake-firefox-nightly](https://github.com/colemickens/flake-firefox-nightly)

## Usage

### via `nix run` for one-time usage

Maybe you just want to enjoy some dolphin netplay with your friends, so need
the latest version of Dolphin, and exactly the same version of Dolphin. All participants should run the following command

- `nix run github:matthewcroughan/dolphin-emu-nix`

### NixOS

To use `dolphin-emu-nix`, add the flake to the inputs of a `flake.nix` and make use of its `packages` attribute. Below is an example of how you might add the dolphin-emu from this flake to your systemPackages if you're using NixOS:

```nix
{
  inputs.dolphin-emu-nix.url = "github:matthewcroughan/dolphin-emu-nix";

  outputs = { self, nixpkgs, dolphin-emu-nix }: {
    nixosConfigurations.my-machine = nixpkgs.lib.nixosSystem {
      modules = [
        {
          environment.systemPackages = [
            dolphin-emu-nix.packages.x86_64-linux.dolphin-emu
          ];
        }
      ];
    };
  };
}
```
