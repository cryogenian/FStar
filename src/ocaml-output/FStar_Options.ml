
open Prims
type debug_level_t =
| Low
| Medium
| High
| Extreme
| Other of Prims.string

let is_Low = (fun _discr_ -> (match (_discr_) with
| Low -> begin
true
end
| _ -> begin
false
end))

let is_Medium = (fun _discr_ -> (match (_discr_) with
| Medium -> begin
true
end
| _ -> begin
false
end))

let is_High = (fun _discr_ -> (match (_discr_) with
| High -> begin
true
end
| _ -> begin
false
end))

let is_Extreme = (fun _discr_ -> (match (_discr_) with
| Extreme -> begin
true
end
| _ -> begin
false
end))

let is_Other = (fun _discr_ -> (match (_discr_) with
| Other (_) -> begin
true
end
| _ -> begin
false
end))

let ___Other____0 = (fun projectee -> (match (projectee) with
| Other (_21_4) -> begin
_21_4
end))

let show_signatures = (FStar_Util.mk_ref [])

let norm_then_print = (FStar_Util.mk_ref true)

let z3_exe = (let _87_19 = (FStar_Platform.exe "z3")
in (FStar_Util.mk_ref _87_19))

let silent = (FStar_Util.mk_ref false)

let debug = (FStar_Util.mk_ref [])

let debug_level = (FStar_Util.mk_ref [])

let dlevel = (fun _21_1 -> (match (_21_1) with
| "Low" -> begin
Low
end
| "Medium" -> begin
Medium
end
| "High" -> begin
High
end
| "Extreme" -> begin
Extreme
end
| s -> begin
Other (s)
end))

let one_debug_level_geq = (fun l1 l2 -> (match (l1) with
| (Other (_)) | (Low) -> begin
(l1 = l2)
end
| Medium -> begin
((l2 = Low) || (l2 = Medium))
end
| High -> begin
(((l2 = Low) || (l2 = Medium)) || (l2 = High))
end
| Extreme -> begin
((((l2 = Low) || (l2 = Medium)) || (l2 = High)) || (l2 = Extreme))
end))

let debug_level_geq = (fun l2 -> (let _87_29 = (FStar_ST.read debug_level)
in (FStar_All.pipe_right _87_29 (FStar_Util.for_some (fun l1 -> (one_debug_level_geq l1 l2))))))

let log_types = (FStar_Util.mk_ref false)

let print_effect_args = (FStar_Util.mk_ref false)

let print_real_names = (FStar_Util.mk_ref false)

let dump_module = (FStar_Util.mk_ref None)

let should_dump = (fun l -> (match ((FStar_ST.read dump_module)) with
| None -> begin
false
end
| Some (m) -> begin
(m = l)
end))

let logQueries = (FStar_Util.mk_ref false)

let z3exe = (FStar_Util.mk_ref true)

let outputDir = (FStar_Util.mk_ref (Some (".")))

let fstar_home_opt = (FStar_Util.mk_ref None)

let _fstar_home = (FStar_Util.mk_ref "")

let prims_ref = (FStar_Util.mk_ref None)

let z3timeout = (FStar_Util.mk_ref 5)

let admit_smt_queries = (FStar_Util.mk_ref false)

let pretype = (FStar_Util.mk_ref true)

let codegen = (FStar_Util.mk_ref None)

let admit_fsi = (FStar_Util.mk_ref [])

let codegen_libs = (FStar_Util.mk_ref [])

let trace_error = (FStar_Util.mk_ref false)

let verify = (FStar_Util.mk_ref true)

let full_context_dependency = (FStar_Util.mk_ref true)

let print_implicits = (FStar_Util.mk_ref false)

let hide_uvar_nums = (FStar_Util.mk_ref false)

let hide_genident_nums = (FStar_Util.mk_ref false)

let serialize_mods = (FStar_Util.mk_ref false)

let initial_fuel = (FStar_Util.mk_ref 2)

let initial_ifuel = (FStar_Util.mk_ref 1)

let max_fuel = (FStar_Util.mk_ref 8)

let min_fuel = (FStar_Util.mk_ref 1)

let max_ifuel = (FStar_Util.mk_ref 2)

let warn_top_level_effects = (FStar_Util.mk_ref false)

let no_slack = (FStar_Util.mk_ref false)

