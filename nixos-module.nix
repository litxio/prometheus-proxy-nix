# See https://nixos.wiki/wiki/Module
{config, pkgs, lib, ...}: 
let cfg = config.services.prometheusProxy;
in
  with lib;
  {
    options = {
      services.prometheusProxy = {
        enable = mkOption {
          default = false;
          type = with types; bool;
          description = ''
           Run prometheus proxy
          '';
        };

        port = mkOption {
          default = 8080;
          type = with types; int;
          description = ''
           Port on which Prometheus proxy listens
          '';
        };
      };
    };

    config = lib.mkIf cfg.enable {
      systemd.services.prometheusProxy = {
        wantedBy = [ "multi-user.target" ]; 
        after = [ "network.target" ];
        description = "Start prometheus-proxy";
        serviceConfig = {
          Type = "exec";
         # User = "${cfg.user}";
         ExecStart = ''${pkgs.prometheus-proxy}/bin/prometheus-proxy -p ${cfg.port}'';         
       };
     };

     #environment.systemPackages = [ pkgs.screen ];
   };
 }
