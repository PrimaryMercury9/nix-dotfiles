{ config, pkgs, ... }:

let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
  doom-emacs = pkgs.callPackage (builtins.fetchTarball {
    url = https://github.com/nix-community/nix-doom-emacs/archive/master.tar.gz;
  }) {
    doomPrivateDir = ~/.config/doom;  # Directory containing your config.el, init.el
                                # and packages.el files
  };
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "jpm";
  home.homeDirectory = "/home/jpm";

  # You should not change this value, even if you update Home Manager.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # Allow non-free
  nixpkgs.config.allowUnfree = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    #unstable
    unstable.logseq
    unstable.obsidian
    unstable.yambar
    
    #stable
    cargo
    catppuccin-cursors.mochaDark
    catppuccin-gtk
    ccls
    ctags
    curl
    dconf
    dmenu
    dracula-icon-theme
    dracula-theme
    fd
    feh
    ffmpeg
    firefox
    gcc
    gnome.adwaita-icon-theme
    gnumake
    grim
    htop
    killall
    kitty
    lsof
    marksman
    meslo-lgs-nf
    mpv
    mpvpaper
    neofetch
    rnix-lsp #nix lsp for nvim
    nitch
    nodejs
    notion-app-enhanced
    pamixer
    pciutils
    pkgsCross.avr.buildPackages.gcc
    pfetch
    python3
    pyright
    qmk
    qutebrowser
    ripgrep
    slurp
    speedtest-cli
    sway
    swaybg
    swaylock
    swayidle
    texlive.combined.scheme-full
    tldr
    tmux
    unzip
    wev
    wget
    wofi
    yt-dlp
    zathura

    (buildEnv {
      name = "my-scripts"; 
      paths = [ ~/nix-dotfiles/scripts ]; 
    }) 

    (waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
    })
    )

    (writeShellScriptBin "sonarr" ''
      qutebrowser 10.0.0.200:8989
    '')

    (writeShellScriptBin "bazarr" ''
      qutebrowser 10.0.0.200:6767
    '')

    (writeShellScriptBin "deluge" ''
      qutebrowser 10.0.0.200:8112
    '')

    (writeShellScriptBin "google" ''
      qutebrowser https://www.google.com.au
    '')

    (writeShellScriptBin "jackett" ''
      qutebrowser 10.0.0.200:9117
    '')

    (writeShellScriptBin "jellyfin" ''
      qutebrowser 10.0.0.180:8096
    '')

    (writeShellScriptBin "kindle" ''
      qutebrowser https://read.amazon.com/kindle-library
    '')

    (writeShellScriptBin "nyaa" ''
      qutebrowser https://www.nyaa.si
    '')

    (writeShellScriptBin "nzbget" ''
      qutebrowser 10.0.0.200:6789
    '')

    (writeShellScriptBin "plex" ''
      qutebrowser 10.0.0.180:32400/web
    '')

    (writeShellScriptBin "radarr" ''
      qutebrowser 10.0.0.200:7878
    '')

    (writeShellScriptBin "emacs" ''
      emacsclient -nc
    '')

    (writeShellScriptBin "WAYBAR" ''
      CONFIG="$HOME/.config/waybar/config"
      STYLE="$HOME/.config/waybar/style.css"

      if pgrep -f waybar &> /dev/null 2>&1; then
          pkill waybar
          waybar -c $CONFIG -s $STYLE > /dev/null 2>&1 &
      else
        if [[ $(pgrep -x "waybar") = "" ]]; then
          waybar -c $CONFIG -s $STYLE > /dev/null 2>&1 &
      fi
      fi
    '')

  ];

  programs.git.enable = true;

  programs.neovim = {
      enable = true;
      package = unstable.pkgs.neovim-unwrapped;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      plugins = with pkgs.vimPlugins; [
        nvim-treesitter.withAllGrammars
        dracula-nvim
        tokyonight-nvim
        gruvbox-material
        nightfox-nvim
        onedark-nvim
        material-nvim
        tagbar
        harpoon
        todo-comments-nvim
        nvim-lspconfig
        nvim-cmp
        cmp-nvim-lsp
        cmp_luasnip
        mru
        catppuccin-nvim
      ];
  };

  nixpkgs.overlays = [
      (final: prev: {
          dmenu = prev.dmenu.overrideAttrs(old: {src = ~/dotfiles/arch/suckless/dmenu-5.0 ;});
          })
      ];

  gtk = {
    enable = true;
    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };

    iconTheme = {
      name = "Dracula";
      package = pkgs.dracula-icon-theme;
    };

  };

   gtk.cursorTheme = {
    name = "Catppuccin-Mocha-Dark-Cursors";
    package = pkgs.catppuccin-cursors.mochaDark;
    size = 24;
  };
   home.pointerCursor = {
    name = "Catppuccin-Mocha-Dark-Cursors";
    package = pkgs.catppuccin-cursors.mochaDark;
    size = 24;
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
