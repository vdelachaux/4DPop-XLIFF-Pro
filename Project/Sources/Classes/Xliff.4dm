Class extends xml

// MARK: Default values ⚙️
property allUnits:=[]
property groups:=[]

// MARK: Constants 🔐
// Extensions
property FILE_EXTENSION:=".xlf"
property FOLDER_EXTENSION:=".lproj"

// Common XPATH
property XPATH_HEADER:="/xliff/header"
property XPATH_PROP_GROUP:="/xliff/file/header/prop-group"
property XPATH_FILE:="/xliff/file"
property XPATH_BODY:="/xliff/file/body"

// State values
property NEW:="new"  // The item is new (not in a previous version of the document)
property NEEDS_TRANSLATION:="needs-translation"  // The item needs to be translated.
property NEEDS_REVIEW:="needs-review-translation"  // Only the text of the item needs to be reviewed.

// MARK: Other 💾
property attributes; language : Object
property datatype : Text

property noTranslate : Boolean
property note : Boolean

property languages:=[]
property error : Text

property duplicateID; duplicateResname; modified : Boolean

Class constructor($file : 4D:C1709.File)
	
	Super:C1705($file)
	
	// Do not close the XML tree when they are saved
	This:C1470.autoClose:=False:C215
	
	// === === === === === === === === === === === === === === === === === === ===
	/// Creating and returning a new group
Function createGroup($resname : Text) : cs:C1710.XliffGroup
	
	var $node : Text
	var $attributes : Object
	var $group : cs:C1710.XliffGroup
	
	$attributes:=New object:C1471(\
		"resname"; $resname)
	
	$node:=This:C1470.create(This:C1470.bodyNode; "group"; $attributes)
	
	// Update me
	$attributes.xpath:=This:C1470.XPATH_BODY+"/group[@resname=\""+$resname+"\"]"
	$group:=cs:C1710.XliffGroup.new($node; $attributes)
	
	This:C1470.groups.push($group)
	This:C1470.groups:=This:C1470.groups.orderBy("resname")
	
	return $group
	
	// === === === === === === === === === === === === === === === === === === ===
Function deleteUnit($unit : cs:C1710.XliffUnit) : cs:C1710.XliffGroup
	
	var $indx : Integer
	var $c : Collection
	var $group : cs:C1710.XliffGroup
	
	// Delete unit
	This:C1470.remove($unit.node)
	
	// Update group
	$c:=Split string:C1554($unit.xpath; "/")
	$c.pop()
	$group:=This:C1470.groups.query("xpath = :1"; $c.join("/")).pop()
	
	$indx:=$group.transunits.indices("id = :1"; $unit.id)[0]
	$group.transunits.remove($indx)
	
	return $group
	
	// === === === === === === === === === === === === === === === === === === ===
	/// Creating and returning a new trans-unit
