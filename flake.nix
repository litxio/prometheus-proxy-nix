{
  # Bin dependency
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:

    (flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
          packageName = "prometheus-proxy";
      in 
      {
        packages.prometheus-proxy = import ./prometheus-proxy.nix { inherit pkgs; };
        defaultPackage = self.packages.${system}.${packageName};
      })) 
      //
      {
        nixosModules.prometheusProxy = {
          imports = [./nixos-module.nix];
          nixpkgs.overlays = [
            (final: prev: {
              prometheus-proxy = self.packages.x86_64-linux.prometheus-proxy;
            })
          ];
        };
      };
  }
