try(destroyDialog Ymap_Rollout )catch()
fileIn (scriptspath+"\\DOLU_MAX_SCRIPT\\occlu\\entities.ms")

-- clearlistener()
-- actionMan.executeAction 0 "40472"
format "Occlusion Script\n\nHow to use the script:\nEXPORT: Select all the geometries you want to export, choose your settings and click on Export to generate the .ymap.xml file.\nCHECK: Reads all the entities from a .ymap.xml file and checks if each object with given archetypeName exists in the scene.\nIMPORT: Reads a .ymap.xml file and moves/rotates/scales each object according to the entities array.\n\n"
entities = #()
Extents = CMapData__Extents()

fn UpdateExtents Extents obj =
(
	local lodDist = 100 + (1.5 * (distance obj.max obj.min)/2)
	Extents.entitiesExtentsMax.x = amax Extents.entitiesExtentsMax.x obj.max.x
	Extents.entitiesExtentsMax.y = amax Extents.entitiesExtentsMax.y obj.max.y
	Extents.entitiesExtentsMax.z = amax Extents.entitiesExtentsMax.z obj.max.z

	Extents.entitiesExtentsMin.x = amin Extents.entitiesExtentsMin.x obj.min.x
	Extents.entitiesExtentsMin.y = amin Extents.entitiesExtentsMin.y obj.min.y
	Extents.entitiesExtentsMin.z = amin Extents.entitiesExtentsMin.z obj.min.z

	Extents.streamingExtentsMax.x = amax Extents.streamingExtentsMax.x (obj.max.x + lodDist)
	Extents.streamingExtentsMax.y = amax Extents.streamingExtentsMax.y (obj.max.y + lodDist)
	Extents.streamingExtentsMax.z = amax Extents.streamingExtentsMax.z (obj.max.z + lodDist)

	Extents.streamingExtentsMin.x = amin Extents.streamingExtentsMin.x (obj.min.x - lodDist)
	Extents.streamingExtentsMin.y = amin Extents.streamingExtentsMin.y (obj.min.y - lodDist)
	Extents.streamingExtentsMin.z = amin Extents.streamingExtentsMin.z (obj.min.z - lodDist)
	return Extents
)

rollout Ymap_Rollout "Occlusion Scripts" width:250 height:200
(
	
	group "CMapData"
	(
		edittext 'CMapData_name' "name:" text:"New"
		edittext 'CMapData_parent' "parent:"
		spinner 'CMapData_flags' "flags:" range:[0,2147483647,0] type:#integer
		spinner 'CMapData_contentFlags' "contentFlags:" range:[0,2147483647,32] type:#integer
	)
	
	-- group "Entity"
	-- (
	-- 	spinner 'Entity_flags' "flags:" range:[0,2147483647,0] type:#integer
	-- 	dropdownlist 'Entity_lodLevel' "lodLevel:" items:#("LODTYPES_DEPTH_HD","LODTYPES_DEPTH_LOD","LODTYPES_DEPTH_SLOD1","LODTYPES_DEPTH_SLOD2","LODTYPES_DEPTH_SLOD3","LODTYPES_DEPTH_ORPHANHD","LODTYPES_DEPTH_SLOD4") 
	-- 	dropdownlist 'Entity_priorityLevel' "priorityLevel:" items:#("PRI_REQUIRED","PRI_OPTIONAL_HIGH","PRI_OPTIONAL_MEDIUM","PRI_OPTIONAL_LOW")
	-- )
	button 'btn_add_entities' "Add Entities" width:232 height:21 align:#left
	button 'btn_ymap_export' "Export .ymap.xml" width:232 height:21 align:#left
	button 'btn_reset_entities' "Reset Entities" width:232 height:21 align:#left

	-- button 'btn_ymap_check' "Check .ymap.xml" width:232 height:21 align:#left
	-- button 'btn_ymap_import' "Import .ymap.xml" width:232 height:21 align:#left

	fn ResetSettings =
	(
		CMapData_name.text = "New"
		CMapData_parent.text = ""
		CMapData_flags.value = 0
		CMapData_contentFlags.value = 32
	)
	
	on btn_reset_entities pressed do 
	(
		entities = #()
		Extents = CMapData__Extents()
		ResetSettings()
	)
	
	-- on btn_add_entities pressed do
	-- (
	-- 	local EntitySettings = #(Entity_flags.value,Entity_lodLevel.selected,Entity_priorityLevel.selected)
	-- 	list = getCurrentSelection()
	-- 	if(list != undefined and list.count > 0) then
	-- 	(
	-- 		for obj in list do 
	-- 		(
	-- 			if((superclassOf obj) == GeometryClass) then
	-- 				(
	-- 					Extents = UpdateExtents Extents obj
	-- 					local Entity = EntityFromGeometry obj EntitySettings
	-- 					append entities Entity
	-- 				)
	-- 			else (format "% is not a Geometry, it will be skipped.\n" (obj.name))
	-- 		)
	-- 	)
	-- 	else (format "YMAP Exporter: Selection is empty.\n")
	-- )
	
	on btn_add_entities pressed do
	(
		--local EntitySettings = #(Entity_flags.value,Entity_lodLevel.selected,Entity_priorityLevel.selected)
		list = getCurrentSelection()
		if(list != undefined and list.count > 0) then
		(
			for obj in list do 
			(
				if((superclassOf obj) == GeometryClass) then
					(
						Extents = UpdateExtents Extents obj
						local Entity = OcclusionFromGeometry obj
						append entities Entity
					)
				else (format "% is not a Geometry, it will be skipped.\n" (obj.name))
			)
		)
		else (format "YMAP Exporter: Selection is empty.\n")
	)
	
	on btn_ymap_export pressed do
	(
		local CMapDataSettings = #(CMapData_name.text,CMapData_parent.text,CMapData_flags.value,CMapData_contentFlags.value)
		if(entities != undefined and entities.count > 0)then
		(
			local CMapData = CreateCMapData CMapDataSettings
			CMapData.entities = entities
			CMapData.streamingExtentsMin = Extents.streamingExtentsMin
			CMapData.streamingExtentsMax = Extents.streamingExtentsMax
			CMapData.entitiesExtentsMin = Extents.entitiesExtentsMin
			CMapData.entitiesExtentsMax = Extents.entitiesExtentsMax
			ExportYmap CMapData
		)
		else (format "YMAP Exporter: Entities array is empty.\n")
	)
	
	on btn_ymap_check pressed do
	(
		CheckEntitiesFromYmap()
	)
	
	on btn_ymap_import pressed do
	(
		MoveObjectsByYmap()
	)
)
createdialog Ymap_Rollout