{ pkgs ? import <nixpkgs> { } }:
pkgs.mkShell {
  buildInputs = with pkgs; [
    bash
    curl
    git
    jq
    openssh
  ];
}
