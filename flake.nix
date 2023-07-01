{
  description = "Emacs versions for CI";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
    "emacs-23.4" = { url = "https://ftp.gnu.org/gnu/emacs/emacs-23.4.tar.gz"; flake = false; };
    "emacs-24.1" = { url = "https://ftp.gnu.org/gnu/emacs/emacs-24.1.tar.gz"; flake = false; };
    "emacs-24.2" = { url = "https://ftp.gnu.org/gnu/emacs/emacs-24.2.tar.gz"; flake = false; };
    "emacs-24.3" = { url = "https://ftp.gnu.org/gnu/emacs/emacs-24.3.tar.gz"; flake = false; };
    "emacs-24.4" = { url = "https://ftp.gnu.org/gnu/emacs/emacs-24.4.tar.gz"; flake = false; };
    "emacs-24.5" = { url = "https://ftp.gnu.org/gnu/emacs/emacs-24.5.tar.gz"; flake = false; };
    "emacs-25.1" = { url = "https://ftp.gnu.org/gnu/emacs/emacs-25.1.tar.gz"; flake = false; };
    "emacs-25.2" = { url = "https://ftp.gnu.org/gnu/emacs/emacs-25.2.tar.gz"; flake = false; };
    "emacs-25.3" = { url = "https://ftp.gnu.org/gnu/emacs/emacs-25.3.tar.gz"; flake = false; };
    "emacs-26.1" = { url = "https://ftp.gnu.org/gnu/emacs/emacs-26.1.tar.gz"; flake = false; };
    "emacs-26.2" = { url = "https://ftp.gnu.org/gnu/emacs/emacs-26.2.tar.gz"; flake = false; };
    "emacs-26.3" = { url = "https://ftp.gnu.org/gnu/emacs/emacs-26.3.tar.gz"; flake = false; };
    "emacs-27.1" = { url = "https://ftp.gnu.org/gnu/emacs/emacs-27.1.tar.gz"; flake = false; };
    "emacs-27.2" = { url = "https://ftp.gnu.org/gnu/emacs/emacs-27.2.tar.gz"; flake = false; };
    "emacs-28.1" = { url = "https://ftp.gnu.org/gnu/emacs/emacs-28.1.tar.gz"; flake = false; };
    "emacs-28.2" = { url = "https://ftp.gnu.org/gnu/emacs/emacs-28.2.tar.gz"; flake = false; };
    emacs-snapshot = { url = "github:emacs-mirror/emacs"; flake = false; };
    emacs-release-snapshot = { url = "github:emacs-mirror/emacs?ref=emacs-29"; flake = false; };
    macos-unexec-patches = { url = "https://github.com/emacs-mirror/emacs/commit/888ffd960c06d56a409a7ff15b1d930d25c56089.patch"; flake = false; };
    latest-package-keyring = { url = "github:emacs-mirror/emacs?path=/etc/package-keyring.gpg"; flake = false; };
  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      rec {
        overlays.default = self: super: (
          let
            source_for = version: rec {
              inherit version;
              name = "emacs-${version}";
              src = inputs."emacs-${version}";
            };

            latestPackageKeyring = inputs.latest-package-keyring;

            versions = (if super.stdenv.isLinux then {
              # Some versions do not currently build on MacOS, so we do not even
              # expose them on that platform.

              emacs-23-4 = with super; callPackage ./emacs.nix {
                inherit (source_for "23.4") name src version;
                inherit latestPackageKeyring;
                withAutoReconf = false;
                stdenv = if stdenv.cc.isGNU then gcc49Stdenv else stdenv;
                patches = [
                  ./patches/all-dso-handle.patch
                  ./patches/fpending-23.4.patch
                ];
                needCrtDir = true;
              };

              emacs-24-1 = with super; callPackage ./emacs.nix {
                inherit (source_for "24.1") name src version;
                inherit latestPackageKeyring;
                withAutoReconf = false;
                stdenv = if stdenv.cc.isGNU then gcc49Stdenv else stdenv;
                patches = [
                  ./patches/gnutls-e_again-old-emacsen.patch
                  ./patches/all-dso-handle.patch
                  ./patches/remove-old-gets-warning.patch
                  ./patches/fpending-24.1.patch
                ];
              };

              emacs-24-2 = with super; callPackage ./emacs.nix {
                inherit (source_for "24.2") name src version;
                inherit latestPackageKeyring;
                withAutoReconf = false;
                stdenv = if stdenv.cc.isGNU then gcc49Stdenv else stdenv;
                patches = [
                  ./patches/gnutls-e_again-old-emacsen.patch
                  ./patches/all-dso-handle.patch
                  ./patches/fpending-24.1.patch
                ];
              };
            } else { }
            ) // {
              emacs-24-3 = with super; callPackage ./emacs.nix {
                inherit (source_for "24.3") name src version;
                inherit latestPackageKeyring;
                withAutoReconf = false;
                stdenv = if stdenv.cc.isGNU then gcc49Stdenv else stdenv;
                patches = [
                  ./patches/gnutls-e_again.patch
                  ./patches/all-dso-handle.patch
                  ./patches/fpending-24.3.patch
                  inputs.macos-unexec-patches
                ];
                inherit (self.darwin) sigtool;
              };

              emacs-24-4 = with super; callPackage ./emacs.nix {
                inherit (source_for "24.4") name src version;
                inherit latestPackageKeyring;
                withAutoReconf = false;
                stdenv = if stdenv.cc.isGNU then gcc49Stdenv else stdenv;
                patches = [
                  ./patches/gnutls-e_again.patch
                  inputs.macos-unexec-patches
                ];
                inherit (self.darwin) sigtool;
              };

              emacs-24-5 = with super; callPackage ./emacs.nix {
                inherit (source_for "24.5") name src version;
                inherit latestPackageKeyring;
                withAutoReconf = false;
                stdenv = if stdenv.cc.isGNU then gcc49Stdenv else stdenv;
                patches = [
                  ./patches/gnutls-e_again.patch
                  inputs.macos-unexec-patches
                ];
                inherit (self.darwin) sigtool;
              };

              emacs-25-1 = super.callPackage ./emacs.nix {
                inherit (source_for "25.1") name src version;
                inherit latestPackageKeyring;
                patches = [
                  ./patches/gnutls-use-osx-cert-bundle.patch
                  ./patches/gnutls-e_again.patch
                  ./patches/sigsegv-stack.patch
                  inputs.macos-unexec-patches
                ];
                inherit (self.darwin) sigtool;
              };

              emacs-25-2 = super.callPackage ./emacs.nix {
                inherit (source_for "25.2") name src version;
                inherit latestPackageKeyring;
                patches = [
                  ./patches/gnutls-use-osx-cert-bundle.patch
                  ./patches/gnutls-e_again.patch
                  ./patches/sigsegv-stack.patch
                  inputs.macos-unexec-patches
                ];
                inherit (self.darwin) sigtool;
              };

              emacs-25-3 = super.callPackage ./emacs.nix {
                inherit (source_for "25.3") name src version;
                inherit latestPackageKeyring;
                patches = [
                  ./patches/gnutls-use-osx-cert-bundle.patch
                  ./patches/gnutls-e_again.patch
                  ./patches/sigsegv-stack.patch
                  inputs.macos-unexec-patches
                ];
                inherit (self.darwin) sigtool;
              };

              emacs-26-1 = super.callPackage ./emacs.nix {
                inherit (source_for "26.1") name src version;
                inherit latestPackageKeyring;
                patches = [
                  ./patches/gnutls-e_again.patch
                  ./patches/sigsegv-stack.patch
                  inputs.macos-unexec-patches
                ];
                inherit (self.darwin) sigtool;
              };

              emacs-26-2 = super.callPackage ./emacs.nix {
                inherit (source_for "26.2") name src version;
                inherit latestPackageKeyring;
                patches = [
                  ./patches/gnutls-e_again.patch
                  ./patches/sigsegv-stack.patch
                  inputs.macos-unexec-patches
                ];
                inherit (self.darwin) sigtool;
              };

              emacs-26-3 = super.callPackage ./emacs.nix {
                inherit (source_for "26.3") name src version;
                inherit latestPackageKeyring;
                patches = [
                  ./patches/sigsegv-stack.patch
                  inputs.macos-unexec-patches
                ];
                inherit (self.darwin) sigtool;
              };

              emacs-27-1 = super.callPackage ./emacs.nix {
                inherit (source_for "27.1") name src version;
                inherit latestPackageKeyring;
                patches = [
                  ./patches/sigsegv-stack.patch
                ];
                inherit (self.darwin) sigtool;
              };

              emacs-27-2 = super.callPackage ./emacs.nix {
                inherit (source_for "27.2") name src version;
                inherit latestPackageKeyring;
                patches = [
                  ./patches/sigsegv-stack.patch
                ];
                inherit (self.darwin) sigtool;
              };

              emacs-28-1 = super.callPackage ./emacs.nix {
                inherit (source_for "28.1") name src version;
                inherit latestPackageKeyring;
                inherit (self.darwin) sigtool;
              };

              emacs-28-2 = super.callPackage ./emacs.nix {
                inherit (source_for "28.2") name src version;
                inherit latestPackageKeyring;
                inherit (self.darwin) sigtool;
              };

              emacs-release-snapshot = super.callPackage ./emacs.nix {
                inherit (source_for "release-snapshot") name src;
                inherit latestPackageKeyring;
                version = "29.0.60";
                srcRepo = true;
                treeSitter = true;
                inherit (self.darwin) sigtool;
              };

              emacs-snapshot = super.callPackage ./emacs.nix {
                inherit (source_for "snapshot") name src;
                inherit latestPackageKeyring;
                version = "30.0.50";
                srcRepo = true;
                treeSitter = true;
                inherit (self.darwin) sigtool;
              };
            };
          in
          versions // {
            emacs-ci-versions = builtins.attrNames versions;
          }
        );

        packages =
          let pkgs = import nixpkgs { inherit system; overlays = [ overlays.default ]; };
          in
          builtins.listToAttrs
            (builtins.map (a: { name = a; value = builtins.getAttr a pkgs; })
              pkgs.emacs-ci-versions);
      }
    );
}
