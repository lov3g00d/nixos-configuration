{sharedFeeds, ...}: {
  catppuccin.newsboat.enable = false;

  programs.newsboat = {
    enable = true;
    autoReload = true;
    reloadThreads = 5;
    urls = sharedFeeds;
    extraConfig = ''
      reload-time 30
      max-items 100
      text-width 80
      confirm-mark-feed-read no

      # Catppuccin Mocha colors
      color background          default   default
      color listnormal          color7    default
      color listnormal_unread   color5    default bold
      color listfocus           color0    color5
      color listfocus_unread    color0    color5  bold
      color info                color5    color0
      color article             color7    default

      # Key bindings (vim-like)
      bind-key j down
      bind-key k up
      bind-key j next articlelist
      bind-key k prev articlelist
      bind-key J next-feed articlelist
      bind-key K prev-feed articlelist
      bind-key G end
      bind-key g home
      bind-key d pagedown
      bind-key u pageup
      bind-key l open
      bind-key h quit
      bind-key a toggle-article-read
      bind-key n next-unread
      bind-key N prev-unread
      bind-key U show-urls
      bind-key o open-in-browser

      browser "xdg-open %u"

      articlelist-format "%4i %f %D  %?T?|%-17T|  ?%t"
      feedlist-format "%4i %n %11u %t"
      datetime-format "%b %d"
    '';
  };
}
