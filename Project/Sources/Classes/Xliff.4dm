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
property XPATH_PROPERTIES:="/xliff/file/header/prop-group"
property XPATH_FILE:="/xliff/file"
property XPATH_BODY:="/xliff/file/body"

// State values
property STATE_NEW:="new"  // The item is new (not in a previous version of the document)
property STATE_NEEDS_TRANSLATION:="needs-translation"  // The item needs to be translated.
property STATE_NEEDS_REVIEW:="needs-review-translation"  // Only the text of the item needs to be reviewed.

// MARK: Other 💾
property attributes; language : Object
property datatype : Text

property noTranslate : Boolean
property note : Boolean

property languages:=[]
property error : Text

property duplicateID; duplicateResname; modified : Boolean
property lastID : Integer
property _usedIDs : Object  // Index of the ids in use (keys), see getUID()
property _usedIDsCount : Integer

Class constructor($file : 4D:C1709.File)
	
	Super:C1705($file)
	
	// Do not close the XML tree when they are saved
	This:C1470.autoClose:=False:C215
	
	// === === === === === === === === === === === === === === === === === === ===
	/// Creating and returning a new group
Function createGroup($resname : Text) : cs:C1710.XliffGroup
	
	var $attributes:={resname: $resname}
	var $node:=This:C1470.create(This:C1470.bodyNode; "group"; $attributes)
	$attributes.xpath:=This:C1470.XPATH_BODY+"/group[@resname="+XLIFF_xpathLiteral($resname)+"]"
	var $group:=cs:C1710.XliffGroup.new($node; $attributes)
	
	This:C1470.groups.push($group)
	This:C1470.groups:=This:C1470.groups.orderBy("resname")
	
	return $group
	
	// === === === === === === === === === === === === === === === === === === ===
	/// Deletes a group, its node and its trans-units, also from the collections (B32): a file displayed again from the
	/// cache showed a deleted group whose node no longer exists (-9926 on the next Delete). False if the group is not
	/// (any more) one of this file: its node is not touched
