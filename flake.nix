{
  description = "Fafuja's NixOS configuration.";

  nixConfig = {
    experimental-features = [ "nix-command" "flakes" ];
  };

  inputs = {
    #nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    #home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    bling = {
      url = "github:BlingCorp/bling?rev=70c894e58bb88dea55e9799ad373fdaea309da9e";
      flake = false;
    };

    wsmcolor = {
      url = "github:andOrlando/color?rev=064459a663a717ab29e4c4efd54c9fc0a2e51d66";
      flake = false;
    };

    wsmupower = {
      url = "github:Aire-One/awesome-battery_widget?rev=48b83f444d175496104f3b9ff36f1dff0473e01e";
      flake = false;
    };

    layout-machi = {
      url = "github:xinhaoyuan/layout-machi?rev=d15b877fb5b0a5f90f010871c7dbfb163b874fe4";
      flake = false;
    };

    nur.url = "github:nix-community/NUR";
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, nur, home-manager, nix-vscode-extensions, bling, wsmcolor, wsmupower, layout-machi, ... }: 
  let
    x64_system = "x86_64-linux";
    x64_specialArgs = {
      pkgs-unstable = import inputs.nixpkgs-unstable {
        system = x64_system; # refer the `system` parameter form outer scope recursively
        # To use chrome, we need to allow the installation of non-free software
        config.allowUnfree = true;
        config.allowBroken = true;
      };
    } // inputs;
  in 
  {
    # Used with `nixos-rebuild --flake .#<hostname>`
    # nixosConfigurations."<hostname>".config.system.build.toplevel must be a derivation
    nixosConfigurations = {
      pc = nixpkgs.lib.nixosSystem {
	system = x64_system;
        #specialArgs = inputs;
        specialArgs = x64_specialArgs;
        modules = [
 	  home-manager.nixosModules.home-manager {
	    home-manager.useGlobalPkgs = true;
	    home-manager.useUserPackages = true;
	    home-manager.extraSpecialArgs = x64_specialArgs;
	    home-manager.users.fafuja = import ./home;
	  }

	  {
            nixpkgs.overlays = [
              (final: prev: {
                nur = import nur {
                  nurpkgs = prev;
                  pkgs = prev;
                };
		#luaPackages = final.lua.pkgs;
              })
            ];
          } 

	  ./hosts/pc
	];
      };
    };
  };
}
