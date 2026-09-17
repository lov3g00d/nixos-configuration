{
  stdenv,
  lib,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  coreutils,
  gawk,
  gnugrep,
  util-linux,
  systemd,
  nettools,
  glib,
  dconf,
  runtimeShell,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "endpoint-verification";
  version = "1759763773599-804530221";

  # Google publishes only a Debian package. To bump: read the Packages index at
  # https://packages.cloud.google.com/apt/dists/endpoint-verification/main/binary-amd64/Packages
  # and copy the newest Version, Filename hash, and SHA256.
  src = fetchurl {
    url = "https://packages.cloud.google.com/apt/pool/endpoint-verification/endpoint-verification_${finalAttrs.version}_amd64_3a0d00c3c3cdeb3ec89408ff47a9b46f.deb";
    hash = "sha256-J6y2Is6To6IMxve5d51bnrl0Ph1hMBG4Mz08ZzuXAic=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
  ];
  buildInputs = [ stdenv.cc.cc.lib ];

  unpackPhase = "dpkg-deb -x $src .";

  # device_state.sh hardcodes Debian tool paths and, under `set -u`, crashes on
  # NixOS because OS_VERSION/OS_FIREWALL are only assigned in the Ubuntu/ufw
  # branches. Repoint the tools at the store and default the unset vars to empty
  # so it reports "unknown" truthfully instead of aborting.
  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/google/endpoint-verification/bin
    cp opt/google/endpoint-verification/bin/apihelper \
      $out/opt/google/endpoint-verification/bin/apihelper

    substitute opt/google/endpoint-verification/bin/device_state.sh \
      $out/opt/google/endpoint-verification/bin/device_state.sh \
      --replace-fail '#!/bin/sh' '#!${runtimeShell}' \
      --replace-fail 'set -u' 'set -u
    SERIAL_NUMBER=""
    OS_VERSION=""
    OS_FIREWALL=""' \
      --replace-fail 'AWK=/usr/bin/awk' 'AWK=${gawk}/bin/awk' \
      --replace-fail 'CAT=/bin/cat' 'CAT=${coreutils}/bin/cat' \
      --replace-fail 'CUT=/usr/bin/cut' 'CUT=${coreutils}/bin/cut' \
      --replace-fail 'DCONF=/usr/bin/dconf' 'DCONF=${dconf}/bin/dconf' \
      --replace-fail 'ECHO=/bin/echo' 'ECHO=${coreutils}/bin/echo' \
      --replace-fail 'GREP=/bin/grep' 'GREP=${gnugrep}/bin/grep' \
      --replace-fail 'GSETTINGS=/usr/bin/gsettings' 'GSETTINGS=${glib.bin}/bin/gsettings' \
      --replace-fail 'LSBLK=/bin/lsblk' 'LSBLK=${util-linux}/bin/lsblk' \
      --replace-fail 'MOUNTPOINT=/bin/mountpoint' 'MOUNTPOINT=${util-linux}/bin/mountpoint' \
      --replace-fail 'PRINTF=/usr/bin/printf' 'PRINTF=${coreutils}/bin/printf' \
      --replace-fail 'STAT=/usr/bin/stat' 'STAT=${coreutils}/bin/stat' \
      --replace-fail 'TR=/usr/bin/tr' 'TR=${coreutils}/bin/tr' \
      --replace-fail 'UDEVADM=/bin/udevadm' 'UDEVADM=${systemd}/bin/udevadm' \
      --replace-fail '/bin/hostname' '${nettools}/bin/hostname'
    chmod +x $out/opt/google/endpoint-verification/bin/device_state.sh

    mkdir -p $out/etc/opt/chrome/native-messaging-hosts
    substitute etc/opt/chrome/native-messaging-hosts/com.google.endpoint_verification.api_helper.json \
      $out/etc/opt/chrome/native-messaging-hosts/com.google.endpoint_verification.api_helper.json \
      --replace-fail '/opt/google/endpoint-verification/bin/apihelper' \
        "$out/opt/google/endpoint-verification/bin/apihelper"

    runHook postInstall
  '';

  meta = {
    description = "Google Endpoint Verification native helper";
    homepage = "https://support.google.com/a/users/answer/9018161";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
