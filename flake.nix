{
  description = "A Flake for the Dolphin Gamecube Emulator";
  nixConfig = {
    extra-substituters = [ "https://matthewcroughan.cachix.org" ];
    extra-trusted-public-keys = [ "matthewcroughan.cachix.org-1:fON2C9BdzJlp1qPan4t5AF0xlnx8sB0ghZf8VDo7+e8=" ];
  };
  inputs = {
    dolphin-emu-src = {
      url = "https://github.com/dolphin-emu/dolphin.git";
      type = "git";
      submodules = true;
      flake = false;
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };
  outputs = inputs@{ self, nixpkgs, flake-parts, dolphin-emu-src }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      flake = {
        herculesCI.ciSystems = [ "x86_64-linux" ];
        overlay = final: prev: {
          dolphin-emu = self.packages.${prev.stdenv.hostPlatform.system}.dolphin-emu;
        };
      };
      perSystem = { config, self', inputs', pkgs, system, ... }: {
        packages = rec {
          default = dolphin-emu;
          dolphin-emu = pkgs.dolphinEmuMaster.overrideAttrs (old: {
            meta.mainProgram = "dolphin-emu";
            src = dolphin-emu-src;
            version = dolphin-emu-src.rev;
            cmakeFlags = old.cmakeFlags ++ [
              "-DDOLPHIN_WC_REVISION=${dolphin-emu-src.rev}"
              "-DDOLPHIN_WC_DESCRIBE=${pkgs.lib.substring 0 8 dolphin-emu-src.rev}"
            ];
          });
        };
      };
    };
}
