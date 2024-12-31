property version : Text
property file : 4D:C1709.File
property content : Object

// MARK: Constants 🔐
property LAST_VERSION:="3.2"

Class constructor($version : Text)
	
	Super:C1705()
	
	This:C1470.version:=$version || This:C1470.LAST_VERSION
	
	This:C1470.file:=File:C1566("/PACKAGE/Preferences/4DPop XLIFF.settings"; *)
	
	If (This:C1470.file.exists)
		
		This:C1470.content:=JSON Parse:C1218(This:C1470.file.getText())
		
		This:C1470._update()
		
	Else 
		
		This:C1470.content:={version: This:C1470.version}
		
	End if 
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function exists($key : Text) : Boolean
	
	If (Length:C16($key)>0)
		
		return This:C1470.content[$key]#Null:C1517
		
	Else 
		
		return This:C1470.file.exists
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function get($key : Text) : Variant
	
	return This:C1470.content[$key]
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function set($key : Text; $value)
	
	This:C1470.content[$key]:=$value
	
	This:C1470.save()
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function save()
	
	This:C1470.file.setText(JSON Stringify:C1217(This:C1470.content; *))
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _update()
	
	var $version : Text:=This:C1470.content.version || ""
	
	Repeat 
		
		Case of 
				
				//______________________________________________________
			: ($version="")
				
				OB REMOVE:C1226(This:C1470.content; "file")
				OB REMOVE:C1226(This:C1470.content; "files")
				OB REMOVE:C1226(This:C1470.content; "languages")
				OB REMOVE:C1226(This:C1470.content; "digest")
				
				$version:="3.0"
				
				//______________________________________________________
			: ($version="3.0")  // Update to 3.1 or higher
				
				UPDATE_fixIDsWithSlashes
				
				$version:="3.1"
				
				//______________________________________________________
			: ($version="3.1")  // Update to 3.2 or higher
				
				This:C1470.content.currentProject:=This:C1470.content.project
				OB REMOVE:C1226(This:C1470.content; "project")
				
				This:C1470.content.sourceLanguage:=This:C1470.content.reference
				OB REMOVE:C1226(This:C1470.content; "reference")
				
				var $project:=cs:C1710.database.new()
				var $o : Object:=This:C1470.content[$project.name]
				This:C1470.content.targetLanguages:=$o.languages
				This:C1470.content.files:=$o.files
				This:C1470.content.currentFile:=$o.file
				This:C1470.content.digest:=$o.digest
				OB REMOVE:C1226(This:C1470.content; $project.name)
				
				$version:="3.2"
				
				//______________________________________________________
		End case 
	Until ($version=This:C1470.version)
	
	If (This:C1470.content.version#$version)
		
		This:C1470.content.version:=$version
		This:C1470.save()
		
	End if 