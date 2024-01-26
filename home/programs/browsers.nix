{ pkgs, config, lib, ... }: 
{
  modules = {
    librewolf = {
      enable = true;
      profiles.fafuja = {
        id = 0;
        userChrome = (builtins.readFile ../../files/userChrome.css);
        userContent = "";
        settings = {
	  "extensions.activeThemeID" = "{ad66e2ae-60dd-4815-b858-c892e44a183a}";
	  "browser.toolbars.bookmarks.visibility" = "never";
	  "webgl.disabled" = false;
          "layout.css.devPixelsPerPx" = "1";
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        };
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          #ublock-origin
          bitwarden
          #ghostery
          clearurls
          canvasblocker
          #persistentpin
          snowflake
          xbrowsersync
          grammarly
          (buildFirefoxXpiAddon {
            pname = "edge-dark-theme";
            version = "2.1";
            addonId = "{ad66e2ae-60dd-4815-b858-c892e44a183a}";
            url = "https://addons.mozilla.org/firefox/downloads/file/3786374/edge_darkmode-2.1.xpi";
            sha256 = "sha256-J57JI8rxcoAGDmQcIiHo6x4mfRT8X7RD2sdNrtszGbs=";
	    meta = {};
          })
          #(buildFirefoxXpiAddon {
          #  pname = "simple-tab-groups";
          #  version = "5.2";
          #  addonId = "{d18bc93b-834b-421c-b91b-15a47e825f4d}";
          #  url = "https://addons.mozilla.org/firefox/downloads/file/4103800/simple_tab_groups-5.2.xpi";
          #  sha256 = "sha256-tW8wzqdTqcTRwOB4wOXmNfGIXqfkAwXO5ZueFF+tCmw=";
          #  meta = with lib; {
          #    homepage = "https://github.com/Drive4ik/simple-tab-groups";
          #    description = "Create, modify, and quickly change tab groups";
          #    license = licenses.mpl20;
          #    platforms = platforms.all;
          #  };
          #})
        ];
        search = {
          #force = false;
          default = "DuckDuckGo";
          engines = {
            "Nix Packages" = {
              urls = [{ template = "https://search.nixos.org/packages?type=packages&query={searchTerms}"; }];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@np" ];
            };
            "NixOS Wiki" = {
              urls = [{ template = "https://nixos.wiki/index.php?search={searchTerms}"; }];
              iconUpdateURL = "https://nixos.org/favicon.png";
              updateInterval = 24 * 60 * 60 * 1000;
              definedAliases = [ "@nw" ];
            };
            "Brave Seach" = {
              urls = [{ template = "https://search.brave.com/search?q={searchTerms}"; }];
              iconUpdateURL = "https://brave.com/static-assets/images/brave-favicon.png";
              updateInterval = 24 * 60 * 60 * 1000; # every day
              definedAliases = [ "@bs" ];
            };
            "Wikipedia (en)".metaData.alias = "@wiki";
          };
        };
      };
    };
  };

  programs = {
    chromium = {
      enable = true;
      #commandLineArgs = ["--enable-features=TouchpadOverscrollHistoryNavigation"];
      extensions = [
        # {id = "";}  // extension id, query from chrome web store
      ];
    };
  };
}
