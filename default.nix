let
  nixpkgs-20-03 = import (
    builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/5272327b81ed355bbed5659b8d303cf2979b6953.tar.gz";
      sha256 = "0182ys095dfx02vl2a20j1hz92dx3mfgz2a6fhn31bqlp1wa8hlq";
    }
  ) {};

  pkgs = nixpkgs-20-03;

  release = version: sha256: rec {
    name = "emacs-${version}";
    src = pkgs.fetchurl {
      inherit sha256;
      url = "mirror://gnu/emacs/${name}.tar.gz";
    };
  };

  snapshot = commit: sha256: rec {
    name = "emacs-snapshot-${pkgs.lib.strings.substring 0 8 commit}";
    src = pkgs.fetchurl {
      inherit sha256;
      url = "https://github.com/emacs-mirror/emacs/archive/${commit}.tar.gz";
    };
  };
in
  # Some versions do not currently build on MacOS, so we do not even
  # expose them on that platform.
(
  if pkgs.stdenv.isLinux then {

    emacs-23-4 = with pkgs; callPackage ./emacs.nix {
      inherit (release "23.4" "1fc8x5p38qihg7l6z2b1hjc534lnjb8gqpwgywlwg5s3csg6ymr6") name src;
      withAutoReconf = false;
      stdenv = if stdenv.cc.isGNU then overrideCC stdenv gcc49 else stdenv;
      patches = [
        ./patches/all-dso-handle.patch
        ./patches/fpending-23.4.patch
      ];
      needCrtDir = true;
    };

    emacs-24-1 = with pkgs; callPackage ./emacs.nix {
      inherit (release "24.1" "1awbgkwinpqpzcn841kaw5cszdn8sx6jyfp879a5bff0v78nvlk0") name src;
      withAutoReconf = false;
      stdenv = if stdenv.cc.isGNU then overrideCC stdenv gcc49 else stdenv;
      patches = [
        ./patches/all-dso-handle.patch
        ./patches/remove-old-gets-warning.patch
        ./patches/fpending-24.1.patch
      ];
    };

    emacs-24-2 = with pkgs; callPackage ./emacs.nix {
      inherit (release "24.2" "0mykbg5rzrm2h4805y4nl5vpvwx4xcmp285sbr51sxp1yvgr563d") name src;
      withAutoReconf = false;
      stdenv = if stdenv.cc.isGNU then overrideCC stdenv gcc49 else stdenv;
      patches = [ ./patches/all-dso-handle.patch ./patches/fpending-24.1.patch ];
    };
  } else {}
) // {
  emacs-24-3 = with pkgs; callPackage ./emacs.nix {
    inherit (release "24.3" "0hggksbn9h5gxmmzbgzlc8hgl0c77simn10jhk6njgc10hrcm600") name src;
    withAutoReconf = false;
    stdenv = if stdenv.cc.isGNU then overrideCC stdenv gcc49 else stdenv;
    patches = [ ./patches/all-dso-handle.patch ./patches/fpending-24.3.patch ];
  };

  emacs-24-4 = with pkgs; callPackage ./emacs.nix {
    inherit (release "24.4" "1iicqcijr56r7vxxm3v3qhf69xpxlpq7afbjr6h6bpjsz8d4yg59") name src;
    withAutoReconf = false;
    stdenv = if stdenv.cc.isGNU then overrideCC stdenv gcc49 else stdenv;
    patches = [ ./patches/gnutls-e_again.patch ];
  };

  emacs-24-5 = with pkgs; callPackage ./emacs.nix {
    inherit (release "24.5" "1dn3jx1dph5wr47v97g0fhka9gcpn8pnzys7khp9indj5xiacdr7") name src;
    withAutoReconf = false;
    stdenv = if stdenv.cc.isGNU then overrideCC stdenv gcc49 else stdenv;
    patches = [ ./patches/gnutls-e_again.patch ];
  };

  emacs-25-1 = pkgs.callPackage ./emacs.nix {
    inherit (release "25.1" "0rqw9ama0j5b6l4czqj4wlf21gcxi9s18p8cx6ghxm5l1nwl8cvn") name src;
    withAutoReconf = true;
    patches = [
      ./patches/gnutls-use-osx-cert-bundle.patch
      ./patches/gnutls-e_again.patch
    ];
  };

  emacs-25-2 = pkgs.callPackage ./emacs.nix {
    inherit (release "25.2" "0b9dwx6nxzflaipkgml4snny2c3brgy0py6h05q995y1lrpbsnsh") name src;
    withAutoReconf = true;
    patches = [
      ./patches/gnutls-use-osx-cert-bundle.patch
      ./patches/gnutls-e_again.patch
    ];
  };

  emacs-25-3 = pkgs.callPackage ./emacs.nix {
    inherit (release "25.3" "1jc3g79nrcix0500kiw6hqpql82ajq0xivlip6iaryxn90dnlb7p") name src;
    withAutoReconf = true;
    patches = [
      ./patches/gnutls-use-osx-cert-bundle.patch
      ./patches/gnutls-e_again.patch
    ];
  };

  emacs-26-1 = pkgs.callPackage ./emacs.nix {
    inherit (release "26.1" "18vaqn7y7c39as4bn95yfcabwvqkw6y59xz8g78d1ifdx3aq40vn") name src;
    withAutoReconf = true;
    patches = [ ./patches/gnutls-e_again.patch ];
  };

  emacs-26-2 = pkgs.callPackage ./emacs.nix {
    inherit (release "26.2" "1sxl0bqwl9b62nswxaiqh1xa61f3hng4fmyc69lmadx770mfb6ag") name src;
    withAutoReconf = true;
    patches = [ ./patches/gnutls-e_again.patch ];
  };

  emacs-26-3 = pkgs.callPackage ./emacs.nix {
    inherit (release "26.3" "14bm73758w6ydxlvckfy9nby015p20lh2yvl6pnrjz0k93h4giq9") name src;
    withAutoReconf = true;
  };

  emacs-snapshot = pkgs.callPackage ./emacs.nix {
    inherit (snapshot "23ef804eb55ed7324509b81638c66532344fe523" "1206ip4v3yh5vp5w40qmd4i7cshfmhbkpw00xsaa2yz05fk0nw5s") name src;
    srcRepo = true;
    withAutoReconf = true;
  };
}
