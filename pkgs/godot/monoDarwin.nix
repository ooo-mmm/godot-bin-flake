{ 
  stdenv,
  lib,
  makeWrapper,
  fetchurl,
  unzip,
  zlib,
  dotnet-sdk_8
}:

let
  qualifier = "stable";
  username = builtins.getEnv "USER";
in

stdenv.mkDerivation rec {
  pname = "godot-mono-bin";
  version = "4.3";

  src = fetchurl {
    url = "https://github.com/godotengine/godot-builds/releases/download/${version}-${qualifier}/Godot_v${version}-${qualifier}_mono_macos.universal.zip";
    sha512 = "71eed3a033cef64f814ba2d14389780d30c558ecc9a216582cfe44dcbeaed3f3c26100da461590fc87dd3e8fdb53a19b6ac03720eb9140e9d1d0639c2be8493a";
  };

  nativeBuildInputs = [makeWrapper unzip];

  buildInputs = [zlib dotnet-sdk_8];
  libraries = lib.makeLibraryPath buildInputs;

  unpackCmd = "unzip $curSrc -d source";
  installPhase = ''
    mkdir -p $out/bin

    install -m 0755 Godot_mono $out/bin/godot-mono
  '';

  postFixup = ''
    wrapProgram $out/bin/godot-mono \
      --set LD_LIBRARY_PATH ${libraries} \
      --set PATH ${dotnet-sdk_8}/bin:$PATH \
      --set PATH "/Users/${username}/.nuget/packages":$PATH
  '';

  meta = {
    homepage    = "https://godotengine.org";
    description = "Free and Open Source 2D and 3D game engine";
    license     = lib.licenses.mit;
    platforms   = [ "aarch64-darwin" ];
    maintainers = [ "vg" ];
  };
}
