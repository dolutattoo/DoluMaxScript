DotNet.LoadAssembly "System.Xml"

struct CBaseArchetypeDef
(
    lodDist,
    flags,
    specialAttribute,
    bbMin,
    bbMax,
    bsCentre,
    bsRadius,
    hdTextureDist,
    _name,
    textureDictionary,
    clipDictionary,
    drawableDictionary,
    physicsDictionary,
    assetType,
    assetName,
    extensions,

    fn WriteXML =
	(
		local XmlDocument = dotNetObject "System.Xml.XmlDocument"
		local XmlElement_Item = XmlDocument.CreateElement "Item"
        XmlElement_Item.SetAttribute "type" "CBaseArchetypeDef"
        
        local XmlElement_lodDist = XmlDocument.CreateElement "lodDist"
		XmlElement_lodDist.SetAttribute "value" (lodDist as string)
        XmlElement_Item.appendChild XmlElement_lodDist
        
        local XmlElement_flags = XmlDocument.CreateElement "flags"
		XmlElement_flags.SetAttribute "value" (flags as string)
        XmlElement_Item.appendChild XmlElement_flags
        
        local XmlElement_specialAttribute = XmlDocument.CreateElement "specialAttribute"
		XmlElement_specialAttribute.SetAttribute "value" (specialAttribute as string)
        XmlElement_Item.appendChild XmlElement_specialAttribute

        local XmlElement_bbMin = XmlDocument.CreateElement "bbMin"
		XmlElement_bbMin.SetAttribute "x" (bbMin.x as string)
		XmlElement_bbMin.SetAttribute "y" (bbMin.y as string)
		XmlElement_bbMin.SetAttribute "z" (bbMin.z as string)
        XmlElement_Item.appendChild XmlElement_bbMin
        
        local XmlElement_bbMax = XmlDocument.CreateElement "bbMax"
		XmlElement_bbMax.SetAttribute "x" (bbMax.x as string)
		XmlElement_bbMax.SetAttribute "y" (bbMax.y as string)
		XmlElement_bbMax.SetAttribute "z" (bbMax.z as string)
        XmlElement_Item.appendChild XmlElement_bbMax
        
        local XmlElement_bsCentre = XmlDocument.CreateElement "bsCentre"
		XmlElement_bsCentre.SetAttribute "x" (bsCentre.x as string)
		XmlElement_bsCentre.SetAttribute "y" (bsCentre.y as string)
		XmlElement_bsCentre.SetAttribute "z" (bsCentre.z as string)
        XmlElement_Item.appendChild XmlElement_bsCentre

        local XmlElement_bsRadius = XmlDocument.CreateElement "bsRadius"
		XmlElement_bsRadius.SetAttribute "value" (bsRadius as string)
        XmlElement_Item.appendChild XmlElement_bsRadius
        
        local XmlElement_hdTextureDist = XmlDocument.CreateElement "hdTextureDist"
		XmlElement_hdTextureDist.SetAttribute "value" (hdTextureDist as string)
        XmlElement_Item.appendChild XmlElement_hdTextureDist

        local XmlElement_name = XmlDocument.CreateElement "name"
		XmlElement_name.InnerText = _name
        XmlElement_Item.appendChild XmlElement_name
        
        local XmlElement_textureDictionary = XmlDocument.CreateElement "textureDictionary"
        if(textureDictionary != undefined and textureDictionary != "") do 
            XmlElement_textureDictionary.InnerText = textureDictionary
		XmlElement_Item.appendChild XmlElement_textureDictionary

        local XmlElement_clipDictionary = XmlDocument.CreateElement "clipDictionary"
        if(clipDictionary != undefined and clipDictionary != "") do 
            XmlElement_clipDictionary.InnerText = clipDictionary
        XmlElement_Item.appendChild XmlElement_clipDictionary
        
        local XmlElement_drawableDictionary = XmlDocument.CreateElement "drawableDictionary"
        if(drawableDictionary != undefined and drawableDictionary != "") do 
            XmlElement_drawableDictionary.InnerText = drawableDictionary
        XmlElement_Item.appendChild XmlElement_drawableDictionary

        local XmlElement_physicsDictionary = XmlDocument.CreateElement "physicsDictionary"
        if(physicsDictionary != undefined and physicsDictionary != "") do 
            XmlElement_physicsDictionary.InnerText = physicsDictionary
        XmlElement_Item.appendChild XmlElement_physicsDictionary

        local XmlElement_assetType = XmlDocument.CreateElement "assetType"
		XmlElement_assetType.InnerText = assetType
        XmlElement_Item.appendChild XmlElement_assetType

        local XmlElement_assetName = XmlDocument.CreateElement "assetName"
		XmlElement_assetName.InnerText = assetName
        XmlElement_Item.appendChild XmlElement_assetName

        local XmlElement_extensions = XmlDocument.CreateElement "extensions"
        XmlElement_Item.appendChild XmlElement_extensions

        XmlDocument.appendChild XmlElement_Item
		return XmlDocument
    )
)

