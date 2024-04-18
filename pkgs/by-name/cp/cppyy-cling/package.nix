{ lib
, fetchurl
, fetchFromGitHub
, python311Packages
, fetchPypi
, cmake
, gcc
, glibcLocales
, pkg-config
, git
}:

python311Packages.buildPythonPackage rec {
  pname = "cppyy-cling";
  version = "6.30.0";

  # Version must be in sync with cppyy-backend/cling
  # https://github.com/wlav/cppyy-backend/blob/master/cling/create_src_directory.py#L42
  root_version = "6.30.00";
  format = "setuptools";

  srcs = [
    (fetchFromGitHub {
      owner = "wlav";
      repo = "cppyy-backend";
      rev = "clingwrapper-1.15.2";
      sha256 = "sha256-xX1tx3E+vvKj8lUAdqvKXcGAEAifN8oganlfBco7QQw=";
    })

    # cppyy-backend/cling depends on root
    (fetchurl {
      url = "https://root.cern.ch/download/root_v${root_version}.source.tar.gz";
      hash = "sha256-BZLAZpVM/tQjEpV8nLJRZURWBk/i2Nq9y4gm8cAJnXE=";
    })
  ];
  sourceRoot =".";

  nativeBuildInputs = [
    gcc
    glibcLocales
    python311Packages.setuptools
    python311Packages.wheel
    python311Packages.pip
    python311Packages.cmake
    git
    pkg-config
  ];

  dontUseCmakeConfigure = true;

  buildPhase = ''
    # Copy root tarball to desired location
    # https://github.com/wlav/cppyy-backend/blob/master/cling/create_src_directory.py#L39
    mkdir -p source/cling/releases
    tar czf root_v${root_version}.source.tar.gz root-${root_version}
    cp root_v${root_version}.source.tar.gz source/cling/releases/
    cd source/cling
    python setup.py egg_info
    python create_src_directory.py
    python setup.py bdist_wheel
  '';

  # installPhase = ''
  # '';

  # postFixup = ''
  # '';

  # installCheck = ''
  # '';

  # doCheck = true;
  # pythonImportsCheck = [ "cppyy_cling" ];

  meta = with lib; {
    homepage = "https://github.com/wlav/cppyy-backend/tree/master/cling";
    description = "Automatic, dynamic Python-C++ bindings (backend)";
    license = licenses.bsd3;
    maintainers = with maintainers; [ matthiasdotsh ];
  };
}

