open Asv_plugin

let check_if_conditions filename =
  let in_channel = open_in filename in
  let if_statements = ref 0 in
  let has_assignments = ref false in
  let missing_else_lines = ref [] in
  
  let if_found = ref false in
  let else_if_found = ref false in
  let else_found = ref false in

  (* Define the function to check for assignments in a condition. *)
  let contains_assignments condition =
    Str.string_match (Str.regexp ".*\\(\\+=\\|\\-=\\|\\ = \\|\\*=\\|/=\\|<<=\\|>>=\\|&=\\|^=\\||=\\|%=\\).*") condition 0
  in

  let rec loop line_number =
    try
      let line = input_line in_channel in
      if Str.string_match (Str.regexp ".*\\bif\\s* (.*") line 0 then begin
        if_statements := !if_statements + 1;
        if_found := true;
        let start_pos = try String.index line '(' + 1 with Not_found -> 0 in
        let condition = String.sub line start_pos (String.length line - start_pos) in
        if contains_assignments condition then (
          has_assignments := true;
          Self.result "The 'if' condition contains assignments:\n";
          print_endline condition;
        ) 
      end;
      if Str.string_match (Str.regexp ".*\\belse if\\s*\\(.*\\)") line 0 then
        else_if_found := true
      else if Str.string_match (Str.regexp ".*\\belse\\s*") line 0 then
        else_found := true
      else 
        missing_else_lines := line_number - 1 :: !missing_else_lines;

      
      loop (line_number + 1)
    with End_of_file -> ()
  in

  loop 1;
  close_in in_channel;

  if !if_found then  
    Self.result "If statement found\n";
    if !has_assignments then
       Self.result "  Contains assignments.\n";
  if !if_found then begin
   if !else_if_found then begin
    
    if !else_found then
      Self.result "  Has a final 'else'.\n"
    else
      if List.length !missing_else_lines > 0 then begin
        Self.result "Some 'else if' statements have missing 'else' statements";
        end;
      Self.result "Doesn't have a final 'else'.\n";
   end else
    Self.result "Doesn't contain an 'else if'.\n";
    end else
  Self.result "Total 'if' statements found: %d\n" !if_statements;
  