{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    lazyvim = {
      url = "github:pfassina/lazyvim-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    lazyvim,
    nix-flatpak,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations.borno = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {inherit inputs pkgs;};
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        nix-flatpak.nixosModules.nix-flatpak
        ./hardware-configuration.nix
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.borno = {
            config,
            pkgs,
            ...
          }: {
            imports = [
              inputs.lazyvim.homeManagerModules.default
              ./home.nix
            ];
            programs.lazyvim = {
              enable = true;
              extras = {
                lang.nix.enable = true;
                # lang.lua.enable = true;
                lang.json.enable = true;
              };
              extraPackages = with pkgs; [
                css-checker
                css-html-js-minify
                prettierd
                html-xml-utils
                nixd
                alejandra
                lua-language-server
                stylua
              ];
              treesitterParsers = with pkgs.vimPlugins.nvim-treesitter-parsers; [
                css
                html
                lua
                nix
                javascript
                typescript
              ];
            };
          };
        }
      ];
    };
  };
}
