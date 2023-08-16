{ name
, src
, version
, stdenv
, lib
, fetchurl
, glibc
, ncurses
, autoreconfHook
, pkg-config
, libxml2
, gettext
, gnutls
, jansson
, sqlite
, tree-sitter
, withTreeSitter ? lib.versionAtLeast version "29"
, withSQLite3 ? lib.versionAtLeast version "29"
, gmp
, sigtool ? null
, autoconf ? null
, automake ? null
, texinfo ? null
, srcRepo ? false
, latestPackageKeyring
}:

# A very minimal version of https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/emacs/default.nix
stdenv.mkDerivation rec {
  inherit name version src;

  enableParallelBuilding = true;

  nativeBuildInputs =
    [ pkg-config ]
    ++ lib.optionals stdenv.isDarwin [ sigtool ]
    ++ lib.optionals (lib.versionAtLeast version "25.1") [ autoreconfHook texinfo ];

  buildInputs =
    [ ncurses libxml2 gnutls gettext jansson gmp ]
    ++ lib.optional withSQLite3 sqlite
    ++ lib.optional withTreeSitter tree-sitter;

  hardeningDisable = [ "format" ];

  patches =
    lib.optionals ("23.4" == version) [
      ./patches/all-dso-handle.patch
      ./patches/fpending-23.4.patch
    ] ++
    lib.optionals ("24.1" == version) [
      ./patches/gnutls-e_again-old-emacsen.patch
      ./patches/all-dso-handle.patch
      ./patches/remove-old-gets-warning.patch
      ./patches/fpending-24.1.patch
    ] ++
    lib.optionals ("24.2" == version) [
      ./patches/gnutls-e_again-old-emacsen.patch
      ./patches/all-dso-handle.patch
      ./patches/fpending-24.1.patch
    ] ++
    lib.optionals ("24.3" == version) [
      ./patches/all-dso-handle.patch
      ./patches/fpending-24.3.patch
    ] ++
    lib.optionals (lib.versionAtLeast version "24.3" && lib.versionOlder version "26.3") [
      ./patches/gnutls-e_again.patch
    ] ++
    lib.optionals (lib.versionAtLeast version "25.1" && lib.versionOlder version "28.1") [
      ./patches/sigsegv-stack.patch
    ] ++
    lib.optionals (stdenv.isDarwin && lib.versionAtLeast version "25.1" && lib.versionOlder version "26.1") [
      ./patches/gnutls-use-osx-cert-bundle.patch
    ] ++
    lib.optionals (stdenv.isDarwin && lib.versionOlder version "27.1") [
      ./patches/macos-unexec.patch
    ];

  passthru = {
    inherit withTreeSitter;
  };

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
  ] ++ lib.optionals ("23.4" == version) [ "--with-crt-dir=${glibc}/lib" ];

  postPatch = lib.concatStringsSep "\n" [
    (lib.optionalString srcRepo ''
      rm -fr .git
      substituteInPlace lisp/loadup.el \
        --replace '(emacs-repository-get-version)' '"${src.rev}"' \
        --replace '(emacs-repository-get-branch)' '"master"'
    '')

    # Reduce closure size by cleaning the environment of the emacs dumper
    ''
      substituteInPlace src/Makefile.in \
        --replace 'RUN_TEMACS = ./temacs' 'RUN_TEMACS = env -i ./temacs'
    ''

    ''
      substituteInPlace lisp/international/mule-cmds.el \
        --replace /usr/share/locale ${gettext}/share/locale

      for makefile_in in $(find . -name Makefile.in -print); do
          substituteInPlace $makefile_in --replace /bin/pwd pwd
      done
      if [ -f etc/package-keyring.gpg ]; then
        rm etc/package-keyring.gpg
        cp ${latestPackageKeyring} etc/package-keyring.gpg
      fi
    ''
  ];

  installTargets = "tags install";

  # Create site-start.el which is needed by the wrapper
  postInstall = ''
    mkdir -p $out/share/emacs/site-lisp
    touch $out/share/emacs/site-lisp/site-start.el
  '';

  meta = with lib; {
    description = "The extensible, customizable GNU text editor";
    homepage = https://www.gnu.org/software/emacs/;
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    mainProgram = "emacs";

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
