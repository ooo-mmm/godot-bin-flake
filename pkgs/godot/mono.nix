{ 
  fetchurl,
  godotBin,
  zlib,
  dotnet-sdk_8
}:

let
  qualifier = "stable";
  username = builtins.getEnv "USER";
in

godotBin.overrideAttrs (oldAttrs: rec {
  pname = "godot-mono-bin";
  version = "4.3";

  src = fetchurl {
    url = "https://github.com/godotengine/godot-builds/releases/download/${version}-${qualifier}/Godot_v${version}-${qualifier}_mono_linux_x86_64.zip";
    sha512 = "33d0539bc368ff6f30b5f15d64ec893da8639bd607df83050b5df746c3d30da99238c26dd03a16d7fe31b3a3e58680aeb5545af8784d8ce01edeff07b061ac80";
  };

  buildInputs = oldAttrs.buildInputs ++ [zlib dotnet-sdk_8];

  unpackCmd = "";
  installPhase = ''
    mkdir -p $out/bin $out/opt/godot-mono

    install -m 0755 Godot_v${version}-${qualifier}_mono_linux.x86_64 $out/opt/godot-mono/Godot_v${version}-${qualifier}_mono_linux.x86_64
    cp -r GodotSharp $out/opt/godot-mono

    ln -s $out/opt/godot-mono/Godot_v${version}-${qualifier}_mono_linux.x86_64 $out/bin/godot-mono
  '';

  postFixup = ''
    wrapProgram $out/bin/godot-mono \
      --set LD_LIBRARY_PATH ${oldAttrs.libraries} \
      --set PATH ${dotnet-sdk_8}/bin:$PATH \
      --set PATH "/home/${username}/.nuget/packages":$PATH
  '';
})