let eager_inference = (FStar_Util.mk_ref false)

let unthrottle_inductives = (FStar_Util.mk_ref false)

let use_eq_at_higher_order = (FStar_Util.mk_ref false)

let use_native_int = (FStar_Util.mk_ref false)

let fs_typ_app = (FStar_Util.mk_ref false)

let n_cores = (FStar_Util.mk_ref 1)

let verify_module = (FStar_Util.mk_ref [])

let __temp_no_proj = (FStar_Util.mk_ref [])

let interactive = (FStar_Util.mk_ref false)

let interactive_context = (FStar_Util.mk_ref None)

let split_cases = (FStar_Util.mk_ref 0)

let _include_path = (FStar_Util.mk_ref [])

let interactive_fsi = (FStar_Util.mk_ref false)

let print_fuels = (FStar_Util.mk_ref false)

let cardinality = (FStar_Util.mk_ref "off")

let timing = (FStar_Util.mk_ref false)

let inline_arith = (FStar_Util.mk_ref false)

let warn_cardinality = (fun _21_26 -> (match (()) with
| () -> begin
(match ((FStar_ST.read cardinality)) with
| "warn" -> begin
true
end
| _21_29 -> begin
false
end)
end))

let check_cardinality = (fun _21_30 -> (match (()) with
| () -> begin
(match ((FStar_ST.read cardinality)) with
| "check" -> begin
true
end
| _21_33 -> begin
false
end)
end))

let dep = (FStar_ST.alloc None)

let explicit_deps = (FStar_Util.mk_ref false)

let init_options = (fun _21_34 -> (match (()) with
| () -> begin
(let _21_35 = (FStar_ST.op_Colon_Equals show_signatures [])
in (let _21_37 = (FStar_ST.op_Colon_Equals norm_then_print true)
in (let _21_39 = (let _87_38 = (FStar_Platform.exe "z3")
in (FStar_ST.op_Colon_Equals z3_exe _87_38))
in (let _21_41 = (FStar_ST.op_Colon_Equals silent false)
in (let _21_43 = (FStar_ST.op_Colon_Equals debug [])
in (let _21_45 = (FStar_ST.op_Colon_Equals debug_level [])
in (let _21_47 = (FStar_ST.op_Colon_Equals log_types false)
in (let _21_49 = (FStar_ST.op_Colon_Equals print_effect_args false)
in (let _21_51 = (FStar_ST.op_Colon_Equals print_real_names false)
in (let _21_53 = (FStar_ST.op_Colon_Equals dump_module None)
in (let _21_55 = (FStar_ST.op_Colon_Equals logQueries false)
in (let _21_57 = (FStar_ST.op_Colon_Equals z3exe true)
in (let _21_59 = (FStar_ST.op_Colon_Equals outputDir (Some (".")))
in (let _21_61 = (FStar_ST.op_Colon_Equals fstar_home_opt None)
in (let _21_63 = (FStar_ST.op_Colon_Equals _fstar_home "")
in (let _21_65 = (FStar_ST.op_Colon_Equals prims_ref None)
in (let _21_67 = (FStar_ST.op_Colon_Equals z3timeout 5)
in (let _21_69 = (FStar_ST.op_Colon_Equals admit_smt_queries false)
in (let _21_71 = (FStar_ST.op_Colon_Equals pretype true)
in (let _21_73 = (FStar_ST.op_Colon_Equals codegen None)
in (let _21_75 = (FStar_ST.op_Colon_Equals codegen_libs [])
in (let _21_77 = (FStar_ST.op_Colon_Equals admit_fsi [])
in (let _21_79 = (FStar_ST.op_Colon_Equals trace_error false)
in (let _21_81 = (FStar_ST.op_Colon_Equals verify true)
in (let _21_83 = (FStar_ST.op_Colon_Equals full_context_dependency true)
in (let _21_85 = (FStar_ST.op_Colon_Equals print_implicits false)
in (let _21_87 = (FStar_ST.op_Colon_Equals hide_uvar_nums false)
in (let _21_89 = (FStar_ST.op_Colon_Equals hide_genident_nums false)
in (let _21_91 = (FStar_ST.op_Colon_Equals serialize_mods false)
in (let _21_93 = (FStar_ST.op_Colon_Equals initial_fuel 2)
in (let _21_95 = (FStar_ST.op_Colon_Equals initial_ifuel 1)
in (let _21_97 = (FStar_ST.op_Colon_Equals max_fuel 8)
in (let _21_99 = (FStar_ST.op_Colon_Equals min_fuel 1)
in (let _21_101 = (FStar_ST.op_Colon_Equals max_ifuel 2)
in (let _21_103 = (FStar_ST.op_Colon_Equals warn_top_level_effects false)
in (let _21_105 = (FStar_ST.op_Colon_Equals no_slack false)
in (let _21_107 = (FStar_ST.op_Colon_Equals eager_inference false)
in (let _21_109 = (FStar_ST.op_Colon_Equals unthrottle_inductives false)
in (let _21_111 = (FStar_ST.op_Colon_Equals use_eq_at_higher_order false)
in (let _21_113 = (FStar_ST.op_Colon_Equals fs_typ_app false)
in (let _21_115 = (FStar_ST.op_Colon_Equals n_cores 1)
in (let _21_117 = (FStar_ST.op_Colon_Equals split_cases 0)
in (let _21_119 = (FStar_ST.op_Colon_Equals verify_module [])
in (let _21_121 = (FStar_ST.op_Colon_Equals __temp_no_proj [])
in (let _21_123 = (FStar_ST.op_Colon_Equals _include_path [])
in (let _21_125 = (FStar_ST.op_Colon_Equals print_fuels false)
in (let _21_127 = (FStar_ST.op_Colon_Equals use_native_int false)
in (let _21_129 = (FStar_ST.op_Colon_Equals explicit_deps false)
in (let _21_131 = (FStar_ST.op_Colon_Equals dep None)
in (let _21_133 = (FStar_ST.op_Colon_Equals timing false)
in (FStar_ST.op_Colon_Equals inline_arith false)))))))))))))))))))))))))))))))))))))))))))))))))))
end))

