# Dotfiles
My personal dotfiles I use as configuration for my machines and servers.
The files are managed using `stow` and `make`.
They are organized into packages.
Each package contains the files required to configure a specific (tool or group of tools) and can be installed separately using `make install-<package>`.
