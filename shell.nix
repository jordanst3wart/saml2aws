# Development shell for saml2aws on Nix/NixOS.
#
# Provides the build tooling plus the shared libraries needed by the
# Playwright-downloaded Chromium used in pkg/provider/browser tests.
#
# Usage:
#   nix-shell             # enter the shell
#   nix-shell --run "make test"
{ pkgs ? import <nixpkgs> { } }:

let
  # Runtime libraries required by Playwright's Chromium / headless shell
  browserLibs = with pkgs; [
    alsa-lib
    at-spi2-atk
    atk
    cairo
    cups
    dbus
    expat
    glib
    libdrm
    libgbm
    libx11
    libxcb
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxkbcommon
    libxrandr
    mesa
    nspr
    nss
    pango
    systemd
  ];
in
pkgs.mkShell {
  packages = with pkgs; [
    go
    gnumake
    goreleaser
  ] ++ browserLibs;

  shellHook = ''
    export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath browserLibs}''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
  '';
}
