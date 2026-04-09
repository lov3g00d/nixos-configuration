{
  pkgs,
  lib,
  sharedFeeds,
  ...
}: let
  credentialsFile = "/etc/miniflux-admin-credentials";

  feedsByCategory =
    builtins.groupBy
    (feed: builtins.head (feed.tags or ["uncategorized"]))
    sharedFeeds;

  opmlOutlines = lib.concatStrings (lib.mapAttrsToList (category: feeds:
    ''
      <outline text="${category}" title="${category}">
    ''
    + lib.concatMapStrings (feed: ''
      <outline type="rss" text="${feed.title or feed.url}" title="${feed.title or feed.url}" xmlUrl="${feed.url}" />
    '')
    feeds
    + ''
      </outline>
    '')
  feedsByCategory);

  opmlFile = pkgs.writeText "feeds.opml" ''
    <?xml version="1.0" encoding="UTF-8"?>
    <opml version="2.0">
      <head><title>NixOS Managed Feeds</title></head>
      <body>
    ${opmlOutlines}
      </body>
    </opml>
  '';
in {
  services.postgresql.settings.port = 5433;

  services.miniflux = {
    enable = true;
    config = {
      LISTEN_ADDR = "127.0.0.1:8080";
      BASE_URL = "http://127.0.0.1:8080";
      CLEANUP_FREQUENCY_HOURS = "24";
      CLEANUP_ARCHIVE_READ_DAYS = "60";
      POLLING_FREQUENCY = "30";
      BATCH_SIZE = "10";
      DATABASE_URL = "user=miniflux host=/run/postgresql port=5433 dbname=miniflux";
    };
    adminCredentialsFile = credentialsFile;
  };

  # The nixpkgs miniflux-dbsetup service runs psql without specifying a port
  systemd.services.miniflux-dbsetup.environment.PGPORT = "5433";

  systemd.services.miniflux-feed-import = {
    description = "Import declarative feeds into Miniflux";
    after = ["miniflux.service"];
    requires = ["miniflux.service"];
    wantedBy = ["multi-user.target"];
    path = with pkgs; [curl coreutils];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      for i in $(seq 1 30); do
        if curl -sf http://127.0.0.1:8080/healthcheck > /dev/null 2>&1; then
          break
        fi
        sleep 1
      done

      set -a
      source ${credentialsFile}
      set +a

      curl -s -X POST \
        -u "$ADMIN_USERNAME:$ADMIN_PASSWORD" \
        -H "Content-Type: application/xml" \
        --data-binary @${opmlFile} \
        http://127.0.0.1:8080/v1/import
    '';
  };
}
