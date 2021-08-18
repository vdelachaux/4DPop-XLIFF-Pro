Class extends language

// === === === === === === === === === === === === === === === === === === ===
Class constructor
	
	Super:C1705()
	
	This:C1470.component:=(Structure file:C489#Structure file:C489(*))
	
	var $file : 4D:C1709.File
	$file:=Folder:C1567(fk database folder:K87:14; *).file("Preferences/4DPop XLIFF.settings")
	
	If ($file.exists)
		
		This:C1470.preferences:=JSON Parse:C1218($file.getText())
		
	Else 
		
		This:C1470.preferences:=New object:C1471(\
			"reference"; Get database localization:C1009(Default localization:K5:21); \
			"file"; "")
		
		This:C1470.savePreferences()
		
	End if 
	
	If (This:C1470.component)
		
		// Component execution
		This:C1470.mode:="editor"
		
		If (Application type:C494=4D Remote mode:K5:5)
			
			// Open the local cached folder
			This:C1470.project:=Folder:C1567(fk remote database folder:K87:9; *).folder("Resources")
			
		Else 
			
			// Open host database resources
			This:C1470.project:=Folder:C1567(fk resources folder:K87:11; *)
			
		End if 
		
	Else 
		
		If (Is compiled mode:C492)
			
			// Standalone editeur
			This:C1470.mode:="editor"
			
			//#TO_BE_DONE - must manage more than one project
			This:C1470.directory:=Folder:C1567(fk resources folder:K87:11)
			
		Else 
			
			// Matrix database
			If (Macintosh option down:C545)
				
				// Test project mode
				This:C1470.mode:="editor"
				
				//#TO_BE_DONE - 
				//This.directory:=Null
				
			Else 
				
				This:C1470.mode:="component"
				This:C1470.project:=Folder:C1567(fk resources folder:K87:11)
				
			End if 
		End if 
	End if 
	
	This:C1470.update()
	
	// === === === === === === === === === === === === === === === === === === ===
Function getFiles()->$files : Collection
	
	$files:=This:C1470.project.folder(This:C1470.reference+".lproj").files().query("extension = .xlf")
	
	// === === === === === === === === === === === === === === === === === === ===
Function update
	
	var $language : Text
	var $localizations : Collection
	
	Super:C1706.reload()
	
	This:C1470.interface:=New collection:C1472
	$localizations:=This:C1470.localizations.extract("name").orderBy()
	
	If ($localizations.length>0)
		
		For each ($language; $localizations)
			
			If ($language=This:C1470.reference)  // Reference language
				
				This:C1470.interface[0].language:=This:C1470.reference
				This:C1470.interface[0].regional:=This:C1470.getFlag(This:C1470.reference)
				
			Else   // Localization
				
				This:C1470.interface.push(New object:C1471(\
					"language"; $language; \
					"regional"; This:C1470.getFlag($language)))
				
			End if 
		End for each 
		
	Else 
		
		This:C1470.interface[0].language:=This:C1470.reference
		This:C1470.interface[0].regional:=This:C1470.getFlag(This:C1470.reference)
		
		CREATE FOLDER:C475(Get 4D folder:C485(Current resources folder:K5:16; *)+This:C1470.reference; *)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === ===
Function getPreference($key : Text)->$value : Variant
	
	$value:=This:C1470.preferences[$key]
	
	// === === === === === === === === === === === === === === === === === === ===
Function setPreference($key : Text; $value : Variant)
	
	If ($value=Null:C1517)\
		 | (Length:C16(String:C10($value))=0)
		
		// Remove the key
		OB REMOVE:C1226(This:C1470.preferences; $key)
		
	Else 
		
		// Set the value
		This:C1470.preferences[$key]:=$value
		
	End if 
	
	Folder:C1567(fk database folder:K87:14; *).file("Preferences/4DPop XLIFF.settings").setText(JSON Stringify:C1217(This:C1470.preferences; *))
	
	Case of 
			//______________________________________________________
		: ($key="reference")
			
			// Create the folder if any
			This:C1470.project.folder($value+".lproj").create()
			
			//______________________________________________________
		: (False:C215)
			
			
			
			//______________________________________________________
		Else 
			
			// A "Case of" statement should never omit "Else"
			
			//______________________________________________________
	End case 
	
	// === === === === === === === === === === === === === === === === === === ===
Function savePreferences()
	
	Folder:C1567(fk database folder:K87:14; *).file("Preferences/4DPop XLIFF.settings").setText(JSON Stringify:C1217(This:C1470.preferences; *))