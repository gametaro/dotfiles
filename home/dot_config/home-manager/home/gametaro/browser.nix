{
  inputs',
  pkgs,
  ...
}: {
  programs = {
    chromium = {
      enable = true;
      package = pkgs.brave;
      commandLineArgs = ["--ozone-platform-hint=wayland"];
      extensions = [
        # uBlock Origin
        {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";}
        # Firenvim
        {id = "egpjdkipkomnmjhjmdamaniclmdlobbo";}
        # 1Password Nightly
        {id = "gejiddohjgogedgjnonbofjigllpkmbf";}
        # Dark Reader
        {id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";}
      ];
    };
    firefox = {
      enable = true;
      arkenfox.enable = true;
      arkenfox.version = "119.0";
      profiles = {
        default = {
          arkenfox = {
            enable = true;
            "0100".enable = true;
            "0200".enable = true;
            "0300".enable = true;
            "0400".enable = true;
            "0600".enable = true;
            "0700".enable = true;
            "0800".enable = true;
            "0900".enable = true;
            "1000".enable = true;
            "1200".enable = true;
            "1600".enable = true;
            "1700".enable = true;
            "2000".enable = true;
            "2400".enable = true;
            "2600".enable = true;
            "2700".enable = true;
            "2800".enable = true;
            "4500".enable = true;
          };
          extensions = with inputs'.firefox-addons.packages; [
            darkreader
            onepassword-password-manager
            ublock-origin
            vimium
          ];
          search = {
            default = "DuckDuckGo";
            force = true;
            privateDefault = "DuckDuckGo";
          };
          settings = {
            "browser.search.region" = "en-US";
            "distribution.searchplugins.defaultLocale" = "en-US";
            "general.useragent.locale" = "en-US";
          };
        };
      };
    };
  };
}
