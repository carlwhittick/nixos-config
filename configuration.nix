# Edit this configuration file to define what should be installed on

# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;

    text = ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
      systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
    '';
  };
  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;
    text = let
      schema = pkgs.gsettings-desktop-schemas;
      datadir = "${schema}/share/gsettings-schemas/${schema.name}";
    in ''
      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
      gnome_schema=org.gnome.desktop.interface
      gsettings set $gnome_schema gtk-theme 'Dracula'
    '';
  };
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz";
  nix-software-center = import (pkgs.fetchFromGitHub {
    owner = "vlinkz";
    repo = "nix-software-center";
    rev = "0.1.2";
    sha256 = "xiqF1mP8wFubdsAQ1BmfjzCgOD3YZf7EGWl9i69FTls=";
  }) {};
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (import "${home-manager}/nixos")
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader.
  # boot.kernelParams = [
  #   video=HDMI-A-1:3840x2160@60
  #   video=DP-1:1920x1080@144
  #   video=DP-2:1920x1080@144
  #   video=DP-3:1920x1080@144
  # ];
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;
  boot.initrd = {
    # supportedFilesystems = [ "nfs" ];
    kernelModules = [
      "amdgpu"
      # "v4l2loopback"
    ];
  };
  boot.kernelModules = [
    "v4l2loopback"
  ];

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  # services.xserver = {
  #   layout = "gb";
  #   xkbVariant = "";
  # };

  # Configure console keymap
  console.keyMap = "uk";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    # jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
  

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
    tmux
    swayidle
    nfs-utils

    dbus-sway-environment
    configure-gtk
    wayland
    xdg-utils # for opening default programs when clicking links
    glib # gsettings
    dracula-theme # gtk theme
    gnome3.adwaita-icon-theme  # default gnome cursors
    swaylock
    swayidle
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    wdisplays # tool to configure displays

    # Webcam
    gphoto2
    v4l-utils
    # v4l2loopback-dkms
    ffmpeg
  ];

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  users.defaultUserShell = pkgs.fish;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.carlw = {
    isNormalUser = true;
    description = "Carl Whittick";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
  };

  home-manager.users.carlw = {
    home.username = "carlw";
    home.homeDirectory = "/home/carlw";

    home.stateVersion = "23.05";

    home.packages = with pkgs; [
      firefox
      chromium
      kitty
      remmina
      dolphin
      # obsidian
      
      # Desktop Environment
      hyprpaper
      waybar # Main toolbars
      swaylock-effects # Lock screen
      nwg-drawer
      nwg-launchers
      polkit-kde-agent # Authentication agent
      pkgs.xclip # Clipboard
      pkgs.wl-clipboard # Clipboard
      # xdg-desktop-portal-hyprland
      xdg-desktop-portal-wlr
      hyprland-share-picker
      whatsapp-for-linux
      sway-contrib.grimshot # Screenshots
      dunst # Notification daemon
      fuzzel # Quick application runner
      swaybg # Wallpapers
      sov # Sway overview
      wob # Graphical indicator (volume/brightness/etc)
      cinnamon.nemo-with-extensions
      usbutils
      gthumb # Image Viewer
      hyprpicker

      # CLI
      lazygit
      lazydocker
      fzf # Fuzzy finder
      bat # Better cat
      exa # Better ls
      ripgrep # Better grep
      htop # System monitor
      tree-sitter
      fd # Find cli alternative
      zig # Compiler for zig and c/c++
      ncspot # Spotify in terminal

      keeweb
      mullvad-vpn
      qbittorrent
      haruna
      arduino
      arduino-cli
      gparted
      nix-software-center
      # gencfsm # gnome-encfs-manager
      encfs
      bitwarden
      bitwarden-cli
      gnome.file-roller
      signal-desktop

      # Games
      clonehero
      steam-tui

      # Fonts
      (pkgs.nerdfonts.override { fonts = [ "SourceCodePro" ]; })
    ];

    home.file = {
      ".config/nvim" = {
        "source" = dotfiles-nix/nvim;
        "recursive" = true;
      };
      ".config/kitty/kitty.conf".source = dotfiles-nix/kitty/kitty.conf;
      ".config/fish".source = dotfiles-nix/fish;
      ".config/waybar".source = dotfiles-nix/waybar;
      ".config/dunst".source = dotfiles-nix/dunst;
      ".config/sway".source = dotfiles-nix/sway;
      ".config/sov".source = dotfiles-nix/sov;
      ".config/swaylock".source = dotfiles-nix/swaylock;
      "Pictures/wallpapers".source = dotfiles-nix/wallpapers;
    };

    home.sessionVariables = {
      EDITOR = "nvim";
      _JAVA_AWT_WM_NONREPARENTING = "1";
    };

    home.pointerCursor = {
      gtk.enable = true;
      package = pkgs.vimix-gtk-themes;
      name = "Layan-cursors";
      size = 32;
    };

    gtk = {
      enable = true;
      font.name = "TeX Gyre Adventor 10";

      # cursorTheme = {
      #   package = pkgs.vimix-gtk-themes;
      #   name = "Layan-cursors";
      # };
      # theme = {
      #   name = "Juno-palenight";
      #   package = pkgs.juno-theme;
      # };
      # theme = {
      #   name = "palenight";
      #   package = pkgs.palenight-theme;
      # };
      # theme = {
      #   name = "Catppuccin-Frappe-Standard-Blue-Dark";
      #   package = pkgs.catppuccin-gtk.override {
      #     accents = [ "pink" ];
      #     size = "compact";
      #     tweaks = [ "rimless" "black" ];
      #     variant = "macchiato";
      #   };
      # };

      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };

# capitaine-cursors-themed

      gtk3.extraConfig = {
        Settings = ''
          gtk-application-prefer-dark-theme=1
        '';
      };

      gtk4.extraConfig = {
        Settings = ''
          gtk-application-prefer-dark-theme=1
        '';
      };
    };
  };

  # Allow unfree packages
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  environment.shells = with pkgs; [ fish ];

  # virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = ["carlw"];

  # fileSystems."/mnt/media" = {
  #   device = "192.168.1.224:/media";
  #   fsType = "nfs";
  #   # options = [ "user" "users" ];
  #   options = [ "x-systemd.automount" "noauto" ];
  # };
  
  # fileSystems."/mnt/other" = {
  #   device = "192.168.1.224:/export/media";
  #   fsType = "nfs";
  #   # options = [ "user" "users" ];
  #   options = [ "x-systemd.automount" "noauto" ];
  # };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias=true;
    vimAlias=true;
  };

  programs.fish = {
    enable = true;
  };

  programs.git = {
    enable = true;
  };

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  # Thumbnails
  services.tumbler.enable = true;

  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [ thunar-archive-plugin thunar-volman ];
  };

  programs.steam.enable = true;

  programs.autojump = {
    enable = true;
    # enableBashIntegration = true;
    # enableFishIntegration = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  services.mullvad-vpn.enable = true;

  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;
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