let set_fstar_home = (fun _21_135 -> (match (()) with
| () -> begin
(let fh = (match ((FStar_ST.read fstar_home_opt)) with
| None -> begin
(let x = (FStar_Util.get_exec_dir ())
in (let x = (Prims.strcat x "/..")
in (let _21_139 = (FStar_ST.op_Colon_Equals _fstar_home x)
in (let _21_141 = (FStar_ST.op_Colon_Equals fstar_home_opt (Some (x)))
in x))))
end
| Some (x) -> begin
(let _21_145 = (FStar_ST.op_Colon_Equals _fstar_home x)
in x)
end)
in fh)
end))

let get_fstar_home = (fun _21_148 -> (match (()) with
| () -> begin
(match ((FStar_ST.read fstar_home_opt)) with
| None -> begin
(let _21_150 = (let _87_43 = (set_fstar_home ())
in (FStar_All.pipe_left Prims.ignore _87_43))
in (FStar_ST.read _fstar_home))
end
| Some (x) -> begin
x
end)
end))

let get_include_path = (fun _21_154 -> (match (()) with
| () -> begin
(let h = (get_fstar_home ())
in (let _87_46 = (FStar_ST.read _include_path)
in (FStar_List.append _87_46 ((".")::((Prims.strcat h "/lib"))::((Prims.strcat h "/lib/fstar"))::((Prims.strcat h "/stdlib"))::((Prims.strcat h "/stdlib/fstar"))::[]))))
end))

let find_file = (fun filename -> (let search_path = (get_include_path ())
in (FStar_All.try_with (fun _21_159 -> (match (()) with
| () -> begin
(let _87_51 = if (FStar_Util.is_path_absolute filename) then begin
if (FStar_Util.file_exists filename) then begin
Some (filename)
end else begin
None
end
end else begin
(FStar_Util.find_map search_path (fun p -> (let path = (FStar_Util.join_paths p filename)
in if (FStar_Util.file_exists path) then begin
Some (path)
end else begin
None
end)))
end
in (FStar_Util.map_option FStar_Util.normalize_file_path _87_51))
end)) (fun _21_158 -> (match (_21_158) with
| _21_162 -> begin
None
end)))))

