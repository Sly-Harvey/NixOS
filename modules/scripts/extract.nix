{ pkgs, ... }:
pkgs.writeShellScriptBin "ex" ''
  if [ -z "$1" ]; then
     # display usage if no parameters given
     echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
     echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
     echo "       For password-protected files: EX_PASSWORD=yourpassword extract file.rar"
  else
     for n in "$@"
     do
       if [ -f "$n" ] ; then
           case "''${n%,}" in
             *.cbt|*.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
             ${pkgs.gnutar}/bin/tar xvf "$n"       ;;
             *.lzma)      unlzma ./"$n"      ;;
             *.bz2)       bunzip2 ./"$n"     ;;
             *.cbr|*.rar)
                 if [ -n "$EX_PASSWORD" ]; then
                     ${pkgs.unrar}/bin/unrar x -ad -p"$EX_PASSWORD" ./"$n"
                 else
                     ${pkgs.unrar}/bin/unrar x -ad ./"$n"
                 fi ;;
             *.gz)        gunzip ./"$n"      ;;
             *.cbz|*.epub|*.zip)
                 if [ -n "$EX_PASSWORD" ]; then
                     ${pkgs.unzip}/bin/unzip -P "$EX_PASSWORD" ./"$n"
                 else
                     ${pkgs.unzip}/bin/unzip ./"$n"
                 fi ;;
             *.z)         uncompress ./"$n"  ;;
             *.7z|*.arj|*.cab|*.cb7|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.pkg|*.rpm|*.udf|*.wim|*.xar)
                 if [ -n "$EX_PASSWORD" ]; then
                     ${pkgs.p7zip}/bin/7z x -p"$EX_PASSWORD" ./"$n"
                 else
                     ${pkgs.p7zip}/bin/7z x ./"$n"
                 fi ;;
             *.xz)        unxz ./"$n"        ;;
             *.exe)       cabextract ./"$n"  ;;
             *.cpio)      cpio -id < ./"$n"  ;;
             *.cba|*.ace)      unace x ./"$n"      ;;
             *)
             echo "Unsupported format"
             return 1
             ;;
           esac
       else
           echo "'$n' - file does not exist"
           return 1
       fi
     done
  fi
''
