# WIP Packaging cppyy-cling

Currrent status: Not working

```terminal
$ nix-build -E 'with import <nixpkgs> {}; callPackage ./package.nix {}'
...
[ 12%] Built target obj.clang-tblgen
[ 12%] Building CXX object core/base/CMakeFiles/Base.dir/src/TSysEvtHandler.cxx.o
[ 12%] Building CXX object core/base/CMakeFiles/Base.dir/src/TSystem.cxx.o
[ 12%] Building CXX object interpreter/llvm-project/llvm/utils/TableGen/CMakeFiles/obj.llvm-tblgen.dir/WebAssemblyDisassemblerEmitter.cpp.o
[ 12%] Building CXX object core/meta/CMakeFiles/Meta.dir/src/TGenericClassInfo.cxx.o
/build/source/cling/src/core/base/src/TSystem.cxx:43:10: fatal error: compiledata.h: No such file or directory
   43 | #include "compiledata.h"
      |          ^~~~~~~~~~~~~~~
compilation terminated.
make[2]: *** [core/base/CMakeFiles/Base.dir/build.make:412: core/base/CMakeFiles/Base.dir/src/TSystem.cxx.o] Error 1
make[2]: *** Waiting for unfinished jobs....
[ 12%] Building CXX object core/meta/CMakeFiles/Meta.dir/src/TGlobal.cxx.o
[ 12%] Building CXX object core/meta/CMakeFiles/Meta.dir/src/TInterpreter.cxx.o
[ 12%] Building CXX object core/meta/CMakeFiles/Meta.dir/src/TIsAProxy.cxx.o
[ 12%] Building CXX object interpreter/llvm-project/llvm/utils/TableGen/CMakeFiles/obj.llvm-tblgen.dir/CTagsEmitter.cpp.o
[ 12%] Building CXX object core/meta/CMakeFiles/Meta.dir/src/TListOfDataMembers.cxx.o
[ 12%] Building CXX object core/meta/CMakeFiles/Meta.dir/src/TListOfEnums.cxx.o
[ 12%] Building CXX object core/meta/CMakeFiles/Meta.dir/src/TListOfEnumsWithLock.cxx.o
[ 12%] Building CXX object core/meta/CMakeFiles/Meta.dir/src/TListOfFunctions.cxx.o
[ 12%] Building CXX object core/meta/CMakeFiles/Meta.dir/src/TListOfFunctionTemplates.cxx.o
[ 12%] Building CXX object core/meta/CMakeFiles/Meta.dir/src/TMethod.cxx.o
[ 12%] Building CXX object core/meta/CMakeFiles/Meta.dir/src/TMethodArg.cxx.o
[ 12%] Building CXX object interpreter/llvm-project/llvm/lib/Support/CMakeFiles/LLVMSupport.dir/APInt.cpp.o
[ 12%] Building CXX object core/meta/CMakeFiles/Meta.dir/src/TProtoClass.cxx.o
[ 12%] Building CXX object core/meta/CMakeFiles/Meta.dir/src/TRealData.cxx.o
[ 12%] Building CXX object core/meta/CMakeFiles/Meta.dir/src/TStreamerElement.cxx.o
make[1]: *** [CMakeFiles/Makefile2:28591: core/base/CMakeFiles/Base.dir/all] Error 2
make[1]: *** Waiting for unfinished jobs....
[ 12%] Building CXX object core/meta/CMakeFiles/Meta.dir/src/TVirtualStreamerInfo.cxx.o
...
[ 17%] Built target LLVMSupport
make: *** [Makefile:156: all] Error 2
error: Failed to build cppyy-cling
error: boost::bad_format_string: format-string is ill-formed
```

## Debugging notes

### Regarding `compiledata.h: No such file or directory`

- I get this error on both, Alma9 and nixOS when building package.nix
  - I put some `find . -name 'compiledata.h` in my buildPhase, but no result
