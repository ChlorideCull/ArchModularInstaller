#Modular Arch Installer
This is an Arch installer that follows the upstream KISS principle.
Nothing stops it from being just an Arch installer, but that is what it ships as by default.

#Usage
All `.part.sh` files in `PostInstall` and `PreInstall` is compiled into `install.sh` with `build.sh`.
To use the default, just run `build.sh` and then `install.sh`. Follow the instructions in the script.

If you wish to modify it, add stages that run on the Arch ISO itself in `PreInstall`, and add complimentary stages
that run on the bootstrapped system in `PostInstall`. For available helper functions, see `framework.sh`, most notably
`exportPostInstall` which lets you move variables to the `PostInstall` stage, since `PostInstall` runs in a different
"scope" of sorts.

#License
MIT License, really, since it's not too advanced, and we use this commercially, so why shouldn't you be able to?