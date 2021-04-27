with builtins;
{ pkgs, system }:
  let
    l = p.lib; p = pkgs;

    devshell =
      fetchGit
        { url = "https://github.com/numtide/devshell.git";
          rev = "709fe4d04a9101c9d224ad83f73416dce71baf21";
        };

    mkNakedShell =
      (import
         (devshell + /nix/mkNakedShell.nix)
         { inherit (p) bashInteractive coreutils system writeTextFile; }
      );

    make-path = { env-var, packages, subpath ? "" }:
      ''
      export ${env-var}=${
      if length packages != 0 then
        concatStringsSep ":" (map (pkg: "${pkg}/${subpath}") packages)
        + "\${${env-var}:+:\$${env-var}}"
      else
        "\$${env-var}"
      }'';

    write-set = set: f: concatStringsSep "\n" (l.mapAttrsToList f set);
  in
  { packages ? []
  , aliases ? {}
  , functions ? {}
  , subshell-functions ? {}
  , setup ? ""
  , expand-aliases ? false
  , ...
  }@args:
  mkNakedShell
    ({ name = "shell";
       script =
         p.writeShellScript "shell-script"
           ''
           ${if !expand-aliases then "shopt -u expand_aliases" else ""}

           # add packages to PATH
           ${make-path
               { env-var = "PATH";
                 inherit packages;
                 subpath = "bin";
               }
           }

           # add bash completions
           ${make-path
               { env-var = "XDG_DATA_DIRS";
                 inherit packages;
                 subpath = "share";
               }
           }

           ${write-set aliases (n: v: "alias ${n}=${l.escapeShellArg v}") }

           ${write-set functions
               (n: v:
                  ''
                  ${n}() {
                    ${v}
                  }
                  ''
               )
           }

           ${write-set subshell-functions
               (n: v:
                  ''
                  ${n}() (
                    ${v}
                  )
                  ''
               )
           }

           ${setup}

           ${if !expand-aliases then "shopt -s expand_aliases" else ""}
           '';
     }
     // (if args?meta then { inherit (args) meta; } else {})
     // { passthru = removeAttrs args [ "meta" "packages" "setup" ]; }
    )
