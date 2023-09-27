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
                
                lua = prev.lua5_4.override rec {
		  packageOverrides = lfinal: lprev: {
		    luadbi = lprev.luadbi.overrideAttrs(prevAttrs: {
		      src = prev.fetchgit (removeAttrs (builtins.fromJSON ''{
                         "url": "https://github.com/mwild1/luadbi.git",
                         "rev": "01bf20f59a7251684ad74e4e0a5323f673fef1bb",
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
                         "rev": "8c09109924b218aaecbfd4d4b1de538269c4d765",
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
		      #patches = [ ./files/lgi-0.9.2-lua54.patch ];
		      knownRockspec = (prev.fetchurl {
                        url    = "https://raw.githubusercontent.com/lgi-devs/lgi/master/lgi-scm-1.rockspec";
                        sha256 = "sha256-1MCWll/Sfhk74Pe72jfJu8Dbgg0Q+XLm/b34ALoTgvQ=";
                      }).outPath;

		      # 0.9.2
                      #"rev": "0fdcf8c677094d0c109dfb199031fdbc0c9c47ea",
                      #"sha256": "sha256-UpamUbvqzF0JKV3J0wIiJlV6iedwe823vD0EIm3zKw8=",

                      #git
                      #"rev": "975737940d4463abc107fc366b9ab817e9217e0b",
                      #"sha256": "sha256-G13BrqUmHwRtlmBVafo0LiwsX4nL/muw0/9cca+sigg=",

		      src = prev.fetchgit (removeAttrs (builtins.fromJSON ''{
                         "url": "https://github.com/lgi-devs/lgi.git",
                         "rev": "975737940d4463abc107fc366b9ab817e9217e0b",
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
