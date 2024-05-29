{ stdenv,
  lib,
  autoPatchelfHook,
  makeWrapper,
  fetchurl,
  unzip,
  udev,
  vulkan-loader, dbus, speechd, fontconfig,
  alsa-lib, libXcursor, libXinerama, libXrandr, libXrender, libX11, libXi,
  libpulseaudio, libGL, libXext, libXfixes, libxkbcommon,
  godotDesktopFile,
  godotIconPNG,
  godotIconSVG,
  godotManpage
}:

let
  qualifier = "stable";
in

stdenv.mkDerivation rec {
  pname = "godot-bin";
  version = "4.2.2";

  src = fetchurl {
    url = "https://github.com/godotengine/godot-builds/releases/download/${version}-${qualifier}/Godot_v${version}-${qualifier}_linux_x86_64.zip";
    sha512 = "4c0294f437b97cf14f848d921ed028cb6e100ebbfcf6480f2d50292d001221cf29cda73f0a96a8c0e80b145b65cdbf7e422252dbbe17e79d883753e500306276";
  };

  nativeBuildInputs = [autoPatchelfHook makeWrapper unzip];

  buildInputs = [
    udev
    alsa-lib
    libXcursor
    libXinerama
    libXrandr
    libXrender
    libX11
    libXi
    libXext
    libXfixes
    libxkbcommon
    libpulseaudio
    libGL
    vulkan-loader
    dbus
    dbus.lib
    speechd
    fontconfig
    fontconfig.lib
  ];

  libraries = lib.makeLibraryPath buildInputs;

  unpackCmd = "unzip $curSrc -d source";
  installPhase = ''
    mkdir -p $out/bin
    install -m 0755 Godot_v${version}-${qualifier}_linux.x86_64 $out/bin/godot

    # Only create a desktop file, if the necessary variables are set
    # these are set only, if one installs this program using flakes.
    if [[ -f "${godotDesktopFile}" ]]; then
      mkdir -p "$out/man/share/man/man6"
      cp ${godotManpage} "$out/man/share/man/man6/"

      mkdir -p $out/share/{applications,icons/hicolor/scalable/apps}
      cp ${godotDesktopFile} "$out/share/applications/org.godotengine.Godot.desktop"
      cp ${godotIconSVG} "$out/share/icons/hicolor/scalable/apps/godot.svg"
      cp ${godotIconPNG} "$out/share/icons/godot.png"
      substituteInPlace "$out/share/applications/org.godotengine.Godot.desktop" \
        --replace "Exec=godot" "Exec=$out/bin/godot"
    fi
  '';

  postFixup = ''
    wrapProgram $out/bin/godot \
      --set LD_LIBRARY_PATH ${libraries}
  '';

  meta = {
    homepage    = "https://godotengine.org";
    description = "Free and Open Source 2D and 3D game engine";
    license     = lib.licenses.mit;
    platforms   = [ "x86_64-linux" ];
    maintainers = [ lib.maintainers.twey ];
  };
}
