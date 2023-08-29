{ config, pkgs, ... }:

let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in
#  { home.packages = with pkgs; [
#    unstable.logseq
#    ];
#  }

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "jpm";
  home.homeDirectory = "/home/jpm";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # Allow non-free
  nixpkgs.config.allowUnfree = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    #unstable
    unstable.logseq
    unstable.obsidian
    
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
    nodejs
    notion-app-enhanced
    pamixer
    pciutils
    pfetch
    pkgsCross.avr.buildPackages.gcc
    qmk
    pyright
    python3
    qutebrowser
    ripgrep
    slurp
    speedtest-cli
    st
    sway
    swaybg
    swaylock
    swayidle
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

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];


  #fonts.fonts = with pkgs; [
  #  nerdfonts
  #  fira-mono
  #];

  programs.git.enable = true;

  programs.neovim = {
      enable = true;
      #package = unstable.pkgs.neovim;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      plugins = with pkgs.vimPlugins; [
        nvim-treesitter.withAllGrammars
      ];
  };

  nixpkgs.overlays = [
      (final: prev: {
          dmenu = prev.dmenu.overrideAttrs(old: {src = ~/dotfiles/arch/suckless/dmenu-5.0 ;});
          st = prev.st.overrideAttrs(old: {src = ~/dotfiles/arch/suckless/st-0.8.4 ;});
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

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/jpm/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
