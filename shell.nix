{ nixpkgs ? import <nixpkgs> {}, compiler ? "default" }:
let
  hsPkgs = with nixpkgs.pkgs; if compiler == "default" then haskellPackages else haskell.packages.${compiler};
  project = import ./default.nix { inherit nixpkgs compiler; };
in
  with nixpkgs.pkgs; stdenv.mkDerivation {
    name = "shell";
    buildInputs = project.env.nativeBuildInputs ++ (with hsPkgs; [
      cabal-install
      ormolu
      cabal-fmt
    ]);
  }

