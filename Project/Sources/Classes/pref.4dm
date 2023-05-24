Class extends _classCore  //test

property file : 4D:C1709.File
property content : Object

// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Class constructor($file : 4D:C1709.File)
	
	Super:C1705()
	
	This:C1470.file:=Null:C1517
	This:C1470.content:=Null:C1517
	
	This:C1470._default:="Preference.pref"
	
	If ($file#Null:C1517)  // Customized file
		
		This:C1470.file:=$file
		This:C1470.load()
		
	End if 
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get exists() : Boolean
	
	return This:C1470.file=Null:C1517 ? False:C215 : This:C1470.file.exists
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function database($fileName) : cs:C1710.pref
	
	$fileName:=$fileName || This:C1470._default
	
	This:C1470.file:=Folder:C1567(fk database folder:K87:14; *).folder("Preferences").file($fileName)
	This:C1470.load()
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function user($fileName) : cs:C1710.pref
	
	$fileName:=$fileName || This:C1470._default
	
	This:C1470.file:=Folder:C1567(fk user preferences folder:K87:10).folder(Folder:C1567(Database folder:K5:14; *).name).file($fileName)
	This:C1470.load()
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function session($fileName) : cs:C1710.pref
	
	$fileName:=$fileName || This:C1470._default
	
	This:C1470.file:=Folder:C1567(fk home folder:K87:24).folder("Library/Preferences/").file($fileName)
	This:C1470.load()
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function get($key : Text) : Variant
	
	return Count parameters:C259=0 ? This:C1470.content : This:C1470.content[$key]
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function set($data; $value)
	
	Case of 
			//______________________________________________________
		: (Value type:C1509($data)=Is text:K8:3)
			
			If (Count parameters:C259>=2)
				
				This:C1470.content[$data]:=$value
				
			Else 
				
				// Remove
				OB REMOVE:C1226(This:C1470.content; $data)
				
			End if 
			
			//______________________________________________________
		: (Value type:C1509($data)=Is object:K8:27)
			
			This:C1470.content:=$data
			
			//______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215; Current method name:C684+"(): data must be a Text or an Object!")
			
			//______________________________________________________
	End case 
	
	// Save immediately
	This:C1470.save()
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function load()
	
	If (Asserted:C1132(This:C1470.file#Null:C1517; "file is null"))
		
		If (This:C1470.file.exists)
			
			This:C1470.content:=JSON Parse:C1218(This:C1470.file.getText())
			
		Else 
			
			// Create
			This:C1470.content:={}
			
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function save()
	
	If (Asserted:C1132(This:C1470.file#Null:C1517; "content is null"))
		
		This:C1470.file.setText(JSON Stringify:C1217(This:C1470.content; *))
		
	End if 