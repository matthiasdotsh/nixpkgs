{
  inputs = {
    nixpkgs = { url = "github:nixos/nixpkgs/nixos-unstable"; };
    flake-utils = { url = "github:numtide/flake-utils"; };
  };
  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

      in rec {
        devShell = pkgs.mkShell {
          buildInputs = [
            pkgs.gcc
      	    pkgs.glibcLocales
            pkgs.python311Packages.pip
            pkgs.git
            pkgs.zlib
            pkgs.cmake
          ];
          shellHook = ''
            rm -rf .nix
            mkdir -p .nix

            # Now install your software according to the 'normal' docu
            # https://nixos.wiki/wiki/Python#Emulating_virtualenv_with_nix-shell
            export PIP_PREFIX=$(pwd)/.nix/_build/pip_packages || exit 1
            export PYTHONPATH="$PIP_PREFIX/${pkgs.python311.sitePackages}:$PYTHONPATH" || exit 1
            export PATH="$PIP_PREFIX/bin:$PATH" || exit 1
            unset SOURCE_DATE_EPOCH || exit 1

            pip install setuptools wheel

            # https://cppyy.readthedocs.io/en/latest/repositories.html#building-from-source
            git clone https://github.com/wlav/cppyy-backend.git
            cd cppyy-backend/cling
            python setup.py egg_info
            python create_src_directory.py
            python setup.py bdist_wheel
            python -m pip install dist/cppyy_cling-* --upgrade
            cd ../..

            ##-- # to develop/modify cppyy-cling, consider using the cmake interface.
            ##-- python -m pip install cppyy-cling
            ##-- git clone https://github.com/wlav/cppyy-backend.git
            ##-- cd cppyy-backend/cling
            ##-- python setup.py egg_info
            ##-- python create_src_directory.py
            ##-- mkdir dev
            ##-- cd dev
            ##-- cmake ../src -Wno-dev -DCMAKE_CXX_STANDARD=17 -DLLVM_ENABLE_EH=0 -DLLVM_ENABLE_RTTI=0 -DLLVM_ENABLE_TERMINFO=0 -DLLVM_ENABLE_ASSERTIONS=0 -Dminimal=ON -Druntime_cxxmodules=OFF -Dbuiltin_zlib=ON -Dbuiltin_cling=ON -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_INSTALL_PREFIX=$PIP_PREFIX/${pkgs.python311.sitePackages}/
            ##-- make -j 24 install
            ##-- cd ../../..

            cd cppyy-backend/clingwrapper
            python -m pip install . --upgrade --no-use-pep517 --no-deps
            cd ../..

            git clone https://github.com/wlav/CPyCppyy.git
            cd CPyCppyy
            python -m pip install . --upgrade --no-use-pep517 --no-deps
            mkdir build
            cmake ../CPyCppyy
            make -j 24
            cd ..
            git clone https://github.com/wlav/cppyy.git
            cd cppyy
            python -m pip install . --upgrade --no-deps
            cd ..

            # Validate installation with example from
            # https://cppyy.readthedocs.io/en/latest/starting.html
            export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath [
                pkgs.zlib
            ]}:$LD_LIBRARY_PATH || exit 1
            python test_cppyy.py
          '';
        };
      });
}
