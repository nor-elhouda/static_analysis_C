open Asv_plugin

let contains_substring str substring =
  let re = Str.regexp_string substring in
  try ignore (Str.search_forward re str 0); true
  with Not_found -> false

let check_break_continue filename =
  let in_channel = open_in filename in
  let rec loop inside_loop flag =
    try
      let line = input_line in_channel in
      if contains_substring line "for" || contains_substring line "while" then
        loop true flag
      else if (contains_substring line "break" || contains_substring line "continue") && inside_loop && flag then begin
        Self.result "Found break or continue inside a loop:\n%s\n" line;
        loop inside_loop false
      end else
        if flag then
          loop inside_loop flag
        else
          ()
    with End_of_file -> ()
  in
  loop false true;
  close_in in_channel
