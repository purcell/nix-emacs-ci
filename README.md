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

- Official release versions from 24.3 onwards are supported
- Binary caching via Cachix is enabled, and working for Linux (but not yet MacOS)
- Early Travis integration is tested and [in use
  elsewhere](https://github.com/purcell/emacs.d) but see notes below.

## Travis usage

Here's some example usage: caution that this early method may change,
and in particular I may provide a shell script that can be piped to
bash, to provide some insurance against future setup changes.

```yaml
language: nix

install:
  # Enable downloadable pre-built binaries stored on cachix
  - nix-env -iA cachix -f https://cachix.org/api/v1/install
  - cachix use emacs-ci
  # Install a specific Emacs version in the nix environment
  # The default "emacs" executable will then be Emacs 25.2
  - nix-env -iA emacs-25-2 -f https://github.com/purcell/nix-emacs-ci/archive/master.tar.gz

script:
  - ... your commands go here ...
```


<hr>


[💝 Support this project and my other Open Source work](https://www.patreon.com/sanityinc)

[💼 LinkedIn profile](https://uk.linkedin.com/in/stevepurcell)

[✍ sanityinc.com](http://www.sanityinc.com/)

[🐦 @sanityinc](https://twitter.com/sanityinc)
