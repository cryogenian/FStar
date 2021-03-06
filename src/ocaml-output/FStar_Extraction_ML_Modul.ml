
open Prims

let fail_exp = (fun lid t -> (let _174_16 = (let _174_15 = (let _174_14 = (FStar_Syntax_Syntax.fvar FStar_Syntax_Const.failwith_lid FStar_Syntax_Syntax.Delta_constant None)
in (let _174_13 = (let _174_12 = (FStar_Syntax_Syntax.iarg t)
in (let _174_11 = (let _174_10 = (let _174_9 = (let _174_8 = (let _174_7 = (let _174_6 = (let _174_5 = (let _174_4 = (let _174_3 = (FStar_Syntax_Print.lid_to_string lid)
in (Prims.strcat "Not yet implemented:" _174_3))
in (FStar_Bytes.string_as_unicode_bytes _174_4))
in ((_174_5), (FStar_Range.dummyRange)))
in FStar_Const.Const_string (_174_6))
in FStar_Syntax_Syntax.Tm_constant (_174_7))
in (FStar_Syntax_Syntax.mk _174_8 None FStar_Range.dummyRange))
in (FStar_All.pipe_left FStar_Syntax_Syntax.iarg _174_9))
in (_174_10)::[])
in (_174_12)::_174_11))
in ((_174_14), (_174_13))))
in FStar_Syntax_Syntax.Tm_app (_174_15))
in (FStar_Syntax_Syntax.mk _174_16 None FStar_Range.dummyRange)))


let mangle_projector_lid : FStar_Ident.lident  ->  FStar_Ident.lident = (fun x -> (

let projecteeName = x.FStar_Ident.ident
in (

let _80_19 = (FStar_Util.prefix x.FStar_Ident.ns)
in (match (_80_19) with
| (prefix, constrName) -> begin
(

let mangledName = (FStar_Ident.id_of_text (Prims.strcat "___" (Prims.strcat constrName.FStar_Ident.idText (Prims.strcat "___" projecteeName.FStar_Ident.idText))))
in (FStar_Ident.lid_of_ids (FStar_List.append prefix ((mangledName)::[]))))
end))))


let lident_as_mlsymbol : FStar_Ident.lident  ->  Prims.string = (fun id -> id.FStar_Ident.ident.FStar_Ident.idText)


let binders_as_mlty_binders = (fun env bs -> (FStar_Util.fold_map (fun env _80_28 -> (match (_80_28) with
| (bv, _80_27) -> begin
(let _174_29 = (let _174_27 = (let _174_26 = (let _174_25 = (FStar_Extraction_ML_UEnv.bv_as_ml_tyvar bv)
in FStar_Extraction_ML_Syntax.MLTY_Var (_174_25))
in Some (_174_26))
in (FStar_Extraction_ML_UEnv.extend_ty env bv _174_27))
in (let _174_28 = (FStar_Extraction_ML_UEnv.bv_as_ml_tyvar bv)
in ((_174_29), (_174_28))))
end)) env bs))


