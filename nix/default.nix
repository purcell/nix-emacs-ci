{
  system ? builtins.currentSystem,
  sources ? import ./sources.nix
}:
import sources.nixpkgs {
  inherit system;
}