fn ArchetypeFromGeometry obj settings =
(	
    local flags = settings[1]
    local specialAttribute = settings[2]
    local bbMin = (in coordsys local obj.min)
    local bbMax = (in coordsys local obj.max)
    local bsCentre = (bbMin + bbMax )/2
    local bsRadius = (distance bbMax bbMin )/2
    local lodDist = 100 + (1.5 * bsRadius)
    local hdTextureDist = 0.75 * lodDist
    local _name = obj.name

    if(settings[3] == "")then
    (
        local textureDictionary = obj.name
    )else
    (
        local textureDictionary = settings[3]
    )
    local clipDictionary = settings[4]
    local drawableDictionary = settings[5]
    local physicsDictionary = settings[6]
    local assetType = settings[7]
    local assetName = obj.name
    local extensions = #()

    local Archetype = CBaseArchetypeDef lodDist:lodDist flags:flags specialAttribute:specialAttribute bbMin:bbMin bbMax:bbMax bsCentre:bsCentre bsRadius:bsRadius hdTextureDist:hdTextureDist _name:_name textureDictionary:textureDictionary clipDictionary:clipDictionary drawableDictionary:drawableDictionary physicsDictionary:physicsDictionary assetType:assetType assetName:assetName extensions:extensions
    return Archetype
)

struct CMapTypes
(
    extensions,
    archetypes,
    _name,
    dependencies,
    compositeEntityTypes,

    fn WriteXML =
	(
		local XmlDocument = dotNetObject "System.Xml.XmlDocument"
		XmlDocument.appendChild (XmlDocument.CreateXmlDeclaration "1.0" "utf-8" "no")
        local XmlElement_CMapTypes = XmlDocument.CreateElement "CMapTypes"

        local XmlElement_extensions = XmlDocument.CreateElement "extensions"
        XmlElement_CMapTypes.appendChild XmlElement_extensions

        local XmlElement_archetypes = XmlDocument.CreateElement "archetypes"
		if(archetypes != undefined and archetypes.count > 0)do
		(
			for archetype in archetypes do
			(
				local XmlElement_archetype = XmlDocument.ImportNode (archetype.WriteXML()).DocumentElement true
				XmlElement_archetypes.appendChild XmlElement_archetype
			)
		)
		XmlElement_CMapTypes.appendChild XmlElement_archetypes

        local XmlElement_name = XmlDocument.CreateElement "name"
		if(_name != undefined and _name != "") do 
			XmlElement_name.InnerText = _name
        XmlElement_CMapTypes.appendChild XmlElement_name

        local XmlElement_dependencies = XmlDocument.CreateElement "dependencies"
        XmlElement_CMapTypes.appendChild XmlElement_dependencies

        local XmlElement_compositeEntityTypes = XmlDocument.CreateElement "compositeEntityTypes"
        XmlElement_CMapTypes.appendChild XmlElement_compositeEntityTypes

        XmlDocument.appendChild XmlElement_CMapTypes

        return XmlDocument
    )
)

fn CreateCMapTypes settings =
(
	local extensions = #()
    local archetypes = #()
    _name = settings[1]
    dependencies = #()
    compositeEntityTypes = #()

	local MapTypes = CMapTypes extensions:extensions archetypes:archetypes _name:_name dependencies:dependencies compositeEntityTypes:compositeEntityTypes
	return MapTypes
)

fn ExportYtyp CMapTypes =
(
	local filePath = getSaveFileName caption:"Save .ytyp.xml file" filename:(CMapTypes._name+".ytyp.xml") types:"Ytyp XML Document (*.ytyp.xml)"
	if( filePath != undefined) then
	( 	
		format "YTYP EXPORTER: %\n\n" (filePath)
		local XmlDocument = CMapTypes.WriteXML()
		XmlDocument.Save(filePath)
	)
)

