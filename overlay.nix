{pkgs}: final: prev: { prometheus-proxy = builtins.trace pkgs (import ./prometheus-proxy.nix {inherit pkgs;}) ; }
