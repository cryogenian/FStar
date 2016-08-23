
open Prims
# 28 "FStar.Fsdoc.Generator.fst"
type mforest =
| Leaf of (Prims.string * Prims.string)
| Branch of mforest FStar_Util.smap

# 32 "FStar.Fsdoc.Generator.fst"
let is_Leaf = (fun _discr_ -> (match (_discr_) with
| Leaf (_) -> begin
true
end
| _ -> begin
false
end))

# 33 "FStar.Fsdoc.Generator.fst"
let is_Branch = (fun _discr_ -> (match (_discr_) with
| Branch (_) -> begin
true
end
| _ -> begin
false
end))

# 32 "FStar.Fsdoc.Generator.fst"
let ___Leaf____0 = (fun projectee -> (match (projectee) with
| Leaf (_81_4) -> begin
_81_4
end))

# 33 "FStar.Fsdoc.Generator.fst"
let ___Branch____0 = (fun projectee -> (match (projectee) with
| Branch (_81_7) -> begin
_81_7
end))

# 33 "FStar.Fsdoc.Generator.fst"
let htree : mforest FStar_Util.smap = (FStar_Util.smap_create 50)

# 35 "FStar.Fsdoc.Generator.fst"
let parse_file : Prims.string  ->  Prims.string  ->  Prims.unit = (fun fn -> (let _174_35 = (FStar_Options.prepend_output_dir ".mk")
in (FStar_Util.write_file _174_35)))

# 38 "FStar.Fsdoc.Generator.fst"
let document_decl : (Prims.string  ->  Prims.unit)  ->  FStar_Parser_AST.decl  ->  Prims.unit = (fun w d -> (
# 41 "FStar.Fsdoc.Generator.fst"
let _81_15 = d
in (match (_81_15) with
| {FStar_Parser_AST.d = decl; FStar_Parser_AST.drange = _81_13; FStar_Parser_AST.doc = doc} -> begin
(
# 42 "FStar.Fsdoc.Generator.fst"
let _81_22 = (match (doc) with
| Some (doc, kw) -> begin
(w doc)
end
| _81_21 -> begin
()
end)
in (match (decl) with
| (FStar_Parser_AST.TopLevelModule (_)) | (FStar_Parser_AST.Open (_)) | (FStar_Parser_AST.ModuleAbbrev (_)) | (FStar_Parser_AST.Main (_)) | (FStar_Parser_AST.Pragma (_)) -> begin
()
end
| FStar_Parser_AST.Fsdoc (fsd) -> begin
(
# 47 "FStar.Fsdoc.Generator.fst"
let _81_41 = (w (Prims.fst fsd))
in (w "\n"))
end
| _81_44 -> begin
(
# 50 "FStar.Fsdoc.Generator.fst"
let _81_45 = (w "```fstar")
in (
# 51 "FStar.Fsdoc.Generator.fst"
let _81_47 = (let _174_45 = (FStar_Parser_AST.decl_to_string d)
in (w _174_45))
in (w "```\n")))
end))
end)))

# 53 "FStar.Fsdoc.Generator.fst"
let document_module : FStar_Parser_AST.modul  ->  Prims.unit = (fun m -> (
# 56 "FStar.Fsdoc.Generator.fst"
let _81_63 = (match (m) with
| FStar_Parser_AST.Module (n, d) -> begin
((n), (d), ("module"))
end
| FStar_Parser_AST.Interface (n, d, _81_57) -> begin
((n), (d), ("interface"))
end)
in (match (_81_63) with
| (name, decls, mt) -> begin
(
# 59 "FStar.Fsdoc.Generator.fst"
let mdoc = (FStar_List.tryPick (fun _81_1 -> (match (_81_1) with
| {FStar_Parser_AST.d = FStar_Parser_AST.TopLevelModule (k); FStar_Parser_AST.drange = _81_67; FStar_Parser_AST.doc = d} -> begin
Some (((k), (d)))
end
| _81_72 -> begin
None
end)) decls)
in (
# 60 "FStar.Fsdoc.Generator.fst"
let _81_96 = (match (mdoc) with
| Some (n, com) -> begin
(
# 62 "FStar.Fsdoc.Generator.fst"
let com = (match (com) with
| Some (doc, kw) -> begin
(match ((FStar_List.tryFind (fun _81_84 -> (match (_81_84) with
| (k, v) -> begin
(k = "summary")
end)) kw)) with
| None -> begin
doc
end
| Some (_81_87, summary) -> begin
summary
end)
end
| None -> begin
"*(no documentation provided)*"
end)
in ((n), (com)))
end
| None -> begin
((name), ("*(no documentation provided)*"))
end)
in (match (_81_96) with
| (name, com) -> begin
(
# 68 "FStar.Fsdoc.Generator.fst"
let on = (FStar_Options.prepend_output_dir (Prims.strcat name.FStar_Ident.str ".mk"))
in (
# 69 "FStar.Fsdoc.Generator.fst"
let fd = (FStar_Util.open_file_for_writing on)
in (
# 70 "FStar.Fsdoc.Generator.fst"
let w = (FStar_Util.append_to_file fd)
in (
# 71 "FStar.Fsdoc.Generator.fst"
let _81_100 = (let _174_51 = (FStar_Util.format "# module %s\n" ((name.FStar_Ident.str)::[]))
in (w _174_51))
in (
# 72 "FStar.Fsdoc.Generator.fst"
let _81_113 = (match (mdoc) with
| Some (_81_103, Some (doc, _81_106)) -> begin
(w doc)
end
| _81_112 -> begin
()
end)
in (
# 73 "FStar.Fsdoc.Generator.fst"
let _81_115 = (FStar_List.iter (document_decl w) decls)
in (FStar_Util.close_file fd)))))))
end)))
end)))

# 74 "FStar.Fsdoc.Generator.fst"
let generate : Prims.string Prims.list  ->  Prims.unit = (fun files -> (
# 77 "FStar.Fsdoc.Generator.fst"
let modules = (FStar_List.collect (fun fn -> (FStar_Parser_Driver.parse_file fn)) files)
in (FStar_List.iter document_module modules)))



