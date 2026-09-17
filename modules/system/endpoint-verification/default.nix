{ pkgs, ... }:
let
  endpoint-verification = pkgs.callPackage ./package.nix { };
  prefix = "/opt/google/endpoint-verification";
  script = "${endpoint-verification}${prefix}/bin/device_state.sh";
in
{
  # apihelper execs device_state.sh from this hardcoded absolute path, and the
  # oneshot writes the root-only attributes (serial, disk encryption) here for
  # the user-launched helper to read back.
  systemd.tmpfiles.rules = [
    "d ${prefix} 0755 root root -"
    "d ${prefix}/bin 0755 root root -"
    "d ${prefix}/var 0755 root root -"
    "d ${prefix}/var/lib 0755 root root -"
    "L+ ${prefix}/bin/device_state.sh - - - - ${script}"
  ];

  systemd.services.endpoint-verification = {
    description = "Endpoint Verification state initialization";
    after = [ "local-fs.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${script} init";
      StandardOutput = "file:${prefix}/var/lib/device_attrs";
      RemainAfterExit = true;

      # Least-privilege the proprietary root binary: it only needs to read /sys
      # and write its one state file. PrivateDevices is intentionally omitted so
      # lsblk/udevadm can still see the real disk for the encryption check.
      NoNewPrivileges = true;
      ProtectSystem = "strict";
      ProtectHome = true;
      PrivateNetwork = true;
      ReadWritePaths = [ "${prefix}/var/lib" ];
      ProtectKernelTunables = true;
      ProtectControlGroups = true;
      RestrictAddressFamilies = [
        "AF_UNIX"
        "AF_NETLINK"
      ];
      RestrictNamespaces = true;
      SystemCallFilter = [ "@system-service" ];
    };
  };
}
