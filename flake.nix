{
  description = "Emacs installations for continuous integration";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        attrs = import ./overlay.nix pkgs pkgs;
        versions = attrs.emacs-ci-versions;
      in
      rec {
        packages = flake-utils.lib.flattenTree (pkgs.lib.listToAttrs (map
          (name: {
            inherit name;
            value = attrs.${name};
          })
          versions));
        defaultPackage = packages.emacs-27-2;
        lib = {
          inherit (attrs) emacs-ci-versions;
        };
      }
    );
}
