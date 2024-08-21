let
  flake = builtins.getFlake (toString ./.) { trustTarballsFromGitForge = true; };
  nixpkgs = import <nixpkgs> { };
in
{ inherit flake; }
// flake.packages.${builtins.currentSystem}
