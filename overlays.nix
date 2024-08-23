self: super:

let
  inherit (super) callPackage config lib;
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
{
  godotBin = callPackage ./pkgs/godot {
    godotDesktopFile = godot-desktop-file;
    godotIconPNG = godot-icon-png;
    godotIconSVG = godot-icon-svg;
    godotManpage = godot-manpage;
  };
  godotMonoBin = callPackage ./pkgs/godot/mono.nix {
    godotBin = godotBin;
    godotDesktopFile = godot-desktop-file;
    godotIconPNG = godot-icon-png;
    godotIconSVG = godot-icon-svg;
    godotManpage = godot-manpage;
  };
}
      
