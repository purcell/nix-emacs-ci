[![Build Status](https://github.com/purcell/nix-emacs-ci/actions/workflows/test.yml/badge.svg)](https://github.com/purcell/nix-emacs-ci/actions/workflows/test.yml)
<a href="https://www.patreon.com/sanityinc"><img alt="Support me" src="https://img.shields.io/badge/Support%20Me-%F0%9F%92%97-ff69b4.svg"></a>

# Emacs installations for continuous integration and testing

This project uses Nix to provide a wide range of executables for current and past
Emacs versions so Emacs Lisp authors to easily test their code.
It is used most widely as the basis of the popular
[setup-emacs GitHub Action](https://github.com/purcell/setup-emacs).

## Goals:

- Usable without Nix knowledge
- Clear, simple docs and setup, initially primarily for Travis and [Github Actions](https://github.com/purcell/setup-emacs)
- Binary caching, ie. pre-built executables, via
  [Cachix](https://cachix.org/) (a wonderful service!)
- Both Linux *and* MacOS support
- Minimal installations by default, for download speed: no image support, no
  `window-system`
- Allow easy local testing

## Status

- Works for Linux and MacOS (but no binary cache for ARM Linux, sorry)
- Official release versions from 23.4 are supported on Linux; from 24.3 on Intel MacOS; and from 28.1 on ARM (Apple Silicon) MacOS
- Emacs development ("HEAD") and pre-release snapshot builds are also provided
- Binary caching via Cachix is enabled, and working
- A [Github Action](https://github.com/purcell/setup-emacs) is available for easy integration with your workflows
- Travis integration is presumably still working but see notes below.

## Github Actions usage

The [`purcell/setup-emacs` Github
Action](https://github.com/purcell/setup-emacs) is available for easy
integration with your Github workflows.

## Travis usage

While people were still using Travis for open source, integration worked like this:

```yaml
language: nix

os:
  - linux
  - osx

env:
  - EMACS_CI=emacs-24-1
  - EMACS_CI=emacs-24-5
  - EMACS_CI=emacs-25-3
  - EMACS_CI=emacs-26-3
  - EMACS_CI=emacs-27-2
  - EMACS_CI=emacs-snapshot

install:
  # The default "emacs" executable on the $PATH will now be the version named by $EMACS_CI
  - bash <(curl https://raw.githubusercontent.com/purcell/nix-emacs-ci/master/travis-install)

script:
  - ... your commands go here ...
```

This repo no longer actively aims to support Travis.

## Low-level Nix usage, e.g. for local testing

This section assumes you have installed the Nix package manager.

### With Flakes (recommended)

There's a flake definition in this repo so (assuming you have flakes
enabled in your nix installation) you can easily run any given Emacs, e.g. using:

```bash
nix run 'github:purcell/nix-emacs-ci#emacs-28-2' -- -Q
```

(`-Q` flag passed to emacs as an example.)

The flake contains the necessary binary cache config, which you may be
prompted to authorise, or you can just pass the
`--accept-flake-config` argument to `nix run`.

On MacOS with Apple Silicon only comparatively recent
Emacs versions are supported, but with Rosetta installed you can run the various
pre-built cached `x86_64` Emacsen like this:

```bash
nix run --system x86_64-darwin 'github:purcell/nix-emacs-ci#emacs-28-2' -- -Q
```


### Without Flakes

First, ensure you have `cachix` enabled, to obtain cached binaries:

```
nix-env -iA cachix -f https://cachix.org/api/v1/install
cachix use emacs-ci
```

If you want to add the cache address and key to your `substituters`
system-wide, use the details on [the cache
page](https://app.cachix.org/cache/emacs-ci).


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


## About `snapshot` builds

`snapshot` builds aim to be a relatively recent commit on the Emacs
master branch, and does not automatically give you the very latest Emacs
revision available via Git. That would defeat binary caching.

Instead, a scheduled Action runs every week to speculatively update
the version: it requires me to click a couple of things, but most
weeks this should happen.

## What patches are applied to these binaries, and why?

There's a tension between having a CI binary that is easily usable for
the majority of testing purposes, and one that faithfully reproduces
the known broken behaviour of that version in certain
circumstances. Binaries for old Emacs versions "in the wild" will have
been built with various old versions of GNUTLS and other libraries,
and there is no single way to reproduce all their quirks.

For this project, we are doing the least patching that will allow the
older Emacsen to install packages from ELPA over HTTPS using a recent
version of GNUTLS. (While older versions used the `http` ELPA URL
anyway, `cask` uses `https` unconditionally.) This involves applying
patches for the `E_AGAIN` issue that was fixed in 26.3, plus a patch
to let old Emacsen find the system cert store on recent OSX versions.

Additionally, the ELPA package signing key has changed and no longer
matches the public key that was bundled with older Emacs releases
(25.x), which meant that those releases could not now install ELPA
packages with stock settings: `package-check-signatures` needed to be
disabled, or the new public key imported into the user's keychain. To
avoid this issue, we bundle the latest public keys into all builds.

Finally, minor patches are applied as necessary to allow very old
Emacs versions to compile against newer `glibc` versions.

<hr>


[💝 Support this project and my other Open Source work via Patreon](https://www.patreon.com/sanityinc)

[💼 LinkedIn profile](https://uk.linkedin.com/in/stevepurcell)

[✍ sanityinc.com](http://www.sanityinc.com/)
