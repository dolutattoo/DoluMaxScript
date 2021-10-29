DotNet.LoadAssembly "System.Xml"
rnd = dotNetObject "System.Random"

struct CMapData__Extents
(
	streamingExtentsMin = [65536,65536,65536],
	streamingExtentsMax = [-65536,-65536,-65536],
	entitiesExtentsMin = [65536,65536,65536],
	entitiesExtentsMax = [-65536,-65536,-65536]
)

struct CBlockDesc
(
	version,
	flags,
	_name,
	exportedBy = "Neos7's Maxscript",
	owner = sysInfo.username,
	_time = localtime
)

struct rage__fwInstancedMapData
(
    ImapLink = #(),
    PropInstanceList = #(),
	GrassInstanceList = #(),

	fn GetExtents  = 
	(
		local Extents = CMapData__Extents()

		for Item in GrassInstanceList do
		(
			local BatchAABB = Item.BatchAABB
			local lodDist = Item.lodDist as float
		
			Extents.entitiesExtentsMax.x = amax Extents.entitiesExtentsMax.x BatchAABB._max.x
			Extents.entitiesExtentsMax.y = amax Extents.entitiesExtentsMax.y BatchAABB._max.y
			Extents.entitiesExtentsMax.z = amax Extents.entitiesExtentsMax.z BatchAABB._max.z

			Extents.entitiesExtentsMin.x = amin Extents.entitiesExtentsMin.x BatchAABB._min.x
			Extents.entitiesExtentsMin.y = amin Extents.entitiesExtentsMin.y BatchAABB._min.y
			Extents.entitiesExtentsMin.z = amin Extents.entitiesExtentsMin.z BatchAABB._min.z

			Extents.streamingExtentsMax.x = amax Extents.streamingExtentsMax.x (BatchAABB._max.x + lodDist)
			Extents.streamingExtentsMax.y = amax Extents.streamingExtentsMax.y (BatchAABB._max.y + lodDist)
			Extents.streamingExtentsMax.z = amax Extents.streamingExtentsMax.z (BatchAABB._max.z + lodDist - 100.0)

			Extents.streamingExtentsMin.x = amin Extents.streamingExtentsMin.x (BatchAABB._min.x - lodDist)
			Extents.streamingExtentsMin.y = amin Extents.streamingExtentsMin.y (BatchAABB._min.y - lodDist)
			Extents.streamingExtentsMin.z = amin Extents.streamingExtentsMin.z (BatchAABB._min.z - lodDist + 100.0)
		)
		return Extents
	),

	fn WriteXML = 
	(
		XmlDocument = dotNetObject "System.Xml.XmlDocument"
		
		XmlElement_instancedData = XmlDocument.CreateElement "instancedData"
		XmlDocument.appendChild XmlElement_instancedData
		
		XmlElement_ImapLink = XmlDocument.CreateElement "ImapLink"
		XmlElement_PropInstanceList = XmlDocument.CreateElement "PropInstanceList"
		XmlElement_GrassInstanceList = XmlDocument.CreateElement "GrassInstanceList"
		
		XmlElement_instancedData.appendChild XmlElement_ImapLink
		XmlElement_instancedData.appendChild XmlElement_PropInstanceList
	
		for Item in GrassInstanceList do
		(
			XmlElement_Item = XmlDocument.CreateElement "Item"
	
			XmlElement_BatchAABB = XmlDocument.CreateElement "BatchAABB"
			XmlElement_min = XmlDocument.CreateElement "min"
			XmlElement_min.SetAttribute "x" (Item.BatchAABB._min.x as string)
			XmlElement_min.SetAttribute "y" (Item.BatchAABB._min.y as string)
			XmlElement_min.SetAttribute "z" (Item.BatchAABB._min.z as string)
			XmlElement_min.SetAttribute "w" (Item.BatchAABB._min.w as string)
			XmlElement_max = XmlDocument.CreateElement "max"
			XmlElement_max.SetAttribute "x" (Item.BatchAABB._max.x as string)
			XmlElement_max.SetAttribute "y" (Item.BatchAABB._max.y as string)
			XmlElement_max.SetAttribute "z" (Item.BatchAABB._max.z as string)
			XmlElement_max.SetAttribute "w" (Item.BatchAABB._max.w as string)
	
			XmlElement_BatchAABB.appendChild XmlElement_min
			XmlElement_BatchAABB.appendChild XmlElement_max
			XmlElement_Item.appendChild XmlElement_BatchAABB
	
			XmlElement_ScaleRange = XmlDocument.CreateElement "ScaleRange"
			XmlElement_ScaleRange.SetAttribute "x" (Item.ScaleRange.x as string)
			XmlElement_ScaleRange.SetAttribute "y" (Item.ScaleRange.y as string)
			XmlElement_ScaleRange.SetAttribute "z" (Item.ScaleRange.z as string)
			XmlElement_Item.appendChild XmlElement_ScaleRange
	
			XmlElement_archetypeName = XmlDocument.CreateElement "archetypeName"
			XmlElement_archetypeName.InnerText = Item.archetypeName
			XmlElement_Item.appendChild XmlElement_archetypeName
	
			XmlElement_lodDist = XmlDocument.CreateElement "lodDist"
			XmlElement_lodDist.SetAttribute "value" (Item.lodDist as string)
			XmlElement_Item.appendChild XmlElement_lodDist
	
			XmlElement_LodFadeStartDist = XmlDocument.CreateElement "LodFadeStartDist"
			XmlElement_LodFadeStartDist.SetAttribute "value" (Item.LodFadeStartDist as string)
			XmlElement_Item.appendChild XmlElement_LodFadeStartDist
	
			XmlElement_LodInstFadeRange = XmlDocument.CreateElement "LodInstFadeRange"
			XmlElement_LodInstFadeRange.SetAttribute "value" (Item.LodInstFadeRange as string)
			XmlElement_Item.appendChild XmlElement_LodInstFadeRange
	
			XmlElement_OrientToTerrain = XmlDocument.CreateElement "OrientToTerrain"
			XmlElement_OrientToTerrain.SetAttribute "value" (Item.OrientToTerrain as string)
			XmlElement_Item.appendChild XmlElement_OrientToTerrain
	
			XmlElement_InstanceList = XmlDocument.CreateElement "InstanceList"
			
			for InstanceItem in Item.InstanceList do
			(
				local PositionValue = ("\r\n              " + (InstanceItem.Position[1] as string) + "\r\n              " + (InstanceItem.Position[2] as string) + "\r\n              " + (InstanceItem.Position[3] as string) + "\r\n            ")
				local ColorValue = ("\r\n              " + (InstanceItem._Color[1] as string) + "\r\n              " + (InstanceItem._Color[2] as string) + "\r\n              " + (InstanceItem._Color[3] as string) + "\r\n            ")
				local PadValue = ("\r\n              " + (InstanceItem.Pad[1] as string) + "\r\n              " + (InstanceItem.Pad[2] as string) + "\r\n              " + (InstanceItem.Pad[3] as string) + "\r\n            ")	
	
				XmlElement_InstanceItem = XmlDocument.CreateElement "Item"
	
				XmlElement_Position = XmlDocument.CreateElement "Position"
				XmlElement_Position.SetAttribute "content" "short_array"
				XmlElement_Position.InnerText = PositionValue
				XmlElement_InstanceItem.appendChild XmlElement_Position
	
				XmlElement_NormalX = XmlDocument.CreateElement "NormalX"
				XmlElement_NormalX.SetAttribute "value" (InstanceItem.NormalX as string)
				XmlElement_InstanceItem.appendChild XmlElement_NormalX
	
				XmlElement_NormalY = XmlDocument.CreateElement "NormalY"
				XmlElement_NormalY.SetAttribute "value" (InstanceItem.NormalY as string)
				XmlElement_InstanceItem.appendChild XmlElement_NormalY 
	
				XmlElement_Color = XmlDocument.CreateElement "Color"
				XmlElement_Color.SetAttribute "content" "char_array"
				XmlElement_Color.InnerText = ColorValue
				XmlElement_InstanceItem.appendChild XmlElement_Color
	
				XmlElement_Scale = XmlDocument.CreateElement "Scale"
				XmlElement_Scale.SetAttribute "value" (InstanceItem._Scale as string)
				XmlElement_InstanceItem.appendChild XmlElement_Scale 
	
				XmlElement_Ao = XmlDocument.CreateElement "Ao"
				XmlElement_Ao.SetAttribute "value" (InstanceItem.Ao as string)
				XmlElement_InstanceItem.appendChild XmlElement_Ao
	
				XmlElement_Pad = XmlDocument.CreateElement "Pad"
				XmlElement_Pad.SetAttribute "content" "char_array"
				XmlElement_Pad.InnerText = PadValue
				XmlElement_InstanceItem.appendChild XmlElement_Pad
	
				XmlElement_InstanceList.appendChild XmlElement_InstanceItem
			)
	
			XmlElement_Item.appendChild XmlElement_InstanceList	
	
			XmlElement_GrassInstanceList.appendChild XmlElement_Item
		)
		
		XmlElement_instancedData.appendChild XmlElement_GrassInstanceList
		return XmlDocument
	)
)

