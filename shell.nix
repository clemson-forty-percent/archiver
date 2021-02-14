{ pkgs ? import <nixpkgs> { } }:
pkgs.mkShell {
  buildInputs = with pkgs; [
    bash
    coreutils
    curl
    git
    jq
    openssh
  ];
}
