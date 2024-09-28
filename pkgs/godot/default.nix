{ stdenv,
  lib,
  autoPatchelfHook,
  makeWrapper,
  fetchurl,
  unzip,
  udev,
  vulkan-loader, dbus, speechd, fontconfig,
  alsa-lib, libXcursor, libXinerama, libXrandr, libXrender, libX11, libXi,
  libpulseaudio, libGL, libXext, libXfixes, libxkbcommon
}:

let
  qualifier = "stable";
in

stdenv.mkDerivation rec {
  pname = "godot-bin";
  version = "4.3";

  src = fetchurl {
    url = "https://github.com/godotengine/godot-builds/releases/download/${version}-${qualifier}/Godot_v${version}-${qualifier}_linux.x86_64.zip";
    sha512 = "fd52bb4ba8acc30ca5accd1c566d470ad7282f891ccc0995dfafabcf92bcf76280ce182bf9d80ebd885f3ed2165d01e1fc3f2928436b15498dfbd98656c2a45a";
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