struct rage__fwGrassInstanceListDef
(
	BatchAABB,
	ScaleRange,
	archetypeName,
	lodDist,
	LodFadeStartDist,
	LodInstFadeRange,
	OrientToTerrain,
	InstanceList
)

struct rage__spdAABB
(
	_min,
	_max
)

struct rage__fwGrassInstanceListDef__InstanceData
(
    Position,
    NormalX,
    NormalY,
    _Color,
    _Scale,
    Ao,
	Pad
)

struct CEntityDef
(
	archetypeName,
	flags,
	guid,
	_position,
	_rotation,
	scaleXY,
	scaleZ,
	parentIndex,
	lodDist,
	childLodDist,
	lodLevel,
	numChildren,
	priorityLevel,
	extensions,
	ambientOcclusionMultiplier,
	artificialAmbientOcclusion,
	tintValue,

	fn WriteXML =
	(
		local XmlDocument = dotNetObject "System.Xml.XmlDocument"
		local XmlElement_Item = XmlDocument.CreateElement "Item"
		XmlElement_Item.SetAttribute "type" "CEntityDef"

		local XmlElement_archetypeName = XmlDocument.CreateElement "archetypeName"
		XmlElement_archetypeName.InnerText = archetypeName
		XmlElement_Item.appendChild XmlElement_archetypeName

		local XmlElement_flags = XmlDocument.CreateElement "flags"
		XmlElement_flags.SetAttribute "value" (flags as string)
		XmlElement_Item.appendChild XmlElement_flags

		local XmlElement_guid = XmlDocument.CreateElement "guid"
		XmlElement_guid.SetAttribute "value" (guid as string)
		XmlElement_Item.appendChild XmlElement_guid

		local XmlElement_position = XmlDocument.CreateElement "position"
		XmlElement_position.SetAttribute "x" (_position.x as string)
		XmlElement_position.SetAttribute "y" (_position.y as string)
		XmlElement_position.SetAttribute "z" (_position.z as string)
		XmlElement_Item.appendChild XmlElement_position

		local XmlElement_rotation = XmlDocument.CreateElement "rotation"
		XmlElement_rotation.SetAttribute "x" (_rotation.x as string)
		XmlElement_rotation.SetAttribute "y" (_rotation.y as string)
		XmlElement_rotation.SetAttribute "z" (_rotation.z as string)
		XmlElement_rotation.SetAttribute "w" (_rotation.w as string)
		XmlElement_Item.appendChild XmlElement_rotation

		local XmlElement_scaleXY = XmlDocument.CreateElement "scaleXY"
		XmlElement_scaleXY.SetAttribute "value" (scaleXY as string)
		XmlElement_Item.appendChild XmlElement_scaleXY

		local XmlElement_scaleZ = XmlDocument.CreateElement "scaleZ"
		XmlElement_scaleZ.SetAttribute "value" (scaleZ as string)
		XmlElement_Item.appendChild XmlElement_scaleZ

		local XmlElement_parentIndex = XmlDocument.CreateElement "parentIndex"
		XmlElement_parentIndex.SetAttribute "value" (parentIndex as string)
		XmlElement_Item.appendChild XmlElement_parentIndex

		local XmlElement_lodDist = XmlDocument.CreateElement "lodDist"
		XmlElement_lodDist.SetAttribute "value" (lodDist as string)
		XmlElement_Item.appendChild XmlElement_lodDist

		local XmlElement_childLodDist = XmlDocument.CreateElement "childLodDist"
		XmlElement_childLodDist.SetAttribute "value" (childLodDist as string)
		XmlElement_Item.appendChild XmlElement_childLodDist

		local XmlElement_lodLevel = XmlDocument.CreateElement "lodLevel"
		XmlElement_lodLevel.InnerText = lodLevel
		XmlElement_Item.appendChild XmlElement_lodLevel

		local XmlElement_numChildren = XmlDocument.CreateElement "numChildren"
		XmlElement_numChildren.SetAttribute "value" (numChildren as string)
		XmlElement_Item.appendChild XmlElement_numChildren

		local XmlElement_priorityLevel = XmlDocument.CreateElement "priorityLevel"
		XmlElement_priorityLevel.InnerText = priorityLevel
		XmlElement_Item.appendChild XmlElement_priorityLevel

		local XmlElement_extensions = XmlDocument.CreateElement "extensions"--TODO
		XmlElement_Item.appendChild XmlElement_extensions

		local XmlElement_ambientOcclusionMultiplier = XmlDocument.CreateElement "ambientOcclusionMultiplier"
		XmlElement_ambientOcclusionMultiplier.SetAttribute "value" (ambientOcclusionMultiplier as string)
		XmlElement_Item.appendChild XmlElement_ambientOcclusionMultiplier

		local XmlElement_artificialAmbientOcclusion = XmlDocument.CreateElement "artificialAmbientOcclusion"
		XmlElement_artificialAmbientOcclusion.SetAttribute "value" (artificialAmbientOcclusion as string)
		XmlElement_Item.appendChild XmlElement_artificialAmbientOcclusion

		local XmlElement_tintValue = XmlDocument.CreateElement "tintValue"
		XmlElement_tintValue.SetAttribute "value" (tintValue as string)
		XmlElement_Item.appendChild XmlElement_tintValue

		XmlDocument.appendChild XmlElement_Item
		return XmlDocument
	)
)

