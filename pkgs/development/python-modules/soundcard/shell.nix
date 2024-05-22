{ pkgs ? import ../../../.. { } }:

let
  # Custom version of the SoundCard package
  custom_soundcard = pkgs.python3Packages.soundcard.overrideAttrs (oldAttrs: rec {
    version = "0.4.0";
    src = pkgs.python3Packages.fetchPypi {
      pname = oldAttrs.pname;
      version = version;
      hash = "sha256-fYxPQZm4jugjEwLptbgT6iOk+pVY3MY5bDIBF7BBtZ4=";
    };
  });

in
pkgs.mkShell {
  buildInputs = [
    # (pkgs.python3.withPackages (p: [ custom_soundcard ]))
    (pkgs.python3.withPackages (p: [ p.soundcard ]))
  ];
}
