open If_check
open Switch_ckeck
open While_check
open Break_continue
open For_check
open Data_types
open Subset_check
open Functions_check

let print_section_header header =
  print_endline ("\n---------------------------" ^ header ^ "-----------------------------")

let main file_path =
  print_endline "\n---------------------------ASV ANALYSIS-----------------------------";
  try
    if Asv_plugin.Enabled.get() then begin

      print_section_header "IF CHECK";
      check_if_conditions file_path;

      print_section_header "SWITCH CHECK";
      check_switch_and_default file_path;
      
      print_section_header "WHILE CHECK";
      check_while_loop file_path;

      print_section_header "BREAK CONTINUE CHECK";
      check_break_continue file_path;
    
      print_section_header "DATATYPES CHECK";
      check_typedefs file_path;
      
      print_section_header "subset CHECK";
      check_c_code file_path;

      print_section_header "Functions CHECK";
      check_prototype_return_type file_path;

      print_section_header "FOR check ";
      check_for_loop_condition file_path;

      Printf.printf "\n";
    end;
  with Sys_error _ as exc ->
    let msg = Printexc.to_string exc in
    Printf.eprintf "There was an error: %s\n" msg

let () =
  if Array.length Sys.argv < 2 then
    failwith "Usage: <program> <C_code_file_path>"
  else
    let file_path = Sys.argv.(1) in
    main file_path
