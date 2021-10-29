try(destroyDialog Ytyp_Rollout )catch()
fileIn (scriptspath+"\\DOLU_MAX_SCRIPT\\ytyp\\CMapTypes.ms")

clearlistener()
actionMan.executeAction 0 "40472"
format "Ytyp Script\n\nHow to use the script:\nSelect all the geometries you want to export and click on Export to generate the .ytyp.xml file.\n"
archetypes = #()
samenamelist = #()

rollout Ytyp_Rollout "Ytyp Scripts" width:250 height:500
(
	group "CMapTypes"
	(
		edittext 'CMapTypes_name' "name:" text:"New"
	)
	
	group "Archetype"
	(
		spinner 'Archetype_flags' "flags:" range:[0,2147483647,0] type:#integer
		spinner 'Archetype_specialAttribute' "specialAttribute:" range:[0,2147483647,0] type:#integer
		edittext 'Archetype_textureDictionary' "textureDictionary:"
		edittext 'Archetype_clipDictionary' "clipDictionary:"
		edittext 'Archetype_drawableDictionary' "drawableDictionary:"
		edittext 'Archetype_physicsDictionary' "physicsDictionary:"
		dropdownlist 'Archetype_assetType' "assetType:" items:#("ASSET_TYPE_DRAWABLE","ASSET_TYPE_UNINITIALIZED","ASSET_TYPE_FRAGMENT","ASSET_TYPE_DRAWABLEDICTIONARY","ASSET_TYPE_ASSETLESS")
	)
	button 'btn_add_archetypes' "Add Archetypes" width:232 height:21 align:#left
	button 'btn_ytyp_export' "Export .ytyp.xml" width:232 height:21 align:#left
	button 'btn_reset_archetypes' "Reset Archetypes" width:232 height:21 align:#left
	
	fn ResetSettings =
	(
		CMapTypes_name.text = "New"
		Archetype_flags.value = 0
		Archetype_specialAttribute.value = 0
		Archetype_textureDictionary.text = ""
		Archetype_clipDictionary.text = ""
		Archetype_drawableDictionary.text = ""
		Archetype_physicsDictionary.text = ""
		Archetype_assetType.selected = Archetype_assetType.items[1]
	)

	on btn_reset_archetypes pressed do 
	(
		archetypes = #()
		samenamelist = #()
		ResetSettings()
	)

	on btn_add_archetypes pressed do
	(
		local ArchetypeSettings = #(Archetype_flags.value,Archetype_specialAttribute.value,Archetype_textureDictionary.text,Archetype_clipDictionary.text,Archetype_drawableDictionary.text,Archetype_physicsDictionary.text,Archetype_assetType.selected)
		list = getCurrentSelection()
		if(list != undefined and list.count > 0) then
		(
			for obj in list do 
			(
				if((superclassOf obj) == GeometryClass) then
				(
					if(finditem samenamelist obj.name == 0) then
					(
						local Archetype = ArchetypeFromGeometry obj ArchetypeSettings
						append archetypes Archetype
						append samenamelist obj.name
					)else format "Duplicated archetype with the name % found, it will be skipped.(Is this an instance?)\n" (obj.name)
				)
				else (format "% is not a Geometry, it will be skipped.\n" (obj.name))
			)
		)
		else (format "YTYP Exporter: Selection is empty.\n")
	)

	on btn_ytyp_export pressed do
	(
		local CMapTypesSettings = #(CMapTypes_name.text)
		if(archetypes != undefined and archetypes.count > 0)then
		(
			local CMapTypes = CreateCMapTypes CMapTypesSettings
			CMapTypes.archetypes = archetypes
			ExportYtyp CMapTypes
		)
		else (format "YTYP Exporter: Archetypes array is empty.\n")
	)
)
createdialog Ytyp_Rollout