# modules/athena/default.nix
{ lib, pkgs, inputs, athenaRole ? [ ], ... }:

let
  pkgSkipName = [ "zssh" ];

  # use upstream path that exists at eval time
  rolesDir = inputs.athena-nix + "/nixos/modules/cyber/roles";
  haveRolesDir = builtins.pathExists rolesDir;

  entries   = if haveRolesDir then builtins.readDir rolesDir else {};
  roleFiles = lib.filterAttrs (n: t: t == "regular" && lib.hasSuffix ".nix" n) entries;
  available = map (n: lib.removeSuffix ".nix" n) (builtins.attrNames roleFiles);

  selected =
    if lib.elem "all" athenaRole then available
    else lib.intersectLists available athenaRole;

  getPkgs = role:
    let p = rolesDir + ("/" + role + ".nix");
        e = import p;
        v = if builtins.isFunction e then e { inherit pkgs; } else e;
    in if builtins.isList v then v
       else if builtins.isAttrs v && v ? packages then v.packages
       else throw "athena: role '${role}' must yield a package list";

  flatPkgs  = lib.unique (lib.concatLists (map getPkgs selected));
  finalPkgs = builtins.filter (d:
    let n = d.pname or (lib.getName d);
    in !(lib.elem n pkgSkipName)
  ) flatPkgs;
in
{
  environment.systemPackages = finalPkgs;

  # keep local copy symlinked to upstream (still happens at activation time)
  home-manager.sharedModules = [
    ({ ... }: {
      home.file."NixOS/modules/athena/cyber/".source = "${inputs.athena-nix}/nixos/modules/cyber/";
      home.file."NixOS/modules/athena/cyber/".recursive = true;
      home.file."NixOS/modules/athena/cyber/".force = true;
    })
  ];

  # only assert if roles actually exist but none were selected
  assertions = lib.optional (haveRolesDir && available != []) {
    assertion = selected != [ ];
    message =
      "athena: no roles matched. requested="
      + (builtins.toString athenaRole)
      + " available=" + (builtins.toString available);
  };
}
