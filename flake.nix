{
  description = "Fafuja's NixOS configuration.";

  nixConfig = {
    experimental-features = [ "nix-command" "flakes" ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    #substituters = {
    #  "https://cache.nixos.org"
    #};
    #extra-substituters = [
    #  "https://nix-community.cachix.org"
    #  "https://nixpkgs-wayland.cachix.org"
    #];
    #extra-trusted-public-keys = [
    #  "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    #  "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    #  "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
    #];
    #yoru-theme = {
    #  url = "github:skobman/yoru/new";
    #  flake = false;
    #};
    nur.url = "github:nix-community/NUR";
  };

  outputs = inputs@{ self, nixpkgs, nur, home-manager, nix-vscode-extensions, ... }: 
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
        specialArgs = inputs;
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
                
                lua = prev.lua5_4.override rec {
		  packageOverrides = lfinal: lprev: {
		    luadbi = lprev.luadbi.overrideAttrs(prevAttrs: {
		      src = prev.fetchgit (removeAttrs (builtins.fromJSON ''{
                         "url": "https://github.com/mwild1/luadbi.git",
                         "date": "",
                         "path": "",
                         "sha256": "sha256-4cZFCX51NmnHjVITnkhGdvb9bymqE/6enIOcVUpZmYM=",
                         "fetchLFS": false,
                         "fetchSubmodules": true,
                         "deepClone": false,
                         "leaveDotGit": false
			}                     
                      '') ["date" "path"]);
                      disabled = (lprev.luaOlder "5.1");
                    });
		    markdown = lprev.buildLuarocksPackage {
		      pname = "markdown";
		      version = "1.0";
		      patches = [];
		      knownRockspec = (prev.fetchurl {
                        url    = "https://luarocks.org/manifests/mpeterv/markdown-0.30-1.rockspec";
                        sha256 = "sha256-pUswrM/OlR8N/g0XyeUdkQdXbZYfalNpe5KY7o1tcQ0=";
                      }).outPath;
		      src = prev.fetchgit (removeAttrs (builtins.fromJSON ''{
                         "url": "https://github.com/mpeterv/markdown.git",
                         "date": "",
                         "path": "",
                         "sha256": "sha256-PgRGiSwDODSyNSgeN7kNOCZwjLbGf1Qts/jrfLGYKwU=",
                         "fetchLFS": false,
                         "fetchSubmodules": true,
                         "deepClone": false,
                         "leaveDotGit": false
		    	}                     
                      '') ["date" "path"]);                      
		      disabled = (lprev.luaOlder "5.1");
		      propagatedBuildInputs = [ prev.lua5_4 ];
                    };
		    lgi = lprev.buildLuarocksPackage {
		      pname = "lgi";
  		      version = "scm-1";
		      patches = [];
		      knownRockspec = (prev.fetchurl {
                        url    = "https://raw.githubusercontent.com/lgi-devs/lgi/master/lgi-scm-1.rockspec";
                        sha256 = "sha256-1MCWll/Sfhk74Pe72jfJu8Dbgg0Q+XLm/b34ALoTgvQ=";
                      }).outPath;
		      src = prev.fetchgit (removeAttrs (builtins.fromJSON ''{
                         "url": "https://github.com/lgi-devs/lgi.git",
                         "date": "",
                         "path": "",
                         "sha256": "sha256-G13BrqUmHwRtlmBVafo0LiwsX4nL/muw0/9cca+sigg=",
                         "fetchLFS": false,
                         "fetchSubmodules": true,
                         "deepClone": false,
                         "leaveDotGit": false
			}                     
                      '') ["date" "path"]);
		      buildInputs = with prev; [ gobject-introspection glib ];
		      #nativeBuildInputs = with prev; [ pkg-config ];
		      propagatedBuildInputs = with prev; [ lua5_4 pkg-config ];
		    };
		  };
		};
		luaPackages = final.lua.pkgs;
              })
            ];
          } 

	  ./hosts/pc
	];
      };
    };
  };
}
