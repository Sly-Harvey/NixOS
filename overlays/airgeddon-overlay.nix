# overlays/airgeddon-overlay.nix
self: super:
let
  srcAtTag = super.fetchFromGitHub {
    owner = "v1s1t0r1sh3r3";
    repo  = "airgeddon";
    rev   = "v${super.airgeddon.version}";
    # Update the hash after app update
    sha256 = "sha256-PkP8sPpX/z3yjvTpsRYJ9fKzUaMsnCp+p6AAoTlcAA0=";
  };
  langPath = "${srcAtTag}/languages/language_strings.sh";  # old tags may be at repo root; we handle both
in {
  airgeddon = super.airgeddon.overrideAttrs (old: {
    pname = "airgeddon-with-lang";
    nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ super.makeWrapper ];
    postInstall = (old.postInstall or "") + ''
      set -eu
      if [ -f "${langPath}" ]; then
        src_lang="${langPath}"
      elif [ -f "${srcAtTag}/language_strings.sh" ]; then
        src_lang="${srcAtTag}/language_strings.sh"
      else
        echo "language_strings.sh not found in tag v${super.airgeddon.version}" >&2
        exit 1
      fi

      install -Dm644 "$src_lang" "$out/share/airgeddon/languages/language_strings.sh"
      install -Dm644 "$src_lang" "$out/bin/language_strings.sh"

      # Point the script at the vendored file and block self-writes
      for f in "$out/bin/airgeddon" "$out/bin/.airgeddon-wrapped"; do
        [ -f "$f" ] || continue
        substituteInPlace "$f" \
          --replace "./languages/language_strings.sh" "$out/bin/language_strings.sh" \
          --replace "languages/language_strings.sh"   "$out/bin/language_strings.sh" \
          --replace "bin/language_strings.sh"         "$out/bin/language_strings.sh" \
          --replace '$scriptdir/language_strings.sh'  "$out/bin/language_strings.sh" || true
      done

      wrapProgram "$out/bin/airgeddon" \
        --set AIRGEDDON_LANGFILE "$out/bin/language_strings.sh" \
        --set AIRGEDDON_LANGDIR  "$out/share/airgeddon/languages" \
        --set AIRGEDDON_NO_SELF_UPDATE "1"
    '';
  });
}