Function createUnit($group : cs:C1710.XliffGroup; $resname : Text; $id : Text) : cs:C1710.XliffUnit
	
	var $node : Text
	var $attributes : Object
	var $unit : cs:C1710.XliffUnit
	
	$attributes:=New object:C1471(\
		"resname"; $resname; "id"; Count parameters:C259=3 ? $id : This:C1470._uid())
	
	$node:=This:C1470.create($group.node; "trans-unit"; $attributes)
	
	$unit:=cs:C1710.XliffUnit.new($node; $attributes)
	$unit.xpath:=$group.xpath+"/trans-unit[@id=\""+$unit.id+"\"]"
	
	$unit.source.node:=This:C1470.create($node; "source")
	$unit.source.xpath:=$unit.xpath+"/source"
	
	$unit.target.node:=This:C1470.create($node; "target")
	$unit.target.xpath:=$unit.xpath+"/target"
	
	$group.transunits.push($unit)
	
	$group.transunits:=$group.transunits.orderBy("resname")
	
	This:C1470.allUnits.push($unit)
	
	return $unit
	
	//<== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get fileNode() : Text
	
	If (This:C1470.root#Null:C1517)
		
		return This:C1470.findByXPath(This:C1470.XPATH_FILE)
		
	End if 
	
	//<== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get bodyNode() : Text
	
	If (This:C1470.root#Null:C1517)
		
		return This:C1470.findByXPath(This:C1470.XPATH_BODY)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === ===
	// Returns the collection of all group nodes
Function allGroupNodes() : Collection
	
	return This:C1470.find(This:C1470.root; "//group")
	
	// === === === === === === === === === === === === === === === === === === ===
	// Returns the collection of a $node or top-level group nodes
Function groupNodes($node : Text) : Collection
	
	return This:C1470.find($node || This:C1470.bodyNode; "*")
	
	// === === === === === === === === === === === === === === === === === === ===
	// Returns the collection of all trans-unit nodes
Function allUnitNodes() : Collection
	
	return This:C1470.find(This:C1470.root; "//trans-unit")
	
	// === === === === === === === === === === === === === === === === === === ===
	// Returns the collection of all trans-unit nodes in a group
Function groupUnitNodes($group : Text) : Collection
	
	return This:C1470.find($group; "*")
	
	// === === === === === === === === === === === === === === === === === === ===
Function sourceNode($unit; $create : Boolean) : Text
	
	var $node : Text
	$node:=This:C1470._child($unit; "source")
	
	If ($create && Not:C34(This:C1470.isReference($node)))
		
		$node:=This:C1470.create($unit; "source")
		
	End if 
	
	If (This:C1470.success & This:C1470.isReference($node))
		
		return $node
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === ===
Function sourceValue($unit) : Text
	
	return String:C10(This:C1470.getValue(This:C1470._child($unit; "source")))
	
	// === === === === === === === === === === === === === === === === === === ===
Function targetNode($unit; $create : Boolean) : Text
	
	var $node : Text
	$node:=This:C1470._child($unit; "target")
	
	If ($create && Not:C34(This:C1470.isReference($node)))
		
		$node:=This:C1470.create($unit; "target")
		
	End if 
	
	If (This:C1470.success & This:C1470.isReference($node))
		
		return $node
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === ===
Function targetValue($unit) : Text
	
	return String:C10(This:C1470.getValue(This:C1470._child($unit; "target")))
	
	// === === === === === === === === === === === === === === === === === === ===
Function targetAttributes($unit) : Object
	
	var $node : Text
	
	$node:=This:C1470.firstChild($unit; "target")
	
	If (This:C1470.success)
		
		return This:C1470.getAttributes($node)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === ===
Function noteNode($unit) : Text
	
	var $node : Text
	$node:=This:C1470._child($unit; "note")
	
	If (This:C1470.success & This:C1470.isReference($node))
		
		return $node
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === ===
	// Returns the collection of all target nodes with a state attribute
Function todoNodes() : Collection
	
	return This:C1470.find(This:C1470.root; "//target[@state]")
	
	// === === === === === === === === === === === === === === === === === === ===
Function setState($node : Text; $state : Text)
	
	$node:=This:C1470.getTarget($node)
	
	If (This:C1470.isReference($node))
		
		If (Length:C16($state)>0)
			
			var $currentState : Text:=String:C10(This:C1470.getAttributes($node).state)
			
			If (Length:C16($currentState)>0)\
				 && (($currentState=This:C1470.NEW) | ($state=This:C1470.NEEDS_TRANSLATION) | ($state=This:C1470.NEEDS_REVIEW))
				
				return   // Don't modify
				
			End if 
			
			This:C1470.setAttribute($node; "state"; $state)
			
		Else 
			
			This:C1470.removeAttribute($node; "state")
			
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === ===
Function removeState($node)
	
	$node:=This:C1470.getTarget($node)
	
	If (This:C1470.isReference($node))
		
		This:C1470.removeAttribute($node; "state")
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === ===
Function getTarget($node) : Text
	
	var $name : Text
	$name:=This:C1470.getName($node)
	
	Case of 
			
			//______________________________________________________
		: ($name="target")
			
			// We're at the right place
			return $node
			
			//______________________________________________________
		: ($name="source")\
			 | ($name="note")
			
			return This:C1470.findByXPath($node; "../target")
			
			//______________________________________________________
		: ($name="trans-unit")
			
			return This:C1470.targetNode($node)
			
			//______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215)  // A "Case of" statement should never omit "Else"
			
			//______________________________________________________
	End case 
	
	// === === === === === === === === === === === === === === === === === === ===
Function parse() : cs:C1710.Xliff
	
	var $node : Text
	var $allUnits : Collection
	var $group : cs:C1710.XliffGroup
	var $unit : cs:C1710.XliffUnit
	
	If (This:C1470.root=Null:C1517)
		
		return This:C1470
		
	End if 
	
	This:C1470.attributes:=This:C1470.getAttributes(This:C1470.fileNode)
	
	This:C1470.datatype:=String:C10(This:C1470.attributes.datatype)
	
	This:C1470.language:=New object:C1471(\
		"source"; This:C1470.attributes["source-language"]; \
		"target"; This:C1470.attributes["target-language"])
	
	This:C1470.allUnits:=New collection:C1472
	
	// Get the groups
	This:C1470.groups:=New collection:C1472
	
	For each ($node; This:C1470.groupNodes())
		
		$group:=cs:C1710.XliffGroup.new($node; This:C1470.getAttributes($node))
		$group.xpath:=This:C1470.XPATH_BODY+"/group[@resname=\""+$group.resname+"\"]"
		
		// Get the trans-units
		For each ($node; This:C1470.groupUnitNodes($group.node))
			
			$unit:=cs:C1710.XliffUnit.new($node; This:C1470.getAttributes($node))
			$unit.xpath:=$group.xpath+"/trans-unit[@id=\""+$unit.id+"\"]"
			
			$unit.source.value:=This:C1470.sourceValue($node)
			$unit.source.xpath:=$unit.xpath+"/source"
			
			If ($unit.attributes.translate#Null:C1517)\
				 && ($unit.attributes.translate#"no")
				
				$unit.target.value:=This:C1470.targetValue($node)
				$unit.target.xpath:=$unit.xpath+"/target"
				
			Else 
				
				//FIXME: What to do ?
				
			End if 
			
			$node:=This:C1470.noteNode($unit)
			
			If (Length:C16($node)>0)
				
				$unit.note:=This:C1470.getValue($node)
				
			End if 
			
			$group.transunits.push($unit)
			
		End for each 
		
		// Sort
		$group.transunits:=$group.transunits.orderBy("resname")
		
		This:C1470.groups.push($group)
		
		This:C1470.allUnits:=This:C1470.allUnits.combine($group.transunits)
		
	End for each 
	
	This:C1470.groups:=This:C1470.groups.orderBy("resname")
	
	This:C1470.duplicateID:=Not:C34(This:C1470.allUnits.extract("id").orderBy().equal(This:C1470.allUnits.distinct("id"; ck diacritical:K85:3); ck diacritical:K85:3))
	This:C1470.duplicateResname:=Not:C34(This:C1470.allUnits.extract("resname").orderBy().equal(This:C1470.allUnits.distinct("resname"; ck diacritical:K85:3); ck diacritical:K85:3))
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === ===
Function deDuplicateIDs($before : Collection; $after : Collection) : Boolean
	
	var $node; $uid : Text
	var $i; $indx : Integer
	var $nodes : Collection
	var $group : cs:C1710.XliffGroup
	var $unit : cs:C1710.XliffUnit
	
	If (Count parameters:C259=0)  // Main file
		
		For each ($group; This:C1470.groups)
			
			For each ($unit; $group.transunits)
				
				$nodes:=This:C1470.find(This:C1470.root; "//trans-unit[@id=\""+Replace string:C233($unit.id; "/"; "//")+"\"]")
				
				For ($i; 0; $nodes.length-1; 1)
					
					$uid:=This:C1470._uid()
					This:C1470.setAttribute($unit.node; "id"; $uid)
					$unit.id:=$uid
					$unit.attributes.id:=$uid
					
				End for 
			End for each 
		End for each 
		
	Else   // Location file to be synchronized
		
		For each ($unit; $before)
			
			$node:=This:C1470.findUnitNode($unit)
			
			If (Length:C16($node)>0)
				
				$uid:=$after[$indx].id
				This:C1470.setAttribute($node; "id"; $uid)
				$unit.id:=$uid
				$unit.attributes.id:=$uid
				
			Else 
				
				TRACE:C157
				
				This:C1470.success:=False:C215
				This:C1470._pushError("Two or more strings are identical.")
				break
				
			End if 
			
			$indx+=1
			
		End for each 
	End if 
	
	return This:C1470.success
	
	// === === === === === === === === === === === === === === === === === === ===
	// Returns a trans-unit nodes accordind to id & resname & d4:inclu
Function findUnitNode($unit : cs:C1710.XliffUnit) : Text
	
	var $node : Text
	var $indice : Integer
	var $attributes : Object
	var $nodes : Collection
	
	// Search first with the id
	$nodes:=This:C1470.find(This:C1470.root; $unit.xpath)
	
	If ($nodes.length>1)
		
		// More than one ID, so we need to compare resname (diacritic)
		// and the platform, if there is one.
		For each ($node; $nodes.copy())
			
			$attributes:=This:C1470.getAttributes($node)
			
			If ($attributes.resname#$unit.resname) | (Position:C15($unit.resname; $attributes.resname; 1; *)#1)\
				 || (String:C10($attributes["d4:includeIf"])#String:C10($unit.attributes["d4:includeIf"]))
				
				$nodes.remove($indice)
				
			Else 
				
				$indice+=1
				
			End if 
		End for each 
		
		If ($nodes.length>1)
			
			// If duplicates, take the first one
			var $foundOne : Boolean
			For each ($node; $nodes)
				
				$foundOne:=True:C214
				
				var $key : Text
				For each ($key; This:C1470.getAttributes($node))
					
					If ($attributes[$key]#$unit[$key])
						
						$foundOne:=False:C215
						break
						
					End if 
					
				End for each 
				
				If ($foundOne)
					
					$nodes:=New collection:C1472($node)
					break
					
				End if 
			End for each 
		End if 
	End if 
	
	If ($nodes.length=1)
		
		return $nodes[0]
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === ===
	// Returns the expected localized file based on the target language
Function localizedFile($file : 4D:C1709.File; $masterLanguage : Text; $language : Text) : 4D:C1709.File
	
	var $path : Text
	
	ARRAY INTEGER:C220($pos; 0x0000)
	ARRAY INTEGER:C220($len; 0x0000)
	
	// Manage the target language in upper case (EN, FR, ...) as a suffix of the name
	$path:=$file.platformPath
	
	If (Match regex:C1019("(?m-si)(.*)"+Uppercase:C13(Substring:C12($masterLanguage; 1; 2))+"\\"+This:C1470.FILE_EXTENSION+"$"; $path; 1; $pos; $len))
		
		$path:=Substring:C12($path; 1; $len{1})+Uppercase:C13(Substring:C12($language; 1; 2))+This:C1470.FILE_EXTENSION
		
	End if 
	
	return File:C1566(Replace string:C233($path; $masterLanguage+This:C1470.FOLDER_EXTENSION; $language+This:C1470.FOLDER_EXTENSION); fk platform path:K87:2)
	
	// === === === === === === === === === === === === === === === === === === ===
Function synchronize($file : 4D:C1709.File; $targetLanguage : Text)
	
	var $groupNode; $node; $t : Text
	var $len; $pos : Integer
	var $attributes; $string; $localizedGroup; $o : Object
	var $group : cs:C1710.XliffGroup
	var $unit : cs:C1710.XliffUnit
	var $xliff : cs:C1710.Xliff
	
	If (Not:C34($file.exists))
		
		// Create from reference
		$file:=This:C1470.file.copyTo($file.parent; $file.fullName)
		
		// Set the target language
		$t:=$file.getText()
		
		If (Match regex:C1019("(?i-ms)(?<=target-language=\")([^\"]*)"; $t; 1; $pos; $len))
			
			$t:=Substring:C12($t; 1; $pos-1)+$targetLanguage+Substring:C12($t; $pos+$len)
			$file.setText($t)
			
		End if 
		
		// Set all targets state as "new"
		$xliff:=cs:C1710.Xliff.new($file).parse()
		
		For each ($group; $xliff.groups)
			
			For each ($unit; $group.transunits)
				
				If (Not:C34(Bool:C1537($unit.noTranslate)))
					
					$xliff.setState($unit.node; This:C1470.NEW)
					
				End if 
			End for each 
		End for each 
		
	Else 
		
		$xliff:=cs:C1710.Xliff.new($file).parse()
		
		// Ensure that the target language is correctly defined according to the desired language
		If ($xliff.language.target#$targetLanguage)
			
			$xliff.attributes["target-language"]:=$targetLanguage
			$xliff.setAttributes($xliff.fileNode; $xliff.attributes)
			
		End if 
		
		// Ensure that all groups are synchronized
		For each ($group; This:C1470.groups)
			
			$localizedGroup:=$xliff.groups.query("resname = :1"; $group.resname).pop()
			
			If ($localizedGroup=Null:C1517)
				
				// Create the group
				$groupNode:=$xliff.append($xliff.findByXPath($xliff.XPATH_BODY); $group.node)
				
				// Set all target states as "new"
				For each ($node; $xliff.childrens($groupNode))
					
					$attributes:=$xliff.getAttributes($node)
					
					If (String:C10($attributes.translate)#"no")
						
						$xliff.setState($node; This:C1470.NEW)
						
					End if 
				End for each 
				
				continue
				
			End if 
			
			// Ensure that all units are synchronized
			$groupNode:=$xliff.findByXPath($group.xpath)
			
			For each ($unit; $group.transunits.orderBy("resname"))
				
				$string:=Null:C1517
				
				$o:=$xliff.groups.query("transunits[].id = :1"; $unit.id).pop()
				
				If ($o#Null:C1517)
					
					$string:=$o.transunits.query("id = :1"; $unit.id).pop()
					
				End if 
				
				If ($string=Null:C1517)
					
					// Create the unit
					$node:=$xliff.append($groupNode; $unit.node)
					
					If (String:C10($unit.attributes.translate)#"no")
						
						// Set the target state as "new"
						$xliff.setState($node; This:C1470.NEW)
						
					End if 
				End if 
			End for each 
		End for each 
	End if 
	
	$xliff.save()
	
	// === === === === === === === === === === === === === === === === === === ===
Function updateHeader($name : Text; $version : Text)
	
	var $node : Text
	
	$node:=This:C1470.findByXPath(This:C1470.XPATH_PROP_GROUP)
	
	If (This:C1470.isReference($node))
		
		This:C1470.setAttribute($node; "name"; $name)
		
	Else 
		
		$node:=This:C1470.create(This:C1470.root; This:C1470.XPATH_PROP_GROUP; New object:C1471("name"; $name))
		
	End if 
	
	$node:=This:C1470.findByXPath(This:C1470.XPATH_PROP_GROUP+"/prop[@prop-type=\"version\"")
	
	If (Not:C34(This:C1470.isReference($node)))
		
		$node:=This:C1470.create(This:C1470.root; This:C1470.XPATH_PROP_GROUP+"/prop"; New object:C1471("prop-type"; "version"))
		
	End if 
	
	This:C1470.setValue($node; $version)
	
	// Delete old properties
	This:C1470.remove(This:C1470.findByXPath(This:C1470.XPATH_PROP_GROUP+"/prop[@prop-type=\"resname-autofill\""))
	This:C1470.remove(This:C1470.findByXPath(This:C1470.XPATH_PROP_GROUP+"/prop[@prop-type=\"resname-prefix\""))
	This:C1470.remove(This:C1470.findByXPath(This:C1470.XPATH_PROP_GROUP+"/prop[@prop-type=\"resname-separator\""))
	This:C1470.remove(This:C1470.findByXPath(This:C1470.XPATH_PROP_GROUP+"/prop[@prop-type=\"prefix\""))
	This:C1470.remove(This:C1470.findByXPath(This:C1470.XPATH_PROP_GROUP+"/prop[@prop-type=\"separator\""))
	
	This:C1470.save()
	
	// === === === === === === === === === === === === === === === === === === ===
Function updateCopyright()
	
	var $t; $year : Text
	
	$t:=This:C1470.getText()
	$year:=String:C10(Year of:C25(Current date:C33))
	
	ARRAY LONGINT:C221($len; 0x0000)
	ARRAY LONGINT:C221($pos; 0x0000)
	
	If (Match regex:C1019("(?msi)(?:(.*<!--.*Copyright.*[^-])(\\d{4}))+(-*\\d{4})*(.*)"; $t; 1; $pos; $len; *))\
		 && (Substring:C12($t; $pos{2}; $len{2})#$year)
		
		$t:=Substring:C12($t; $pos{1}; $len{1})\
			+Substring:C12($t; $pos{2}; $len{2})+"-"+$year\
			+($len{3}=0 ? Substring:C12($t; $pos{2}+$len{2}) : Substring:C12($t; $pos{4}; $len{4}))
		
		This:C1470.file.setText($t)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === ===
Function addCopyright($copyright : Text)
	
	var $node : Text
	
	$copyright:=Replace string:C233($copyright; "{year}"; String:C10(Year of:C25(Current date:C33)))
	$node:=DOM Append XML child node:C1080(DOM Get XML document ref:C1088(This:C1470.root); XML comment:K45:8; $copyright)
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
	// $item could be a xpath or a unit object
Function _child($item; $element : Text) : Text
	
	If (Value type:C1509($item)=Is object:K8:27)
		
		var $node : Text
		$node:=This:C1470.findByXPath($item.xpath+"/"+$element)
		
		If (This:C1470.success & This:C1470.isReference($node))
			
			return $node
			
		End if 
		
	Else 
		
		return This:C1470.firstChild($item; $element)
		
	End if 
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _uid() : Text
	
	return Replace string:C233(Delete string:C232(Generate digest:C1147(Generate UUID:C1066; _o_4D REST digest:K66:3); 23; 2); "/"; "_")
	