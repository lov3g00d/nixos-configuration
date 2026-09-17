{ pkgs, ... }:
let
  endpoint-verification =
    pkgs.callPackage ../../../modules/system/endpoint-verification/package.nix
      { };
  manifest = "com.google.endpoint_verification.api_helper.json";
in
{
  # Vivaldi reads native-messaging manifests from its own per-user dir, not
  # Chrome's /etc path. Google supports Chrome officially; this is best-effort.
  home.file.".config/vivaldi/NativeMessagingHosts/${manifest}".source =
    "${endpoint-verification}/etc/opt/chrome/native-messaging-hosts/${manifest}";
}
