{ config, pkgs, ... }:
{
  imports = [
    ./awesome
    ./programs
    ./shell
    ./modules
  ];

  # Use mopidy instead!
  services.mpd = {
    enable = true;
    network.listenAddress = "any";
    musicDirectory = "/home/fafuja/Music";
    dataDir = "/home/fafuja/.config/mpd";
    extraConfig = ''
      bind_to_address            "127.0.0.1"
      port                       "6600"
      auto_update                "yes"
      restore_paused             "yes"
      music_directory            "/home/fafuja/Music"
      playlist_directory         "/home/fafuja/.config/mpd/playlists"
      db_file                    "/home/fafuja/.config/mpd/mpd.db"
      log_file                   "syslog"
      pid_file                   "/tmp/mpd.pid"
      state_file                 "/home/fafuja/.config/mpd/mpd.state"
      audio_output {
          type                   "pipewire"
          name                   "PipeWire Sound Server"
          buffer_time            "100000"
      }
      audio_output {
          type                   "fifo"
          name                   "ncmpcpp visualizer"
          format                 "44100:16:2"
          path                   "/tmp/mpd.fifo"
      }
      audio_output {
      	type		           "httpd"
      	name		           "lossless"
      	encoder		           "flac"
      	port		           "9090"
      	max_client	           "8"
      	mixer_type	           "software"
      	format		           "44100:16:2"
      }
    '';
  };

  services.mpdris2.enable = true;
  services.mpdris2.notifications = false;
  services.mpdris2.multimediaKeys = false;
  services.mpdris2.mpd.host = "127.0.0.1";
  services.mpdris2.mpd.port = 6600;
  services.mpdris2.mpd.musicDirectory = "/home/fafuja/Music";

  programs.ncmpcpp = { 
    enable = true;
    package = pkgs.ncmpcpp.override { visualizerSupport = true; };
  };
  
  home = {
    username = "fafuja";
    homeDirectory = "/home/fafuja";
    stateVersion = "23.11";
    sessionVariables = {
      XCURSOR_SIZE = 10;
      XCURSOR_THEME = "Colloid-cursors";
    };
  };
  gtk.cursorTheme = {
    name = "Colloid-cursors";
    size = 10;
  };

  programs.home-manager.enable = true;
}
