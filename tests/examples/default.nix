{
  self,
  lib,
  coreutils,
  git,
  nix,
  utils,
  dream2nixWithExternals,
  ...
}: let
  l = lib // builtins;
  examples = ../../examples;
in
  utils.writePureShellScript
  [
    coreutils
    git
    nix
  ]
  ''
    if [ -n "$1" ]; then
      examples=$1
    else
      examples=$(ls ${examples})
    fi

    for dir in $examples; do
      echo -e "\ntesting example for $dir"
      mkdir tmp
      cp ${examples}/$dir/* ./tmp/
      chmod -R +w ./tmp
      cd ./tmp
      nix flake lock --override-input dream2nix ${../../.}
      nix run .#resolveImpure
      nix flake check
      cd -
      rm -r tmp
    done
  ''