{ buildPythonPackage
, cffi
, fetchPypi
, lib
, libpulseaudio
, numpy
, setuptools
, testers
}:

let
  version = "0.4.3";
  pname = "SoundCard";
in

buildPythonPackage {
  inherit pname version;
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-QQg1UUuhCAmAPLmIfUJw85K1nq82WRW7lFFq8/ix0Dc=";
  };

  patchPhase = ''
    substituteInPlace soundcard/pulseaudio.py \
      --replace "'pulse'" "'${libpulseaudio}/lib/libpulse.so'"
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    cffi
    numpy
  ];

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

