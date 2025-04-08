{
  description = "Emacs versions for CI";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    "emacs-23-4" = {
      url = "https://ftp.gnu.org/gnu/emacs/emacs-23.4.tar.bz2";
      flake = false;
    };
    "emacs-24-1" = {
      url = "https://ftp.gnu.org/gnu/emacs/emacs-24.1.tar.bz2";
      flake = false;
    };
    "emacs-24-2" = {
      url = "https://ftp.gnu.org/gnu/emacs/emacs-24.2.tar.xz";
      flake = false;
    };
    "emacs-24-3" = {
      url = "https://ftp.gnu.org/gnu/emacs/emacs-24.3.tar.xz";
      flake = false;
    };
    "emacs-24-4" = {
      url = "https://ftp.gnu.org/gnu/emacs/emacs-24.4.tar.xz";
      flake = false;
    };
    "emacs-24-5" = {
      url = "https://ftp.gnu.org/gnu/emacs/emacs-24.5.tar.xz";
      flake = false;
    };
    "emacs-25-1" = {
      url = "https://ftp.gnu.org/gnu/emacs/emacs-25.1.tar.xz";
      flake = false;
    };
    "emacs-25-2" = {
      url = "https://ftp.gnu.org/gnu/emacs/emacs-25.2.tar.xz";
      flake = false;
    };
    "emacs-25-3" = {
      url = "https://ftp.gnu.org/gnu/emacs/emacs-25.3.tar.xz";
      flake = false;
    };
    "emacs-26-1" = {
      url = "https://ftp.gnu.org/gnu/emacs/emacs-26.1.tar.xz";
      flake = false;
    };
    "emacs-26-2" = {
      url = "https://ftp.gnu.org/gnu/emacs/emacs-26.2.tar.xz";
      flake = false;
    };
    "emacs-26-3" = {
      url = "https://ftp.gnu.org/gnu/emacs/emacs-26.3.tar.xz";
      flake = false;
    };
    "emacs-27-1" = {
      url = "https://ftp.gnu.org/gnu/emacs/emacs-27.1.tar.xz";
      flake = false;
    };
    "emacs-27-2" = {
      url = "https://ftp.gnu.org/gnu/emacs/emacs-27.2.tar.xz";
      flake = false;
    };
    "emacs-28-1" = {
      url = "https://ftp.gnu.org/gnu/emacs/emacs-28.1.tar.xz";
      flake = false;
    };
    "emacs-28-2" = {
      url = "https://ftp.gnu.org/gnu/emacs/emacs-28.2.tar.xz";
      flake = false;
    };
    "emacs-29-1" = {
      url = "https://ftp.gnu.org/gnu/emacs/emacs-29.1.tar.xz";
      flake = false;
    };
    "emacs-29-2" = {
      url = "https://ftp.gnu.org/gnu/emacs/emacs-29.2.tar.xz";
      flake = false;
    };
    "emacs-29-3" = {
      url = "https://ftp.gnu.org/gnu/emacs/emacs-29.3.tar.xz";
      flake = false;
    };
    "emacs-29-4" = {
      url = "https://ftp.gnu.org/gnu/emacs/emacs-29.4.tar.xz";
      flake = false;
    };
    "emacs-30-1" = {
      url = "https://ftp.gnu.org/gnu/emacs/emacs-30.1.tar.xz";
      flake = false;
    };
    emacs-snapshot = {
      url = "github:emacs-mirror/emacs";
      flake = false;
    };
    emacs-release-snapshot = {
      url = "github:emacs-mirror/emacs?ref=emacs-30";
      flake = false;
    };
  };

  nixConfig = {
    extra-substituters = "https://emacs-ci.cachix.org";
    extra-trusted-public-keys =
      "emacs-ci.cachix.org-1:B5FVOrxhXXrOL0S+tQ7USrhjMT5iOPH+QN9q0NItom4=";
  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs: {
    packages = nixpkgs.lib.genAttrs [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ] (system:
      let
        inherit (nixpkgs) lib;
        pkgs = nixpkgs.legacyPackages.${system};
        versions =
          # Some versions do not currently build on MacOS, so we do not even
          # expose them on that platform.
          (lib.optionalAttrs pkgs.stdenv.isLinux {
            emacs-23-4 = "23.4";
            emacs-24-1 = "24.1";
            emacs-24-2 = "24.2";
          }) // (lib.optionalAttrs (system != "aarch64-darwin") {
            emacs-24-3 = "24.3";
            emacs-24-4 = "24.4";
            emacs-24-5 = "24.5";
            emacs-25-1 = "25.1";
            emacs-25-2 = "25.2";
            emacs-25-3 = "25.3";
            emacs-26-1 = "26.1";
            emacs-26-2 = "26.2";
            emacs-26-3 = "26.3";
            emacs-27-1 = "27.1";
            emacs-27-2 = "27.2";
          }) // {
            emacs-28-1 = "28.1";
            emacs-28-2 = "28.2";
            emacs-29-1 = "29.1";
            emacs-29-2 = "29.2";
            emacs-29-3 = "29.3";
            emacs-29-4 = "29.4";
            emacs-30-1 = "30.1";
            emacs-release-snapshot = "30.1.50";
            emacs-snapshot = "31.0.50";
          };
      in builtins.mapAttrs (name: version:
        pkgs.callPackage ./emacs.nix {
          inherit name version;
          inherit (pkgs.darwin) sigtool;
          src = inputs.${name};
          latestPackageKeyring = inputs.emacs-snapshot
            + "/etc/package-keyring.gpg";
          srcRepo = lib.strings.hasInfix "snapshot" version;
        }) versions);

    checks = builtins.mapAttrs (system:
      builtins.mapAttrs (_name: ciEmacs:
        nixpkgs.legacyPackages.${system}.callPackage ./tests {
          inherit ciEmacs;
        })) self.packages;

    githubActions = let
      inherit (builtins)
        attrValues mapAttrs attrNames map concatLists intersectAttrs;
      platforms = {
        "x86_64-linux" = "ubuntu-latest";
        "aarch64-linux" = "ubuntu-24.04-arm";
        "x86_64-darwin" = "macos-latest";
        "aarch64-darwin" = "macos-latest";
      };
    in rec {
      checks = intersectAttrs platforms self.checks;
      matrix.include = concatLists (attrValues (mapAttrs (system: pkgs:
        map (pkg: {
          inherit system;
          attr = pkg;
          os = platforms.${system};
        }) (attrNames pkgs)) checks));
    };
  };
}
