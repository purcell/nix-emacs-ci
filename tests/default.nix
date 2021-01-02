{ emacsAttr
}:
let
  inherit ((import (
    let
      lock = builtins.fromJSON (builtins.readFile ../flake.lock);
    in
      fetchTarball {
        url = "https://github.com/edolstra/flake-compat/archive/${lock.nodes.flake-compat.locked.rev}.tar.gz";
        sha256 = lock.nodes.flake-compat.locked.narHash;
      }
  ) {
    src = ../.;
  }
  ).defaultNix.lib.${builtins.currentSystem}) emacsPackagesFor;
  emacs = (import ../default.nix).${emacsAttr};
in
(emacsPackagesFor emacs).emacsWithPackages (
  epkgs: [
    epkgs.seq
    epkgs.dash
  ]
)
