{ config, pkgs, ... }:

let
  doom-emacs = pkgs.callPackage (builtins.fetchTarball {
    url = https://github.com/nix-community/nix-doom-emacs/archive/master.tar.gz;
    #url = https://github.com/nix-community/nix-doom-emacs/archive/34d8f65.tar.gz;
    #sha256 = "0gfb054dny6k0w55cpn2q7y3ir01m7pg48c6mkm7x9zb8xx6idqm";
    }) {
      doomPrivateDir = /home/jpm/.config/doom;
      };
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  # Hostname
  networking.hostName = "nixos"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Time zone.
  time.timeZone = "Australia/Sydney";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_AU.UTF-8";
    LC_IDENTIFICATION = "en_AU.UTF-8";
    LC_MEASUREMENT = "en_AU.UTF-8";
    LC_MONETARY = "en_AU.UTF-8";
    LC_NAME = "en_AU.UTF-8";
    LC_NUMERIC = "en_AU.UTF-8";
    LC_PAPER = "en_AU.UTF-8";
    LC_TELEPHONE = "en_AU.UTF-8";
    LC_TIME = "en_AU.UTF-8";
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jpm = {
    isNormalUser = true;
    description = "John";
    extraGroups = [ "networkmanager" "wheel" "video" "keyd" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Bluetooth
  hardware.bluetooth.enable = true;

  #Pipewire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Screen brightness (requires video group permissions)
  programs.light.enable = true;

  # fonts
  fonts.fonts = with pkgs; [
    nerdfonts
    fira-mono
    source-sans-pro
  ];

  # emacs daemon
  services.emacs = {
    enable = true;
    package = doom-emacs;
  };

  # Packages installed in system profile.
  environment.systemPackages = with pkgs; [
    cifs-utils
    kitty
    git
    wofi
    python3
  ];

  services.keyd = {
    enable = true;
    settings = {
      main = {
        capslock = "overload(nav_layer, esc)";
        space = "overload(num_layer, space)";
      };
      nav_layer = {
        h = "left";
        j = "down";
        k = "up";
        l = "right";
	y = "home";
	u = "pagedown";
	i = "pageup";
	o = "end";
      };
      #num_layer = {
      #  a = "1";
      #  s = "2";
      #  d = "3";
      #  f = "4";
      #  g = "5";
      #  h = "6";
      #  j = "7";
      #  k = "8";
      #  l = "9";
      #  ";" = "0";
      #  q = "!";
      #  w = "@";
      #  e = "#";
      #  r = "$";
      #  t = "%";
      #  y = "^";
      #  u = "&";
      #  i = "*";
      #  o = "(";
      #  p = ")";
      #};
      shift = {
        leftshift = "capslock";
        rightshift = "capslock";
      };
    };
  };

  # x11
  #services.xserver.enable = true;
  #services.xserver.displayManager.startx.enable = true;

  # Qtile
  #services.xserver.windowManager.qtile.enable = true;
  #services.xserver.windowManager.qtile.backend = "wayland";

  # Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # 1Password
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
  };

  # ZSH
  programs.zsh.enable = true;
  users.users.jpm.shell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh ];

  # PAM Swylock
  security.pam.services.swaylock = {};

  # SSH
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
    openFirewall = true;
  };

  # Samba Shares
  ## Other
  fileSystems."/mnt/other" = {
      device = "//10.0.0.200/other";
      fsType = "cifs";
      options = let
        # this line prevents hanging on network split
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";

      in ["${automount_opts},credentials=/etc/nixos/smb-secrets"];
  };

  ## Movies
  fileSystems."/mnt/movies" = {
      device = "//10.0.0.200/movies";
      fsType = "cifs";
      options = let
        # this line prevents hanging on network split
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";

      in ["${automount_opts},credentials=/etc/nixos/smb-secrets"];
  };

  ## Movies 2
  fileSystems."/mnt/movies2" = {
      device = "//10.0.0.200/movies2";
      fsType = "cifs";
      options = let
        # this line prevents hanging on network split
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";

      in ["${automount_opts},credentials=/etc/nixos/smb-secrets"];
  };

  ## Seasons
  fileSystems."/mnt/seasons" = {
      device = "//10.0.0.200/seasons";
      fsType = "cifs";
      options = let
        # this line prevents hanging on network split
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";

      in ["${automount_opts},credentials=/etc/nixos/smb-secrets"];
  };

  ## Seasons 2
  fileSystems."/mnt/seasons2" = {
      device = "//10.0.0.200/seasons2";
      fsType = "cifs";
      options = let
        # this line prevents hanging on network split
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";

      in ["${automount_opts},credentials=/etc/nixos/smb-secrets"];
  };

  ## Seasons 5
  fileSystems."/mnt/seasons5" = {
      device = "//10.0.0.200/seasons5";
      fsType = "cifs";
      options = let
        # this line prevents hanging on network split
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";

      in ["${automount_opts},credentials=/etc/nixos/smb-secrets"];
  };

  ## Instruction
  fileSystems."/mnt/instruction" = {
      device = "//10.0.0.200/instruction";
      fsType = "cifs";
      options = let
        # this line prevents hanging on network split
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";

      in ["${automount_opts},credentials=/etc/nixos/smb-secrets"];
  };

  # Thunar
  programs.thunar.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images

  # Syncthing
  services = {
    syncthing = {
      enable = true;
      dataDir = "/home/jpm/Documents";
      configDir = "/home/jpm/.config/syncthing";
      user = "jpm";
      group = "users";
      guiAddress = "127.0.0.1:8384";
      extraOptions.gui = {
	theme = "dark";
      };
      overrideDevices = true;     # overrides any devices added or deleted through the WebUI
      overrideFolders = true;     # overrides any folders added or deleted through the WebUI
      devices = {
        "woodhouse" = { id = "GNV43TB-76P06P2-07AN3AF-YZJ6XII-URJPIAQ-FLH3DWQ-HRH7S6M-TW5TIA2"; };
      };
      folders = {
        "obsidian" = {
	  id = "ksdg2-n3fmv";
          path = "/home/jpm/Documents/01-Projects/obsidian";
          devices = [ "woodhouse" ];
        };
        "logseq" = {
	  id = "zgavv-cktxf";
          path = "/home/jpm/Documents/01-Projects/logseq";
          devices = [ "woodhouse" ];
        };
        "cookbook" = {
	  id = "jpnn9-jl5d9";
          path = "/home/jpm/Documents/01-Projects/cookbook";
          devices = [ "woodhouse" ];
        };
        "coding" = {
	  id = "67t3y-nk2kv";
          path = "/home/jpm/Documents/01-Projects/coding";
          devices = [ "woodhouse" ];
        };
        "mymaps" = {
	  id = "kdwrd-6klc5";
          path = "/home/jpm/Documents/01-Projects/keyboards/mymaps";
          devices = [ "woodhouse" ];
        };
        "dotfiles" = {
	  id = "jnxm9-tkxip";
          path = "/home/jpm/dotfiles";
          devices = [ "woodhouse" ];
        };
        "orgmode" = {
	  id = "zae9w-nmayb";
          path = "/home/jpm/Documents/01-Projects/org";
          devices = [ "woodhouse" ];
        };
        "inbox" = {
	  id = "zbko2-xrbjg";
          path = "/home/jpm/Documents/00-Inbox";
          devices = [ "woodhouse" ];
        };
      };
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Before changing this value, read the documentation
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
