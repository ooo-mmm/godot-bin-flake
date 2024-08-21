{
  description = "Official Godot binary packages for NixOS - An overlay for Godot";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:numtide/flake-utils";
    };
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    # Add files needed to create a launcher icon for Godot
    godot-desktop-file = {
      url = "https://raw.githubusercontent.com/godotengine/godot/master/misc/dist/linux/org.godotengine.Godot.desktop";
      flake = false;
    };
    godot-icon-png = {
      url = "https://raw.githubusercontent.com/godotengine/godot/master/icon.png";
      flake = false;
    };
    godot-icon-svg = {
      url = "https://raw.githubusercontent.com/godotengine/godot/master/icon.svg";
      flake = false;
    };
    godot-manpage = {
      url = "https://raw.githubusercontent.com/godotengine/godot/master/misc/dist/linux/godot.6";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
        rec {
          defaultApp = apps.godot;
          apps.godot = {
            type = "app";
            program = "${packages.godot}/bin/godot";
          };
          apps.godotMono = {
            type = "app";
            program = "${packages.godotMono}/bin/godot-mono";
          };

          defaultPackage = packages.godotMono;
          packages.godot = pkgs.callPackage ./pkgs/godot {
            godotDesktopFile = inputs.godot-desktop-file;
            godotIconPNG = inputs.godot-icon-png;
            godotIconSVG = inputs.godot-icon-svg;
            godotManpage = inputs.godot-manpage;
          };
          packages.godotMono = pkgs.callPackage ./pkgs/godot/mono.nix {
            godotBin = packages.godot;
            godotDesktopFile = inputs.godot-desktop-file;
            godotIconPNG = inputs.godot-icon-png;
            godotIconSVG = inputs.godot-icon-svg;
            godotManpage = inputs.godot-manpage;
          };
          overlays.default = final: prev: {
            godot = packages.godot;
            godotMono = packages.godotMono;
          };
        }
      );
}
