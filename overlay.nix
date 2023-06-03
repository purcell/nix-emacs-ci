self: super:
let
  sources = import ./nix/sources.nix { inherit (super) system; };

  source_for = version: rec {
    inherit version;
    name = "emacs-${version}";
    src = sources."emacs-${version}";
  };

  # Vital backport which prevents catastrophic failure during build
  fixMacosUnexecPatches = super.lib.optional super.stdenv.isDarwin (super.fetchpatch {
    url = "https://github.com/emacs-mirror/emacs/commit/888ffd960c06d56a409a7ff15b1d930d25c56089.patch";
    sha256 = "08q3ygdigqwky70r47rcgzlkc5jy82xiq8am5kwwy891wlpl7frw";
  });

  versions = (if super.stdenv.isLinux then {
    # Some versions do not currently build on MacOS, so we do not even
    # expose them on that platform.

    emacs-23-4 = with super; callPackage ./emacs.nix {
      inherit (source_for "23.4") name src version;
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
      withAutoReconf = false;
      stdenv = if stdenv.cc.isGNU then gcc49Stdenv else stdenv;
      patches = [
        ./patches/gnutls-e_again.patch
        ./patches/all-dso-handle.patch
        ./patches/fpending-24.3.patch
      ] ++ fixMacosUnexecPatches;
    };

    emacs-24-4 = with super; callPackage ./emacs.nix {
      inherit (source_for "24.4") name src version;
      withAutoReconf = false;
      stdenv = if stdenv.cc.isGNU then gcc49Stdenv else stdenv;
      patches = [
        ./patches/gnutls-e_again.patch
      ] ++ fixMacosUnexecPatches;
    };

    emacs-24-5 = with super; callPackage ./emacs.nix {
      inherit (source_for "24.5") name src version;
      withAutoReconf = false;
      stdenv = if stdenv.cc.isGNU then gcc49Stdenv else stdenv;
      patches = [ ./patches/gnutls-e_again.patch ] ++ fixMacosUnexecPatches;
    };

    emacs-25-1 = super.callPackage ./emacs.nix {
      inherit (source_for "25.1") name src version;
      withAutoReconf = true;
      patches = [
        ./patches/gnutls-use-osx-cert-bundle.patch
        ./patches/gnutls-e_again.patch
        ./patches/sigsegv-stack.patch
      ] ++ fixMacosUnexecPatches;
    };

    emacs-25-2 = super.callPackage ./emacs.nix {
      inherit (source_for "25.2") name src version;
      withAutoReconf = true;
      patches = [
        ./patches/gnutls-use-osx-cert-bundle.patch
        ./patches/gnutls-e_again.patch
        ./patches/sigsegv-stack.patch
      ] ++ fixMacosUnexecPatches;
    };

    emacs-25-3 = super.callPackage ./emacs.nix {
      inherit (source_for "25.3") name src version;
      withAutoReconf = true;
      patches = [
        ./patches/gnutls-use-osx-cert-bundle.patch
        ./patches/gnutls-e_again.patch
        ./patches/sigsegv-stack.patch
      ] ++ fixMacosUnexecPatches;
    };

    emacs-26-1 = super.callPackage ./emacs.nix {
      inherit (source_for "26.1") name src version;
      withAutoReconf = true;
      patches = [
        ./patches/gnutls-e_again.patch
        ./patches/sigsegv-stack.patch
      ] ++ fixMacosUnexecPatches;
    };

    emacs-26-2 = super.callPackage ./emacs.nix {
      inherit (source_for "26.2") name src version;
      withAutoReconf = true;
      patches = [
        ./patches/gnutls-e_again.patch
        ./patches/sigsegv-stack.patch
      ] ++ fixMacosUnexecPatches;
    };

    emacs-26-3 = super.callPackage ./emacs.nix {
      inherit (source_for "26.3") name src version;
      withAutoReconf = true;
      patches = [
        ./patches/sigsegv-stack.patch
      ] ++ fixMacosUnexecPatches;
    };

    emacs-27-1 = super.callPackage ./emacs.nix {
      inherit (source_for "27.1") name src version;
      withAutoReconf = true;
      patches = [
        ./patches/sigsegv-stack.patch
      ];
    };

    emacs-27-2 = super.callPackage ./emacs.nix {
      inherit (source_for "27.2") name src version;
      withAutoReconf = true;
      patches = [
        ./patches/sigsegv-stack.patch
      ];
    };

    emacs-28-1 = super.callPackage ./emacs.nix {
      inherit (source_for "28.1") name src version;
      withAutoReconf = true;
    };

    emacs-28-2 = super.callPackage ./emacs.nix {
      inherit (source_for "28.2") name src version;
      withAutoReconf = true;
    };

    emacs-release-snapshot = super.callPackage ./emacs.nix {
      inherit (source_for "release-snapshot") name src;
      version = "29.0.60";
      srcRepo = true;
      withAutoReconf = true;
      treeSitter = true;
      inherit (self.darwin) sigtool;
    };

    emacs-snapshot = super.callPackage ./emacs.nix {
      inherit (source_for "snapshot") name src;
      version = "30.0.50";
      srcRepo = true;
      withAutoReconf = true;
      treeSitter = true;
      inherit (self.darwin) sigtool;
    };
  };
in
versions // {
  emacs-ci-versions = builtins.attrNames versions;
}

