{
  description = "HYPRE";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        packages.default = pkgs.stdenv.mkDerivation {
          name = "hypre";

          src = ./src;

          buildInputs = with pkgs; [
            mpi
          ];

          configureFlags = [
            "--enable-shared"
            "--enable-mpi"
          ];

          preBuild = ''
            makeFlagsArray+=(AR="ar -rcu")
          '';

          installPhase = ''
            runHook preInstall
            mkdir -p $out/{include,lib}
            cp -r hypre/include/* $out/include
            cp -r hypre/lib/* $out/lib
            runHook postInstall
          '';
        };
      }
    );
}
