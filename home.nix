{pkgs, ...}: {
  home.username = "borno";
  home.homeDirectory = "/home/borno";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    flatpak
    zed-editor
  ];
}
