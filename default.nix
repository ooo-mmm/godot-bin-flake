{
  pkgs ? import <nixpkgs> { },
}:

let
  flake = import ./flake.nix;
in
flake.packages.${pkgs.system}
