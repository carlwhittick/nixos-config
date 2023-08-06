{ config, pkgs, lib, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "carlw";
  home.homeDirectory = "/home/carlw";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    pkgs.htop
    pkgs.kitty

    pkgs.xclip
    pkgs.wl-clipboard

    pkgs.tree-sitter
    pkgs.ripgrep
    pkgs.bottom
    pkgs.gdu
    pkgs.fzf
    pkgs.fd
    pkgs.bat
    pkgs.curl
    pkgs.unzip
    pkgs.firefox
    pkgs.lazygit
    pkgs.lazydocker
    pkgs.exa
    pkgs.cura
    pkgs.ncspot
    # pkgs.git-credential-manager-core-bin
    pkgs.nwg-drawer
    pkgs.nwg-launchers
    pkgs.swaylock-effects
    pkgs.xdg-desktop-portal-hyprland
    # pkgs.grimblast
    # pkgs.hyprland
    pkgs.hyprpaper
    pkgs.waybar

    pkgs.remmina
    pkgs.chromium

    # Backup manager
    pkgs.restic

    # Notes tool
    pkgs.obsidian

    (pkgs.nerdfonts.override { fonts = [ "SourceCodePro" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;
    ".config/nvim".source = ./nvim;
    
    ".config/hypr".source = ./.dotfiles/hyprland/hypr;
    ".config/kitty/kitty.conf".source = ./.dotfiles/kitty.conf;
    ".config/fish".source = ./.dotfiles/fish;
    ".config/waybar".source = ./.dotfiles/waybar/waybar;
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
  #  /etc/profiles/per-user/carlw/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    EDITOR = "nvim";
  };


  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
#     extraConfig = lib.fileContents nvim/init.lua;
  };

  programs.fish = {
    enable = true;
  };
}