struct CMapData
(
	_name,
	parent,
	flags,
	contentFlags,
	streamingExtentsMin,
	streamingExtentsMax,
	entitiesExtentsMin,
	entitiesExtentsMax,
	entities,
	containerLods,
	boxOccluders,
	occludeModels,
	physicsDictionaries,
	instancedData,
	timeCycleModifiers,
	carGenerators,
	LODLightsSOA,
	DistantLODLightsSOA,
	_block,

	fn WriteXML =
	(
		local XmlDocument = dotNetObject "System.Xml.XmlDocument"
		XmlDocument.appendChild (XmlDocument.CreateXmlDeclaration "1.0" "utf-8" "no")
		local XmlElement_CMapData = XmlDocument.CreateElement "CMapData"
		
		local XmlElement_name = XmlDocument.CreateElement "name"
		if(_name != undefined and _name != "") do 
			XmlElement_name.InnerText = _name
		XmlElement_CMapData.appendChild XmlElement_name

		local XmlElement_parent = XmlDocument.CreateElement "parent"
		if(parent != undefined and parent != "") do 
			XmlElement_parent.InnerText = parent
		XmlElement_CMapData.appendChild XmlElement_parent

		local XmlElement_flags = XmlDocument.CreateElement "flags"
		XmlElement_flags.SetAttribute "value" (flags as string)
		XmlElement_CMapData.appendChild XmlElement_flags

		local XmlElement_contentFlags = XmlDocument.CreateElement "contentFlags"
		XmlElement_contentFlags.SetAttribute "value" (contentFlags as string)
		XmlElement_CMapData.appendChild XmlElement_contentFlags

		local XmlElement_streamingExtentsMin = XmlDocument.CreateElement "streamingExtentsMin"
		XmlElement_streamingExtentsMin.SetAttribute "x" (streamingExtentsMin.x as string)
		XmlElement_streamingExtentsMin.SetAttribute "y" (streamingExtentsMin.y as string)
		XmlElement_streamingExtentsMin.SetAttribute "z" (streamingExtentsMin.z as string)
		XmlElement_CMapData.appendChild XmlElement_streamingExtentsMin

		local XmlElement_streamingExtentsMax = XmlDocument.CreateElement "streamingExtentsMax"
		XmlElement_streamingExtentsMax.SetAttribute "x" (streamingExtentsMax.x as string)
		XmlElement_streamingExtentsMax.SetAttribute "y" (streamingExtentsMax.y as string)
		XmlElement_streamingExtentsMax.SetAttribute "z" (streamingExtentsMax.z as string)
		XmlElement_CMapData.appendChild XmlElement_streamingExtentsMax

		local XmlElement_entitiesExtentsMin = XmlDocument.CreateElement "entitiesExtentsMin"
		XmlElement_entitiesExtentsMin.SetAttribute "x" (entitiesExtentsMin.x as string)
		XmlElement_entitiesExtentsMin.SetAttribute "y" (entitiesExtentsMin.y as string)
		XmlElement_entitiesExtentsMin.SetAttribute "z" (entitiesExtentsMin.z as string)
		XmlElement_CMapData.appendChild XmlElement_entitiesExtentsMin

		local XmlElement_entitiesExtentsMax = XmlDocument.CreateElement "entitiesExtentsMax"
		XmlElement_entitiesExtentsMax.SetAttribute "x" (entitiesExtentsMax.x as string)
		XmlElement_entitiesExtentsMax.SetAttribute "y" (entitiesExtentsMax.y as string)
		XmlElement_entitiesExtentsMax.SetAttribute "z" (entitiesExtentsMax.z as string)
		XmlElement_CMapData.appendChild XmlElement_entitiesExtentsMax
		
		local XmlElement_entities = XmlDocument.CreateElement "entities"
		if(entities != undefined and entities.count > 0)do
		(
			for entity in entities do
			(
				local XmlElement_entity = XmlDocument.ImportNode (entity.WriteXML()).DocumentElement true
				XmlElement_entities.appendChild XmlElement_entity
			)
		)
		XmlElement_CMapData.appendChild XmlElement_entities

		XmlElement_CMapData.appendChild (XmlDocument.CreateElement "containerLods")---TO DO
		XmlElement_CMapData.appendChild (XmlDocument.CreateElement "boxOccluders")---TO DO
		XmlElement_CMapData.appendChild (XmlDocument.CreateElement "occludeModels")---TO DO
		
		local XmlElement_physicsDictionaries = XmlDocument.CreateElement "physicsDictionaries"
		if(physicsDictionaries != undefined and physicsDictionaries.count > 0)do
		(
			for physicsDictionary in physicsDictionaries do
			(
				local XmlElement_physicsDictionary = XmlDocument.CreateElement "Item"
				XmlElement_physicsDictionary.InnerText = physicsDictionary
				XmlElement_physicsDictionaries.appendChild XmlElement_physicsDictionary
			)
		)
		XmlElement_CMapData.appendChild XmlElement_physicsDictionaries
		
		local XmlElement_instancedData = XmlDocument.CreateElement "instancedData"
		XmlElement_instancedData.appendChild (XmlDocument.CreateElement "ImapLink")
		XmlElement_instancedData.appendChild (XmlDocument.CreateElement "PropInstanceList")

		if(instancedData.GrassInstanceList != undefined and instancedData.GrassInstanceList.count > 0) then 
		(
			local NEW_instancedData = XmlDocument.ImportNode ((instancedData.WriteXML()).Item["instancedData"]) true
			local XmlElement_GrassInstanceList = NEW_instancedData.Item["GrassInstanceList"]
		)else
		(
			local XmlElement_GrassInstanceList = XmlDocument.CreateElement "GrassInstanceList"
		)
		XmlElement_instancedData.appendChild XmlElement_GrassInstanceList
		XmlElement_CMapData.appendChild XmlElement_instancedData
	
		XmlElement_CMapData.appendChild (XmlDocument.CreateElement "timeCycleModifiers")---TO DO
		XmlElement_CMapData.appendChild (XmlDocument.CreateElement "carGenerators")---TO DO
	
		local XmlElement_LODLightsSOA = XmlDocument.CreateElement "LODLightsSOA"---TO DO
		XmlElement_LODLightsSOA.appendChild (XmlDocument.CreateElement "direction")
		XmlElement_LODLightsSOA.appendChild (XmlDocument.CreateElement "falloff")
		XmlElement_LODLightsSOA.appendChild (XmlDocument.CreateElement "falloffExponent")
		XmlElement_LODLightsSOA.appendChild (XmlDocument.CreateElement "timeAndStateFlags")
		XmlElement_LODLightsSOA.appendChild (XmlDocument.CreateElement "hash")
		XmlElement_LODLightsSOA.appendChild (XmlDocument.CreateElement "coneInnerAngle")
		XmlElement_LODLightsSOA.appendChild (XmlDocument.CreateElement "coneOuterAngleOrCapExt")
		XmlElement_LODLightsSOA.appendChild (XmlDocument.CreateElement "coronaIntensity")
		XmlElement_CMapData.appendChild XmlElement_LODLightsSOA
	
		local XmlElement_DistantLODLightsSOA = XmlDocument.CreateElement "DistantLODLightsSOA"---TO DO
		XmlElement_DistantLODLightsSOA.appendChild (XmlDocument.CreateElement "position")
		XmlElement_DistantLODLightsSOA.appendChild (XmlDocument.CreateElement "RGBI")
		local XmlElement_numStreetLights = XmlDocument.CreateElement "numStreetLights"
		XmlElement_numStreetLights.SetAttribute "value" "0"
		XmlElement_DistantLODLightsSOA.appendChild XmlElement_numStreetLights
		local XmlElement_category = XmlDocument.CreateElement "category"
		XmlElement_category.SetAttribute "value" "0"
		XmlElement_DistantLODLightsSOA.appendChild XmlElement_category
		XmlElement_CMapData.appendChild XmlElement_DistantLODLightsSOA
	
		local XmlElement_block = XmlDocument.CreateElement "block"
		local XmlElement_version = XmlDocument.CreateElement "version"
		XmlElement_version.SetAttribute "value" (_block.version as string)
		XmlElement_block.appendChild XmlElement_version
		local XmlElement_blockflags = XmlDocument.CreateElement "flags"
		XmlElement_blockflags.SetAttribute "value" (_block.flags as string)
		XmlElement_block.appendChild XmlElement_blockflags
		local XmlElement_blockname = XmlDocument.CreateElement "name"
		XmlElement_blockname.InnerText = (_block._name as string)
		XmlElement_block.appendChild XmlElement_blockname
		local XmlElement_exportedBy = XmlDocument.CreateElement "exportedBy"
		XmlElement_exportedBy.InnerText = (_block.exportedBy as string)
		XmlElement_block.appendChild XmlElement_exportedBy
		local XmlElement_owner = XmlDocument.CreateElement "owner"
		XmlElement_owner.InnerText = (_block.owner as string)
		XmlElement_block.appendChild XmlElement_owner
		local XmlElement_time = XmlDocument.CreateElement "time"
		XmlElement_time.InnerText = (_block._time as string)
		XmlElement_block.appendChild XmlElement_time
		XmlElement_CMapData.appendChild XmlElement_block
	
		XmlDocument.appendChild XmlElement_CMapData
		return XmlDocument
	)
)

