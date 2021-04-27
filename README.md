# make-shell
**make-shell** is for those who want something better than `mkShell` for their development environment, without all the extra stuff that comes with [devshell](https://github.com/numtide/devshell).

It currently has:

- Bash completion
- Alias expansion in `setup` (`shellHook`) turned off by default
- A more intuitive API for its purpose
  - `buildInputs` -> `packages`
  - `shellHook` -> `setup`
  - Declare aliases and functions in Nix for easier parsing of the created environment.

This project has numbered branches which you can use in your flake URLs, the number will be bumped up whenever there is a breaking change, so you should aways be safe to upgrade if you don't change that number.

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
, aliases ? {}
, functions ? {}
, subshell-functions ? {}
, setup ? ""
, expand-aliases ? false
}
```
- `packages`: A list of packages whose executables will be added to your `PATH` and whose Bash completions will be loaded.
- `aliases`: A set of aliases which will be available inside the shell.
  ```
  aliases.hello = "echo hello!";
  ```
- `functions`: A set of functions that will be available inside the shell, created with [{}](https://www.gnu.org/software/bash/manual/bash.html#Command-Grouping).
  ```
  functions.echo2 = "echo $@";
  ```
- `subshell-functions`: A set of functions that will be available inside the shell, created with [()](https://www.gnu.org/software/bash/manual/bash.html#Command-Grouping).
  ```
  subshell-functions.see-root = "cd / && ls";
  ```
- `setup`: A string of bash which will be executed when entering the shell.
- `expand-aliases`: Whether or not aliases will be expanded during evaluation of `aliases`, `functions`, `subshell-functions`, and `setup`. The default is `false`, as it makes the environment more consistent across systems.

and returns a derivation to be used by `nix develop` or `nix-shell`.
