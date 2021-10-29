/*
fn ColorFromFaceTexture obj faceIndex bitmapName = 
(
	--local obj = snapshotAsMesh theobj
	local mapChannel = 1
	
	if(polyop.getMapSupport obj mapChannel) then
	(
		
		--local matID = polyop.getFaceMatID obj faceIndex
		--local mat = obj.material[matID]
		--local matDiffuseMap = mat.diffuseMap
		--local bitmapTest = openBitMap matDiffuseMap.filename
		local bitmapTest = bitmapName
		
		local colorAvg = color 0 0 0
		local mapFace = polyop.getMapFace obj mapChannel faceIndex
		local faceVerts = polyop.getFaceVerts obj faceIndex
		
		for vertIndex = 1 to faceVerts.count do
		(
			local mapVert = polyop.getMapVert obj mapChannel mapFace[vertIndex] --vertices uv map
			
			--vertices absolute uv map
			local myPoint = point2 (mod mapVert.x 1) (mod mapVert.y 1) --TEMP
			if (myPoint.x < 0) do (myPoint.x = 1 + myPoint.x) --TEMP
			if (myPoint.y < 0) do (myPoint.y = 1 + myPoint.y) --TEMP

			local pixelPoint = point2 (myPoint.x*bitmapTest.width) (myPoint.y*bitmapTest.height) --pixel from vertices uv map
			local pixelColor = getPixels bitmapTest pixelPoint 1 --rgb of the pixel
			colorAvg = colorAvg + pixelColor[1]
		)
		colorAvg.r = (colorAvg.r/faceVerts.count)
		colorAvg.g = (colorAvg.g/faceVerts.count)
		colorAvg.b = (colorAvg.b/faceVerts.count)

		close bitmapTest
		return colorAvg
	)
	else
	(
		format "Map Channel % undefined" mapChannel 
	)
)

fn BatchFromFaces obj faces =
(
	local bbmax = [-65536,-65536,-65536,0]
	local bbmin = [65536,65536,65536,0]
	
	for index in faces do
	(
		local vertices = polyop.getFaceVerts obj index
		for vertex in vertices do
		(
			local vertex_position = polyop.getVert obj vertex
			bbmax.x = amax bbmax.x vertex_position.x
			bbmax.y = amax bbmax.y vertex_position.y
			bbmax.z = amax bbmax.z vertex_position.z
			bbmin.x = amin bbmin.x vertex_position.x
			bbmin.y = amin bbmin.y vertex_position.y
			bbmin.z = amin bbmin.z vertex_position.z
		)
	)
	local batch = rage__spdAABB _min:bbmin _max:bbmax
	return batch
)

fn InstanceDataFromFace batch obj face settings =
(
	local FaceNormal = polyop.getFaceNormal obj face
	local NormalX = ((FaceNormal.x +1)*0.5 * 255) as integer
	local NormalY = ((FaceNormal.y +1)*0.5 * 255) as integer

	local _Scale = settings[1]
	local Colors = settings[2]
	local Ao = settings[3]
	local Pad = settings[4]
	
    local world_pos = polyop.getFaceCenter obj face
    local batch_pos = (world_pos - batch._min)/(batch._max-batch._min) * 65535 
	local new_pos = #(batch_pos.x as integer,batch_pos.y as integer,batch_pos.z as integer)
	
    local InstanceData = rage__fwGrassInstanceListDef__InstanceData Position:new_pos NormalX:NormalX NormalY:NormalY _Color:Colors _Scale:_Scale Ao:Ao Pad:Pad
    return InstanceData
)

fn GrassInstanceListFromFaces obj faces BatchSettings InstancesSettings bitmapName =
(
	local batch = BatchFromFaces obj faces
	local ScaleRange = BatchSettings[1]
	local archetypeName = BatchSettings[2]
	local lodDist = BatchSettings[3]
	local LodFadeStartDist = BatchSettings[4]
	local LodInstFadeRange = BatchSettings[5]
	local OrientToTerrain = BatchSettings[6]
	local InstanceList = #()
	
	for face in faces do
	(
		local settings = deepCopy InstancesSettings	
		if(InstancesSettings[1] == -1)do(settings[1] = random 1 255)
		
		if((InstancesSettings[2][1] == -2) and (InstancesSettings[2][2] == -2) and (InstancesSettings[2][3] == -2))then
		(
			bitmapColor = ColorFromFaceTexture obj face bitmapName
			settings[2][1] = bitmapColor.r as integer
			settings[2][2] = bitmapColor.g as integer
			settings[2][3] = bitmapColor.b as integer
		)else 
		(
			if(InstancesSettings[2][1] == -1)do(settings[2][1] = random 0 255)
			if(InstancesSettings[2][2] == -1)do(settings[2][2] = random 0 255)
			if(InstancesSettings[2][3] == -1)do(settings[2][3] = random 0 255)
		)
		
		local InstanceData = InstanceDataFromFace batch obj face settings
		append InstanceList InstanceData
	)
	local GrassInstanceList = rage__fwGrassInstanceListDef BatchAABB:batch ScaleRange:ScaleRange	archetypeName:archetypeName	lodDist:lodDist	LodFadeStartDist:LodFadeStartDist LodInstFadeRange:LodInstFadeRange	OrientToTerrain:OrientToTerrain InstanceList:InstanceList
)*/