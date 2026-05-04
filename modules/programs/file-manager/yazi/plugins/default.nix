{ lib }:
let
  luaFiles = builtins.readDir ./.;

  readLuaFile = name: builtins.readFile (./. + "/${name}");

  luaContent = lib.concatStringsSep "\n\n" (
    lib.mapAttrsToList (
      name: type: if type == "regular" && lib.hasSuffix ".lua" name then readLuaFile name else ""
    ) luaFiles
  );

  cleanedContent = lib.concatStringsSep "\n\n" (
    lib.filter (s: s != "") (lib.splitString "\n\n" luaContent)
  );
in
cleanedContent
