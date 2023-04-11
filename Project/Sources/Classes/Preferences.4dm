Class extends _classCore

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
		
		This:C1470.data:=New object:C1471("version"; This:C1470.version)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === ===
Function get($key : Text) : Variant
	
	return This:C1470.data[$key]
	
	// === === === === === === === === === === === === === === === === === === ===
Function set($key : Text; $value)
	
	This:C1470.data[$key]:=$value
	
	This:C1470._save()
	
	// === === === === === === === === === === === === === === === === === === ===
Function _save()
	
	This:C1470.file.setText(JSON Stringify:C1217(This:C1470.data; *))
	
	// === === === === === === === === === === === === === === === === === === ===
Function _update()
	
	Case of 
			
			//______________________________________________________
		: (This:C1470.data.version=Null:C1517)
			
			This:C1470.data.version:=This:C1470.version
			
			OB REMOVE:C1226(This:C1470.data; "file")
			OB REMOVE:C1226(This:C1470.data; "files")
			OB REMOVE:C1226(This:C1470.data; "languages")
			OB REMOVE:C1226(This:C1470.data; "digest")
			
			//______________________________________________________
		: (This:C1470.data.version="3.0")  // Update to 3.1 or higher
			
			//
			
			//______________________________________________________
	End case 