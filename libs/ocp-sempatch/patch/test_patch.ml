open Ppx_patch
(* open Ast_helper *)
open Ast_filter

let () =
  let patch =
    []
    >> filter_simple (limit_to_def_of "test1")
       ->> make_fun_call "f" (Ast_helper.Exp.constant ( Asttypes.Const_int 1))
    >> filter_simple (limit_to_def_of "test2")
       ->> rename_var "y" "x"
    >> filter_simple (limit_to_def_of "test3")
       ->> add_arg_fun "f" "x"
       ->> make_fun_call "f" (Ast_helper.Exp.constant ( Asttypes.Const_int 2))
    >> filter_simple (limit_to_def_of "test4")
       ->> insert_open "List"
    >> filter Ast_filter.(Test (limit_to_def_of "test5")
                          &@ Test(limit_to_scope_of "x")
                         )
       ->> rename_var ~rename_def:false "y" "x"
    >> filter Ast_filter.(Test (limit_to_scope_of "foo")
                          |@ Test(limit_to_scope_of "bar")
                         )
       ->> rename_var ~rename_def:false "y" "x"
    >> filter Ast_filter.((Test (limit_to_def_of "test7")
                            &@ Test(limit_to_scope_of "x")
                            &@ (not_ @@ Test(limit_to_scope_of "y"))
                          ))
       ->> rename_var ~rename_def:false "y" "x"
  in register "patch" patch
