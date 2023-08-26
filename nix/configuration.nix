# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  
  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Enable grub cryptodisk
  boot.loader.grub.enableCryptodisk=true;

  boot.initrd.luks.devices."luks-2f957f11-b1fc-46cf-8ea1-4dc08faf192b".keyFile = "/crypto_keyfile.bin";
  boot.initrd.luks.devices."luks-1c93ac5c-e671-46bc-bd1a-7eb41f4bdcfb".keyFile = "/crypto_keyfile.bin";
  networking.hostName = "nixThinkPad"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;

  # Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Fix Swaylock
  security.pam.services.swaylock = {
    text = ''
      auth include login
    '';
  };

  # Lid Ignore
  services.logind.lidSwitchDocked = "ignore";
  services.logind.lidSwitch = "suspend";
  services.logind.lidSwitchExternalPower = "suspend";

  # Pipewire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Screen brightness (requires video group permissions)
  programs.light.enable = true;

  # Set your time zone.
  time.timeZone = "Australia/Sydney";

  # QMK
  hardware.keyboard.qmk.enable = true;
  
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
    description = "jpm";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "input" ];
    packages = with pkgs; [
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # ZSH
  programs.zsh.enable = true;
  users.users.jpm.shell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #neovim
    cifs-utils
    xremap-flake.homeManagerModules.default
  ];

  # SSH
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
    settings.PasswordAuthentication = false;
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

  ## Home
  fileSystems."/mnt/homes" = {
      device = "//10.0.0.200/jpm";
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
    #overrideDevices = true;     # overrides any devices added or deleted through the WebUI
    #overrideFolders = true;     # overrides any folders added or deleted through the WebUI
    devices = {
      "woodhouse" = { id = "GNV43TB-76P06P2-07AN3AF-YZJ6XII-URJPIAQ-FLH3DWQ-HRH7S6M-TW5TIA2"; };
    };
    #folders = {
    #  "obsidian" = {        # Name of folder in Syncthing, also the folder ID
    #    path = "/home/jpm/Documents/01-Projects/obsidian";    # Which folder to add to Syncthing
    #    #devices = [ "device1" "device2" ];      # Which devices to share the folder with
    #  };
    #  "logseq" = {
    #    path = "/home/jpm/Documents/01-Projects/logseq";
    #    #devices = [ "device1" ];
    #    #ignorePerms = false;     # By default, Syncthing doesn't sync file permissions. This line enables it for this folder.
    #  };
    #};
  };
};

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
