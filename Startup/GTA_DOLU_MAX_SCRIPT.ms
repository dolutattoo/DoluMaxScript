fileIn (scriptspath+"\\DOLU_MAX_SCRIPT\\utility\\gims_shortcuts.ms")

rollout DOLU_MAX_SCRIPT "Dolu MaxScript" 
(		
	groupBox modifiers "GTAV Modifiers" pos:[5,5] width:150 height:65
		button 'btn_gamemeshmodifier' "Game Mesh" pos:[10,20] width:80 height:20 tooltip:"Apply Game Mesh modifier (Drawable)"
		button 'btn_meshmodifier' "Mesh" pos:[95,20] width:55 height:20 tooltip:"Apply Mesh modifier (Collision)"
		button 'btn_primitive_box_col' "Primitive Box" pos:[10,45] width:80 height:20 tooltip:"Convert Box to GTAV box (only for primitives)"

	groupBox createmodel "GTAV Models" pos:[165,5] width:155 height:65
		button 'btn_createmodel' "Model"  pos:[170,22] width:55 tooltip:"Create a Drawable Model and apply Game Mesh modifier"
		checkbox embedcol "Embed Col" pos:[171,45]  tooltip:"Dupplicate the object to create an embeded collision with common flags and default material (Doesnt work with 'Multiple Models')"
		button 'btn_createmultimodels' "Multiple Models" pos:[230,22] width:85 tooltip:"Create a Drawable Model for each selected objects and apply Game Mesh modifier"
	
	groupBox createcol "GTAV Collision" pos:[325,5] width:110 height:65
		button 'btn_createcomposite' "Composite" pos:[340,22] width:80 tooltip:"Create a Composite and apply Mesh modifier (Collision)"
		checkbox colmaterial "Default Material" pos:[333,45]

	groupBox metafiles "GTAV Meta Files" pos:[445,5] width:151 height:65
		button 'btn_ytyp' "Ytyp" pos:[450,25] width:68 height:30 tooltip:"Open YTYP tool"
		button 'btn_ymap' "Ymap" pos:[523,25] width:68 height:30 tooltip:"Open YMAP tool"

	groupBox tools "Tools" pos:[5,80] width:215 height:70
		button 'btn_paintvertex' "Paint Vertices" width:80 pos:[10,96] tooltip:"Paint object vertices with current color"
		colorpicker VertexColorPicker "" color:[0,255,0] modal:false pos:[95,96] width:25
		button 'btn_occlu' "Occlusion Box" pos:[130,96] width:80 tooltip:"Generate occlusion boxes from prim boxes"
		button 'btn_Vertices2Portals' "Portals" width:50  pos:[10,122] tooltip:"Open Portals tool"
	
	groupBox pivotoptions "Move/Pivot Options" pos:[235,80] width:361 height:70
		button 'btn_pos_and_rot_to_parent' "Snap to Parent" width:90  pos:[240,96] tooltip:"Align object using parent pivot"
		button 'btn_get_parent_pivot' "Get Parent Pivot" width:95 pos:[335,96] tooltip:"Align pivot to parent pivot"
		button 'btn_get_children_pivot' "Get Children Pivot" width:100 pos:[435,96] tooltip:"Align pivot to children pivot"
		button 'btn_centerbottom' "Center Pivot to Bottom" width:125 pos:[240,122] tooltip:"Align pivot to the object bottom center"
		button 'btn_resetpivot' "Pivot to world" width:80 pos:[370,122] tooltip:"Reset pivot position and rotation to world"
		button 'btn_resetXForm' "XForm" width:45 pos:[455,122] tooltip:"Reset XForm and convert to editable poly"
		button 'btn_resetPos' "Reset Pos" width:60 pos:[505,122] tooltip:"Reset XYZ coordinates"
	
	groupBox materialsoptions "Material Options" pos:[5,155] width:590 height:40
		button 'btn_material_editor' "Material Editor" width:110 height:20 pos:[10,170]
		button 'btn_copy_material' "Copy Lib" width:60 height:20 pos:[125,170]
		button 'btn_paste_material' "Paste Lib" width:60 height:20 pos:[190,170]
		button 'btn_convert_material_to_col' "Default Collision Material" width:140 height:20 pos:[255,170] tooltip:"Apply collision default material to selected object"
		button 'btn_apply_generic_flags' "Collision flags" width:110 height:20 pos:[400,170] tooltip:"Apply generic collision flags to selected objects"
	
	/* TODO- IMPORT EXPORT SHORTCUTS
	 
	button 'btn_Export' "Export" width:55 height:25 pos:[5,200]
	button 'btn_Import' "Import" width:55 height:25 pos:[65,200]
		
	

	on btn_Export pressed do (
		local	GUIMgr = GIMS.Core.GUIMgr,
				UpdateProgress = GUIMgr.UpdateProgress,
				SavePath = (GetSavePath Caption:"Select a location to export" InitialDir:GUIMgr.LastPath)
				
		
		if Have SavePath then (
			Append SavePath "\\"
			GUIMgr.LastPath = SavePath
			GUIMgr.InitProgress #(
				"Collect objects from scene"
			) Title:"Export"
			UpdateProgress #Stage 1
			local	Objs = (GIMS.Core.MAXFactory.SceneOps.GetObjsToExport()),
					HaveObjects = (Objs.Count != 0),
					AddResult = GIMS.Core.SystemMgr.AddResult
			if HaveObjects then (
				local	MaxMemUsage = 0.9,
						MemInfo = (SysInfo.GetSystemMemoryInfo()),
						GBDiv = (1024L * 1024L * 1024L),
						RAMFree = ((MemInfo[3] as Float) / GBDiv),
						RAMCanBeUsed = (RAMFree * MaxMemUsage),
						SwapFree = ((MemInfo[5] as Float) / GBDiv),
						MemFree = (RAMFree + SwapFree)
				for CNode in Objs do (
					local	CNodeFaceCount = (Export_GetCNodeFaceCount CNode 0),
							ProjMemoryFootprint = ((0.001 * CNodeFaceCount) / 28)
					if ProjMemoryFootprint > RAMCanBeUsed then (
						if ProjMemoryFootprint > MemFree then (
							local	SS = (StringStream "")
							Format "Model or dictionary \"%\" contains % faces, and it can take a lot of time and memory to export it.\n" CNode.Obj.Name CNodeFaceCount To:SS
							Format "Projected memory usage is around % GB, while you have only % GB of free memory(% GB RAM, % GB Swap).\n" ProjMemoryFootprint MemFree RAMFree SwapFree To:SS
							Format "You should consider splitting that model into multiple pieces.\n" To:SS
							AddResult #Error (SS as String)
							Free SS
						) else (
							local	SS = (StringStream "")
							Format "Model or dictionary \"%\" contains % faces, and it can take a lot of time and memory to export it.\n" CNode.Obj.Name CNodeFaceCount To:SS
							Format "Projected memory usage is around % GB, while you have % GB of free RAM and % GB of free Swap memory.\n" ProjMemoryFootprint RAMFree SwapFree To:SS
							Format "You can continue at your own risk if you have most of the swap memory on an SSD disk,\n" To:SS
							Format "but it will be better to split that model into multiple pieces." To:SS
							AddResult #Warning (SS as String)
							Free SS
						)
					)
					GIMS.Core.ArrayOps.Dispose MeshInfos
				)
				Free MemInfo
			) else
				AddResult #Error "Nothing found to export."
			GIMS.Core.ObjectMgr.ExchangeData = #(#(GIMS.CurrentGame, 2, #Export_Select, 2), Objs, SavePath)
			GUIMgr.EndProgress true Continueable:HaveObjects
		)
	)
	
	on btn_Import pressed do (
		GIMS.Core.ObjectMgr.ExchangeData = #(
			undefined,
			(
				GIMS.Core.GUI.SelectFiles \
				"Select the resources to load" \
				true \
				"GTA V openFormats|*.obn;*.obd;*.odr;*.odd;*.ovr|GTA V drawables|*.odr;*.odd|GTA V bounds|*.obn;*.obd"
			)
		)
		
		TODO remove, distantlights and OVR support
		GIMS.Core.ObjectMgr.ExchangeData = #(
			undefined,
			(
				GIMS.Core.GUI.SelectFiles \
				"Select the resources to load" \
				true \
				"GTA V openFormats, paths|*.obn;*.obd;*.odr;*.odd;distantlights_hd.dat|GTA V drawables|*.odr;*.odd|GTA V bounds|*.obn;*.obd|GTA V Paths|*.ovr;distantlights_hd.dat"
			)
		)
		
		Import_Files Sender Args
	)
	*/
	---------------------------
	-- APPLY MODIFIERS
	on btn_gamemeshmodifier pressed do (
		gamemesh_GIMS_model()
	)

	on btn_meshmodifier pressed do (
		meshmodifier_GIMS_composite()
	)

	on btn_primitive_box_col pressed do (
		primitive_box_col()
	)
	---------------------------
	-- CREATE MODELS/COMPOSITES
	
	global embedCollision = false
	on embedcol changed theState do (
		embedCollision = theState
	)
	
	on btn_createmodel pressed do (
		for obj in selection do (
			if embedCollision then (
				if(classof(obj) == Editable_Poly) or (classof(obj) == Editable_Mesh) then (	
					create_GIMS_model_withEmbedCol()
				)else messagebox "Object needs to be set as Editable Poly or Editable Mesh."
			) else (
				if (classof(obj) == Editable_Poly) or (classof(obj) == Editable_Mesh) then (	
					create_GIMS_model()
				) else messagebox "Object needs to be set as Editable Poly or Editable Mesh."
			)
		)
	)
	
	on btn_createmultimodels pressed do
	(
		create_multiple_GIMS_models()
	)
	
	global collisionMaterial = false
	on colmaterial changed theState do (
		if theState then (
			collisionMaterial = true
		) else (	
			collisionMaterial = false
		)
	)
	
	on btn_convert_material_to_col pressed do (
		for o in selection do (
			o.material = EGIMS_V_Material()
			messagebox "Material applied."
		)
	)
	
	on btn_apply_generic_flags pressed do (
		for obj in selection do (

			-- If selection is a mesh and doesnt have the Mesh modifier, apply it first.
			if ((classof(obj) == Editable_Mesh) or (classof(obj) == Editable_Poly)) then (
				
				-- Testing with delete the mesh modifier if there is one before to apply a fresh one again
				if (classOf(obj.modifiers[#Mesh]) == EGIMS_V_CollisionMesh) then (
					deleteModifier obj (obj.modifiers[#Mesh])
				)

				addmodifier obj (EGIMS_V_CollisionMesh())
			)

			-- If collision have Mesh modifier or is a Collision Box
			if (classOf(obj.modifiers[#Mesh]) == EGIMS_V_CollisionMesh) or (classOf(obj) == EGIMS_V_Col_Box) then (

				local flagsON = #(7,8,10,13,14)
				local flagsOFF = #(1,2,3,4,5,6,9,11,12,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32)

				-- If Mesh modifier, set VertOffset part to 0.0025
				if ((classof(obj) == Editable_Mesh) or (classof(obj) == Editable_Poly)) and (classOf(obj.modifiers[#Mesh]) == EGIMS_V_CollisionMesh) then (
					for i=1 to flagsON.count do (
						obj.modifiers[#Mesh].Flags1[flagsON[i]] = on
					)
					for j=1 to flagsOFF.count do (
						obj.modifiers[#Mesh].Flags1[flagsOFF[j]] = off
					)
					obj.modifiers[#Mesh].VertexOffset_UnkPart = 0.0025 as float
					
				) else (
					for i=1 to flagsON.count do (
						obj.Flags1[flagsON[i]] = on
					)
					for j=1 to flagsOFF.count do (
						obj.Flags1[flagsOFF[j]] = off
					)
				)
			) else messagebox "Object needs to be an Editable Poly, an Editable Mesh or a Col Box."
		)
		print "[DoluMaxScript] Flags succefully applied!"
	)
	
	---------------------------
	-- META FILES
	on btn_ytyp pressed do (
		fileIn (scriptspath+"\\DOLU_MAX_SCRIPT\\gui\\ytyp_settings.ms")
	)
	
	on btn_ymap pressed do (
		fileIn (scriptspath+"\\DOLU_MAX_SCRIPT\\gui\\ymap_settings.ms")
	)

	on btn_occlu pressed do (
		fileIn (scriptspath+"\\DOLU_MAX_SCRIPT\\gui\\occlu_settings.ms")
	)
	
	---------------------------
	-- TOOLS
	
	global vColor = [0,255,0]
	on VertexColorPicker changed new_col do  (
		vColor = new_col
	)
	
	on btn_paintvertex pressed do (
		for obj in selection do (
			if (classof(obj) == Editable_Mesh) then
			(	
				setNumCPVVerts obj obj.numverts
				defaultVCFaces obj
				for n in 1 to obj.numverts do
				(
					setvertcolor obj n vColor
				)
				print "[DoluMaxScript] Vertex color applied !"
			) else messagebox "Object needs to be an Editable Mesh before to apply the vertex color."
		)
	) 
	
	on btn_get_children_pivot pressed do (
		for i in selection do (	
			if(i.children.count > 0) then (
				children_center = [0,0,0]
				for b in i.children do (
					children_center = children_center + b.center
				)
				children_center = children_center/i.children.count
				i.pivot = children_center
				i.children.pivot = children_center
			) else messagebox "Object doesnt have any child."
		)
	)
	
	on btn_get_parent_pivot pressed do (
		for i in selection do (
			if(i.parent != undefined) then (
				i.pivot = i.parent.pivot
			)else messagebox "Object doesnt have parent."
		)
	)
	
	on btn_pos_and_rot_to_parent pressed do (
		for i in selection do (
			if (i.parent != undefined) then (
				i.pos = i.parent.pos
				i.rotation = i.parent.rotation
			)else messagebox "Object doesnt have parent."
		)
	)
	
	on btn_pos_to_parent pressed do (
		for i in selection do (
			if(i.parent != undefined) then
			(
				i.pos = i.parent.pos
			)else messagebox "Object doesnt have parent."
		)
	)
	
	
	
	on btn_centerbottom pressed do (
		for i in selection do (
			i.pivot = i.center
			i.pivot.z = i.min.z
		)
	)

	on btn_resetpivot pressed do (
		for i in selection do (
			i.pivot.x = 0
			i.pivot.y = 0
			i.pivot.z = 0
			WorldAlignPivot(i)
		)
	)
	
	on btn_resetXForm pressed do (	
		for obj in selection do (	
			resetXForm obj
			macros.run "Modifier Stack" "Convert_to_Poly"
		)
	)
	
	on btn_resetPos pressed do (
		for obj in selection do (
			obj.pos = [0,0,0]
		)	
	)
	
	---------------------------
	-- MATERIAL OPTIONS
	on btn_material_editor pressed do (
		DestroyDialog EGIMS_V_matlist
		CreateDialog EGIMS_V_matlist Style:#(#style_titlebar, #style_border, #style_sysmenu, #style_minimizebox)
	)
	
	
	global stored_material
	on btn_copy_material pressed do (
		if (selection.count == 0) then (
			messagebox "Nothing selected" 
		) else (
			if (selection[1].mat == undefined) then (
				messagebox "Object has no material"
			) else (
				stored_material = selection[1].mat
				print "[DoluMaxScript] MATERIAL LIBRARY COPIED!"
			)
		)

	)

	on btn_paste_material pressed do (
		if (selection.count == 0) then (
			messagebox "Nothing selected"
		) else (
			if (stored_material == undefined) then (
				messagebox "Copy material first"
			) else (
				for obj in selection do (
					obj.mat = stored_material
					print "[DoluMaxScript] MATERIAL LIBRARY PASTED!"
				)
			)
		)
	)
	
	on btn_createcomposite pressed do
	(
		for obj in selection do
		(	
			if(classof(obj) == Editable_Poly) or (classof(obj) == Editable_Mesh) then
			(
				if collisionMaterial then
				(
					create_GIMS_composite()
					obj.material = EGIMS_V_Material()
				)else
				(
					create_GIMS_composite()
				)
			)else messagebox "Object needs to be set as Editable Poly or Editable Mesh."
		)
	)
	
	---------------------------
	-- VERTICES 2 PORTALS
	rollout MKTools "Vertex2Portal Converter"
	(
		button 'addSelectionBtn' "Format Portal Positions" pos:[11,109] width:200 height:40 enabled:true align:#left
		edittext 'vertexText' "" pos:[9,18] width:200 height:89 align:#left
		button 'clearSelectionBtn' "Clear Selection" pos:[111,149] width:100 height:30 align:#left
		button 'copyBtn' "Copy To Clipboard" pos:[11,149] width:100 height:30 align:#left
		GroupBox 'grp1' "" pos:[5,4] width:212 height:182 align:#left
		checkbox myCheckBox "Add ' , ' (for CodeWalker use)" align:#center

		global putCommas = false
		on myCheckBox changed theState do (
			if theState then (
				putCommas = true
			) else  (	
				putCommas = false
			)
		)

		on addSelectionBtn pressed do (	
			try
			for i in $.selectedVerts do (
				if putCommas then (
					vertexText.text += i.pos.x as string + ", " + i.pos.y as string + ", " + i.pos.z as string + "\r\n"
				) else  ( 
					vertexText.text += i.pos.x as string + " " + i.pos.y as string + " " + i.pos.z as string + "\r\n"
				)
			) catch (
				messageBox "No Vertices Selected!"
			)
			
		)
		on clearSelectionBtn pressed do (	
			vertexText.text = ""
		)

		on copyBtn pressed do (	
			local str = vertexText.text
			retCode = setclipboardText str
		)
 	)
	on btn_Vertices2Portals pressed do
    (
        if (not MKTools.open or not MKTools.isDisplayed) do (
            if (not (menu == undefined ) and menu.placement == #minimized) then (
                menu.placement = #normal
            ) else (
		        menu = newRolloutFloater "V2P" 234 243
            )
        )
		addrollout MKTools menu
	)
)

createdialog DOLU_MAX_SCRIPT 600 230 935 690

utility DOLU_MAX_SCRIPT2 "Dolu Max Script" (
	button open_menu "Open" width:125 height:30
    button open_cred_menu "About" width:75 height:20
	on open_menu pressed do (
        if (not DOLU_MAX_SCRIPT.open or not DOLU_MAX_SCRIPT.isDisplayed) do (
            if (not (menu == undefined ) and menu.placement == #minimized) then (
                menu.placement = #normal
            )
        )
		createdialog DOLU_MAX_SCRIPT 600 230 935 690
	)
	
    on open_cred_menu pressed do (
        messageBox "Dolu Max Script v0.1 \r\n"
    )
)
openUtility DOLU_MAX_SCRIPT2