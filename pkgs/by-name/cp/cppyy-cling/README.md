# WIP Packaging cppyy-cling

Currrent status: Not working

```terminal
$ nix-build -E 'with import <nixpkgs> {}; callPackage ./package.nix {}'
...

```terminal
@nix { "action": "setPhase", "phase": "installPhase" }
Running phase: installPhase
Executing pypaInstallPhase
Successfully installed cppyy_cling-6.30.0-py2.py3-none-linux_x86_64.whl
Finished executing pypaInstallPhase

[...]

Executing pythonRemoveTestsDir
Finished executing pythonRemoveTestsDir
Running phase: installCheckPhase
no Makefile or custom installCheckPhase, doing nothing
Running phase: pythonCatchConflictsPhase
Running phase: pythonRemoveBinBytecodePhase
Running phase: pythonImportsCheckPhase
Executing pythonImportsCheckPhase
Check whether the following modules can be imported: cppyy_cling
Traceback (most recent call last):
  File "<string>", line 1, in <module>
  File "<string>", line 1, in <lambda>
  File "/nix/store/gd3shnza1i50zn8zs04fa729ribr88m9-python3-3.11.8/lib/python3.11/importlib/__init__.py", line 126, in import_module
    return _bootstrap._gcd_import(name[level:], package, level)
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "<frozen importlib._bootstrap>", line 1204, in _gcd_import
  File "<frozen importlib._bootstrap>", line 1176, in _find_and_load
  File "<frozen importlib._bootstrap>", line 1140, in _find_and_load_unlocked
ModuleNotFoundError: No module named 'cppyy_cling'
note: keeping build directory '/tmp/nix-build-python3.11-cppyy-cling-6.30.0.drv-6'
error: builder for '/nix/store/kpcsvsvg6bzisig6nsfpda6gx5j3khnh-python3.11-cppyy-cling-6.30.0.drv' failed with exit code 1;
       last 10 log lines:
       > Traceback (most recent call last):
       >   File "<string>", line 1, in <module>
       >   File "<string>", line 1, in <lambda>
       >   File "/nix/store/gd3shnza1i50zn8zs04fa729ribr88m9-python3-3.11.8/lib/python3.11/importlib/__init__.py", line 126, in import_module
       >     return _bootstrap._gcd_import(name[level:], package, level)
       >            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
       >   File "<frozen importlib._bootstrap>", line 1204, in _gcd_import
       >   File "<frozen importlib._bootstrap>", line 1176, in _find_and_load
       >   File "<frozen importlib._bootstrap>", line 1140, in _find_and_load_unlocked
       > ModuleNotFoundError: No module named 'cppyy_cling'
       For full logs, run 'nix-store -l /nix/store/kpcsvsvg6bzisig6nsfpda6gx5j3khnh-python3.11-cppyy-cling-6.30.0.drv'.
```
