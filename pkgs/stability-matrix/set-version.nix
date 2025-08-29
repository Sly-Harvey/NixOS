{ pkgs, version ? "2.14.2" }:
let
  curl     = "${pkgs.curl}/bin/curl";
  jq       = "${pkgs.jq}/bin/jq";
  prefetch = "${pkgs.nix}/bin/nix-prefetch-url";  # flat file
in
pkgs.writeShellApplication {
  name = "update-stability-matrix-pin";
  runtimeInputs = [ ];
  text = ''
    set -euo pipefail
    repo_root="$(pwd)"

    repo="LykosAI/StabilityMatrix"
    ver="${version}"
    tag="v${version}"
    url="https://github.com/$repo/releases/download/''${tag}/StabilityMatrix-linux-x64.zip"

    echo "→ pinned tag: $tag"
    echo "→ prefetching (FLAT) $url ..."
    base32="$(${prefetch} "$url")"
    echo "→ sha256 (base32): $base32"

    printf '{ version = "%s"; sha256 = "%s"; }\n' "$ver" "$base32" > "$repo_root/pkgs/stability-matrix/source.nix"
    echo "✔ wrote $repo_root/pkgs/stability-matrix/source.nix"
  '';
}
