{ emacsAttr
}:
let
  pkgs = import (import ../nix/sources.nix).nixpkgs { overlays = [ (import ../overlay.nix) ]; };
  emacs = (import ../default.nix).${emacsAttr};
in
(pkgs.emacsPackagesFor emacs).emacsWithPackages (
  epkgs: [
    epkgs.seq
    epkgs.dash
  ]
)
