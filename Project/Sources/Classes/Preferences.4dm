Class extends pref

property file : 4D:C1709.File
property content : Object

Class constructor($version : Text)
	
	Super:C1705()
	
	This:C1470.version:=$version
	
	This:C1470.database("4DPop XLIFF.settings")
	
	If (This:C1470.exists)
		
		This:C1470.load()
		This:C1470._update()
		
	Else 
		
		// Set default
		This:C1470.set({version: This:C1470.version})
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === ===
Function _update()
	
	Case of 
			
			//______________________________________________________
		: (This:C1470.content.version=Null:C1517)  // Firts update
			
			This:C1470.content.version:=This:C1470.version
			
			OB REMOVE:C1226(This:C1470.content; "file")
			OB REMOVE:C1226(This:C1470.content; "files")
			OB REMOVE:C1226(This:C1470.content; "languages")
			OB REMOVE:C1226(This:C1470.content; "digest")
			
			//______________________________________________________
		: (This:C1470.content.version="3.0")  // Update to 3.1 or higher
			
			//
			
			//______________________________________________________
	End case 