fn CreateCMapData settings =
(
	local _name = settings[1]
	local parent = settings[2]
	local flags = settings[3]
	local contentFlags = settings[4]
	local streamingExtentsMin = [0,0,0]
	local streamingExtentsMax = [0,0,0]
	local entitiesExtentsMin = [0,0,0]
	local entitiesExtentsMax = [0,0,0]
	local entities = #()
	local containerLods = #()
	local boxOccluders = #()
	local occludeModels = #()
	local physicsDictionaries = #()
	local instancedData = rage__fwInstancedMapData()
	local timeCycleModifiers = #()
	local carGenerators = #()
	local LODLightsSOA = #()
	local DistantLODLightsSOA = #()
	local _block = CBlockDesc version:0 flags:0 _name:"Custom"

	local MapData = CMapData _name:_name parent:parent flags:flags contentFlags:contentFlags streamingExtentsMin:streamingExtentsMin streamingExtentsMax:streamingExtentsMax entitiesExtentsMin:entitiesExtentsMin entitiesExtentsMax:entitiesExtentsMax entities:entities containerLods:containerLods boxOccluders:boxOccluders occludeModels:occludeModels physicsDictionaries:physicsDictionaries instancedData:instancedData timeCycleModifiers:timeCycleModifiers carGenerators:carGenerators LODLightsSOA:LODLightsSOA DistantLODLightsSOA:DistantLODLightsSOA _block:_block
	return MapData
)

fn ExportYmap CMapData =
(
	local filePath = getSaveFileName caption:"Save .ymap.xml file" filename:(CMapData._name+".ymap.xml") types:"Ymap XML Document (*.ymap.xml)"
	if( filePath != undefined) then
	( 	
		format "YMAP EXPORTER: %\n\n" (filePath)
		local XmlDocument = CMapData.WriteXML()
		XmlDocument.Save(filePath)
	)
)
