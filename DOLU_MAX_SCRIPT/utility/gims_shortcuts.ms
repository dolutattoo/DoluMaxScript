fn create_GIMS_model=(
	model_new = EGIMS_V_Model()
	for j=1 to selection.count do (	
		i = selection[j]

		if (classOf i) == Editable_Mesh or (classOf i) == Editable_Poly then (
			model_new.rotation = i.rotation
			model_new.pivot = i.pivot
			model_new.name = i.name
			i.parent  = model_new
			addmodifier i (EGIMS_V_ModelMesh())
			i.name = i.name + "_high"
		) else messagebox "Object needs to be set as Editable Poly or Editable Mesh."
	)
)

fn gamemesh_GIMS_model=(
	for j=1 to selection.count do (	
		local i = selection[j]

		if classof(i) == Editable_Poly or classof(i) == Editable_Mesh then (
			addmodifier i (EGIMS_V_ModelMesh())
		) else messagebox "Object needs to be set as Editable Poly or Editable Mesh."
	)
)

fn meshmodifier_GIMS_composite=(
	for j=1 to selection.count do (	
		local i = selection[j]

		if (classOf i) == Editable_Mesh or (classOf i) == Editable_Poly then (
			addmodifier i (EGIMS_V_CollisionMesh())
			i.modifiers[#Mesh].VertexOffset_UnkPart = 0.0025 as float

			flags = #(7, 8, 10, 13, 14)
			for j=1 to flags.count do (
				i.modifiers[#Mesh].Flags1[flags[j]] = on
			)
		) else messagebox "Object needs to be set as Editable Poly or Editable Mesh."
	)
)

fn primitive_box_col=(

	for i in selection do (
		
		-- calculating bounding box of the geometry
		bb = nodeGetBoundingBox i i.transform
		size = (bb[2]-bb[1])

		in coordsys i (

			-- creating a temporary standard primitive box from boundaries datas
			temp_box = box width:size[1] length:size[2] height:size[3]
			CenterPivot temp_box
			temp_box.transform = i.transform
			temp_box.pivot = i.pivot
			temp_box.pos = i.center
			temp_box.name = i.name
			
			-- creating a gta col primbox and apply it all the necessary stuff from temp_box
			v_prim = EGIMS_V_Col_PrimBox()
			v_prim.name = "v_" + temp_box.name
			v_prim.position = temp_box.position
			v_prim.rotation = temp_box.rotation
			v_prim.pivot = temp_box.pivot
			v_prim.width = temp_box.width
			v_prim.depth = temp_box.length
			v_prim.height = temp_box.height
			
			-- delete the temporary standard primbox
			delete i
			delete temp_box
		)
	)
)

fn create_multiple_GIMS_models=(
	for j=1 to selection.count do (	
		local i = selection[j]

		if(classof(i) == Editable_Poly) or (classof(i) == Editable_Mesh) then (
			model_new = EGIMS_V_Model()
			model_new.name = i.name
			model_new.rotation = i.rotation
			model_new.pivot = i.pivot
			i.parent  = model_new
			addmodifier i (EGIMS_V_ModelMesh())
		) else messagebox (i.name + " is not an Editable Mesh.")
	)
)

fn create_GIMS_composite=(
	for j=1 to selection.count do (
		local i = selection[j]

		local composite_new = EGIMS_V_Col_Composite()
		composite_new.name = i.name
		if((superclassOf i) == GeometryClass) then (
			i.parent  = composite_new
			i.pivot = composite_new.pivot
			if((classOf i) == Editable_Mesh or (classOf i) == Editable_Poly) then (
				addmodifier i (EGIMS_V_CollisionMesh())
				i.modifiers[#Mesh].VertexOffset_UnkPart = 0.0025 as float

				flags = #(7, 8, 10, 13, 14)
				for j=1 to flags.count do (
					i.modifiers[#Mesh].Flags1[flags[j]] = on
				)
			) else format "% is not an Editable_Mesh or Editable_Poly, Mesh modifier skipped\n" (i.name)
		) else format "% is not a Geometry\n" (i.name)
	)
)

fn create_GIMS_model_withEmbedCol=(
	
	if selection.count == 1 then ( -- TODO | Be able to make this process with multiple objects selected
		for j=1 to selection.count do (	
			local obj = selection[j]
			
			if classOf obj == Editable_Mesh or classOf obj == Editable_Poly then (
				-- creating a model as parent
					local model_new = EGIMS_V_Model()
					model_new.rotation = obj.rotation
					model_new.pivot = obj.pivot
					model_new.name = obj.name
					obj.parent = model_new
				
				-- dupplicate the object and create a collision
					local collisionObj = copy obj
					collisionObj.name = "0x1"
					collisionObj.material = EGIMS_V_Material() -- Apply GTAV default col material

				-- set flags and offset for collision
					addmodifier collisionObj (EGIMS_V_CollisionMesh())
					collisionObj.modifiers[#Mesh].VertexOffset_UnkPart = 0.0025
					local flags = #(7, 8, 10, 13, 14)
					for j=1 to flags.count do (
						collisionObj.modifiers[#Mesh].Flags1[flags[j]] = on
					)
				
				-- create a composite as parent of the collision mesh
					local composite_new = EGIMS_V_Col_Composite()
					composite_new.name = obj.name
					composite_new.parent = model_new
					collisionObj.parent = composite_new
			
				-- rename the drawable geometry
					addmodifier obj (EGIMS_V_ModelMesh())
					obj.name = obj.name + "_high"
				
			) else messagebox "Object needs to be set as Editable Poly or Editable Mesh."
		)
	) else messagebox "Please select 1 object only."
)