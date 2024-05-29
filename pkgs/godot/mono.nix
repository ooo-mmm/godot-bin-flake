{ 
  fetchurl,
  godotBin,
  zlib,
  dotnet-sdk_8,
  godotDesktopFile,
  godotIconPNG,
  godotIconSVG,
  godotManpage
}:

let
  qualifier = "stable";
in

godotBin.overrideAttrs (oldAttrs: rec {
  pname = "godot-mono-bin";
  version = "4.2.2";

  src = fetchurl {
    url = "https://github.com/godotengine/godot-builds/releases/download/${version}-${qualifier}/Godot_v${version}-${qualifier}_mono_linux_x86_64.zip";
    sha512 = "9e38f41785c92c27ce08d5f197be66e167fc5b402d345c6bd06968deecce276b2817d1eabb96c17d3bd21759403f7c29f1cf6acf6f52062786ad84fa507b30b5";
  };

  buildInputs = oldAttrs.buildInputs ++ [zlib dotnet-sdk_8];

  unpackCmd = "";
  installPhase = ''
    mkdir -p $out/bin $out/opt/godot-mono

    install -m 0755 Godot_v${version}-${qualifier}_mono_linux.x86_64 $out/opt/godot-mono/Godot_v${version}-${qualifier}_mono_linux.x86_64
    cp -r GodotSharp $out/opt/godot-mono

    ln -s $out/opt/godot-mono/Godot_v${version}-${qualifier}_mono_linux.x86_64 $out/bin/godot-mono

    # Only create a desktop file, if the necessary variables are set
    # these are set only, if one installs this program using flakes.
    if [[ -f "${godotDesktopFile}" ]]; then
      mkdir -p "$out/man/share/man/man6"
      cp ${godotManpage} "$out/man/share/man/man6/"

      mkdir -p $out/share/{applications,icons/hicolor/scalable/apps}
      cp ${godotDesktopFile} "$out/share/applications/org.godotengine.Godot-Mono.desktop"
      cp ${godotIconSVG} "$out/share/icons/hicolor/scalable/apps/godot.svg"
      cp ${godotIconPNG} "$out/share/icons/godot.png"
      substituteInPlace "$out/share/applications/org.godotengine.Godot-Mono.desktop" \
        --replace "Exec=godot" "Exec=$out/bin/godot-mono"
    fi
  '';

  postFixup = ''
    wrapProgram $out/bin/godot-mono \
      --set LD_LIBRARY_PATH ${oldAttrs.libraries} \
      --set PATH ${dotnet-sdk_8}/bin:$PATH    
  '';
})
