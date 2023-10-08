open Asv_plugin

let contains_assignment condition =
  Str.string_match (Str.regexp ".*\\(\\+=\\|\\-=\\|\\b=b\\|\\*=\\|/=\\|<<=\\|>>=\\|&=\\|^=\\||=\\|%=\\).*") condition 0


let check_for_loop_condition file_path =
  let file = open_in file_path in

  try
    let inside_for_loop = ref false in
    let line_number = ref 0 in  

    while true do
      let line = input_line file in
      let line_trimmed = String.trim line in

    
      line_number := !line_number + 1;

      if not !inside_for_loop && String.length line_trimmed >= 3 && String.sub line_trimmed 0 3 = "for" then begin
        inside_for_loop := true;
        let condition_start = try String.index line_trimmed ';' + 1 with Not_found -> 0 in
        let condition_end = try String.index_from line_trimmed condition_start ';' with Not_found -> 0 in
        let condition = String.sub line_trimmed condition_start (condition_end - condition_start) in
        
        let condition_contains_assignment = contains_assignment condition in

       
        Self.result "Line %d - For loop condition: %s\n" !line_number line_trimmed;
        if condition_contains_assignment then
          Self.result "Contains assignment.\n"
        else
          Self.result "Doesn't contain assignment.\n";

        let next_line = input_line file in
        let next_line_trimmed = String.trim next_line in
        if String.length next_line_trimmed > 0 && next_line_trimmed.[0] = '{' then
          Self.result "For loop body is enclosed between braces.\n"
        else begin
          Self.result "For loop body is NOT enclosed between braces.\n";
       
          let rec consume_until_closing_brace () =
            let next_line = input_line file in
            let next_line_trimmed = String.trim next_line in
            if String.length next_line_trimmed > 0 && String.contains next_line_trimmed '}' then
              Self.result "Found closing brace.\n"
            else
              consume_until_closing_brace ()
          in
          consume_until_closing_brace ();
        end;

        inside_for_loop := false;  
      end;
    done;
  with End_of_file ->
    close_in file;
    exit 0 

    