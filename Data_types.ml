

(* Check if a string matches a regular expression *)
let matches_regex str regex =
  try
    let _ = Str.search_forward regex str 0 in
    true
  with Not_found -> false

(* Function to process a line and check for type suffix *)
let process_line line =
  let type_suffixes = [ "_t"; "_f"; "_e" ] in
  let suffix_matched =
    List.fold_left
      (fun acc suffix -> acc || matches_regex line (Str.regexp_string suffix))
      false
      type_suffixes
  in
  if suffix_matched then
    Printf.printf "no  violation: %s\n" line
 
(* Function to check type naming conventions in a C file *)
let check_typedefs file_path =
  try
    let ic = open_in file_path in
    try
      while true do
        let line = input_line ic in
        process_line line
      done
    with End_of_file ->
      close_in ic
  with Sys_error msg ->
    Printf.eprintf "Error: %s\n" msg
