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

  hardware.opengl.enable = true;
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "borno";

  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Dhaka";
   

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver
    libvdpau-va-gl
    xf86-video-vesa
    mesa       
    intel-vaapi-driver       # For older Intel GPUs (pre-Broadwell)
    vaapiVdpau
    libvdpau-va-gl
    vulkan-loader
    vulkan-validation-layers
    vulkan-extension-layer
    intel-compute-runtime    
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
    feh
    xwallpaper
    nitrogen
    brightnessctl
    dunst
    flameshot
    xclip
    polybar
    acpid
    networkmanager
    trayer
    libinput
    i3lock
    fontconfig
    pavucontrol
    blueman
    networkmanagerapplet
    mako
    wl-clipboard
    noctalia-shell
      vulkan-tools     
  mesa-demos       
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
    videoDrivers = [ "modesetting" ];
    libinput.enable = true;

    windowManager.oxwm.enable = true;
    windowManager.i3.enable = true;
    # displayManager.defaultSession = "oxwm+i3";
  };
  services.displayManager.ly.enable = true;
    programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };
 services.gnome.gnome-keyring.enable = true;

services.flatpak = {
  enable = true;
  packages = [
    "org.vinegarhq.Sober"
  ];
  overrides = {
    "org.vinegarhq.Sober" = {
      Context.sockets = [ "wayland" "!x11" ];
    };
  };
  remotes = [
    {
      name = "flathub";
      location = "https://flathub.org/repo/flathub.flatpakrepo";
    }
    {
      name = "flathub-beta";
      location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
    }
  ];
};
  services.openssh.enable = true;
  system.stateVersion = "25.11";
}