fn ReadYtypFromXML = 
(
	local filePath = getOpenFileName caption:"Import .ytyp.xml file" types:"XML Document (*.xml)"
	
	if(filePath != undefined) then
	(
		format "YTYP READER: %\n\n" (filePath)
		
		local XmlDocument_Ytyp = dotNetObject "System.Xml.XmlDocument"
        XmlDocument_Ytyp.Load(filePath)
        extensions = #() --NOT SUPPORTED
		local XmlElement_archetypes = XmlDocument_Ytyp.SelectNodes("descendant::CMapTypes/archetypes/Item")
		local Enumerator = XmlElement_archetypes.GetEnumerator()
		
		local archetypes =#()
				
		while Enumerator.MoveNext() do
		(
			local XmlElement_CBaseArchetypeDef = dotNetObject "System.Xml.XmlElement" Enumerator.Current
			local type = XmlElement_CBaseArchetypeDef.GetAttribute("type")
			
			if(type == "CBaseArchetypeDef")then
			(
                local lodDist = XmlElement_CBaseArchetypeDef.Item["lodDist"].GetAttribute("value") as float
                local flags = XmlElement_CBaseArchetypeDef.Item["flags"].GetAttribute("value") as integer
                local specialAttribute = XmlElement_CBaseArchetypeDef.Item["specialAttribute"].GetAttribute("value") as integer
               
                local XmlElement_bbMin = XmlElement_CBaseArchetypeDef.Item["bbMin"]
				local bbMin_x = XmlElement_bbMin.GetAttribute("x") as double
				local bbMin_y = XmlElement_bbMin.GetAttribute("y") as double
				local bbMin_z = XmlElement_bbMin.GetAttribute("z") as double
				local bbMin = [bbMin_x,bbMin_y,bbMin_z]

                local XmlElement_bbMax = XmlElement_CBaseArchetypeDef.Item["bbMax"]
				local bbMax_x = XmlElement_bbMax.GetAttribute("x") as double
				local bbMax_y = XmlElement_bbMax.GetAttribute("y") as double
				local bbMax_z = XmlElement_bbMax.GetAttribute("z") as double
                local bbMax = [bbMax_x,bbMax_y,bbMax_z]

                local XmlElement_bsCentre = XmlElement_CBaseArchetypeDef.Item["bsCentre"]
				local bsCentre_x = XmlElement_bsCentre.GetAttribute("x") as double
				local bsCentre_y = XmlElement_bsCentre.GetAttribute("y") as double
				local bsCentre_z = XmlElement_bsCentre.GetAttribute("z") as double
                local bsCentre = [bsCentre_x,bsCentre_y,bsCentre_z]
                
                local bsRadius = XmlElement_CBaseArchetypeDef.Item["bsRadius"].GetAttribute("value") as float
                local hdTextureDist = XmlElement_CBaseArchetypeDef.Item["hdTextureDist"].GetAttribute("value") as float

                local _name = toLower (XmlElement_CBaseArchetypeDef.Item["name"].InnerText)
                local textureDictionary = XmlElement_CBaseArchetypeDef.Item["name"].InnerText
                local clipDictionary = XmlElement_CBaseArchetypeDef.Item["clipDictionary"].InnerText
                local drawableDictionary = XmlElement_CBaseArchetypeDef.Item["drawableDictionary"].InnerText
                local physicsDictionary = XmlElement_CBaseArchetypeDef.Item["physicsDictionary"].InnerText
                local assetType = XmlElement_CBaseArchetypeDef.Item["assetType"].InnerText
                local assetName = XmlElement_CBaseArchetypeDef.Item["assetName"].InnerText
                extensions = #() --NOT SUPPORTED
				
                local Archetype = CBaseArchetypeDef lodDist:lodDist flags:flags specialAttribute:specialAttribute bbMin:bbMin bbMax:bbMax bsCentre:bsCentre bsRadius:bsRadius hdTextureDist:hdTextureDist _name:_name textureDictionary:textureDictionary clipDictionary:clipDictionary drawableDictionary:drawableDictionary physicsDictionary:physicsDictionary assetType:assetType assetName:assetName extensions:extensions
                append archetypes Archetype
			)else
			(
				format "Skipped unsupported %\n" (type)
			)
        )
        _name = XmlDocument_Ytyp.Item["CMapTypes"].Item["name"].InnerText
        dependencies = #() --NOT SUPPORTED
        compositeEntityTypes = #() --NOT SUPPORTED
	)
	local MapTypes = CMapTypes extensions:extensions archetypes:archetypes _name:_name dependencies:dependencies compositeEntityTypes:compositeEntityTypes
	return MapTypes
)