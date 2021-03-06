(******************************************************************************)
(* OASIS: architecture for building OCaml libraries and applications          *)
(*                                                                            *)
(* Copyright (C) 2011-2013, Sylvain Le Gall                                   *)
(* Copyright (C) 2008-2011, OCamlCore SARL                                    *)
(*                                                                            *)
(* This library is free software; you can redistribute it and/or modify it    *)
(* under the terms of the GNU Lesser General Public License as published by   *)
(* the Free Software Foundation; either version 2.1 of the License, or (at    *)
(* your option) any later version, with the OCaml static compilation          *)
(* exception.                                                                 *)
(*                                                                            *)
(* This library is distributed in the hope that it will be useful, but        *)
(* WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY *)
(* or FITNESS FOR A PARTICULAR PURPOSE. See the file COPYING for more         *)
(* details.                                                                   *)
(*                                                                            *)
(* You should have received a copy of the GNU Lesser General Public License   *)
(* along with this library; if not, write to the Free Software Foundation,    *)
(* Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA              *)
(******************************************************************************)

(* Compile OASIS itself using the version under tests. *)

open OUnit2
open TestCommon

let tests = 
  "SelfCompile" >::
  (fun test_ctxt ->
     let pwd = FileUtil.pwd () in
     let src_dir = Filename.dirname pwd in
     let in_src_dir fn = Filename.concat src_dir fn in
     let () = 
       skip_if
         (Sys.os_type <> "Unix" || not (Sys.file_exists (in_src_dir ".git")))
         "Only compile for particular dev configurations."
     in
     let tmpdir = bracket_tmpdir test_ctxt in
     (* List all files that should be copied. *)
     let is_ignored = 
       let ignore_dot_git fn' =
         OASISString.starts_with ~what:(in_src_dir ".git") fn'
       in
       let rlst = ref [ignore_dot_git] in
       let chn = open_in (in_src_dir ".gitignore") in
       let () = 
         try 
           while true do 
             let fn = in_src_dir (input_line chn) in
             let test fn' = OASISString.starts_with ~what:fn fn' in
             rlst := test :: !rlst
           done;
         with End_of_file ->
           ()
       in
         close_in chn;
         fun fn -> 
           List.exists (fun test -> test fn) !rlst
     in
     let files =
       FileUtil.find FileUtil.Is_file src_dir (fun lst fn -> fn :: lst) []
     in
     (* Copy all files to a temporary directory. *)
     let () =
       List.iter
         (fun fn ->
            if not (is_ignored fn) then begin
              let target_fn = FilePath.reparent src_dir tmpdir fn in
              let dn = Filename.dirname target_fn in
              logf test_ctxt `Info "Copy %s -> %s." fn target_fn;
              if not (Sys.file_exists dn) then
                FileUtil.mkdir ~parent:true dn;
              FileUtil.cp [fn] target_fn
            end)
         files
     in
       (* Regenerate setup.ml and try to compile. *)
       assert_oasis_cli ~ctxt:test_ctxt ~chdir:src_dir ["setup"];
       assert_command ~ctxt:test_ctxt ~chdir:src_dir
         "ocaml" ["setup.ml"; "-configure";
                  "--override"; "is_native"; string_of_bool (is_native test_ctxt);
                  "--override"; "native_dynlink"; string_of_bool (native_dynlink test_ctxt)];
       assert_command ~ctxt:test_ctxt ~chdir:src_dir
         "ocaml" ["setup.ml"; "-build"])