let prims = (fun _21_167 -> (match (()) with
| () -> begin
(match ((FStar_ST.read prims_ref)) with
| None -> begin
(let filen = "prims.fst"
in (match ((find_file filen)) with
| Some (result) -> begin
result
end
| None -> begin
(let _87_56 = (let _87_55 = (FStar_Util.format1 "unable to find required file \"%s\" in the module search path.\n" filen)
in FStar_Util.Failure (_87_55))
in (Prims.raise _87_56))
end))
end
| Some (x) -> begin
x
end)
end))

let prependOutputDir = (fun fname -> (match ((FStar_ST.read outputDir)) with
| None -> begin
fname
end
| Some (x) -> begin
(Prims.strcat (Prims.strcat x "/") fname)
end))

let cache_dir = "cache"

let display_version = (fun _21_179 -> (match (()) with
| () -> begin
(let _87_61 = (FStar_Util.format5 "F* %s\nplatform=%s\ncompiler=%s\ndate=%s\ncommit=%s\n" FStar_Version.version FStar_Version.platform FStar_Version.compiler FStar_Version.date FStar_Version.commit)
in (FStar_Util.print_string _87_61))
end))

let display_usage = (fun specs -> (let _21_181 = (FStar_Util.print_string "fstar [option] file...\n")
in (FStar_List.iter (fun _21_188 -> (match (_21_188) with
| (_21_184, flag, p, doc) -> begin
(match (p) with
| FStar_Getopt.ZeroArgs (ig) -> begin
if (doc = "") then begin
(let _87_65 = (FStar_Util.format1 "  --%s\n" flag)
in (FStar_Util.print_string _87_65))
end else begin
(let _87_66 = (FStar_Util.format2 "  --%s  %s\n" flag doc)
in (FStar_Util.print_string _87_66))
end
end
| FStar_Getopt.OneArg (_21_192, argname) -> begin
if (doc = "") then begin
(let _87_68 = (FStar_Util.format2 "  --%s %s\n" flag argname)
in (FStar_Util.print_string _87_68))
end else begin
(let _87_69 = (FStar_Util.format3 "  --%s %s  %s\n" flag argname doc)
in (FStar_Util.print_string _87_69))
end
end)
end)) specs)))

