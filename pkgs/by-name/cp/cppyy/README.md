# Setup DevShell with Cppyy

```bash
nix develop .
```

Validate installation
`python test_cppyy`

On a nixos system this outputs:
```terminal
1.3.1
```

On a alma9.2 system with nix:

```terminal
<built-in>:8:9: warning: '__CLING__GNUC__' macro redefined [-Wmacro-redefined]
#define __CLING__GNUC__ 13
        ^
<built-in>:460:9: note: previous definition is here
#define __CLING__GNUC__ 9
        ^
<built-in>:9:9: warning: '__CLING__GNUC_MINOR__' macro redefined [-Wmacro-redefined]
#define __CLING__GNUC_MINOR__ 2
        ^
<built-in>:461:9: note: previous definition is here
#define __CLING__GNUC_MINOR__ 3
        ^
1.3.1
```

# References
- https://github.com/NixOS/nixpkgs/issues/267455
- https://cppyy.readthedocs.io/en/latest/repositories.html#building-from-source
- https://cppyy.readthedocs.io/en/latest/starting.html
