{
  description = "SDR++";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";

    sdrpp.url = "github:AlexandreRouma/SDRPlusPlus";
    sdrpp.flake = false;
  };
  outputs = inputs @ { self, ... }:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.flake-parts.flakeModules.easyOverlay
      ];

      systems = [ "aarch64-darwin" "aarch64-linux" "x86_64-linux" ];

      perSystem = { self', system, pkgs, lib, config, inputs', ... }: {
        overlayAttrs = {
          inherit (config.packages) my-package;
        };
        packages.sdrpp = pkgs.callPackage ./sdrpp.nix { src = inputs.sdrpp; inherit (pkgs.darwin.apple_sdk.frameworks) AppKit; };
        packages.default = config.packages.sdrpp;
      };
    };
}