Function deleteGroup($group : cs:C1710.XliffGroup) : Boolean
	
	If ($group=Null:C1517) || (This:C1470.groups.indexOf($group)=-1)
		
		return False:C215
		
	End if 
	
	This:C1470.remove($group.node)
	This:C1470._usedIDs:=Null:C1517  // The index of the ids in use is rebuilt on the next getUID()
	
	var $unit : Object
	var $indx : Integer
	
	If ($group.transunits#Null:C1517)
		
		For each ($unit; $group.transunits)
			
			$indx:=This:C1470.allUnits.indexOf($unit)
			
			If ($indx>=0)
				
				This:C1470.allUnits.remove($indx)
				
			End if 
		End for each 
	End if 
	
	This:C1470.groups.remove(This:C1470.groups.indexOf($group))
	
	return True:C214
	
	// === === === === === === === === === === === === === === === === === === ===
Function deleteUnit($unit : cs:C1710.XliffUnit) : cs:C1710.XliffGroup
	
	// Delete unit
	This:C1470.remove($unit.node)
	This:C1470._usedIDs:=Null:C1517  // The index of the ids in use is rebuilt on the next getUID()
	
	var $indx : Integer:=This:C1470.allUnits.indices("id = :1"; $unit.id).first()
	This:C1470.allUnits.remove($indx)
	
	// Update group
	var $c:=Split string:C1554($unit.xpath; "/")
	$c.pop()
	var $group : cs:C1710.XliffGroup:=This:C1470.groups.query("xpath = :1"; $c.join("/")).first()
	
	$indx:=$group.transunits.indices("id = :1"; $unit.id)[0]
	$group.transunits.remove($indx)
	
	return $group
	
	// === === === === === === === === === === === === === === === === === === ===
	/// Creating and returning a new trans-unit
Function createUnit($group : cs:C1710.XliffGroup; $resname : Text; $id : Text) : cs:C1710.XliffUnit
	
	var $attributes:={resname: $resname; id: Count parameters:C259=3 ? $id : This:C1470.getUID()}
	var $node:=This:C1470.create($group.node; "trans-unit"; $attributes)
	
	var $unit:=cs:C1710.XliffUnit.new($node; $attributes)
	$unit.xpath:=$group.xpath+"/trans-unit[@id="+XLIFF_xpathLiteral($unit.id)+"]"
	
	$unit.source.node:=This:C1470.create($node; "source")
	$unit.source.xpath:=$unit.xpath+"/source"
	
	$unit.target.node:=This:C1470.create($node; "target")
	$unit.target.xpath:=$unit.xpath+"/target"
	
	This:C1470.allUnits.push($unit)
	
	// Keep the index of the ids in use up to date (if it was in sync before the push)
	If (This:C1470._usedIDs#Null:C1517) && (This:C1470._usedIDsCount=(This:C1470.allUnits.length-1))
		
		If (Length:C16($unit.id)>0)
			
			This:C1470._usedIDs[$unit.id]:=True:C214
			
		End if 
		
		This:C1470._usedIDsCount:=This:C1470.allUnits.length
		
	End if 
	
	$group.transunits.push($unit)
	$group.transunits:=$group.transunits.orderBy("resname")
	
	return $unit
	
	// === === === === === === === === === === === === === === === === === === ===
Function getUID() : Text
	
	// The ids are Text: look them up as Text, in an index built once
	// (and rebuilt if allUnits changed outside createUnit), not with one query per candidate id
	If (This:C1470._usedIDs=Null:C1517) || (This:C1470._usedIDsCount#This:C1470.allUnits.length)
		
		This:C1470._indexIDs()
		
	End if 
	
	var $uid : Integer:=(This:C1470.lastID#Null:C1517 ? This:C1470.lastID : 0)+1
	
	While (This:C1470._usedIDs[String:C10($uid)]#Null:C1517)
		
		$uid+=1
		
	End while 
	
	This:C1470.lastID:=$uid
	This:C1470._usedIDs[String:C10($uid)]:=True:C214
	
	return String:C10(This:C1470.lastID)
	
	// === === === === === === === === === === === === === === === === === === ===
	// Builds the index of the ids in use: {id: True}
Function _indexIDs()
	
	var $unit : Object
	
	This:C1470._usedIDs:={}
	
	For each ($unit; This:C1470.allUnits)
		
		If (Length:C16(String:C10($unit.id))>0)
			
			This:C1470._usedIDs[String:C10($unit.id)]:=True:C214
			
		End if 
	End for each 
	
	This:C1470._usedIDsCount:=This:C1470.allUnits.length
	
	//<== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get fileNode() : Text
	
	If (This:C1470.root#Null:C1517)
		
		return This:C1470.findByXPath(This:C1470.XPATH_FILE; This:C1470.root)
		
	End if 
	
	//<== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get bodyNode() : Text
	
	If (This:C1470.root#Null:C1517)
		
		return This:C1470.findByXPath(This:C1470.XPATH_BODY; This:C1470.root)
		
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
	
	var $node:=This:C1470._child($unit; "source")
	
	If ($create && Not:C34(This:C1470.isReference($node)))
		
		$node:=This:C1470.create($unit; "source")
		
	End if 
	
	If (This:C1470.success && This:C1470.isReference($node))
		
		return $node
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === ===
Function sourceValue($unit) : Text
	
	var $node:=This:C1470._child($unit; "source")
	
	If (This:C1470.isNotNull($node))
		
		return String:C10(This:C1470.getValue(This:C1470._child($unit; "source")))
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === ===
Function targetNode($unit; $create : Boolean) : Text
	
	var $node:=This:C1470._child($unit; "target")
	
	If ($create && Not:C34(This:C1470.isReference($node)))
		
		$node:=This:C1470.create($unit; "target")
		
	End if 
	
	If (This:C1470.success && This:C1470.isReference($node))
		
		return $node
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === ===
Function targetValue($unit) : Text
	
	return String:C10(This:C1470.getValue(This:C1470._child($unit; "target")))
	
	// === === === === === === === === === === === === === === === === === === ===
Function targetExists($unit) : Boolean
	
	//var $node : Text:=This._child($unit; "target")
	//return This.isNotNull($node)
	
	
	var $node : Text:=This:C1470.targetNode($unit)
	return This:C1470.isNotNull($node)
	
	// === === === === === === === === === === === === === === === === === === ===
Function targetAttributes($unit) : Object
	
	var $node:=This:C1470.firstChild($unit; "target")
	
	If (This:C1470.success)
		
		return This:C1470.getAttributes($node)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === ===
Function noteNode($unit) : Text
	
	var $node:=This:C1470._child($unit; "note")
	
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
			
			var $currentState:=String:C10(This:C1470.getAttributes($node).state)
			
			If (Length:C16($currentState)>0)\
				 && (($currentState=This:C1470.STATE_NEW) | ($state=This:C1470.STATE_NEEDS_TRANSLATION) | ($state=This:C1470.STATE_NEEDS_REVIEW))
				
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
	
	var $name:=This:C1470.getName($node)
	
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
	
	If (This:C1470.root=Null:C1517)
		
		return This:C1470
		
	End if 
	
	// A well-formed XML document that is not XLIFF has no /xliff/file element
	var $fileNode : Text:=This:C1470.fileNode
	This:C1470.attributes:=This:C1470.isReference($fileNode) ? This:C1470.getAttributes($fileNode) : {}
	
	This:C1470.datatype:=String:C10(This:C1470.attributes.datatype)
	
	This:C1470.language:=New object:C1471(\
		"source"; This:C1470.attributes["source-language"]; \
		"target"; This:C1470.attributes["target-language"])
	
	This:C1470.allUnits:=[]
	This:C1470._usedIDs:=Null:C1517
	
	// Get the groups
	This:C1470.groups:=[]
	
	var $node : Text
	For each ($node; This:C1470.groupNodes())
		
		var $group:=cs:C1710.XliffGroup.new($node; This:C1470.getAttributes($node))
		$group.xpath:=This:C1470.XPATH_BODY+"/group[@resname="+XLIFF_xpathLiteral($group.resname)+"]"
		
		// Get the trans-units
		For each ($node; This:C1470.groupUnitNodes($group.node))
			
			If (This:C1470.getName($node)#"trans-unit")
				
				continue
				
			End if 
			
			var $unit:=cs:C1710.XliffUnit.new($node; This:C1470.getAttributes($node))
			$unit.xpath:=$group.xpath+"/trans-unit[@id="+XLIFF_xpathLiteral($unit.id)+"]"
			
			$unit.source.value:=This:C1470.sourceValue($node)
			$unit.source.xpath:=$unit.xpath+"/source"
			
			If (Not:C34(This:C1470.isReference(This:C1470.targetNode($unit))))
				
				This:C1470.setAttribute($unit.node; "translate"; "no")
				$unit.noTranslate:=True:C214
				
			End if 
			
			If (Not:C34($unit.noTranslate))
				
				$unit.target.value:=This:C1470.targetValue($node)
				$unit.target.xpath:=$unit.xpath+"/target"
				
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
	
	var $node : Text
	var $indx : Integer
	
	var $unit : cs:C1710.XliffUnit
	
	If (Count parameters:C259=0)
		
		// MARK: Main file
		var $group : cs:C1710.XliffGroup
		For each ($group; This:C1470.groups)
			
			For each ($unit; $group.transunits)
				
				var $nodes : Collection:=This:C1470.find(This:C1470.root; "//trans-unit[@id=\""+Replace string:C233($unit.id; "/"; "//")+"\"]")
				
				For ($indx; 0; $nodes.length-1; 1)
					
					var $uid : Text:=This:C1470.getUID()
					This:C1470.setAttribute($unit.node; "id"; $uid)
					$unit.id:=$uid
					$unit.attributes.id:=$uid
					
				End for 
			End for each 
		End for each 
		
	Else 
		
		// MARK: Localization file to be synchronized
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
		
		This:C1470._usedIDs:=Null:C1517  // Ids changed: the index of the ids in use is rebuilt on the next getUID()
		
	End if 
	
	return This:C1470.success
	
	// === === === === === === === === === === === === === === === === === === ===
	// Returns a trans-unit nodes accordind to id & resname & d4:inclu
Function findUnitNode($unit : cs:C1710.XliffUnit) : Text
	
	var $indice : Integer
	
	// Search first with the id
	var $nodes : Collection:=This:C1470.find(This:C1470.root; $unit.xpath)
	
	If ($nodes.length>1)
		
		// More than one ID, so we need to compare resname (diacritic)
		// and the platform, if there is one.
		var $node : Text
		For each ($node; $nodes.copy())
			
			var $attributes : Object:=This:C1470.getAttributes($node)
			
			If (String:C10($attributes.resname)#$unit.resname) | (Position:C15($unit.resname; String:C10($attributes.resname); 1; *)#1)\
				 || (String:C10($attributes["d4:includeIf"])#String:C10($unit.attributes["d4:includeIf"]))
				
				$nodes.remove($indice)
				
				If ($nodes.length=1)
					
					break
					
				End if 
				
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
	
	ARRAY INTEGER:C220($pos; 0)
	ARRAY INTEGER:C220($len; 0)
	
	// Manage the target language in upper case (EN, FR, ...) as a suffix of the name
	var $path:=$file.platformPath
	
	If (Match regex:C1019("(?m-si)(.*)"+Uppercase:C13(Substring:C12($masterLanguage; 1; 2))+"\\"+This:C1470.FILE_EXTENSION+"$"; $path; 1; $pos; $len))
		
		$path:=Substring:C12($path; 1; $len{1})+Uppercase:C13(Substring:C12($language; 1; 2))+This:C1470.FILE_EXTENSION
		
	End if 
	
	return File:C1566(Replace string:C233($path; $masterLanguage+This:C1470.FOLDER_EXTENSION; $language+This:C1470.FOLDER_EXTENSION); fk platform path:K87:2)
	
	// === === === === === === === === === === === === === === === === === === ===
Function synchronize($file : 4D:C1709.File; $targetLanguage : Text)
	
	var $groupNode; $node; $t : Text
	var $len; $pos : Integer
	var $attributes; $string; $o : Object
	var $group : cs:C1710.XliffGroup
	var $unit : cs:C1710.XliffUnit
	var $xliff : cs:C1710.Xliff
	var $oo : Object
	
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
		
		// The reference has no target-language attribute: add it
		If ($xliff.root#Null:C1517)
			
			$node:=$xliff.fileNode
			
			If ($xliff.isReference($node))
				
				If (String:C10($xliff.attributes["target-language"])#$targetLanguage)
					
					$xliff.setAttribute($node; "target-language"; $targetLanguage)
					$xliff.attributes["target-language"]:=$targetLanguage
					
				End if 
			End if 
		End if 
		
		For each ($group; $xliff.groups)
			
			For each ($unit; $group.transunits)
				
				If (Not:C34(Bool:C1537($unit.noTranslate)))
					
					$xliff.setState($unit.node; This:C1470.STATE_NEW)
					
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
		
		var $bodyNode : Text:=$xliff.findByXPath($xliff.XPATH_BODY)
		
		// Units of the localized file by (group, resname, d4:includeIf), to find the same string with another id in the same group
		var $homonyms : Object:={}
		var $refIDs : Object:={}
		var $item : Object
		var $key : Text
		var $localizedGroup : cs:C1710.XliffGroup
		
		For each ($localizedGroup; $xliff.groups)
			
			For each ($item; $localizedGroup.transunits)
				
				$key:=This:C1470._homonymKey($item; $localizedGroup.resname)
				$homonyms[$key]:=$homonyms[$key] || []
				$homonyms[$key].push($item)
				
			End for each 
		End for each 
		
		For each ($item; This:C1470.allUnits)
			
			If (Length:C16(String:C10($item.id))>0)
				
				$refIDs[String:C10($item.id)]:=True:C214
				
			End if 
		End for each 
		
		// Ensure that all groups are synchronized
		For each ($group; This:C1470.groups)
			
			If ($xliff.groups.query("resname = :1"; $group.resname).first()=Null:C1517)
				
				// Create the group
				$groupNode:=$xliff.append($bodyNode; $group.node)
				
				// Set all target states as "new"
				For each ($node; $xliff.childrens($groupNode))
					
					$attributes:=$xliff.getAttributes($node)
					
					If (String:C10($attributes.translate)#"no")
						
						$xliff.setState($node; This:C1470.STATE_NEW)
						
					End if 
				End for each 
				
				continue
				
			End if 
			
			// Ensure that all units are synchronized
			$groupNode:=$xliff.findByXPath($group.xpath)
			
			For each ($unit; $group.transunits.orderBy("resname"))
				
				$string:=Null:C1517
				$oo:=Null:C1517
				
				$o:=$xliff.groups.query("transunits[].id = :1"; $unit.id).first()
				
				If ($o#Null:C1517)
					
					$string:=$o.transunits.query("id = :1"; $unit.id).first()
					
				End if 
				
				// Search, in the same group, for the same resname (and the same d4:includeIf) with a different ID, not used by the reference
				$oo:=This:C1470._homonym($homonyms; $refIDs; $unit; $group.resname)
				
				If ($string=Null:C1517)
					
					If ($oo#Null:C1517)
						
						// Same string with another ID: give it the reference ID, the translation is kept
						$xliff.setAttribute($oo.node; "id"; $unit.id)
						$oo.id:=$unit.id
						$oo.attributes.id:=$unit.id
						$oo:=Null:C1517
						
					Else 
						
						// Create the unit
						$node:=$xliff.append($groupNode; $unit.node)
						
						If (String:C10($unit.attributes.translate)#"no")
							
							// Set the target state as "new"
							$xliff.setState($node; This:C1470.STATE_NEW)
							
						End if 
					End if 
				End if 
				
				If ($oo#Null:C1517)
					
					$xliff.remove($oo.node)
					
				End if 
			End for each 
		End for each 
	End if 
	
	$xliff.save()
	
	// === === === === === === === === === === === === === === === === === === ===
	// Key of a unit for synchronize(): group resname + resname + d4:includeIf (case and accents are significant)
Function _homonymKey($unit : Object; $groupResname : Text) : Text
	
	return $groupResname+"\t"+String:C10($unit.resname)+"\t"+String:C10($unit.attributes["d4:includeIf"])
	
	// === === === === === === === === === === === === === === === === === === ===
	// Returns, and takes out of $homonyms, a unit of the localized file in the same group with the same key as $unit,
	// another ID, and an ID that the reference does not use
Function _homonym($homonyms : Object; $refIDs : Object; $unit : Object; $groupResname : Text) : Object
	
	var $candidates : Collection:=$homonyms[This:C1470._homonymKey($unit; $groupResname)]
	
	If ($candidates=Null:C1517)
		
		return Null:C1517
		
	End if 
	
	var $i : Integer
	
	For ($i; 0; $candidates.length-1; 1)
		
		var $candidate : Object:=$candidates[$i]
		var $id : Text:=String:C10($candidate.id)
		
		If (Compare strings:C1756($id; String:C10($unit.id); sk char codes)#0)\
			 && ((Length:C16($id)=0) || ($refIDs[$id]=Null:C1517))
			
			$candidates.remove($i)
			return $candidate
			
		End if 
	End for 
	
	return Null:C1517
	
	// === === === === === === === === === === === === === === === === === === ===
Function updateHeader($name : Text; $version : Text)
	
	var $node : Text:=This:C1470.findByXPath(This:C1470.XPATH_PROPERTIES)
	
	If (This:C1470.isReference($node))
		
		This:C1470.setAttribute($node; "name"; $name)
		
	Else 
		
		$node:=This:C1470.create(This:C1470.root; This:C1470.XPATH_PROPERTIES; {name: $name})
		
	End if 
	
	$node:=This:C1470.findByXPath(This:C1470.XPATH_PROPERTIES+"/prop[@prop-type=\"version\"")
	
	If (Not:C34(This:C1470.isReference($node)))
		
		$node:=This:C1470.create(This:C1470.root; This:C1470.XPATH_PROPERTIES+"/prop"; New object:C1471("prop-type"; "version"))
		
	End if 
	
	This:C1470.setValue($node; $version)
	
	// Delete old properties, if any
	This:C1470.remove(This:C1470.findByXPath(This:C1470.XPATH_PROPERTIES+"/prop[@prop-type=\"resname-autofill\""))
	This:C1470.remove(This:C1470.findByXPath(This:C1470.XPATH_PROPERTIES+"/prop[@prop-type=\"resname-prefix\""))
	This:C1470.remove(This:C1470.findByXPath(This:C1470.XPATH_PROPERTIES+"/prop[@prop-type=\"resname-separator\""))
	This:C1470.remove(This:C1470.findByXPath(This:C1470.XPATH_PROPERTIES+"/prop[@prop-type=\"prefix\""))
	This:C1470.remove(This:C1470.findByXPath(This:C1470.XPATH_PROPERTIES+"/prop[@prop-type=\"separator\""))
	
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
		
		var $node:=This:C1470.findByXPath($item.xpath+"/"+$element)
		
		If (This:C1470.success & This:C1470.isReference($node))
			
			return $node
			
		End if 
		
	Else 
		
		return This:C1470.firstChild($item; $element)
		
	End if 
	
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
	// Overrides xml._convert(): XLIFF texts and attribute values are kept as Text,
	// never converted to Real, Boolean, Date or Collection ("1.50", "true", "2024-01-15", "[draft]"…)
Function _convert($textValue : Text)->$value
	
	$value:=$textValue
