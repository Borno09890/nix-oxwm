{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      lazyvim.url = "github:pfassina/lazyvim-nix";
    };
  };
  outputs = inputs @ {
    self,
    nixpkgs,
    pkgs,
    home-manager,
    lazyvim,
    ...
  }: {
    nixosConfigurations.borno = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      imports = [lazyvim.homeManagerModules.default];
      programs.lazyvim = {
        enable = true;
        extras = {
          lang.nix.enable = true;
          lang.lua.enable = true;
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
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.borno = import ./home.nix;
        }
      ];
    };
  };
}
