{ stdenv, fetchurl, libjxl }:

stdenv.mkDerivation {
  pname = "macbook-pro-late-black";
  version = "1.0";

  src = fetchurl {
    url = "https://public-store.s3.eu-central-lz-buh-a.cloud.ovh.net/wallpapers/2023-MacBook-Pro-Late-Black.png";
    hash = "sha256-j587j1jc7Hl3UikzVC0Wyk7O+NyZRe9yLbXrambTLoU=";
  };

  nativeBuildInputs = [ libjxl ];
  dontUnpack = true;

  buildPhase = ''
    runHook preBuild
    cjxl "$src" macbook-pro-late-black.jxl
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    cp macbook-pro-late-black.jxl "$out"
    runHook postInstall
  '';
}
