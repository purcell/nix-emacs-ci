[![Build Status](https://travis-ci.com/purcell/nix-emacs-ci.png?branch=master)](https://travis-ci.com/purcell/nix-emacs-ci)
<a href="https://www.patreon.com/sanityinc"><img alt="Support me" src="https://img.shields.io/badge/Support%20Me-%F0%9F%92%97-ff69b4.svg"></a>

# Emacs installations for continuous integration

This work-in-progress repo will provide a method for Emacs Lisp
authors to easily test their code against a wide variety of Emacs
versions.

The rationale for this is that [EVM](https://github.com/rejeep/evm)
and Damien Cassou's PPA are both unmaintained and have various issues.

Goals:

- Usable without Nix knowledge
- Clear, simple docs and setup, initially for Travis
- Binary caching if possible, via Cachix
- Both Linux *and* MacOS support
- Minimal installations by default: no images, no `window-system`

## Status

- Official release versions from 24.2 onwards are supported
- Binary caching via Cachix is enabled, and working
- Early Travis integration is tested and [in use
  elsewhere](https://github.com/purcell/emacs.d) but see notes below.

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

For local testing, that mutates your user-level profile, so you
probably don't want to do that.  There'll be a `nix-shell` equivalent
of this, in order to run a command inside a transient environment
containing a specific Emacs, but I haven't figured that out yet.

## Travis usage

Here's some example usage: caution that this early method may change.

```yaml
language: nix

os:
  - linux
  - osx

env:
  - EMACS_VER=emacs-24-5
  - EMACS_VER=emacs-25-3
  - EMACS_VER=emacs-26-3

install:
  - bash <(curl https://raw.githubusercontent.com/purcell/nix-emacs-ci/master/travis-install)
  - nix-env -iA $EMACS_VER -f https://github.com/purcell/nix-emacs-ci/archive/master.tar.gz
  # The default "emacs" executable will now be the named one

script:
  - ... your commands go here ...
```

<hr>


[💝 Support this project and my other Open Source work](https://www.patreon.com/sanityinc)

[💼 LinkedIn profile](https://uk.linkedin.com/in/stevepurcell)

[✍ sanityinc.com](http://www.sanityinc.com/)

[🐦 @sanityinc](https://twitter.com/sanityinc)
