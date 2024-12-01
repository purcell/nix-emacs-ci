{ lib, emacs, ciEmacs, writeShellApplication }:
let
  canDoPackages = lib.versionAtLeast ciEmacs.version "25.1";
  ciEmacsWithPackages = (emacs.pkgs.overrideScope (_: _: {
    emacs = ciEmacs;
  })).withPackages (
    epkgs: [
      epkgs.compat
    ]
  );
in
writeShellApplication {
  name = "test";
  runtimeInputs = [
    (if canDoPackages then ciEmacsWithPackages else ciEmacs)
  ];
  text = ''
    emacs --version
  '' + lib.optionalString canDoPackages ''
    emacs -batch -q -l compat
    echo "Successfully loaded."
  '' + lib.optionalString (lib.versionAtLeast ciEmacs.version "29") ''
    emacs -batch -q --eval \
      '(if (treesit-available-p)
           (message "treesit is available.")
         (message "treesit is unavailable.")
         (kill-emacs 1))'
  '';
}