let extract_typ_abbrev : FStar_Extraction_ML_UEnv.env  ->  FStar_Ident.lident  ->  FStar_Syntax_Syntax.qualifier Prims.list  ->  FStar_Syntax_Syntax.term  ->  (FStar_Extraction_ML_UEnv.env * FStar_Extraction_ML_Syntax.mlmodule1 Prims.list) = (fun env lid quals def -> (

let def = (let _174_39 = (let _174_38 = (FStar_Syntax_Subst.compress def)
in (FStar_All.pipe_right _174_38 FStar_Syntax_Util.unmeta))
in (FStar_All.pipe_right _174_39 FStar_Syntax_Util.un_uinst))
in (

let def = (match (def.FStar_Syntax_Syntax.n) with
| FStar_Syntax_Syntax.Tm_abs (_80_35) -> begin
(FStar_Extraction_ML_Term.normalize_abs def)
end
| _80_38 -> begin
def
end)
in (

let _80_50 = (match (def.FStar_Syntax_Syntax.n) with
| FStar_Syntax_Syntax.Tm_abs (bs, body, _80_43) -> begin
(FStar_Syntax_Subst.open_term bs body)
end
| _80_47 -> begin
(([]), (def))
end)
in (match (_80_50) with
| (bs, body) -> begin
(

let assumed = (FStar_Util.for_some (fun _80_1 -> (match (_80_1) with
| FStar_Syntax_Syntax.Assumption -> begin
true
end
| _80_54 -> begin
false
end)) quals)
in (

let _80_58 = (binders_as_mlty_binders env bs)
in (match (_80_58) with
| (env, ml_bs) -> begin
(

let body = (let _174_41 = (FStar_Extraction_ML_Term.term_as_mlty env body)
in (FStar_All.pipe_right _174_41 (FStar_Extraction_ML_Util.eraseTypeDeep (FStar_Extraction_ML_Util.udelta_unfold env))))
in (

let td = (((assumed), ((lident_as_mlsymbol lid)), (ml_bs), (Some (FStar_Extraction_ML_Syntax.MLTD_Abbrev (body)))))::[]
in (

let def = (let _174_43 = (let _174_42 = (FStar_Extraction_ML_Util.mlloc_of_range (FStar_Ident.range_of_lid lid))
in FStar_Extraction_ML_Syntax.MLM_Loc (_174_42))
in (_174_43)::(FStar_Extraction_ML_Syntax.MLM_Ty (td))::[])
in (

let env = if (FStar_All.pipe_right quals (FStar_Util.for_some (fun _80_2 -> (match (_80_2) with
| (FStar_Syntax_Syntax.Assumption) | (FStar_Syntax_Syntax.New) -> begin
true
end
| _80_66 -> begin
false
end)))) then begin
env
end else begin
(FStar_Extraction_ML_UEnv.extend_tydef env td)
end
in ((env), (def))))))
end)))
end)))))


type data_constructor =
{dname : FStar_Ident.lident; dtyp : FStar_Syntax_Syntax.typ}


let is_Mkdata_constructor : data_constructor  ->  Prims.bool = (Obj.magic ((fun _ -> (FStar_All.failwith "Not yet implemented:is_Mkdata_constructor"))))


type inductive_family =
{iname : FStar_Ident.lident; iparams : FStar_Syntax_Syntax.binders; ityp : FStar_Syntax_Syntax.term; idatas : data_constructor Prims.list; iquals : FStar_Syntax_Syntax.qualifier Prims.list}


let is_Mkinductive_family : inductive_family  ->  Prims.bool = (Obj.magic ((fun _ -> (FStar_All.failwith "Not yet implemented:is_Mkinductive_family"))))


let print_ifamily : inductive_family  ->  Prims.unit = (fun i -> (let _174_78 = (FStar_Syntax_Print.lid_to_string i.iname)
in (let _174_77 = (FStar_Syntax_Print.binders_to_string " " i.iparams)
in (let _174_76 = (FStar_Syntax_Print.term_to_string i.ityp)
in (let _174_75 = (let _174_74 = (FStar_All.pipe_right i.idatas (FStar_List.map (fun d -> (let _174_73 = (FStar_Syntax_Print.lid_to_string d.dname)
in (let _174_72 = (let _174_71 = (FStar_Syntax_Print.term_to_string d.dtyp)
in (Prims.strcat " : " _174_71))
in (Prims.strcat _174_73 _174_72))))))
in (FStar_All.pipe_right _174_74 (FStar_String.concat "\n\t\t")))
in (FStar_Util.print4 "\n\t%s %s : %s { %s }\n" _174_78 _174_77 _174_76 _174_75))))))


