{
  # Bin dependency
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:

    # Package outputs: one for each default system
    (flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
          packageName = "prometheus-proxy";
      in 
      {
        packages.prometheus-proxy = import ./prometheus-proxy.nix { inherit pkgs; };
        defaultPackage = self.packages.${system}.${packageName};
      }
    ))
    //
    # Additional outputs
    {
      # nixOS module output
      nixosModules.prometheus-proxy = {
        imports = [./nixos-module.nix];
      };

      # Overlay
      overlay = final: prev: {
          prometheus-proxy = self.packages.x86_64-linux.prometheus-proxy;
        };
    };
  }