- Using the devShell I don't get an error
  ```terminal
  # on alma/nixOS
  $ cd cppyy-backend/cling
  $ find . -name 'compiledata.h'
  $
  $ python setup.py egg_info
  $ find . -name 'compiledata.h'
  $
  $ python create_src_directory.py
  $ find . -name 'compiledata.h'
  $
  $ python setup.py bdist_wheel
  $ find . -name 'compiledata.h'
   ./builddir/include/compiledata.h
   ./builddir/install/cppyy_backend/include/compiledata.h
  ```
  I don't get to this point when using `package.nix` because it fails before
  with  `compiledata.h: No such file or directory`

  Difference between `devShell` and `package.nix`:
  - In `devShell` setup `setuptools` and `wheels` are installed via `pip`.
  - `PYTHONPATH` and `PATH` are modified in `devShell` setup.
  - currently I don't run `nix develop` with `--ignore-environment`


  Plain devShell (same when using `nix-shell --pure`) (no pip at all):
   ```terminal
  # on alma
  $ nix-shell -p gcc glibcLocales python311Packages.setuptools python311Packages.wheel python311Packages.cmake git
  $ git clone https://github.com/wlav/cppyy-backend.git
  $ cd cppyy-backend/cling
  $ python setup.py egg_info
  $ python create_src_directory.py
  $ python setup.py bdist_wheel
  $ find . -name 'compiledata.h'
  ./builddir/include/compiledata.h
  ./builddir/install/cppyy_backend/include/compiledata.h
  ```
  - check setup.py source
    - apply some patch to `setup.py` with additonal print commands
    - `is_manylinux` different for `package.nix` and `devShell`?
      `sed -i '62i\        print('\''!!!!!!!!! is_manylinux !!!!!!!!!!!!'\'')' setup.py`
      - Alma, nix shell: is NOT manylinux
      - not working as part of `buildPhase`
      - It's very hard for me to modify the source code that is used for `package.nix`
      - Applying patches or forking cppyy-backend might be an option
      - Skipping for now...

  - Downloading root is different...
    - When comparing cmd output from `python setup.py bdist_wheel` command it
      looks like the root sources get patched in the `devShell` but not for
      `package.nix`
    - Let's try to copy ROOT tarball to devShell source and see if it still works
      - it still works

  - check `setup.py` code and try to find out when `compiledata.h` is generated

  `package.nix` `python setup.py bdist_wheel` output
  ```terminal
  -- Performing Test found_attribute_always_inline - Success
  -- Performing Test has_found_attribute_noinline
  -- Performing Test has_found_attribute_noinline - Success
  -- Configuring done (13.2s)
  -- Generating done (0.8s)
  -- Build files have been written to: /build/source/cling/builddir
  Now building cppyy-cling and dependencies ...
  [  0%] Generating include/module.modulemap
  ```

  `devShell` `python setup.py bdist_wheel` output
  ```terminal
  -- Performing Test found_attribute_always_inline - Success
  -- Performing Test has_found_attribute_noinline
  -- Performing Test has_found_attribute_noinline - Success
  Running /mnt/Foo/Bar/my_user/nixpkgs/pkgs/by-name/cp/cppyy/cppyy-backend/clin
  g/src/build/unix/compiledata.sh
  Making /mnt/Foo/Bar/my_user/nixpkgs/pkgs/by-name/cp/cppyy/cppyy-backend/cling
  /builddir/include/compiledata.h
  -- Configuring done (14.6s)
  -- Generating done (1.1s)
  -- Build files have been written to: /mnt/Foo/Bar/my_user/nixpkgs/pkgs/by-nam
  e/cp/cppyy/cppyy-backend/cling/builddir
  Now building cppyy-cling and dependencies ...
  [  0%] Copying header /mnt/Foo/Bar/my_user/nixpkgs/pkgs/by-name/cp/cppyy/cppy
  ```
  `compiledata.sh` is not called in `package.nix`

  Difference must be in setup.py between

  ```python
  log.info('Running cmake for cppyy-cling: %s', ' '.join(CMAKE_COMMAND))
  log.info('Now building cppyy-cling and dependencies ...')
  ```

  ```python
        log.info('Running cmake for cppyy-cling: %s', ' '.join(CMAKE_COMMAND))
        if subprocess.call(CMAKE_COMMAND, cwd=builddir) != 0:
            raise DistutilsSetupError('Failed to configure cppyy-cling')
        # ^- should be ok, because there is no error in the log
        # Cmake command package.nix:
        # Running cmake for cppyy-cling:
        # cmake /build/source/cling/src
        # -Wno-dev
        # -DCMAKE_CXX_STANDARD=20
        # -DLLVM_ENABLE_TERMINFO=0
        # -DLLVM_ENABLE_ASSERTIONS=0
        # -Dminimal=ON
        # -Dbuiltin_cling=ON
        # -Druntime_cxxmodules=OFF
        # -Dbuiltin_zlib=ON
        # -DCMAKE_BUILD_TYPE=RelWithDebInfo
        # -DCMAKE_INSTALL_PREFIX=/build/source/cling/builddir/install/cppyy_backend
        #
        # Cmake command for devShell:
        # Running cmake for cppyy-cling:
        # cmake /mnt/FOO/BAR/my_user/nixpkgs/pkgs/by-name/cp/cppyy/cppyy-backend/cling/src
        # -Wno-dev
        # -DCMAKE_CXX_STANDARD=20
        # -DLLVM_ENABLE_TERMINFO=0
        # -DLLVM_ENABLE_ASSERTIONS=0
        # -Dminimal=ON
        # -Dbuiltin_cling=ON
        # -Druntime_cxxmodules=OFF
        # -Dbuiltin_zlib=ON
        # -DCMAKE_BUILD_TYPE=RelWithDebInfo
        # -DCMAKE_INSTALL_PREFIX=/mnt/FOO/BAR/my_user/nixpkgs/pkgs/by-name/cp/cppyy/cppyy-backend/cling/builddir/install/cppyy_backend
        # => only different PREFIX, should be ok.

        # use $MAKE to build if it is defined
        env_make = os.getenv('MAKE')
        if not env_make:
            build_cmd = 'cmake'
            # default to using all available cores (x2 if hyperthreading enabled)
            nprocs = os.getenv("MAKE_NPROCS") or '0'
            try:
                nprocs = int(nprocs)
            except ValueError:
                log.warn("Integer expected for MAKE_NPROCS, but got %s (ignored)", nprocs)
                nprocs = 0
            if nprocs < 1:
                nprocs = multiprocessing.cpu_count()
            build_args = ['--build', '.', '--config', get_build_type(), '--']
            if 'win32' in sys.platform:
                build_args.append('/maxcpucount:' + str(nprocs))
            else:
                build_args.append('-j' + str(nprocs))
        else:
            build_args = env_make.split()
            build_cmd, build_args = build_args[0], build_args[1:]
        log.info('Now building cppyy-cling and dependencies ...')
  ```
  in `package.nix` and `devShell` `$MAKE` is empty (at least before a script is
  executed)

  Looks like we run into this:
  https://github.com/wlav/cppyy-backend/blob/1a5daca5d02c99d80497df3846c7fe1c9006ee5d/cling/src/cmake/modules/RootConfiguration.cmake#L377

### Regarding `interpreter`
In [this ticket](https://github.com/NixOS/nixpkgs/issues/304215) SomeoneSerge mentioned:

> The complicated part is managing their cling bindings, which are downloading others:
> -  https://github.com/wlav/cppyy-backend/blob/1a5daca5d02c99d80497df3846c7fe1c9006ee5d/cling/create_src_directory.py#L91-L96

```python
print('adding src ... ')
if not os.path.exists('src'):
    os.mkdir('src')
fullp = os.path.join(pkgdir, 'interpreter')
dest = os.path.join('src', 'interpreter')
shutil.copytree(fullp, dest)
```
For debugging I added an `ls src/interpreter` to my `buildPhase` (after the `python create_src_directory.py` command.
Output was:

```terminal
CMakeLists.txt  cling  llvm-project
```
So I assume, the interpreter folder is ok.

> - https://github.com/wlav/cppyy-backend/blob/1a5daca5d02c99d80497df3846c7fe1c9006ee5d/cling/src/CMakeLists.txt#L242

No idea.
