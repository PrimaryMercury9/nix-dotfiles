#!/usr/bin/env bash

git clone https://github.com/PrimaryMercury9/nix-dotfiles $HOME/nix-dotfiles

rm -rf $HOME/.config/home-manager
sudo rm -rf /etc/nixos/configuration.nix
sudo rm -rf /etc/nixos/hardware-configuration.nix

ln -s $HOME/nix-dotfiles/home-manager $HOME/.config/home-manager
sudo ln -s $HOME/nix-dotfiles/nix/configuration.nix /etc/nixos/configuration.nix
sudo ln -s $HOME/nix-dotfiles/nix/hardware-configuration.nix /etc/nixos/hardware-configuration.nix
