open Asv_plugin

let contains_assignments condition =
  Str.string_match (Str.regexp ".*\\(\\+=\\|\\-=\\|\\b=b\\|\\*=\\|/=\\|<<=\\|>>=\\|&=\\|^=\\||=\\|%=\\).*") condition 0

let check_while_loop file_path =
  let file = open_in file_path in
  let rec read_lines () =
    try
      let line = input_line file in
      let while_found = ref false  in 
      if Str.string_match (Str.regexp ".*\\bwhile\\s*\\(.*\\)") line 0 then (
        while_found :=true;
        let brace_count = ref 0 in
        let start_pos = String.index line '(' + 1 in
        let condition = String.sub line start_pos (String.length line - start_pos) in

        if contains_assignments condition then (
          Self.result "The while loop condition contains assignments:";
          print_endline condition;
        );

        if not ( String.contains line '{' || String.contains line '}') then (
          
          Self.result "Warning: The while loop does not have a body enclosed in braces!";
          print_endline line;
          while_found := false;
        )
        else (
          incr brace_count;
          let lines_acc = ref [line] in

          while !brace_count > 0 do
            let next_line = input_line file in
            if String.contains next_line '{' then incr brace_count;
            if String.contains next_line '}' then decr brace_count;
            lines_acc := next_line :: !lines_acc;
          done;

      
        );
      );

      read_lines ()
    with
    | End_of_file -> close_in file;
                     Self.result "Finished checking ."

    in
     read_lines ()
 