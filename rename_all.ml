#use "topfind";;

#require "fileutils";;

open FilePath
;;
open FileUtil
;;

let main () =
  let tdir = concat current_dir "pages" in
  let is_wiki p = check_extension p "wiki" in
  let files = List.filter is_wiki (ls tdir) in
  let rename p = mv p (replace_extension p "moinmoin") in
  List.iter rename files
;;

let () = main ()
;;
