{ lib, stdenvNoCC, fetchFromGitHub, python3, librsvg, xcursorgen }:

stdenvNoCC.mkDerivation {
  pname = "bibata-modern-ice";
  version = "1.1.0-unstable-2026-10-31";

  src = fetchFromGitHub {
    owner = "rtgiskard";
    repo = "Bibata_Cursor";
    rev = "8c4c0f566562c92ad6a868c07e291cd2cfca12b6";
    hash = "sha256-QYv2pEvQwgL7YrEToWHArTRliS54KquGBjAxISaU72A=";
  };

  nativeBuildInputs = [
    python3
    librsvg
    xcursorgen
  ];

  dontConfigure = true;
  buildPhase = ''
    runHook preBuild

    python3 src/cursor_utils.py --svg --x11 --x11-symlink all \
      --theme Bibata-Modern-Ice --out-dir themes --log-level error

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    cp -a themes/Bibata-Modern-Ice $out/share/icons/

    runHook postInstall
  '';

  meta = {
    description = "Bibata Cursor, with support for hyprcursor and Xcursor";
    homepage = "https://github.com/rtgiskard/Bibata_Cursor";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
  };
}
