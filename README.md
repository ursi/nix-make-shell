# make-shell
**make-shell** is for those who want something better than `mkShell` for their development environment, without all the extra stuff that comes with [devshell](https://github.com/numtide/devshell).

It currently has:

- Bash completion
- Alias expansion in `setup` (`shellHook`) turned off by default
- A more intuitive API for its purpose

## Documentation
### default.nix
`default.nix` contains a function that takes the following arguments:
```
{ pkgs, system }
```
and returns the `make-shell` function.

### make-shell
`make-shell` takes the following arguments:
```
{ packages ? []
, setup ? ""
, expand-aliases ? false
}
```
- `packages`: A list of packages who executables will be added to your `PATH` and whose Bash completions will be loaded.
- `setup`: A string of bash which will be executed when entering the shell.
- `expand-aliases`: Whether or not aliases will be expanded during evaluation of `setup`. The default is `false`, as it makes `setup` more likely to execute the same across systems.

and returns a derivation to be used by `nix develop` or `nix-shell`.
