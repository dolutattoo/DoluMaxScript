fn alignPivotToFaceZUp node face:1 =
(
	c = polyop.getfacecenter node face
	n = polyop.getfacenormal node face
	
	side = cross z_axis n
	up = cross n side
	
	ftm = matrix3 n side up c
	
	p = (nodeGetBoundingBox node ftm)[1] * ftm
	prerotateZ ftm -90 
		
	itm = ftm*(inverse node.transform)
	node.transform = ftm
	node.objectOffsetPos *= inverse itm
	node.objectOffsetRot *= inverse itm.rotation
		
	node.pivot = p
	node.transform
)

rollout PropsUtilityGUI "Placement Tools" width:150 height:240
	(	
		group "Utility"
		(
			button 'btn_center' "Center Pivot to Children" width:130 align:#center
			button 'btn_reset2' "Pos and Rot to Parent" width:130 align:#center
			button 'btn_reset1' "Pivot to Parent" width:130 align:#center
			button 'btn_centerbottom' "Center Pivot to Bottom" width:130 align:#center
			button 'btn_reset3' "Position to Parent" width:130 align:#center
			button 'btn_reset4' "Reset Z up" width:130 align:#center
			button 'btn_bottom_face' "Pivot to Bottom Face" width:130 align:#center
			button 'btn_delete_duplicate' "Delete duplicates" width:130 align:#center
		)
		
		on btn_bottom_face pressed do
		(
			for obj in selection do
			(	
				if(classof(obj) == Editable_Poly)then
				(
					local faces = polyop.getNumFaces obj
					local fbottom = polyop.getfacecenter obj 1
					for face = 2 to faces do
					(
						fcenter = polyop.getfacecenter obj face
						if(fcenter.z < fbottom.z)do
							fbottom = fcenter
					)
					obj.pivot = fbottom
				)else format "% is not an Editable_Poly.\n" (obj.name)
			)
		)
		
		on btn_delete_duplicate pressed do
		(
			local allNames = #()
			local duplicateObjs = #()

			for obj in objects do
			(
				if findItem allNames obj.name == 0 then 
					append allNames obj.name
				else append duplicateObjs obj
			)
			delete duplicateObjs
			allNames = #()	
		)
		
		on btn_reset4 pressed do 
		(
			for obj in selection do
			(
				if (classof(obj) == Editable_Poly) then
				(
					obj.pivot = obj.center
					alignPivotToFaceZUp obj
					obj.pivot = obj.center
				)else format "% is not an Editable_Poly.\n" (obj.name)
			)
		)


		on btn_center pressed do
		(
			for i in selection do
				(	
					if(i.children.count > 0) then
					(
						children_center = [0,0,0]
						for b in i.children do
						(
							children_center = children_center + b.center
						)
						children_center = children_center/i.children.count
						i.pivot = children_center
						i.children.pivot = children_center
					)else format "% hasn't any child.\n" (i.name)
				)
		)
		
		on btn_reset1 pressed do
		(
			for i in selection do
			(
				if(i.parent != undefined) then
				(
					i.pivot = i.parent.pivot
				)else format "% has no parent.\n" (i.name)
			)
		)
		
		on btn_reset2 pressed do
		(
			for i in selection do
			(
				if(i.parent != undefined) then
				(
					i.pos = i.parent.pos
					i.rotation = i.parent.rotation
				)else format "% has no parent.\n" (i.name)
			)
		)
		
		on btn_reset3 pressed do
		(
			for i in selection do
			(
				if(i.parent != undefined) then
				(
					i.pos = i.parent.pos
				)else format "% has no parent.\n" (i.name)
			)
		)
		
		on btn_centerbottom pressed do
		(
			for i in selection do
			(
				i.pivot = i.center
				i.pivot.z = i.min.z
			)
		)
	)
createdialog PropsUtilityGUI