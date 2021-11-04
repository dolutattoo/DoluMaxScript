fn create_GIMS_model=(
	model_new = EGIMS_V_Model()
	for i in selection do 
	(	
			model_new.rotation = i.rotation
			model_new.pivot = i.pivot
			model_new.name = selection[1].name
			i.parent  = model_new
			if((classOf i) == Editable_Mesh or (classOf i) == Editable_Poly) then
			(
				addmodifier i (EGIMS_V_ModelMesh())
			)else 
			(
				model_new.name = "GTAV_Model"
				messagebox "Model succefully created but selected object was not a geometry, so the game mesh modifier was not applied."
			)
	)
)

fn gamemesh_GIMS_model=(
	for i in selection do 
	(	
		if(classof(i) == Editable_Poly) or (classof(i) == Editable_Mesh) then
		(
			addmodifier i (EGIMS_V_ModelMesh())
		)else messagebox "Object needs to be set as Editable Poly or Editable Mesh."
	)
)

fn meshmodifier_GIMS_composite=(
	for i in selection do 
	(	
		if((classOf i) == Editable_Mesh or (classOf i) == Editable_Poly) then
		(
			addmodifier i (EGIMS_V_CollisionMesh())
		)else messagebox "Object needs to be set as Editable Poly or Editable Mesh."
	)
)

fn primitive_box_col=(
	selectedObjects = selection as Array

	for j=1 to selectedObjects.count do
	(	
		i = selectedObjects[j]

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
	for i in selection do 
	(	
		if(classof(i) == Editable_Poly) or (classof(i) == Editable_Mesh) then
		(
			model_new = EGIMS_V_Model()
			model_new.name = i.name
			model_new.rotation = i.rotation
			model_new.pivot = i.pivot
			i.parent  = model_new
			addmodifier i (EGIMS_V_ModelMesh())
		)
		else 
		(
			-- messagebox "Object % needs to be set as Editable Poly or Editable Mesh." + i[1].name
			local currentObj = i.name
			messagebox (i.name + " is not an Editable Mesh.")
		)
	)
)

fn create_GIMS_composite=(
	composite_new = EGIMS_V_Col_Composite()
	composite_new.name = "NEW GTAV COMPOSITE"
	for i in selection do 
	(	
		if((superclassOf i) == GeometryClass) then
		(
			i.parent  = composite_new
			i.pivot = composite_new.pivot
			if((classOf i) == Editable_Mesh or (classOf i) == Editable_Poly) then
			(
				addmodifier i (EGIMS_V_CollisionMesh())
			)
			else
			(
				format "% is not an Editable_Mesh or Editable_Poly, Mesh modifier skipped\n" (i.name)
			)
		)
		else
		(
			format "% is not a Geometry\n" (i.name)
		)
	)
)




fn create_GIMS_model_withEmbedCol=(
	
	if (selection.count == 1) then
    (
		model_new = EGIMS_V_Model()
		for i in selection do 
		(	

					if((superclassOf i) == GeometryClass) then
					(
						model_new.rotation = i.rotation
						model_new.pivot = i.pivot
						model_new.name = selection[1].name
						i.parent  = model_new
						
						collisionObj = for myobj in (selection as array) collect (copy myobj ) -- dupplicating object as copy
						collisionObj.name = selection[1].name + "_col"  -- Generating name with suffix to collision object
						collisionObj.material = EGIMS_V_Material() -- Apply GTAV Collision Material to collision object.
						addmodifier collisionObj (EGIMS_V_CollisionMesh())
						
						addmodifier i (EGIMS_V_ModelMesh()) -- Applying Game Mesh on drawable geometry

						
						composite_new = EGIMS_V_Col_Composite()
						composite_new.parent = model_new
						composite_new.name = selection[1].name
						for k in collisionObj do
						(
							k.parent  = composite_new
						)
						
					)else messagebox "Selected object is not a Geometry"
		)
		
	)

	if (selection.count != 1) then
	(
		messagebox "Please select 1 object only."
	)
)