// MARK: Constants 🔐
property FILE_EXTENSION:=".xlf"
property FOLDER_EXTENSION:=".lproj"

property RESOURCES : Object:=:=JSON Parse:C1218(File:C1566("/RESOURCES/languages.json").getText())

Class constructor
	
	//
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function get lprojFolders() : Collection
	
	return Folder:C1567(fk resources folder:K87:11; *).folders().query("extension = :1 & name != :2"; This:C1470.FOLDER_EXTENSION; "_@")
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function get mainLanguage() : Text
	
	var $lprojFolder : Collection:=This:C1470.lprojFolders
	
	// First, we assume that the main language must be the system language
	var $langue : Text:=Get database localization:C1009(User system localization:K5:23; *)
	var $folder : 4D:C1709.Folder:=$lprojFolder.query("name = :1 OR name = :2"; $langue; $langue+"@").first()
	
	If ($folder#Null:C1517)
		
		return $folder.name
		
	End if 
	
	// As a second intention, let's look for the project's current language
	$langue:=Get database localization:C1009(Current localization:K5:22; *)
	$folder:=$lprojFolder.query("name = :1 OR name = :2"; $langue; $langue+"@").first()
	
	If ($folder#Null:C1517)
		
		return $folder.name
		
	End if 
	
	// Let's use English if it exists
	$folder:=$lprojFolder.query("name = :1 OR name = :2 OR name = :3"; "en"; "en@"; "English").first()
	
	If ($folder#Null:C1517)
		
		return $folder.name
		
	End if 
	
	// Finally, we take the 1st folder found, or as a last resort, the system language.
	return $lprojFolder.length>0\
		 ? $lprojFolder[0].name\
		 : Get database localization:C1009(User system localization:K5:23; *)
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function getFlag($code : Text) : Text
	
	var $source : Text
	
	Case of 
			
			//______________________________________________________
		: (Match regex:C1019("(?mi-s)^[a-zA-Z]{2}-[a-zA-Z]{2,}$"; $code; 1))
			
			$source:="lproj"  // Language-Regional Codes
			
			//______________________________________________________
		: (Match regex:C1019("(?mi-s)^[a-zA-Z]{2}$"; $code; 1))
			
			$source:="ISO639-1"
			
			//______________________________________________________
		Else 
			
			$source:="legacy"
			
			//______________________________________________________
	End case 
	
	$code:=Split string:C1554($code; "-").first()  // Keep only the first 2 characters of a sub-language
	var $index : Integer:=This:C1470.RESOURCES[$source].indexOf($code)
	
	If ($index#-1)
		
		return This:C1470.RESOURCES.flag[$index]  // Emoji
		
	Else 
		
		return "❔"
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function getName($code : Text) : Text
	
	var $source : Text
	
	Case of 
			
			//______________________________________________________
		: (Match regex:C1019("(?mi-s)^[a-zA-Z]{2}-[a-zA-Z]{2,}$"; $code; 1))
			
			$source:="lproj"  // Language-Regional Codes
			
			//______________________________________________________
		: (Match regex:C1019("(?mi-s)^[a-zA-Z]{2}$"; $code; 1))
			
			$source:="ISO639-1"
			
			//______________________________________________________
		Else 
			
			$source:="legacy"
			
			//______________________________________________________
	End case 
	
	$code:=Split string:C1554($code; "-").first()  // Keep only the first 2 characters of a sub-language
	var $index : Integer:=This:C1470.RESOURCES[$source].indexOf($code)
	
	If ($index#-1)
		
		return This:C1470.RESOURCES.flag[$index]  // Emoji
		
	Else 
		
		return "❔"
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function language($code : Text) : Object
	
	$code:=$code || This:C1470.mainLanguage
	
	return {code: $code; flag: This:C1470.getFlag($code)}
	