let bundle_as_inductive_families = (fun env ses quals -> (FStar_All.pipe_right ses (FStar_List.collect (fun _80_4 -> (match (_80_4) with
| FStar_Syntax_Syntax.Sig_inductive_typ (l, _us, bs, t, _mut_i, datas, quals, r) -> begin
(

let _80_95 = (FStar_Syntax_Subst.open_term bs t)
in (match (_80_95) with
| (bs, t) -> begin
(

let datas = (FStar_All.pipe_right ses (FStar_List.collect (fun _80_3 -> (match (_80_3) with
| FStar_Syntax_Syntax.Sig_datacon (d, _80_99, t, l', nparams, _80_104, _80_106, _80_108) when (FStar_Ident.lid_equals l l') -> begin
(

let _80_113 = (FStar_Syntax_Util.arrow_formals t)
in (match (_80_113) with
| (bs', body) -> begin
(

let _80_116 = (FStar_Util.first_N (FStar_List.length bs) bs')
in (match (_80_116) with
| (bs_params, rest) -> begin
(

let subst = (FStar_List.map2 (fun _80_120 _80_124 -> (match (((_80_120), (_80_124))) with
| ((b', _80_119), (b, _80_123)) -> begin
(let _174_87 = (let _174_86 = (FStar_Syntax_Syntax.bv_to_name b)
in ((b'), (_174_86)))
in FStar_Syntax_Syntax.NT (_174_87))
end)) bs_params bs)
in (

let t = (let _174_89 = (let _174_88 = (FStar_Syntax_Syntax.mk_Total body)
in (FStar_Syntax_Util.arrow rest _174_88))
in (FStar_All.pipe_right _174_89 (FStar_Syntax_Subst.subst subst)))
in ({dname = d; dtyp = t})::[]))
end))
end))
end
| _80_128 -> begin
[]
end))))
in ({iname = l; iparams = bs; ityp = t; idatas = datas; iquals = quals})::[])
end))
end
| _80_131 -> begin
[]
end)))))


type env_t =
FStar_Extraction_ML_UEnv.env


let extract_bundle : env_t  ->  FStar_Syntax_Syntax.sigelt  ->  (FStar_Extraction_ML_UEnv.env * FStar_Extraction_ML_Syntax.mlmodule1 Prims.list) = (fun env se -> (

let extract_ctor = (fun ml_tyvars env ctor -> (

let mlt = (let _174_100 = (FStar_Extraction_ML_Term.term_as_mlty env ctor.dtyp)
in (FStar_Extraction_ML_Util.eraseTypeDeep (FStar_Extraction_ML_Util.udelta_unfold env) _174_100))
in (

let tys = ((ml_tyvars), (mlt))
in (

let fvv = (FStar_Extraction_ML_UEnv.mkFvvar ctor.dname ctor.dtyp)
in (let _174_103 = (FStar_Extraction_ML_UEnv.extend_fv env fvv tys false false)
in (let _174_102 = (let _174_101 = (FStar_Extraction_ML_Util.argTypes mlt)
in (((lident_as_mlsymbol ctor.dname)), (_174_101)))
in ((_174_103), (_174_102))))))))
in (

let extract_one_family = (fun env ind -> (

let _80_146 = (binders_as_mlty_binders env ind.iparams)
in (match (_80_146) with
| (env, vars) -> begin
(

let _80_149 = (FStar_All.pipe_right ind.idatas (FStar_Util.fold_map (extract_ctor vars) env))
in (match (_80_149) with
| (env, ctors) -> begin
(

let _80_153 = (FStar_Syntax_Util.arrow_formals ind.ityp)
in (match (_80_153) with
| (indices, _80_152) -> begin
(

let ml_params = (let _174_112 = (FStar_All.pipe_right indices (FStar_List.mapi (fun i _80_155 -> (let _174_111 = (let _174_110 = (FStar_Util.string_of_int i)
in (Prims.strcat "\'dummyV" _174_110))
in ((_174_111), ((Prims.parse_int "0")))))))
in (FStar_List.append vars _174_112))
in (

let tbody = (match ((FStar_Util.find_opt (fun _80_5 -> (match (_80_5) with
| FStar_Syntax_Syntax.RecordType (_80_160) -> begin
true
end
| _80_163 -> begin
false
end)) ind.iquals)) with
| Some (FStar_Syntax_Syntax.RecordType (ids)) -> begin
(

let _80_170 = (FStar_List.hd ctors)
in (match (_80_170) with
| (_80_168, c_ty) -> begin
(

let _80_171 = ()
in (

let fields = (FStar_List.map2 (fun lid ty -> (((lident_as_mlsymbol lid)), (ty))) ids c_ty)
in FStar_Extraction_ML_Syntax.MLTD_Record (fields)))
end))
end
| _80_177 -> begin
FStar_Extraction_ML_Syntax.MLTD_DType (ctors)
end)
in ((env), (((false), ((lident_as_mlsymbol ind.iname)), (ml_params), (Some (tbody)))))))
end))
end))
end)))
in (match (se) with
| FStar_Syntax_Syntax.Sig_bundle ((FStar_Syntax_Syntax.Sig_datacon (l, _80_181, t, _80_184, _80_186, _80_188, _80_190, _80_192))::[], (FStar_Syntax_Syntax.ExceptionConstructor)::[], _80_199, r) -> begin
(

let _80_205 = (extract_ctor [] env {dname = l; dtyp = t})
in (match (_80_205) with
| (env, ctor) -> begin
((env), ((FStar_Extraction_ML_Syntax.MLM_Exn (ctor))::[]))
end))
end
| FStar_Syntax_Syntax.Sig_bundle (ses, quals, _80_209, r) -> begin
(

let ifams = (bundle_as_inductive_families env ses quals)
in (

let _80_216 = (FStar_Util.fold_map extract_one_family env ifams)
in (match (_80_216) with
| (env, td) -> begin
((env), ((FStar_Extraction_ML_Syntax.MLM_Ty (td))::[]))
end)))
end
| _80_218 -> begin
(FStar_All.failwith "Unexpected signature element")
end))))


let level_of_sigelt : FStar_Extraction_ML_UEnv.env  ->  FStar_Syntax_Syntax.sigelt  ->  Prims.unit = (fun g se -> (

let l = (fun _80_6 -> (match (_80_6) with
| FStar_Extraction_ML_Term.Term_level -> begin
"Term_level"
end
| FStar_Extraction_ML_Term.Type_level -> begin
"Type_level"
end
| FStar_Extraction_ML_Term.Kind_level -> begin
"Kind_level"
end))
in (match (se) with
| (FStar_Syntax_Syntax.Sig_bundle (_)) | (FStar_Syntax_Syntax.Sig_inductive_typ (_)) | (FStar_Syntax_Syntax.Sig_datacon (_)) -> begin
(FStar_Util.print_string "\t\tInductive bundle")
end
| FStar_Syntax_Syntax.Sig_declare_typ (lid, _80_237, t, quals, _80_241) -> begin
(let _174_125 = (FStar_Syntax_Print.lid_to_string lid)
in (let _174_124 = (let _174_123 = (let _174_122 = (FStar_Extraction_ML_Term.level g t)
in (FStar_All.pipe_left (FStar_Extraction_ML_Term.predecessor t) _174_122))
in (l _174_123))
in (FStar_Util.print2 "\t\t%s @ %s\n" _174_125 _174_124)))
end
| FStar_Syntax_Syntax.Sig_let ((_80_245, (lb)::_80_247), _80_252, _80_254, _80_256) -> begin
(let _174_133 = (let _174_128 = (let _174_127 = (let _174_126 = (FStar_Util.right lb.FStar_Syntax_Syntax.lbname)
in _174_126.FStar_Syntax_Syntax.fv_name)
in _174_127.FStar_Syntax_Syntax.v)
in (FStar_All.pipe_right _174_128 FStar_Syntax_Print.lid_to_string))
in (let _174_132 = (FStar_Syntax_Print.term_to_string lb.FStar_Syntax_Syntax.lbtyp)
in (let _174_131 = (let _174_130 = (let _174_129 = (FStar_Extraction_ML_Term.level g lb.FStar_Syntax_Syntax.lbtyp)
in (FStar_All.pipe_left (FStar_Extraction_ML_Term.predecessor lb.FStar_Syntax_Syntax.lbtyp) _174_129))
in (l _174_130))
in (FStar_Util.print3 "\t\t%s : %s @ %s\n" _174_133 _174_132 _174_131))))
end
| _80_260 -> begin
(FStar_Util.print_string "other\n")
end)))


let rec extract_sig : env_t  ->  FStar_Syntax_Syntax.sigelt  ->  (env_t * FStar_Extraction_ML_Syntax.mlmodule1 Prims.list) = (fun g se -> (

let _80_266 = (FStar_Extraction_ML_UEnv.debug g (fun u -> (

let _80_264 = (let _174_140 = (let _174_139 = (FStar_Syntax_Print.sigelt_to_string se)
in (FStar_Util.format1 ">>>> extract_sig :  %s \n" _174_139))
in (FStar_Util.print_string _174_140))
in (level_of_sigelt g se))))
in (match (se) with
| (FStar_Syntax_Syntax.Sig_bundle (_)) | (FStar_Syntax_Syntax.Sig_inductive_typ (_)) | (FStar_Syntax_Syntax.Sig_datacon (_)) -> begin
(extract_bundle g se)
end
| FStar_Syntax_Syntax.Sig_new_effect (ed, _80_279) when (FStar_All.pipe_right ed.FStar_Syntax_Syntax.qualifiers (FStar_List.contains FStar_Syntax_Syntax.Reifiable)) -> begin
(

let extend_env = (fun g lid ml_name tm tysc -> (

let mangled_name = (Prims.snd ml_name)
in (

let g = (let _174_151 = (FStar_Syntax_Syntax.lid_as_fv lid FStar_Syntax_Syntax.Delta_equational None)
in (FStar_Extraction_ML_UEnv.extend_fv' g _174_151 ml_name tysc false false))
in (

let lb = {FStar_Extraction_ML_Syntax.mllb_name = ((mangled_name), ((Prims.parse_int "0"))); FStar_Extraction_ML_Syntax.mllb_tysc = None; FStar_Extraction_ML_Syntax.mllb_add_unit = false; FStar_Extraction_ML_Syntax.mllb_def = tm; FStar_Extraction_ML_Syntax.print_typ = false}
in ((g), (FStar_Extraction_ML_Syntax.MLM_Let (((FStar_Extraction_ML_Syntax.NonRec), ([]), ((lb)::[])))))))))
in (

let rec extract_fv = (fun tm -> (match ((let _174_154 = (FStar_Syntax_Subst.compress tm)
in _174_154.FStar_Syntax_Syntax.n)) with
| FStar_Syntax_Syntax.Tm_uinst (tm, _80_295) -> begin
(extract_fv tm)
end
| FStar_Syntax_Syntax.Tm_fvar (fv) -> begin
(

let mlp = (FStar_Extraction_ML_Syntax.mlpath_of_lident fv.FStar_Syntax_Syntax.fv_name.FStar_Syntax_Syntax.v)
in (

let _80_306 = (let _174_155 = (FStar_Extraction_ML_UEnv.lookup_fv g fv)
in (FStar_All.pipe_left FStar_Util.right _174_155))
in (match (_80_306) with
| (_80_302, tysc, _80_305) -> begin
(let _174_156 = (FStar_All.pipe_left (FStar_Extraction_ML_Syntax.with_ty FStar_Extraction_ML_Syntax.MLTY_Top) (FStar_Extraction_ML_Syntax.MLE_Name (mlp)))
in ((_174_156), (tysc)))
end)))
end
| _80_308 -> begin
(FStar_All.failwith "Not an fv")
end))
in (

let extract_action = (fun g a -> (

let _80_314 = (extract_fv a.FStar_Syntax_Syntax.action_defn)
in (match (_80_314) with
| (a_tm, ty_sc) -> begin
(

let _80_317 = (FStar_Extraction_ML_UEnv.action_name ed a)
in (match (_80_317) with
| (a_nm, a_lid) -> begin
(extend_env g a_lid a_nm a_tm ty_sc)
end))
end)))
in (

let _80_326 = (

let _80_320 = (extract_fv (Prims.snd ed.FStar_Syntax_Syntax.return_repr))
in (match (_80_320) with
| (return_tm, ty_sc) -> begin
(

let _80_323 = (FStar_Extraction_ML_UEnv.monad_op_name ed "return")
in (match (_80_323) with
| (return_nm, return_lid) -> begin
(extend_env g return_lid return_nm return_tm ty_sc)
end))
end))
in (match (_80_326) with
| (g, return_decl) -> begin
(

let _80_335 = (

let _80_329 = (extract_fv (Prims.snd ed.FStar_Syntax_Syntax.bind_repr))
in (match (_80_329) with
| (bind_tm, ty_sc) -> begin
(

let _80_332 = (FStar_Extraction_ML_UEnv.monad_op_name ed "bind")
in (match (_80_332) with
| (bind_nm, bind_lid) -> begin
(extend_env g bind_lid bind_nm bind_tm ty_sc)
end))
end))
in (match (_80_335) with
| (g, bind_decl) -> begin
(

let _80_338 = (FStar_Util.fold_map extract_action g ed.FStar_Syntax_Syntax.actions)
in (match (_80_338) with
| (g, actions) -> begin
((g), ((FStar_List.append ((return_decl)::(bind_decl)::[]) actions)))
end))
end))
end)))))
end
| FStar_Syntax_Syntax.Sig_new_effect (_80_340) -> begin
((g), ([]))
end
| FStar_Syntax_Syntax.Sig_declare_typ (lid, _80_344, t, quals, _80_348) when ((FStar_Extraction_ML_Term.level g t) = FStar_Extraction_ML_Term.Kind_level) -> begin
if (let _174_162 = (FStar_All.pipe_right quals (FStar_Util.for_some (fun _80_7 -> (match (_80_7) with
| FStar_Syntax_Syntax.Assumption -> begin
true
end
| _80_354 -> begin
false
end))))
in (FStar_All.pipe_right _174_162 Prims.op_Negation)) then begin
((g), ([]))
end else begin
(

let _80_358 = (FStar_Syntax_Util.arrow_formals t)
in (match (_80_358) with
| (bs, _80_357) -> begin
(let _174_163 = (FStar_Syntax_Util.abs bs FStar_TypeChecker_Common.t_unit None)
in (extract_typ_abbrev g lid quals _174_163))
end))
end
end
| FStar_Syntax_Syntax.Sig_let ((false, (lb)::[]), _80_364, _80_366, quals) when ((FStar_Extraction_ML_Term.level g lb.FStar_Syntax_Syntax.lbtyp) = FStar_Extraction_ML_Term.Kind_level) -> begin
(let _174_166 = (let _174_165 = (let _174_164 = (FStar_Util.right lb.FStar_Syntax_Syntax.lbname)
in _174_164.FStar_Syntax_Syntax.fv_name)
in _174_165.FStar_Syntax_Syntax.v)
in (extract_typ_abbrev g _174_166 quals lb.FStar_Syntax_Syntax.lbdef))
end
| FStar_Syntax_Syntax.Sig_let (lbs, r, _80_373, quals) -> begin
(

let elet = (FStar_Syntax_Syntax.mk (FStar_Syntax_Syntax.Tm_let (((lbs), (FStar_Syntax_Const.exp_false_bool)))) None r)
in (

let _80_383 = (FStar_Extraction_ML_Term.term_as_mlexpr g elet)
in (match (_80_383) with
| (ml_let, _80_380, _80_382) -> begin
(match (ml_let.FStar_Extraction_ML_Syntax.expr) with
| FStar_Extraction_ML_Syntax.MLE_Let ((flavor, _80_386, bindings), _80_390) -> begin
(

let _80_422 = (FStar_List.fold_left2 (fun _80_395 ml_lb _80_405 -> (match (((_80_395), (_80_405))) with
| ((env, ml_lbs), {FStar_Syntax_Syntax.lbname = lbname; FStar_Syntax_Syntax.lbunivs = _80_403; FStar_Syntax_Syntax.lbtyp = t; FStar_Syntax_Syntax.lbeff = _80_400; FStar_Syntax_Syntax.lbdef = _80_398}) -> begin
(

let lb_lid = (let _174_171 = (let _174_170 = (FStar_Util.right lbname)
in _174_170.FStar_Syntax_Syntax.fv_name)
in _174_171.FStar_Syntax_Syntax.v)
in (

let _80_419 = if (FStar_All.pipe_right quals (FStar_Util.for_some (fun _80_8 -> (match (_80_8) with
| FStar_Syntax_Syntax.Projector (_80_409) -> begin
true
end
| _80_412 -> begin
false
end)))) then begin
(

let mname = (let _174_173 = (mangle_projector_lid lb_lid)
in (FStar_All.pipe_right _174_173 FStar_Extraction_ML_Syntax.mlpath_of_lident))
in (

let env = (let _174_175 = (FStar_Util.right lbname)
in (let _174_174 = (FStar_Util.must ml_lb.FStar_Extraction_ML_Syntax.mllb_tysc)
in (FStar_Extraction_ML_UEnv.extend_fv' env _174_175 mname _174_174 ml_lb.FStar_Extraction_ML_Syntax.mllb_add_unit false)))
in ((env), ((

let _80_415 = ml_lb
in {FStar_Extraction_ML_Syntax.mllb_name = (((Prims.snd mname)), ((Prims.parse_int "0"))); FStar_Extraction_ML_Syntax.mllb_tysc = _80_415.FStar_Extraction_ML_Syntax.mllb_tysc; FStar_Extraction_ML_Syntax.mllb_add_unit = _80_415.FStar_Extraction_ML_Syntax.mllb_add_unit; FStar_Extraction_ML_Syntax.mllb_def = _80_415.FStar_Extraction_ML_Syntax.mllb_def; FStar_Extraction_ML_Syntax.print_typ = _80_415.FStar_Extraction_ML_Syntax.print_typ})))))
end else begin
(let _174_178 = (let _174_177 = (let _174_176 = (FStar_Util.must ml_lb.FStar_Extraction_ML_Syntax.mllb_tysc)
in (FStar_Extraction_ML_UEnv.extend_lb env lbname t _174_176 ml_lb.FStar_Extraction_ML_Syntax.mllb_add_unit false))
in (FStar_All.pipe_left Prims.fst _174_177))
in ((_174_178), (ml_lb)))
end
in (match (_80_419) with
| (g, ml_lb) -> begin
((g), ((ml_lb)::ml_lbs))
end)))
end)) ((g), ([])) bindings (Prims.snd lbs))
in (match (_80_422) with
| (g, ml_lbs') -> begin
(

let flags = (let _174_182 = if (FStar_Util.for_some (fun _80_9 -> (match (_80_9) with
| FStar_Syntax_Syntax.Assumption -> begin
true
end
| _80_426 -> begin
false
end)) quals) then begin
(FStar_Extraction_ML_Syntax.Assumed)::[]
end else begin
[]
end
in (let _174_181 = if (FStar_Util.for_some (fun _80_10 -> (match (_80_10) with
| FStar_Syntax_Syntax.Private -> begin
true
end
| _80_430 -> begin
false
end)) quals) then begin
(FStar_Extraction_ML_Syntax.Private)::[]
end else begin
[]
end
in (FStar_List.append _174_182 _174_181)))
in (let _174_185 = (let _174_184 = (let _174_183 = (FStar_Extraction_ML_Util.mlloc_of_range r)
in FStar_Extraction_ML_Syntax.MLM_Loc (_174_183))
in (_174_184)::(FStar_Extraction_ML_Syntax.MLM_Let (((flavor), (flags), ((FStar_List.rev ml_lbs')))))::[])
in ((g), (_174_185))))
end))
end
| _80_433 -> begin
(let _174_187 = (let _174_186 = (FStar_Extraction_ML_Code.string_of_mlexpr g.FStar_Extraction_ML_UEnv.currentModule ml_let)
in (FStar_Util.format1 "Impossible: Translated a let to a non-let: %s" _174_186))
in (FStar_All.failwith _174_187))
end)
end)))
end
| FStar_Syntax_Syntax.Sig_declare_typ (lid, _80_436, t, quals, r) -> begin
if (FStar_All.pipe_right quals (FStar_List.contains FStar_Syntax_Syntax.Assumption)) then begin
(

let always_fail = (

let imp = (match ((FStar_Syntax_Util.arrow_formals t)) with
| ([], t) -> begin
(fail_exp lid t)
end
| (bs, t) -> begin
(let _174_188 = (fail_exp lid t)
in (FStar_Syntax_Util.abs bs _174_188 None))
end)
in (let _174_194 = (let _174_193 = (let _174_192 = (let _174_191 = (let _174_190 = (let _174_189 = (FStar_Syntax_Syntax.lid_as_fv lid FStar_Syntax_Syntax.Delta_constant None)
in FStar_Util.Inr (_174_189))
in {FStar_Syntax_Syntax.lbname = _174_190; FStar_Syntax_Syntax.lbunivs = []; FStar_Syntax_Syntax.lbtyp = t; FStar_Syntax_Syntax.lbeff = FStar_Syntax_Const.effect_ML_lid; FStar_Syntax_Syntax.lbdef = imp})
in (_174_191)::[])
in ((false), (_174_192)))
in ((_174_193), (r), ([]), (quals)))
in FStar_Syntax_Syntax.Sig_let (_174_194)))
in (

let _80_452 = (extract_sig g always_fail)
in (match (_80_452) with
| (g, mlm) -> begin
(match ((FStar_Util.find_map quals (fun _80_11 -> (match (_80_11) with
| FStar_Syntax_Syntax.Discriminator (l) -> begin
Some (l)
end
| _80_457 -> begin
None
end)))) with
| Some (l) -> begin
(let _174_200 = (let _174_199 = (let _174_196 = (FStar_Extraction_ML_Util.mlloc_of_range r)
in FStar_Extraction_ML_Syntax.MLM_Loc (_174_196))
in (let _174_198 = (let _174_197 = (FStar_Extraction_ML_Term.ind_discriminator_body g lid l)
in (_174_197)::[])
in (_174_199)::_174_198))
in ((g), (_174_200)))
end
| _80_461 -> begin
(match ((FStar_Util.find_map quals (fun _80_12 -> (match (_80_12) with
| FStar_Syntax_Syntax.Projector (l, _80_465) -> begin
Some (l)
end
| _80_469 -> begin
None
end)))) with
| Some (_80_471) -> begin
((g), ([]))
end
| _80_474 -> begin
((g), (mlm))
end)
end)
end)))
end else begin
((g), ([]))
end
end
| FStar_Syntax_Syntax.Sig_main (e, r) -> begin
(

let _80_484 = (FStar_Extraction_ML_Term.term_as_mlexpr g e)
in (match (_80_484) with
| (ml_main, _80_481, _80_483) -> begin
(let _174_204 = (let _174_203 = (let _174_202 = (FStar_Extraction_ML_Util.mlloc_of_range r)
in FStar_Extraction_ML_Syntax.MLM_Loc (_174_202))
in (_174_203)::(FStar_Extraction_ML_Syntax.MLM_Top (ml_main))::[])
in ((g), (_174_204)))
end))
end
| FStar_Syntax_Syntax.Sig_new_effect_for_free (_80_486) -> begin
(FStar_All.failwith "impossible -- removed by tc.fs")
end
| (FStar_Syntax_Syntax.Sig_assume (_)) | (FStar_Syntax_Syntax.Sig_sub_effect (_)) | (FStar_Syntax_Syntax.Sig_effect_abbrev (_)) | (FStar_Syntax_Syntax.Sig_pragma (_)) -> begin
((g), ([]))
end)))


let extract_iface : FStar_Extraction_ML_UEnv.env  ->  FStar_Syntax_Syntax.modul  ->  env_t = (fun g m -> (let _174_209 = (FStar_Util.fold_map extract_sig g m.FStar_Syntax_Syntax.declarations)
in (FStar_All.pipe_right _174_209 Prims.fst)))


let rec extract : FStar_Extraction_ML_UEnv.env  ->  FStar_Syntax_Syntax.modul  ->  (FStar_Extraction_ML_UEnv.env * FStar_Extraction_ML_Syntax.mllib Prims.list) = (fun g m -> (

let _80_504 = (FStar_Syntax_Syntax.reset_gensym ())
in (

let name = (FStar_Extraction_ML_Syntax.mlpath_of_lident m.FStar_Syntax_Syntax.name)
in (

let g = (

let _80_507 = g
in {FStar_Extraction_ML_UEnv.tcenv = _80_507.FStar_Extraction_ML_UEnv.tcenv; FStar_Extraction_ML_UEnv.gamma = _80_507.FStar_Extraction_ML_UEnv.gamma; FStar_Extraction_ML_UEnv.tydefs = _80_507.FStar_Extraction_ML_UEnv.tydefs; FStar_Extraction_ML_UEnv.currentModule = name})
in if (((m.FStar_Syntax_Syntax.name.FStar_Ident.str = "Prims") || m.FStar_Syntax_Syntax.is_interface) || (FStar_Options.no_extract m.FStar_Syntax_Syntax.name.FStar_Ident.str)) then begin
(

let g = (extract_iface g m)
in ((g), ([])))
end else begin
(

let _80_511 = (let _174_214 = (FStar_Syntax_Print.lid_to_string m.FStar_Syntax_Syntax.name)
in (FStar_Util.print1 "Extracting module %s\n" _174_214))
in (

let _80_515 = (FStar_Util.fold_map extract_sig g m.FStar_Syntax_Syntax.declarations)
in (match (_80_515) with
| (g, sigs) -> begin
(

let mlm = (FStar_List.flatten sigs)
in ((g), ((FStar_Extraction_ML_Syntax.MLLib ((((name), (Some ((([]), (mlm)))), (FStar_Extraction_ML_Syntax.MLLib ([]))))::[]))::[])))
end)))
end))))




