{ mkDerivation, base, optparse-applicative, stdenv, text
, unicode-transforms
}:
mkDerivation {
  pname = "hconv";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    base optparse-applicative text unicode-transforms
  ];
  description = "cli tool to normalize unicode input";
  license = stdenv.lib.licenses.bsd3;
}
