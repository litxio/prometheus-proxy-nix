# Following https://git.marvid.fr/scolobb/nix-GINsim/src/branch/master/ginsim.nix
{pkgs}: 
pkgs.stdenv.mkDerivation rec {
  name = "${packageName}";
  version = "1.11.0";
  jre = pkgs.jre;

  src = pkgs.fetchurl {
    url = "https://github.com/pambrose/prometheus-proxy/releases/download/${version}/prometheus-proxy.jar";
    sha256 = "sha256-+69uwbAlkEptMlnIvY2D/BhhauexNFHGVwh1r6LYvdE=";
    };

    dontUnpack = true;

    nativeBuildInputs = [ pkgs.makeWrapper ];

    installPhase = ''
            mkdir -pv $out/share/java $out/bin
            cp ${src} $out/share/java/${name}-${version}.jar
            makeWrapper ${jre}/bin/java $out/bin/prometheus-proxy \
            --add-flags "-jar $out/share/java/${name}-${version}.jar" \
    '';
  };

