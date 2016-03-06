Devopnik Packer Templates
===

Usage:
-----
* copy `build.sh.example` to `build.sh` in same directory
* edit `build.sh` to have the values you want for each provider
* run `$ chmod +x build.sh`
* run `./build.sh`

What you need to set before starting:
-----

You'll need to sign up for an [Atlas account](https://atlas.hashicorp.com), and get the appropriate values set in your build environment (placed in ~/.bashrc or ~/.profile, rather than build.sh, unless you have multiple accounts you are maintaining separately). And a computer that can handle the build process. You'll need to install the various provider backends (installation instructions vary depending on platform/OS).

* virtualbox
* vmware workstation
* qemu

TODO:
----
Building with a json template isn't appealing to the eye and doesn't allow for inline notation (the use of which depends on the philosophy of the developer). Yaml would be more suited to the folding in, and override of any given key pair, and make the configuration file have a smaller footprint. Proposed changes to this repo would be:
* Allow build script to include a yaml-to-json conversion on the fly
* Clean up the json conversion afterwards
* Possibly template the yaml in erb for more flexible configurations
