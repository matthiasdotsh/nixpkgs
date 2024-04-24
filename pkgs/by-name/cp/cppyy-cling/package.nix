{ lib
, fetchurl
, fetchFromGitHub
, python3Packages
, fetchPypi
, cmake
, gcc
, glibcLocales
, pkg-config
, git
}:

python3Packages.buildPythonPackage rec {
  pname = "cppyy-cling";
  version = "6.30.0";

  # Version must be in sync with cppyy-backend/cling
  # https://github.com/wlav/cppyy-backend/blob/master/cling/create_src_directory.py#L42
  root_version = "6.30.00";
  format = "setuptools";

  srcs = [
    (fetchFromGitHub {
      owner = "matthiasdotsh";
      repo = "cppyy-backend";
      rev = "6d8d277bc9bd06bf8ea65bb8c1d74ef023b5fb8a";
      sha256 = "sha256-vm/tpYUXLyuFD2FqpjcDORfzfNmPT3HRWjvM7hVTvgg=";
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
    python3Packages.setuptools
    python3Packages.wheel
    python3Packages.pip
    python3Packages.cmake
    git
    pkg-config
    ];

  propagatedBuildInputs = [
    gcc
    glibcLocales
    python3Packages.setuptools
    python3Packages.wheel
    python3Packages.pip
    python3Packages.cmake
    git
    pkg-config
  ];


  # unpackPhase = ''
  # '';

  patchPhase = ''
    # Copy root tarball to desired location
    # https://github.com/wlav/cppyy-backend/blob/master/cling/create_src_directory.py#L39
    mkdir -p source/cling/releases
    tar czf root_v${root_version}.source.tar.gz root-${root_version}
    cp root_v${root_version}.source.tar.gz source/cling/releases/
    cd source/cling
    python setup.py egg_info
    python create_src_directory.py
  '';

  dontUseCmakeConfigure = true;
  # configurePhase = ''
  # '';

  # buildPhase = ''
  #   python setup.py bdist_wheel
  # '';

  #installPhase = ''
  #   pip install dist/cppyy_cling-*
  #'';

  # postFixup = ''
  # '';

  # In the installCheck phase, ${python.interpreter} setup.py test is ran.
  # installCheck = ''
  # ';

  ##-- doCheck = true;
  pythonImportsCheck = [ "cppyy_cling" ];

  meta = with lib; {
    homepage = "https://github.com/wlav/cppyy-backend/tree/master/cling";
    description = "Automatic, dynamic Python-C++ bindings (backend)";
    license = licenses.bsd3;
    maintainers = with maintainers; [ matthiasdotsh ];
  };
}

