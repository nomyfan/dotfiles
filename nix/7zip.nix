{ stdenv, fetchzip }:

let
  sys = builtins.currentSystem;
  dist = ({
    "aarch64-darwin" = {
      url = "https://www.7-zip.org/a/7z2301-mac.tar.xz";
      sha256 = "1zig2n025knsradnpnhxqba13d7rrrkga708nmlhgg6fmi45knim";
    };
    "x86_64-darwin" = {
      url = "https://www.7-zip.org/a/7z2301-mac.tar.xz";
      sha256 = "1zig2n025knsradnpnhxqba13d7rrrkga708nmlhgg6fmi45knim";
    };
    "aarch64-linux" = {
      url = "https://www.7-zip.org/a/7z2301-linux-arm64.tar.xz";
      sha256 = "1z7jkw267cb8d8cngx266di20xmrjn2x8hn9r3hmlyc8y0hk09vd";
    };
    "x86_64-linux" = {
      url = "https://www.7-zip.org/a/7z2301-linux-x64.tar.xz";
      sha256 = "1qsjllx96z22ij48pgpq7qf9dpvbc9y28x563dk700pj4g36wcyr";
    };
    "i686-linux" = {
      url = "https://www.7-zip.org/a/7z2301-linux-x86.tar.xz";
      sha256 = "04hqcpvbq3zcjjbs31nfz14fq08pdfzy88hc2j1aqfpdvpv1iji9";
    };
  })."${sys}";
in
stdenv.mkDerivation rec {
  name = "7zip";
  version = "23.01";
  system = sys;
  src = fetchzip {
    url = dist.url;
    sha256 = dist.sha256;
    stripRoot = false;
  };
  installPhase = ''
    mkdir -p $out/bin
    cp $src/7zz $out/bin
  '';
}
