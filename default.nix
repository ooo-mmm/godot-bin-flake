{
  pkgs ? import <nixpkgs> { },
}:

let
  inherit (pkgs) callPackage;
  godot-desktop-file = fetchurl{
    url = "https://raw.githubusercontent.com/godotengine/godot/master/misc/dist/linux/org.godotengine.Godot.desktop";
  };
  godot-icon-png = fetchurl{
    url = "https://raw.githubusercontent.com/godotengine/godot/master/icon.png";
  };
  godot-icon-svg = fetchurl{
    url = "https://raw.githubusercontent.com/godotengine/godot/master/icon.svg";
  };
  godot-manpage = fetchurl{
    url = "https://raw.githubusercontent.com/godotengine/godot/master/misc/dist/linux/godot.6";
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
  };
}
