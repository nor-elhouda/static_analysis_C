open Str
(* Regular expression to match function declarations *)
let function_declaration_pattern = regexp "^[ \t]*[a-zA-Z_][a-zA-Z_0-9]*[ \t]+[a-zA-Z_][a-zA-Z_0-9]*[ \t]*\\(\\(.*\\)\\);$"

(* Regular expression to extract return type and function name from a declaration *)
let extract_return_type_and_name s =
  if string_match function_declaration_pattern s 0 then
    let return_type = matched_group 1 s in
    let function_name = matched_group 2 s in
    Some (return_type, function_name)
  else
    None

let check_prototype_return_type filename =
  let ic = open_in filename in
  try
    while true do
      let line = input_line ic in
      match extract_return_type_and_name line with
      | Some (return_type, function_name) ->
          if String.trim return_type = "" then
            Printf.printf "Function %s: Missing explicit return type\n" function_name
          else
            Printf.printf "Function %s: Explicit return type found\n" function_name
      | None -> ()
    done
  with End_of_file ->
    close_in ic
