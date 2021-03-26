let
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs { overlays = [ (import ./overlay.nix) ]; };
in
builtins.listToAttrs
  (builtins.map (a: { name = a; value = builtins.getAttr a pkgs; })
    pkgs.emacs-ci-versions)
