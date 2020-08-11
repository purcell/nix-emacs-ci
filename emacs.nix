{ name
, src
, stdenv
, lib
, fetchurl
, ncurses
, autoreconfHook
, pkgconfig
, libxml2
, gettext
, gnutls
, jansson
, gmp
, autoconf ? null
, automake ? null
, texinfo ? null
, withAutoReconf ? false
, patches ? []
, srcRepo ? false
, needCrtDir ? false
}:

let
  latestPackageKeyring = fetchurl {
    url = "https://github.com/emacs-mirror/emacs/raw/master/etc/package-keyring.gpg";
    sha256 = "4a44d6c3a657405892dacf777f03b9267cc74cbc8edad65a88ae8c8929ab1a8d";
  };
in

  # A very minimal version of https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/emacs/default.nix
stdenv.mkDerivation rec {
  inherit name src;

  enableParallelBuilding = true;

  CFLAGS = "-DMAC_OS_X_VERSION_MAX_ALLOWED=101200";

  nativeBuildInputs =
    [ pkgconfig ]
    ++ lib.optionals withAutoReconf [ autoreconfHook ]
    ++ lib.optionals srcRepo [ autoconf automake texinfo ];

  buildInputs =
    [ ncurses libxml2 gnutls gettext jansson gmp ];

  hardeningDisable = [ "format" ];

  inherit patches;

  configureFlags = [
    "--disable-build-details" # for a (more) reproducible build
    "--with-modules"
    "--with-x=no"
    "--with-ns=no"
    "--with-xpm=no"
    "--with-jpeg=no"
    "--with-png=no"
    "--with-gif=no"
    "--with-tiff=no"
  ] ++ lib.optionals needCrtDir [ "--with-crt-dir=${stdenv.glibc}/lib" ];

  preConfigure = ''
    substituteInPlace lisp/international/mule-cmds.el \
      --replace /usr/share/locale ${gettext}/share/locale
    for makefile_in in $(find . -name Makefile.in -print); do
        substituteInPlace $makefile_in --replace /bin/pwd pwd
    done
    substituteInPlace src/Makefile.in --replace 'LC_ALL=C $(RUN_TEMACS)' 'env -i LC_ALL=C $(RUN_TEMACS)'
    if [ -f etc/package-keyring.gpg ]; then
      rm etc/package-keyring.gpg
      ln -s ${latestPackageKeyring} etc/package-keyring.gpg
    fi
  '';

  installTargets = "tags install";

  meta = with stdenv.lib; {
    description = "The extensible, customizable GNU text editor";
    homepage = https://www.gnu.org/software/emacs/;
    license = licenses.gpl3Plus;
    platforms = platforms.all;

    longDescription = ''
      GNU Emacs is an extensible, customizable text editor—and more.  At its
      core is an interpreter for Emacs Lisp, a dialect of the Lisp
      programming language with extensions to support text editing.
      The features of GNU Emacs include: content-sensitive editing modes,
      including syntax coloring, for a wide variety of file types including
      plain text, source code, and HTML; complete built-in documentation,
      including a tutorial for new users; full Unicode support for nearly all
      human languages and their scripts; highly customizable, using Emacs
      Lisp code or a graphical interface; a large number of extensions that
      add other functionality, including a project planner, mail and news
      reader, debugger interface, calendar, and more.  Many of these
      extensions are distributed with GNU Emacs; others are available
      separately.
    '';
  };
}
