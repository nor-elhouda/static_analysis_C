open Asv_plugin
  let check_switch_and_default filename =
  let in_channel = open_in filename in
  let switch_found = ref false in
  let switch_space = ref false in
  let default_found = ref false in
  let case_count = ref 0 in
  let case_found = ref false in
  let default_case_line = ref (-1) in
  let missing_break_lines = ref [] in
  let inside_default_case = ref false in
  let default_count = ref 0 in

  let rec loop line_number =
    try
      let line = input_line in_channel in
      if Str.string_match (Str.regexp ".*\\bswitch\\s* (.*") line 0 then
        switch_found := true;

      if Str.string_match (Str.regexp ".*\\bswitch\\s*(.*") line 0 then
         switch_space := true;
        
      if !switch_found && Str.string_match (Str.regexp ".*\\bdefault\\s*:.*") line 0 then begin
        default_found := true;
        default_count :=  !default_count+1;
        default_case_line := line_number;
         inside_default_case := true;
      if  !case_found then begin
       missing_break_lines := line_number-1 :: !missing_break_lines;
       end;

      end;

      if !switch_found && Str.string_match (Str.regexp ".*\\bcase\\b.*") line 0 then begin

        case_count := !case_count + 1;
       if  !case_found then begin
       missing_break_lines := line_number-1 :: !missing_break_lines;
       end;

        case_found := true;

  end;

    if !case_found && (Str.string_match (Str.regexp ".*\\bbreak\\b.*;.*") line 0) then begin
        case_found := false;

        end;

    if !inside_default_case && (Str.string_match (Str.regexp "}") line 0) then begin

        missing_break_lines := line_number-1 :: !missing_break_lines;
        inside_default_case := false;
      end;

    if !inside_default_case && (Str.string_match (Str.regexp ".*\\bbreak\\b.*;.*") line 0) then begin
        inside_default_case := false;

        end;

      loop (line_number + 1)
    with End_of_file -> ()
  in

  loop 1;
  close_in in_channel;

  if !switch_found then begin
    Self.result "The C code contains 'switch' statement .\n";
    if !default_found then begin
      Self.result "The 'switch' statement contains %d 'default' case in line %d.\n" !default_count !default_case_line;
      if !case_count > 0 then
        Self.result "The 'switch' statement has %d case(s) in addition to the 'default' case.\n" !case_count
      else
        Self.result "The 'switch' statement does not have any case in addition to the 'default' case.\n";

      if List.length !missing_break_lines > 0 then begin
        Self.result "The 'switch' statement has non-empty cases with 'break' statements in lines: ";
        List.iter (fun line -> Printf.printf "%d, " line) (List.rev !missing_break_lines);
        Printf.printf "\n";
      end else
        Self.result "The 'switch' statement has non-empty cases without 'break' statements.\n";
    end else
      Self.result "The 'switch' statement does not contain a 'default' case.\n";

  end else
      if !switch_space then begin
        Self.result"the switch should have a space before the condition\n"
      end else
    Self.result "The C code does not contain a 'switch' statement.\n"
