open Asv_plugin
let check_c_code filename =
  let in_channel = open_in filename in
  let misra_goto_used = ref false in
  let trigraph_sequences_used = ref false in
  let non_stdarg_libraries_used = ref false in
  let ternary_operator_used = ref false in

  let check_line line =
    (* Check for the use of 'goto' keyword *)
    if Str.string_match (Str.regexp ".*\\bgoto\\b.*") line 0 then
      misra_goto_used := true;

    (* Check for the use of trigraph sequences *)
    if Str.string_match (Str.regexp ".*\\(\\b??=b\\|\\b??(b\\|\\b??/b\\|\\b??)b\\|\\b??'b\\|\\b??<b\\|\\b??!b\\|\\b??>b\\|\\b??-b\\).*") line 0 then
      trigraph_sequences_used := true;

    (* Check for the use of non-stdarg C99 libraries *)
    if Str.string_match (Str.regexp ".*\\b\\(printf\\|scanf\\|malloc\\|free\\|etc.\\)\\b.*") line 0 then
      non_stdarg_libraries_used := true;

    (* Check for the use of ternary operator *)
    if Str.string_match (Str.regexp ".*\\?.*") line 0 then
      ternary_operator_used := true;
  in

  try
    let rec loop line_number =
      let line = input_line in_channel in
      check_line line;
      loop (line_number + 1)
    in
    loop 1
  with End_of_file -> close_in in_channel;

  (* Print the results *)
  if !misra_goto_used then
    Self.result "Error: The code contains the 'goto' keyword.\n";

  if !trigraph_sequences_used then
    Self.result "Error: The code contains the C99 trigraph sequences.\n";

  if !non_stdarg_libraries_used then
    Self.result "Error: The code uses non-stdarg C99 standard libraries.\n";

  if !ternary_operator_used then
    Self.result "Error: The code uses the ternary operator.\n";

  if not (!misra_goto_used || !trigraph_sequences_used || !non_stdarg_libraries_used || !ternary_operator_used) then
    Self.result "The code passes all the checks.\n"
;;


