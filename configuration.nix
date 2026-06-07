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
      device = "nodev";
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

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vpl-gpu-rt
    ];
  };

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  services.libinput.enable = true;

  users.users.borno = {
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
    brave
    rofi
    alejandra
    gtk3
    gtk4
    thunar
    thunar-volman
    thunar-vcs-plugin
    thunar-archive-plugin
    thunar-media-tags-plugin
    ntfs3g
  ];

  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  nix = {
    package = pkgs.nix;
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
  system.stateVersion = "25.11";
}
