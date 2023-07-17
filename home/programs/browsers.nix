{ pkgs, config, ... }: 
{
  programs = {
    chromium = {
      enable = true;
      #commandLineArgs = ["--enable-features=TouchpadOverscrollHistoryNavigation"];
      extensions = [
        # {id = "";}  // extension id, query from chrome web store
      ];
    };

    firefox = {
      enable = true;
      profiles.fafuja.extensions = with pkgs.nur.repos.rycee.firefox-addons; [
	ublock-origin
	bitwarden
	#https-everywhere
	#duckduckgo-privary-essentials
	ghostery
	clearurls
	#privacybadger
      ];
      profiles.fafuja = {
        id = 0;
	settings = {
	  "layout.css.devPixelsPerPx" = ".8";
	  "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
	};
	search = {
	  force = true;
	  default = "DuckDuckGo";
	  engines = {
	    "Nix Packages" = {
	      urls = [{ 
	        template = "https://search.nixos.org/packages";
		params = [
		  { name = "type"; value = "packages"; }
		  { name = "query"; value = "{searchTerms}"; }
		];
	      }];
	      icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
	      definedAliases = [ "@np" ];
	    };
	    "NixOS Wiki" = {
              urls = [{ template = "https://nixos.wiki/index.php?search={searchTerms}"; }];
              iconUpdateURL = "https://nixos.org/favicon.png";
              updateInterval = 24 * 60 * 60 * 1000;
              definedAliases = [ "@nw" ];
            };
	    "Wikipedia (en)".metaData.alias = "@wiki";
	  };
	};
	userChrome = (builtins.readFile ../../files/userChrome.css);
	userContent = "";
      };
    };
  };
}
