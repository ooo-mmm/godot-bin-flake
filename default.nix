{
  pkgs ? import <nixpkgs> { },
}:

let
  inherit (pkgs) callPackage;
  godot-desktop-file = builtins.fetchurl{
    url = "https://raw.githubusercontent.com/godotengine/godot/master/misc/dist/linux/org.godotengine.Godot.desktop";
    sha256 = "0g7gsmmkkmyrnx0mw01ws555igc648iyd25fb7zjrfxj8zrb13zb";
  };
  godot-icon-png = builtins.fetchurl{
    url = "https://raw.githubusercontent.com/godotengine/godot/master/icon.png";
    sha256 = "1zlnmjciwbxi1mmsqkn3zna9ngglpgh4i1266h293clg6c0i7pfa";
  };
  godot-icon-svg = builtins.fetchurl{
    url = "https://raw.githubusercontent.com/godotengine/godot/master/icon.svg";
    sha256 = "0j60bsc96f3lrpk5vszjgj9i4ywvbygyl0fzxchpgmvzkc7j14bs";
  };
  godot-manpage = builtins.fetchurl{
    url = "https://raw.githubusercontent.com/godotengine/godot/master/misc/dist/linux/godot.6";
    sha256 = "158rs0whamb67x8fvyx0pvhj0r3alpb4a9l03jy53bpf9kiiix13";
  };
in
rec {
  godot = callPackage ./pkgs/godot { 
    godotDesktopFile = godot-desktop-file;
    godotIconPNG = godot-icon-png;
    godotIconSVG = godot-icon-svg;
    godotManpage = godot-manpage;
  };

  godotMono = callPackage ./pkgs/godot/mono.nix {
    godotBin = godot;
    godotDesktopFile = godot-desktop-file;
    godotIconPNG = godot-icon-png;
    godotIconSVG = godot-icon-svg;
    godotManpage = godot-manpage;
  };
}
