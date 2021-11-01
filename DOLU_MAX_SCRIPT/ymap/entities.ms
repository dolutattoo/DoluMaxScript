fileIn (scriptspath+"\\DOLU_MAX_SCRIPT\\ymap\\CMapData.ms")

fn EntityFromGeometry obj settings =
(	
	local archetypeName = obj.name
	local flags = settings[1]
	--local guid = random 1 4294967295
	local guid = rnd.Next()
	local _position = (in coordsys world obj.pos)
	local _rotation = inverse(in coordsys world obj.rotation)
	local scaleXY = 1
	local scaleZ = 1
	local parentIndex = -1
	local lodDist = 100 + (1.5 * (distance obj.max obj.min)/2)
	local childLodDist = 0
	local lodLevel = settings[2]
	local numChildren = 0
	local priorityLevel = settings[3]
	local extensions = #()
	local ambientOcclusionMultiplier = 255
	local artificialAmbientOcclusion = 255
	local tintValue = 0

	local Entity = CEntityDef archetypeName:archetypeName flags:flags guid:guid _position:_position _rotation:_rotation scaleXY:scaleXY scaleZ:scaleZ parentIndex:parentIndex lodDist:lodDist childLodDist:childLodDist lodLevel:lodLevel numChildren:numChildren priorityLevel:priorityLevel extensions:extensions ambientOcclusionMultiplier:ambientOcclusionMultiplier artificialAmbientOcclusion:artificialAmbientOcclusion tintValue:tintValue
	return Entity
)

fn ReadEntitiesFromYmap = 
(
	local filePath = getOpenFileName caption:"Import .ymap.xml file" types:"XML Document (*.xml)"
	
	if(filePath != undefined) then
	(
		format "YMAP READER: %\n\n" (filePath)
		
		local XmlDocument_Ymap = dotNetObject "System.Xml.XmlDocument"
		XmlDocument_Ymap.Load(filePath)
		local XmlElement_entities = XmlDocument_Ymap.SelectNodes("descendant::CMapData/entities/Item")
		local Enumerator = XmlElement_entities.GetEnumerator()
		
		local entities =#()
				
		while Enumerator.MoveNext() do
		(
			local XmlElement_CEntityDef = dotNetObject "System.Xml.XmlElement" Enumerator.Current
			local type = XmlElement_CEntityDef.GetAttribute("type")
			
			if (type == "CEntityDef") or (type == "CMloInstanceDef") then
			(
				local archetypeName = XmlElement_CEntityDef.Item["archetypeName"].InnerText
				local flags = XmlElement_CEntityDef.Item["flags"].GetAttribute("value")
				local guid = XmlElement_CEntityDef.Item["guid"].GetAttribute("value")
	
				local XmlElement_position = XmlElement_CEntityDef.Item["position"]
				local position_x = XmlElement_position.GetAttribute("x") as double
				local position_y = XmlElement_position.GetAttribute("y") as double
				local position_z = XmlElement_position.GetAttribute("z") as double
				local _position = [position_x,position_y,position_z]
				
				local XmlElement_rotation = XmlElement_CEntityDef.Item["rotation"]
				local rotation_x = XmlElement_rotation.GetAttribute("x") as double
				local rotation_y = XmlElement_rotation.GetAttribute("y") as double
				local rotation_z = XmlElement_rotation.GetAttribute("z") as double
				local rotation_w = XmlElement_rotation.GetAttribute("w") as double
				local _rotation = quat rotation_x rotation_y rotation_z rotation_w
				
				local scaleXY = XmlElement_CEntityDef.Item["scaleXY"].GetAttribute("value") as double
				local scaleZ = XmlElement_CEntityDef.Item["scaleZ"].GetAttribute("value") as double
				local parentIndex = XmlElement_CEntityDef.Item["parentIndex"].GetAttribute("value")
				local lodDist = XmlElement_CEntityDef.Item["lodDist"].GetAttribute("value")
				local childLodDist = XmlElement_CEntityDef.Item["childLodDist"].GetAttribute("value")
				local lodLevel = XmlElement_CEntityDef.Item["lodLevel"].InnerText
				local numChildren = XmlElement_CEntityDef.Item["numChildren"].GetAttribute("value")
				local priorityLevel = XmlElement_CEntityDef.Item["priorityLevel"].InnerText
				local extensions = #() --NOT SUPPORTED
				local ambientOcclusionMultiplier = XmlElement_CEntityDef.Item["ambientOcclusionMultiplier"].GetAttribute("value")
				local artificialAmbientOcclusion = XmlElement_CEntityDef.Item["artificialAmbientOcclusion"].GetAttribute("value")
				local tintValue = XmlElement_CEntityDef.Item["tintValue"].GetAttribute("value")
	
				local Entity = CEntityDef archetypeName:archetypeName flags:flags guid:guid _position:_position _rotation:_rotation scaleXY:scaleXY scaleZ:scaleZ parentIndex:parentIndex lodDist:lodDist childLodDist:childLodDist lodLevel:lodLevel numChildren:numChildren priorityLevel:priorityLevel extensions:extensions ambientOcclusionMultiplier:ambientOcclusionMultiplier artificialAmbientOcclusion:artificialAmbientOcclusion tintValue:tintValue
				append entities Entity
			)else
			(
				format "Skipped unsupported %\n" (type)
			)
		)
	)
	return entities
)

fn CheckEntitiesFromYmap =
(
	local entities = ReadEntitiesFromYmap()
	local missing = #()
	if(entities != undefined and entities.count > 0) then
	(
		for entity in entities do
		(
			if( getnodebyname(entity.archetypeName) == undefined ) do
				appendifunique missing entity.archetypeName
		)	
		if(missing !=undefined and missing.count >0 )then
		(
			for item in missing do
				format "MISSING: %\n" (item)
		) else format "No entity missing in scene!\n"
	)else format "The .ymap.xml file doesn't contain any entity.\n"
)

--TODO: CASE SCENE HAS MULTIPLE OBJECTS WITH SAME NAME
fn MoveObjectsByYmap =
(
	local entities = ReadEntitiesFromYmap()
	local instances = #()
			
	if(entities != undefined and entities.count > 0) then
	(
		for entity in entities do
		(
			if( getnodebyname(entity.archetypeName) != undefined )then
			(
				if( finditem instances entity.archetypeName == 0 )then
				(
					format "FOUND: %\n" (entity.archetypeName)
					append instances entity.archetypeName
					selected_node = getnodebyname(entity.archetypeName)
					selected_node.scale = [entity.scaleXY,entity.scaleXY,entity.scaleZ]
					selected_node.rotation = (inverse(entity._rotation))	
					selected_node.pos = entity._position
				)
				else
				(
					instanced_entity
					format "FOUND: % (INSTANCE)\n" (entity.archetypeName)
					selected_node = getnodebyname(entity.archetypeName)
					maxOps.CloneNodes selected_node expandHierarchy:true cloneType:#instance newNodes:&instanced_entity
					instanced_entity.scale = [entity.scaleXY,entity.scaleXY,entity.scaleZ]
					instanced_entity.rotation = (inverse(entity._rotation))	
					instanced_entity.pos = entity._position
					instanced_entity.name = entity.archetypeName
				)	
			)else format "MISSING: %\n" (entity.archetypeName)
		)
	)
)