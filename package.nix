{
  lib,
  stdenv,
  fetchurl,
  appimageTools,
  autoPatchelfHook,
  makeWrapper,
  # linked
  alsa-lib,
  # dlopen()ed
  dbus,
  libGL,
  vulkan-loader,
  wayland,
  libx11,
  libxcb,
  libxcursor,
  libxi,
  libxrandr,
  libxkbcommon,
  libva,
}:

stdenv.mkDerivation rec {
  pname = "notecraft";
  version = "0.0.7";

  src = appimageTools.extract {
    pname = "notecraft";
    inherit version;
    src = fetchurl {
      url = "https://github.com/AlienTechSoftware/notecraft/releases/download/v${version}/notecraft-${version}-linux-x86_64.AppImage";
      hash = "sha256-hBPGLWS+pJVFV6WjHz+1GGaEi6Rg7A8AXRmv0C64QWI=";
    };
  };

  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];
  buildInputs = [ stdenv.cc.cc.lib alsa-lib ];

  runtimeDependencies = map lib.getLib [
    dbus
    libGL
    vulkan-loader
    wayland
    libx11
    libxcb
    libxcursor
    libxi
    libxrandr
    libxkbcommon
    libva
  ];

  appendRunpaths = [ "/run/opengl-driver/lib" ];
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 -t $out/bin usr/bin/*
    if [ -d usr/share ]; then cp -r usr/share $out/share; fi
    runHook postInstall
  '';

  # Some apps preflight their libraries with `ldconfig -p`, which can't see the
  # RPATH above (dlopen finds them fine), then warn or refuse to start.
  postFixup = ''
    for bin in $out/bin/*; do
      var="$(basename "$bin" | tr 'a-z-' 'A-Z_')_SKIP_LIB_CHECK"
      if grep -qa "$var" "$bin"; then
        wrapProgram "$bin" --set-default "$var" 1
      fi
    done
  '';

  meta = with lib; {
    description = "Note taking and organization; an open-source, clean-room reimplementation of Microsoft OneNote, rebuilt in pure Rust";
    homepage = "https://github.com/AlienTechSoftware/notecraft";
    license = with licenses; [ asl20 ];
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
    mainProgram = "notecraft";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
