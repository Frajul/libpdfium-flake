{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      version = "chromium/6136";
      systems = {
        x86_64-linux = { binary-name = "linux-x64"; hash = "sha256-qVYrX4J2HMczwXs8Sr52KQlz+MZlZIH9fLrvvDSAz60="; };
        aarch64-linux = { binary-name = "linux-arm64"; hash = ""; };
      };
    in
    {
      defaultPackage = builtins.mapAttrs
        (system: { binary-name, hash }:
          let
            pkgs = import nixpkgs { inherit system; };
          in
          pkgs.stdenv.mkDerivation
            {
              name = "libpdfium-${version}";

              src = pkgs.fetchzip {
                url = "https://github.com/bblanchon/pdfium-binaries/releases/download/${version}/pdfium-${binary-name}.tgz";
                stripRoot = false;
                inherit hash;
              };

              installPhase = ''
                mkdir -p $out
                cp $src/lib/libpdfium.so $out
              '';
            }
        )
        systems;
    };
}
