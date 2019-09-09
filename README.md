[![Build Status](https://travis-ci.org/purcell/nix-emacs-ci.png?branch=master)](https://travis-ci.org/purcell/nix-emacs-ci)
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




<hr>


[💝 Support this project and my other Open Source work](https://www.patreon.com/sanityinc)

[💼 LinkedIn profile](https://uk.linkedin.com/in/stevepurcell)

[✍ sanityinc.com](http://www.sanityinc.com/)

[🐦 @sanityinc](https://twitter.com/sanityinc)