let rec specs = (fun _21_196 -> (match (()) with
| () -> begin
(let specs = ((FStar_Getopt.noshort, "admit_fsi", FStar_Getopt.OneArg (((fun x -> (let _87_79 = (let _87_78 = (FStar_ST.read admit_fsi)
in (x)::_87_78)
in (FStar_ST.op_Colon_Equals admit_fsi _87_79))), "module name")), "Treat .fsi as a .fst"))::((FStar_Getopt.noshort, "admit_smt_queries", FStar_Getopt.OneArg (((fun s -> (let _87_83 = if (s = "true") then begin
true
end else begin
if (s = "false") then begin
false
end else begin
(FStar_All.failwith "Invalid argument to --admit_smt_queries")
end
end
in (FStar_ST.op_Colon_Equals admit_smt_queries _87_83))), "true|false")), "Admit SMT queries (UNSAFE! But, useful during development); default: \'false\'"))::((FStar_Getopt.noshort, "cardinality", FStar_Getopt.OneArg (((fun x -> (let _87_87 = (validate_cardinality x)
in (FStar_ST.op_Colon_Equals cardinality _87_87))), "off|warn|check")), "Check cardinality constraints on inductive data types (default \'off\')"))::((FStar_Getopt.noshort, "codegen", FStar_Getopt.OneArg (((fun s -> (let _87_91 = (parse_codegen s)
in (FStar_ST.op_Colon_Equals codegen _87_91))), "OCaml|FSharp")), "Generate code for execution"))::((FStar_Getopt.noshort, "codegen-lib", FStar_Getopt.OneArg (((fun s -> (let _87_96 = (let _87_95 = (FStar_ST.read codegen_libs)
in ((FStar_Util.split s "."))::_87_95)
in (FStar_ST.op_Colon_Equals codegen_libs _87_96))), "namespace")), "External runtime library library"))::((FStar_Getopt.noshort, "debug", FStar_Getopt.OneArg (((fun x -> (let _87_101 = (let _87_100 = (FStar_ST.read debug)
in (x)::_87_100)
in (FStar_ST.op_Colon_Equals debug _87_101))), "module name")), "Print LOTS of debugging information while checking module [arg]"))::((FStar_Getopt.noshort, "debug_level", FStar_Getopt.OneArg (((fun x -> (let _87_106 = (let _87_105 = (FStar_ST.read debug_level)
in ((dlevel x))::_87_105)
in (FStar_ST.op_Colon_Equals debug_level _87_106))), "Low|Medium|High|Extreme")), "Control the verbosity of debugging info"))::((FStar_Getopt.noshort, "dep", FStar_Getopt.OneArg (((fun x -> (FStar_ST.op_Colon_Equals dep (Some (x)))), "make|nubuild")), "Output the transitive closure of the dependency graph in a format suitable for the given tool"))::((FStar_Getopt.noshort, "dump_module", FStar_Getopt.OneArg (((fun x -> (FStar_ST.op_Colon_Equals dump_module (Some (x)))), "module name")), ""))::((FStar_Getopt.noshort, "eager_inference", FStar_Getopt.ZeroArgs ((fun _21_206 -> (match (()) with
| () -> begin
(FStar_ST.op_Colon_Equals eager_inference true)
end))), "Solve all type-inference constraints eagerly; more efficient but at the cost of generality"))::((FStar_Getopt.noshort, "explicit_deps", FStar_Getopt.ZeroArgs ((fun _21_207 -> (match (()) with
| () -> begin
(FStar_ST.op_Colon_Equals explicit_deps true)
end))), "tell FStar to not find dependencies automatically because the user provides them on the command-line, along with the right --admit-fsi options"))::((FStar_Getopt.noshort, "fs_typ_app", FStar_Getopt.ZeroArgs ((fun _21_208 -> (match (()) with
| () -> begin
(FStar_ST.op_Colon_Equals fs_typ_app true)
end))), "Allow the use of t<t1,...,tn> syntax for type applications; brittle since it clashes with the integer less-than operator"))::((FStar_Getopt.noshort, "fsi", FStar_Getopt.ZeroArgs ((fun _21_209 -> (match (()) with
| () -> begin
(set_interactive_fsi ())
end))), "fsi flag; A flag to indicate if type checking a fsi in the interactive mode"))::((FStar_Getopt.noshort, "fstar_home", FStar_Getopt.OneArg (((fun x -> (FStar_ST.op_Colon_Equals fstar_home_opt (Some (x)))), "dir")), "Set the FSTAR_HOME variable to dir"))::((FStar_Getopt.noshort, "full_context_dependency", FStar_Getopt.ZeroArgs ((fun _21_211 -> (match (()) with
| () -> begin
(FStar_ST.op_Colon_Equals full_context_dependency true)
end))), "Introduce unification variables that are dependent on the entire context (possibly expensive, but better for type inference (on, by default)"))::((FStar_Getopt.noshort, "hide_genident_nums", FStar_Getopt.ZeroArgs ((fun _21_212 -> (match (()) with
| () -> begin
(FStar_ST.op_Colon_Equals hide_genident_nums true)
end))), "Don\'t print generated identifier numbers"))::((FStar_Getopt.noshort, "hide_uvar_nums", FStar_Getopt.ZeroArgs ((fun _21_213 -> (match (()) with
| () -> begin
(FStar_ST.op_Colon_Equals hide_uvar_nums true)
end))), "Don\'t print unification variable numbers"))::((FStar_Getopt.noshort, "in", FStar_Getopt.ZeroArgs ((fun _21_214 -> (match (()) with
| () -> begin
(FStar_ST.op_Colon_Equals interactive true)
end))), "Interactive mode; reads input from stdin"))::((FStar_Getopt.noshort, "in_context", FStar_Getopt.OneArg (((fun s -> (let _21_216 = (FStar_ST.op_Colon_Equals interactive true)
in (FStar_ST.op_Colon_Equals interactive_context (Some (s))))), "name")), "Specify the context of an interactive session; needed for --auto_deps to work with interactive mode."))::((FStar_Getopt.noshort, "include", FStar_Getopt.OneArg (((fun s -> (let _87_131 = (let _87_130 = (FStar_ST.read _include_path)
in (FStar_List.append _87_130 ((s)::[])))
in (FStar_ST.op_Colon_Equals _include_path _87_131))), "path")), "A directory in which to search for files included on the command line"))::((FStar_Getopt.noshort, "initial_fuel", FStar_Getopt.OneArg (((fun x -> (let _87_135 = (FStar_Util.int_of_string x)
in (FStar_ST.op_Colon_Equals initial_fuel _87_135))), "non-negative integer")), "Number of unrolling of recursive functions to try initially (default 2)"))::((FStar_Getopt.noshort, "initial_ifuel", FStar_Getopt.OneArg (((fun x -> (let _87_139 = (FStar_Util.int_of_string x)
in (FStar_ST.op_Colon_Equals initial_ifuel _87_139))), "non-negative integer")), "Number of unrolling of inductive datatypes to try at first (default 1)"))::((FStar_Getopt.noshort, "inline_arith", FStar_Getopt.ZeroArgs ((fun _21_221 -> (match (()) with
| () -> begin
(FStar_ST.op_Colon_Equals inline_arith true)
end))), "Inline definitions of arithmetic functions in the SMT encoding"))::((FStar_Getopt.noshort, "lax", FStar_Getopt.ZeroArgs ((fun _21_222 -> (match (()) with
| () -> begin
(let _21_223 = (FStar_ST.op_Colon_Equals pretype true)
in (FStar_ST.op_Colon_Equals verify false))
end))), "Run the lax-type checker only (admit all verification conditions)"))::((FStar_Getopt.noshort, "log_types", FStar_Getopt.ZeroArgs ((fun _21_225 -> (match (()) with
| () -> begin
(FStar_ST.op_Colon_Equals log_types true)
end))), "Print types computed for data/val/let-bindings"))::((FStar_Getopt.noshort, "logQueries", FStar_Getopt.ZeroArgs ((fun _21_226 -> (match (()) with
| () -> begin
(FStar_ST.op_Colon_Equals logQueries true)
end))), "Log the Z3 queries in queries.smt2"))::((FStar_Getopt.noshort, "max_fuel", FStar_Getopt.OneArg (((fun x -> (let _87_147 = (FStar_Util.int_of_string x)
in (FStar_ST.op_Colon_Equals max_fuel _87_147))), "non-negative integer")), "Number of unrolling of recursive functions to try at most (default 8)"))::((FStar_Getopt.noshort, "max_ifuel", FStar_Getopt.OneArg (((fun x -> (let _87_151 = (FStar_Util.int_of_string x)
in (FStar_ST.op_Colon_Equals max_ifuel _87_151))), "non-negative integer")), "Number of unrolling of inductive datatypes to try at most (default 2)"))::((FStar_Getopt.noshort, "min_fuel", FStar_Getopt.OneArg (((fun x -> (let _87_155 = (FStar_Util.int_of_string x)
in (FStar_ST.op_Colon_Equals min_fuel _87_155))), "non-negative integer")), "Minimum number of unrolling of recursive functions to try (default 1)"))::((FStar_Getopt.noshort, "MLish", FStar_Getopt.ZeroArgs ((fun _21_230 -> (match (()) with
| () -> begin
(FStar_ST.op_Colon_Equals full_context_dependency false)
end))), "Introduce unification variables that are only dependent on the type variables in the context"))::((FStar_Getopt.noshort, "n_cores", FStar_Getopt.OneArg (((fun x -> (let _87_160 = (FStar_Util.int_of_string x)
in (FStar_ST.op_Colon_Equals n_cores _87_160))), "positive integer")), "Maximum number of cores to use for the solver (default 1)"))::((FStar_Getopt.noshort, "no_fs_typ_app", FStar_Getopt.ZeroArgs ((fun _21_232 -> (match (()) with
| () -> begin
(FStar_ST.op_Colon_Equals fs_typ_app false)
end))), "Do not allow the use of t<t1,...,tn> syntax for type applications"))::((FStar_Getopt.noshort, "no_slack", FStar_Getopt.ZeroArgs ((fun _21_233 -> (match (()) with
| () -> begin
(FStar_ST.op_Colon_Equals no_slack true)
end))), "Use the partially flow-insensitive variant of --rel2 (experimental)"))::((FStar_Getopt.noshort, "odir", FStar_Getopt.OneArg (((fun x -> (FStar_ST.op_Colon_Equals outputDir (Some (x)))), "dir")), "Place output in directory dir"))::((FStar_Getopt.noshort, "prims", FStar_Getopt.OneArg (((fun x -> (FStar_ST.op_Colon_Equals prims_ref (Some (x)))), "file")), ""))::((FStar_Getopt.noshort, "print_before_norm", FStar_Getopt.ZeroArgs ((fun _21_236 -> (match (()) with
| () -> begin
(FStar_ST.op_Colon_Equals norm_then_print false)
end))), "Do not normalize types before printing (for debugging)"))::((FStar_Getopt.noshort, "print_effect_args", FStar_Getopt.ZeroArgs ((fun _21_237 -> (match (()) with
| () -> begin
(FStar_ST.op_Colon_Equals print_effect_args true)
end))), "Print inferred predicate transformers for all computation types"))::((FStar_Getopt.noshort, "print_fuels", FStar_Getopt.ZeroArgs ((fun _21_238 -> (match (()) with
| () -> begin
(FStar_ST.op_Colon_Equals print_fuels true)
end))), "Print the fuel amounts used for each successful query"))::((FStar_Getopt.noshort, "print_implicits", FStar_Getopt.ZeroArgs ((fun _21_239 -> (match (()) with
| () -> begin
(FStar_ST.op_Colon_Equals print_implicits true)
end))), "Print implicit arguments"))::((FStar_Getopt.noshort, "prn", FStar_Getopt.ZeroArgs ((fun _21_240 -> (match (()) with
| () -> begin
(FStar_ST.op_Colon_Equals print_real_names true)
end))), "Print real names---you may want to use this in conjunction with logQueries"))::((FStar_Getopt.noshort, "serialize_mods", FStar_Getopt.ZeroArgs ((fun _21_241 -> (match (()) with
| () -> begin
(FStar_ST.op_Colon_Equals serialize_mods true)
end))), "Serialize compiled modules"))::((FStar_Getopt.noshort, "show_signatures", FStar_Getopt.OneArg (((fun x -> (let _87_179 = (let _87_178 = (FStar_ST.read show_signatures)
in (x)::_87_178)
in (FStar_ST.op_Colon_Equals show_signatures _87_179))), "module name")), "Show the checked signatures for all top-level symbols in the module"))::((FStar_Getopt.noshort, "silent", FStar_Getopt.ZeroArgs ((fun _21_243 -> (match (()) with
| () -> begin
(FStar_ST.op_Colon_Equals silent true)
end))), " "))::((FStar_Getopt.noshort, "smt", FStar_Getopt.OneArg (((fun x -> (FStar_ST.op_Colon_Equals z3_exe x)), "path")), "Path to the SMT solver (usually Z3, but could be any SMT2-compatible solver)"))::((FStar_Getopt.noshort, "split_cases", FStar_Getopt.OneArg (((fun n -> (let _87_187 = (FStar_Util.int_of_string n)
in (FStar_ST.op_Colon_Equals split_cases _87_187))), "t")), "Partition VC of a match into groups of n cases"))::((FStar_Getopt.noshort, "timing", FStar_Getopt.ZeroArgs ((fun _21_246 -> (match (()) with
| () -> begin
(FStar_ST.op_Colon_Equals timing true)
end))), "Print the time it takes to verify each top-level definition"))::((FStar_Getopt.noshort, "trace_error", FStar_Getopt.ZeroArgs ((fun _21_247 -> (match (()) with
| () -> begin
(FStar_ST.op_Colon_Equals trace_error true)
end))), "Don\'t print an error message; show an exception trace instead"))::((FStar_Getopt.noshort, "unthrottle_inductives", FStar_Getopt.ZeroArgs ((fun _21_248 -> (match (()) with
| () -> begin
(FStar_ST.op_Colon_Equals unthrottle_inductives true)
end))), "Let the SMT solver unfold inductive types to arbitrary depths (may affect verifier performance)"))::((FStar_Getopt.noshort, "use_eq_at_higher_order", FStar_Getopt.ZeroArgs ((fun _21_249 -> (match (()) with
| () -> begin
(FStar_ST.op_Colon_Equals use_eq_at_higher_order true)
end))), "Use equality constraints when comparing higher-order types; temporary"))::((FStar_Getopt.noshort, "use_native_int", FStar_Getopt.ZeroArgs ((fun _21_250 -> (match (()) with
| () -> begin
(FStar_ST.op_Colon_Equals use_native_int true)
end))), "Extract the \'int\' type to platform-specific native int; you will need to link the generated code with the appropriate version of the prims library"))::((FStar_Getopt.noshort, "verify_module", FStar_Getopt.OneArg (((fun x -> (let _87_197 = (let _87_196 = (FStar_ST.read verify_module)
in (x)::_87_196)
in (FStar_ST.op_Colon_Equals verify_module _87_197))), "string")), "Name of the module to verify"))::((FStar_Getopt.noshort, "__temp_no_proj", FStar_Getopt.OneArg (((fun x -> (let _87_202 = (let _87_201 = (FStar_ST.read __temp_no_proj)
in (x)::_87_201)
in (FStar_ST.op_Colon_Equals __temp_no_proj _87_202))), "string")), "Don\'t generate projectors for this module"))::(('v', "version", FStar_Getopt.ZeroArgs ((fun _21_253 -> (let _21_255 = (display_version ())
in (FStar_All.exit 0)))), "Display version number"))::((FStar_Getopt.noshort, "warn_top_level_effects", FStar_Getopt.ZeroArgs ((fun _21_257 -> (match (()) with
| () -> begin
(FStar_ST.op_Colon_Equals warn_top_level_effects true)
end))), "Top-level effects are ignored, by default; turn this flag on to be warned when this happens"))::((FStar_Getopt.noshort, "z3timeout", FStar_Getopt.OneArg (((fun s -> (let _87_208 = (FStar_Util.int_of_string s)
in (FStar_ST.op_Colon_Equals z3timeout _87_208))), "t")), "Set the Z3 per-query (soft) timeout to t seconds (default 5)"))::[]
in (('h', "help", FStar_Getopt.ZeroArgs ((fun x -> (let _21_261 = (display_usage specs)
in (FStar_All.exit 0)))), "Display this information"))::specs)
end))
and parse_codegen = (fun s -> (match (s) with
| ("OCaml") | ("FSharp") -> begin
Some (s)
end
| _21_267 -> begin
(let _21_268 = (FStar_Util.print_string "Wrong argument to codegen flag\n")
in (let _21_270 = (let _87_211 = (specs ())
in (display_usage _87_211))
in (FStar_All.exit 1)))
end))
and validate_cardinality = (fun x -> (match (x) with
| ("warn") | ("check") | ("off") -> begin
x
end
| _21_277 -> begin
(let _21_278 = (FStar_Util.print_string "Wrong argument to cardinality flag\n")
in (let _21_280 = (let _87_213 = (specs ())
in (display_usage _87_213))
in (FStar_All.exit 1)))
end))
and set_interactive_fsi = (fun _21_282 -> if (FStar_ST.read interactive) then begin
(FStar_ST.op_Colon_Equals interactive_fsi true)
end else begin
(let _21_284 = (FStar_Util.print_string "Set interactive flag first before setting interactive fsi flag\n")
in (let _21_286 = (let _87_215 = (specs ())
in (display_usage _87_215))
in (FStar_All.exit 1)))
end)

