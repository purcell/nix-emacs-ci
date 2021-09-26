{
  description = "Emacs installations for continuous integration";

  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.pre-commit-hooks = {
    url = "github:cachix/pre-commit-hooks.nix";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.flake-utils.follows = "flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, pre-commit-hooks }:
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
        checks = {
          pre-commit-check = pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              nixpkgs-fmt.enable = true;
              nix-linter.enable = true;
            };
          };
        };
        devShell = pkgs.mkShell {
          inherit (self.checks.${system}.pre-commit-check) shellHook;
        };
      }
    );
}
