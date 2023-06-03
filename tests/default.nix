{emacsAttr ? null}: let
  pkgs = import (import ../nix/sources.nix).nixpkgs {
    overlays = [(import ../overlay.nix)];
  };
  emacs =
    if emacsAttr == null
    then pkgs.emacs
    else (import ../default.nix).${emacsAttr};
in
  pkgs.writeShellApplication {
    name = "test";
    runtimeInputs = [
      ((pkgs.emacs.pkgs.overrideScope' (_: _: {
          inherit emacs;
        }))
        .withPackages (
          epkgs: [
            epkgs.seq
            epkgs.dash
          ]
        ))
    ];
    text = ''
      emacs --version
      emacs -batch -q -l seq -l dash
      echo "Successfully loaded."
    '';
  }