let should_verify = (fun m -> ((FStar_ST.read verify) && (match ((FStar_ST.read verify_module)) with
| [] -> begin
true
end
| l -> begin
(FStar_List.contains m l)
end)))

let dont_gen_projectors = (fun m -> (let _87_220 = (FStar_ST.read __temp_no_proj)
in (FStar_List.contains m _87_220)))

let should_print_message = (fun m -> (((should_verify m) && (not ((let _87_223 = (FStar_ST.read admit_fsi)
in (FStar_List.contains m _87_223))))) && (m <> "Prims")))

let set_options = (let no_smt_specs = (let _87_226 = (specs ())
in (FStar_All.pipe_right _87_226 (FStar_List.filter (fun _21_300 -> (match (_21_300) with
| (_21_294, name, _21_297, _21_299) -> begin
(name <> "smt")
end)))))
in (fun s -> (FStar_Getopt.parse_string no_smt_specs (fun _21_303 -> ()) s)))

let reset_options_string = (FStar_ST.alloc None)

let reset_options = (fun _21_305 -> (match (()) with
| () -> begin
(let _21_306 = (init_options ())
in (let res = (let _87_232 = (specs ())
in (FStar_Getopt.parse_cmdline _87_232 (fun x -> ())))
in (match ((FStar_ST.read reset_options_string)) with
| Some (x) -> begin
(set_options x)
end
| _21_313 -> begin
res
end)))
end))




