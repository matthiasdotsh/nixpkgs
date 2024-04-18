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
