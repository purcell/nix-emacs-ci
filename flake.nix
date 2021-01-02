{
  description = "Emacs installations for continuous integration";

  inputs.nixpkgs.url = "github:nixos/nixpkgs?rev=3d3c07026e365658b59d6215ebcb1b5e61757d0a";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  inputs.flake-compat = {
    url = "github:edolstra/flake-compat";
    flake = false;
  };

  outputs = { self, nixpkgs, flake-utils, flake-compat }:
    (flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
        rec {
          packages = import ./packages.nix {
            inherit system pkgs;
          };
        })) // { inherit flake-compat; };
}
