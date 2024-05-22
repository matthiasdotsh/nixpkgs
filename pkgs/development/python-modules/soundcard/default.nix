{ buildPythonPackage
, cffi
, fetchPypi
, lib
, libpulseaudio
, numpy
, setuptools
, testers
}:


buildPythonPackage rec {
  pname = "SoundCard";
  version = "0.4.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-QQg1UUuhCAmAPLmIfUJw85K1nq82WRW7lFFq8/ix0Dc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cffi
    numpy
  ];


  patchPhase = ''
    substituteInPlace soundcard/pulseaudio.py \
      --replace "'pulse'" "'${libpulseaudio}/lib/libpulse.so'"
  '';

  # doesn't work because there are not many soundcards in the
  # sandbox. See VM-test
  #pythonImportsCheck = [ "soundcard" ];

  doCheck = false;

  passthru.tests.vm-with-soundcard = testers.runNixOSTest ./test.nix;

  meta = with lib; {
    description = "A Pure-Python Real-Time Audio Library";
    homepage = "https://soundcard.readthedocs.io";
    changelog = "https://soundcard.readthedocs.io/en/latest/#changelog";
    license = licenses.bsd3;
    maintainers = with maintainers; [ matthiasdotsh ];
  };
}

