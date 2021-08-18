Class extends xml

// === === === === === === === === === === === === === === === === === === ===
Class constructor($file : 4D:C1709.File)
	
	Super:C1705()
	
	This:C1470.reset()
	
	If (Count parameters:C259>=1)
		
		This:C1470.Open($file)
		
	Else 
		
		// A "If" statement should never omit "Else" 
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === ===
Function reset()
	
	Super:C1706._reset()
	
	This:C1470.ƒ:=New object:C1471("file"; "")
	This:C1470.shared:=False:C215
	This:C1470.datatype:=""
	This:C1470.groups:=New collection:C1472
	This:C1470.units:=New collection:C1472
	
	
	// === === === === === === === === === === === === === === === === === === ===
Function Open($file : 4D:C1709.File)->$this : cs:C1710.xliff
	
	var $t : Text
	
	This:C1470.success:=(OB Instance of:C1731($file; 4D:C1709.File)) & Bool:C1537($file.exists)
	
	If (This:C1470.success)
		
		This:C1470.close()
		
		$t:=$file.getText()
		
		If (0=Rgx_SubstituteText("(?m-si)>\\s*<"; "><"; ->$t))
			
			This:C1470.parse($t)
			
		Else 
			
			This:C1470.load($file)
			
		End if 
		
		If (This:C1470.success)
			
			This:C1470.setOption(XML indentation:K45:34; XML no indentation:K45:36)
			
			// Get & keep the datatype: x-STR# | x-4DK#
			This:C1470.getDataType()
			
			This:C1470._groups()
			
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === ===
	// Get the datatype: x-STR# | x-4DK#
Function getDataType()->$datatype : Text
	var $attributes : Object
	
	$attributes:=This:C1470.getAttributes("/xliff/file")
	
	If (This:C1470.success)
		
		This:C1470.datatype:=String:C10($attributes.datatype)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === ===
	// Populate the groups & units collections
Function _groups()
	var $ƒgroup; $ƒsource; $ƒunit; $groupName; $node; $value : Text
	var $isConstantThemes : Boolean
	var $attributes; $group; $o; $unit : Object
	var $groups; $themes; $units : Collection
	
	// Used for constants files
	$themes:=New collection:C1472
	
	// Retrieves first level groups
	$groups:=This:C1470.find("file/body/group")
	
	For each ($ƒgroup; $groups)
		
		// Get the group attributes
		$attributes:=This:C1470.getAttributes($ƒgroup)
		
		$group:=New object:C1471(\
			"@"; $ƒgroup; \
			"resname"; String:C10($attributes.resname); \
			"id"; String:C10($attributes.id); \
			"units"; New collection:C1472)
		
		This:C1470.groups.push($group)
		
		$isConstantThemes:=(This:C1470.datatype="x-4DK#") & (String:C10($attributes.restype)#"x-4DK#")
		$groupName:=String:C10($attributes["d4:groupName"])
		
		// Retrieves group trans-units
		$units:=This:C1470.find($ƒgroup; "trans-unit")
		
		If ($units.length>0)
			
			For each ($ƒunit; $units)
				
				// Get the source element reference
				$ƒsource:=This:C1470.findByXPath("source"; $ƒunit)
				
				If (This:C1470.success)
					
					// Get the unit attributes
					$attributes:=This:C1470.getAttributes($ƒunit)
					
					// Get the source string
					$value:=String:C10(This:C1470.getValue($ƒsource))
					
					$unit:=New object:C1471(\
						"@"; $ƒunit; \
						"resname"; String:C10($attributes.resname); \
						"id"; String:C10($attributes.id); \
						"noTranslate"; Bool:C1537(String:C10($attributes.translate)="no"); \
						"source"; New object:C1471("@"; $ƒsource; "value"; $value))
					
					If ($attributes["d4:includeIf"]#Null:C1517)
						
						$unit["d4:includeIf"]:=$attributes["d4:includeIf"]
						
					End if 
					
					// Retrieve note if exists
					$node:=This:C1470.findByXPath("note"; $ƒunit)
					
					If (This:C1470.success)
						
						$unit.note:=This:C1470.getValue($node)
						
					End if 
					
					If ($isConstantThemes)
						
						// Keep the theme name
						$themes.push(New object:C1471(\
							"resname"; String:C10($attributes.resname); \
							"name"; $value))
						
					End if 
					
					If (This:C1470.datatype="x-4DK#")\
						 & Not:C34($isConstantThemes)
						
						// Get the group name
						$o:=$themes.query("resname = :1"; $groupName).pop()
						
						$unit.group:=Choose:C955(Asserted:C1132($o#Null:C1517); \
							New object:C1471("resname"; $o.name); \
							New object:C1471("resname"; ""))
						
						$unit.resname:=$value
						
					Else 
						
						If ($isConstantThemes)
							
							$unit.resname:=$value
							
						End if 
						
						$unit.group:=$group
						
					End if 
					
					$group.units.push($unit)
					This:C1470.units.push($unit)
					
				Else 
					
					// ⚠️ trans-unit without source
					
				End if 
			End for each 
			
		Else 
			
			This:C1470.units.push(New object:C1471(\
				"resname"; "..."; \
				"group"; $group))
			
		End if 
	End for each 
	