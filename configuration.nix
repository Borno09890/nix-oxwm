{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader = {
    systemd-boot.enable = false;
    grub = {
      enable = true;
      device = "nixos-btw";
      efiSupport = true;
      useOSProber = true;
    };
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot";
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "borno";

  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Dhaka";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
    useXkbConfig = true;
  };

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  services.libinput.enable = true;

  users.users.nix-btw = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    packages = with pkgs; [
      tree
    ];
  };

  environment.systemPackages = with pkgs; [
    neovim
    wget
    git
    vimPlugins.LazyVim
    nixd
    foot
    rofi
    alejandra
    gtk3
    gtk4
    thunar
    thunar-volman
    thunar-vcs-plugin
    thunar-archive-plugin
    thunar-media-tags-plugin
  ];

  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  nix = {
    package = pkgs.nixFlakes;
    settings = {
      experimental-features = ["nix-command" "flakes"];
    };
  };
  services.xserver = {
    enable = true;
    xkb.layout = "us";
    xkb.variant = "";

    windowManager.oxwm.enable = true;
    displayManager.defaultSession = "none+oxwm";
  };
  services.displayManager.ly.enable = true;

  services.openssh.enable = true;
  system.stateVersion = "26.05";
}
