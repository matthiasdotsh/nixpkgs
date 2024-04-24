with (import /home/ms/git/nixpkgs {});
mkShell {
  buildInputs = [
    (python3.withPackages (p: [ p.soundcard ]))
  ];
}

