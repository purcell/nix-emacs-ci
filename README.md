[![Build Status](https://travis-ci.com/purcell/nix-emacs-ci.png?branch=master)](https://travis-ci.com/purcell/nix-emacs-ci)
<a href="https://www.patreon.com/sanityinc"><img alt="Support me" src="https://img.shields.io/badge/Support%20Me-%F0%9F%92%97-ff69b4.svg"></a>

# Emacs installations for continuous integration

This project aims to provide a method for Emacs Lisp authors
to easily test their code against a wide variety of Emacs
versions.

The rationale for this is that [EVM](https://github.com/rejeep/evm)
and Damien Cassou's PPA are both unmaintained and have various issues.

## Goals:

- Usable without Nix knowledge
- Clear, simple docs and setup, initially primarily for Travis
- Binary caching, ie. pre-built executables, via
  [Cachix](https://cachix.org/) (a wonderful service!)
- Both Linux *and* MacOS support
- Minimal installations by default, for download speed: no images, no
  `window-system`

## Status

- Official release versions from 24.2 onwards are supported (MacOS:
  24.3 onwards, see [issue
  #4](https://github.com/purcell/nix-emacs-ci/issues/4))
- An Emacs development snapshot build is also available
- Binary caching via Cachix is enabled, and working
- Early Travis integration is tested and in use
  elsewhere (e.g. [my emacs config](https://github.com/purcell/emacs.d)
  and [various other github projects](https://github.com/search?l=&q=nix-emacs-ci+++filename%3A.travis.yml&type=Code))
  but see notes below.

## Travis usage

Here's some example usage: caution that this early method may
change. Early adopters should watch [issue
#6](https://github.com/purcell/nix-emacs-ci/issues/6) to be kept up to
date with changes to the recommended usage method.

Note also that if you want to install packages in your CI build, the
default settings of some Emacs versions require that the packages' GPG
signatures can be verified, so you might also want to install `gpg`
(e.g. via `nix-env -iA gpg -f '<nixpgs>'`) or set
`package-check-signatures` to `nil`.

```yaml
language: nix

os:
  - linux
  - osx

env:
  - EMACS_CI=emacs-24-5
  - EMACS_CI=emacs-25-3
  - EMACS_CI=emacs-26-3
  - EMACS_CI=emacs-snapshot

install:
  # The default "emacs" executable on the $PATH will now be the version named by $EMACS_CI
  - bash <(curl https://raw.githubusercontent.com/purcell/nix-emacs-ci/master/travis-install)

script:
  - ... your commands go here ...
```

## Low-level Nix usage, e.g. for local testing

First, ensure you have `cachix` enabled, to obtain cached binaries:

```
nix-env -iA cachix -f https://cachix.org/api/v1/install
cachix use emacs-ci
```

Then, evaluate one of the `emacs-*` expressions in `default.nix`. You
can do this without first downloading the contents of this repo,
e.g. here's how you would add a specific version to your Nix profile:

```
nix-env -iA emacs-25-2 -f https://github.com/purcell/nix-emacs-ci/archive/master.tar.gz
```

The above command mutates your user-level profile, so you probably
don't want to do that when testing locally. There'll be a `nix-shell`
equivalent of this, in order to run a command inside a transient
environment containing a specific Emacs, but I haven't figured that
out yet.


## Using newer snapshot builds

`snapshot` builds aim to be a relatively recent commit on the Emacs
master branch, and do not automatically give you the very latest Emacs
revision available via Git. That would defeat binary caching, so the
current plan is to periodically update the `-snapshot` builds
manually. Send me a pull request to do this:

- Update the commit named in `default.nix`
- Try `nix-build -A emacs-snapshot`.
- This will fail due to SHA256 checksum mismatch of the downloaded archive,
  so now update that too, and rebuild.
- Now submit the change as a pull request.
- Once merged, we'll all be testing against a newer snapshot
  build.

<hr>


[💝 Support this project and my other Open Source work via Patreon](https://www.patreon.com/sanityinc)

[💼 LinkedIn profile](https://uk.linkedin.com/in/stevepurcell)

[✍ sanityinc.com](http://www.sanityinc.com/)

[🐦 @sanityinc](https://twitter.com/sanityinc)
