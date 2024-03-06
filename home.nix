{ config, pkgs, ... }:

{
  home.username = "carlw";
  home.homeDirectory = "/home/carlw";

  home.stateVersion = "23.11"; # Do not update this.

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    firefox
    chromium
    kitty
    remmina
    dolphin
    # obsidian

    # desktop environment
    hyprpaper
    waybar # main toolbars
    swaylock-effects # lock screen
    nwg-drawer
    nwg-launchers
    polkit-kde-agent # authentication agent
    pkgs.xclip # clipboard
    pkgs.wl-clipboard # clipboard
    # xdg-desktop-portal-hyprland
    xdg-desktop-portal-wlr
    # hyprland-share-picker
    whatsapp-for-linux
    sway-contrib.grimshot # screenshots
    dunst # notification daemon
    fuzzel # quick application runner
    swaybg # wallpapers
    sov # sway overview
    wob # graphical indicator (volume/brightness/etc)
    cinnamon.nemo-with-extensions
    usbutils
    gthumb # image viewer
    hyprpicker

    # cli
    lazygit
    lazydocker
    fzf # fuzzy finder
    bat # better cat
    eza # better ls
    ripgrep # better grep
    htop # system monitor
    tree-sitter
    fd # find cli alternative
    ncspot # spotify in terminal

    keeweb
    mullvad-vpn
    qbittorrent
    haruna
    arduino
    arduino-cli
    gparted
    # nix-software-center
    # gencfsm # gnome-encfs-manager
    encfs
    bitwarden
    bitwarden-cli
    gnome.file-roller
    signal-desktop
    discord
    yazi
    zoxide

    # games
    clonehero
    steam-tui

    # fonts
    # (pkgs.nerdfonts.override { fonts = [ "sourcecodepro" ]; })

    # code
    go
    zig # compiler for zig and c/c++
    # rustc
    # cargo
    gcc
  ];

  home.file = {
    ".config/nvim".source = ./dotfiles-nix/nvim;
    # ".config/kitty/kitty.conf".source = dotfiles-nix/kitty/kitty.conf;
    # ".config/fish".source = dotfiles-nix/fish;
    # ".config/waybar".source = dotfiles-nix/waybar;
    # ".config/dunst".source = dotfiles-nix/dunst;
    # ".config/sway".source = dotfiles-nix/sway;
    # ".config/sov".source = dotfiles-nix/sov;
    # ".config/swaylock".source = dotfiles-nix/swaylock;
    # "Pictures/wallpapers".source = dotfiles-nix/wallpapers;
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
}
