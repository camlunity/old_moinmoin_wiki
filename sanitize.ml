#use "topfind";;

#require "fileutils";;

open FilePath
;;
open FileUtil
;;

let current_revision dir =
  let current = concat dir "current" in
  if test Exists current
  then
    let ch = open_in current in
    let latest = input_line ch in
    let () = close_in ch in
    Some latest
  else None
;;

let copy_latest wd dir latest =
  let source = concat (concat dir "revisions") latest in
  let basename = basename dir in
  let target = add_extension (concat wd basename) "moinmoin" in
  let () = cp ~force:Force ([source]) target
  in ()
;;

let move_folder dir trash =
  mv ~force:Force dir (concat trash dir)
;;

let walk_func wd trash = fun d ->
  let () = match current_revision d with
    | Some latest -> copy_latest wd d latest
    | None -> ()
  in
  move_folder d trash
;;

let main () =
  let tdir = concat current_dir "pages" in
  let is_vdir s =String.get (basename s) 0 <> '_' && test Is_dir s in
  let dirs = List.filter is_vdir (ls tdir) in
  let trash = concat tdir "_sanitize" in
  List.iter (walk_func tdir trash) dirs
;;

let () = main ()
;;
