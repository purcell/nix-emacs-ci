self: super:
let
  sources = super.callPackage ./_sources/generated.nix { };

  snapshot = commit: sha256: rec {
    name = "emacs-snapshot-${super.lib.strings.substring 0 8 commit}";
    src = super.fetchFromGitHub {
      owner = "emacs-mirror";
      repo = "emacs";
      rev = commit;
      inherit sha256;
    };
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
      inherit (sources.emacs-23-4) src version;
      withAutoReconf = false;
      stdenv = if stdenv.cc.isGNU then gcc49Stdenv else stdenv;
      patches = [
        ./patches/all-dso-handle.patch
        ./patches/fpending-23.4.patch
      ];
      needCrtDir = true;
    };

    emacs-24-1 = with super; callPackage ./emacs.nix {
      inherit (sources.emacs-24-1) src version;
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
      inherit (sources.emacs-24-2) src version;
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
      inherit (sources.emacs-24-3) src version;
      withAutoReconf = false;
      stdenv = if stdenv.cc.isGNU then gcc49Stdenv else stdenv;
      patches = [
        ./patches/gnutls-e_again.patch
        ./patches/all-dso-handle.patch
        ./patches/fpending-24.3.patch
      ] ++ fixMacosUnexecPatches;
    };

    emacs-24-4 = with super; callPackage ./emacs.nix {
      inherit (sources.emacs-24-4) src version;
      withAutoReconf = false;
      stdenv = if stdenv.cc.isGNU then gcc49Stdenv else stdenv;
      patches = [
        ./patches/gnutls-e_again.patch
      ] ++ fixMacosUnexecPatches;
    };

    emacs-24-5 = with super; callPackage ./emacs.nix {
      inherit (sources.emacs-24-5) src version;
      withAutoReconf = false;
      stdenv = if stdenv.cc.isGNU then gcc49Stdenv else stdenv;
      patches = [ ./patches/gnutls-e_again.patch ] ++ fixMacosUnexecPatches;
    };

    emacs-25-1 = super.callPackage ./emacs.nix {
      inherit (sources.emacs-25-1) src version;
      withAutoReconf = true;
      patches = [
        ./patches/gnutls-use-osx-cert-bundle.patch
        ./patches/gnutls-e_again.patch
      ] ++ fixMacosUnexecPatches;
    };

    emacs-25-2 = super.callPackage ./emacs.nix {
      inherit (sources.emacs-25-2) src version;
      withAutoReconf = true;
      patches = [
        ./patches/gnutls-use-osx-cert-bundle.patch
        ./patches/gnutls-e_again.patch
      ] ++ fixMacosUnexecPatches;
    };

    emacs-25-3 = super.callPackage ./emacs.nix {
      inherit (sources.emacs-25-3) src version;
      withAutoReconf = true;
      patches = [
        ./patches/gnutls-use-osx-cert-bundle.patch
        ./patches/gnutls-e_again.patch
      ] ++ fixMacosUnexecPatches;
    };

    emacs-26-1 = super.callPackage ./emacs.nix {
      inherit (sources.emacs-26-1) src version;
      withAutoReconf = true;
      patches = [ ./patches/gnutls-e_again.patch ] ++ fixMacosUnexecPatches;
    };

    emacs-26-2 = super.callPackage ./emacs.nix {
      inherit (sources.emacs-26-2) src version;
      withAutoReconf = true;
      patches = [ ./patches/gnutls-e_again.patch ] ++ fixMacosUnexecPatches;
    };

    emacs-26-3 = super.callPackage ./emacs.nix {
      inherit (sources.emacs-26-3) src version;
      withAutoReconf = true;
      patches = fixMacosUnexecPatches;
    };

    emacs-27-1 = super.callPackage ./emacs.nix {
      inherit (sources.emacs-27-1) src version;
      withAutoReconf = true;
    };

    emacs-27-2 = super.callPackage ./emacs.nix {
      inherit (sources.emacs-27-2) src version;
      withAutoReconf = true;
    };

    emacs-snapshot = super.callPackage ./emacs.nix {
      inherit (snapshot "1283e1db9b7750a90472e7d557fdd75fcaff6446" "0m2kjw0h2r0law0l0zfsnh13z1xcwc44a02cphr8d0f0prmx2z9y") name src;
      version = "28.0.50";
      srcRepo = true;
      withAutoReconf = true;
    };
  };
in
versions // { emacs-ci-versions = builtins.attrNames versions; }

