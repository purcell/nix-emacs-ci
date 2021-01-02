{
  description = "Emacs installations for continuous integration";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  inputs.flake-compat = {
    url = "github:edolstra/flake-compat";
    flake = false;
  };

  outputs = { self, nixpkgs, flake-utils, flake-compat }:
    (flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import ./nix { inherit system; };
      in
        {
          packages = import ./packages.nix {
            inherit system;
          };
        })) // { inherit flake-compat; };
}
