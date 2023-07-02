{ emacsAttr ? null }:
let
  flake = builtins.getFlake (toString ../.);
  pkgs = import flake.inputs.nixpkgs { };
  emacs =
    if emacsAttr == null
    then pkgs.emacs
    else flake.packages.${builtins.currentSystem}.${emacsAttr};
in
pkgs.writeShellApplication {
  name = "test";
  runtimeInputs = [
    ((pkgs.emacs.pkgs.overrideScope' (_: _: {
      inherit emacs;
    })).withPackages (
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
