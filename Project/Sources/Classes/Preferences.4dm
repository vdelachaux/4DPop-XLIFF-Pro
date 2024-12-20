Class extends _classCore

property version : Text
property file : 4D:C1709.File
property data : Object

Class constructor($version : Text)
	
	Super:C1705()
	
	This:C1470.version:=$version
	
	This:C1470.file:=Folder:C1567(fk database folder:K87:14; *).file("Preferences/4DPop XLIFF.settings")
	
	If (This:C1470.file.exists)
		
		This:C1470.data:=JSON Parse:C1218(This:C1470.file.getText())
		
		This:C1470._update()
		
	Else 
		
		This:C1470.data:={version: This:C1470.version}
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === ===
Function get($key : Text) : Variant
	
	return This:C1470.data[$key]
	
	// === === === === === === === === === === === === === === === === === === ===
Function set($key : Text; $value)
	
	This:C1470.data[$key]:=$value
	
	This:C1470.save()
	
	// === === === === === === === === === === === === === === === === === === ===
Function save()
	
	This:C1470.file.setText(JSON Stringify:C1217(This:C1470.data; *))
	
	// === === === === === === === === === === === === === === === === === === ===
Function _update()
	
	var $version : Text
	$version:=This:C1470.data.version || ""
	
	Repeat 
		
		Case of 
				
				//______________________________________________________
			: ($version="")
				
				OB REMOVE:C1226(This:C1470.data; "file")
				OB REMOVE:C1226(This:C1470.data; "files")
				OB REMOVE:C1226(This:C1470.data; "languages")
				OB REMOVE:C1226(This:C1470.data; "digest")
				
				$version:="3.0"
				
				//______________________________________________________
			: ($version="3.0")  // Update to 3.1 or higher
				
				fixIDsWithSlashes
				
				$version:="3.1"
				
				//______________________________________________________
			: ($version="3.1")  // Update to 3.2 or higher
				
				//
				
				//______________________________________________________
		End case 
	Until ($version=This:C1470.version)
	
	If (This:C1470.data.version#$version)
		
		This:C1470.data.version:=$version
		This:C1470.save()
		
	End if 