{ emacsAttr
}:
let
  pkgs = import (import ../compat.nix).defaultNix.inputs.nixpkgs { };
  emacs = (import ../default.nix).${emacsAttr};
in
(pkgs.emacsPackagesFor emacs).emacsWithPackages (
  epkgs: [
    epkgs.seq
    epkgs.dash
  ]
)
