(******************************************************************************)
(* OASIS: architecture for building OCaml libraries and applications          *)
(*                                                                            *)
(* Copyright (C) 2008-2010, OCamlCore SARL                                    *)
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

(** File generated using environment variables

    This is the same kind of file as .in file for autoconf, except we
    use the variable definition of [Buffer.add_substitute]. This is
    the default file to be generated by configure step (even for
    autoconf, except that it produce a master file before).

    The file must end with '.ab'.

    @author Sylvain Le Gall
  *)

open OASISTypes

(** Compute the target filename of an .ab file.
  *)
val to_filename : unix_filename -> host_filename

(** Replace variable in file %.ab to generate %.
  *)
val replace : unix_filename list -> unit
