// MARK: Constants 🔐
property FILE_EXTENSION:=".xlf"
property FOLDER_EXTENSION:=".lproj"
property RESOURCES : Object:=JSON Parse:C1218(File:C1566("/RESOURCES/languages.json").getText())
property LANGUAGES:=[]

// MARK: Other 💾
property refLanguage : Text

Class constructor
	
	var $indx : Integer
	var $key : Text
	
	For each ($key; This:C1470.RESOURCES.lproj)
		
		This:C1470.LANGUAGES.push(cs:C1710.language.new({\
			lproj: $key; \
			intl: This:C1470.RESOURCES.intl[$indx]; \
			localized: This:C1470.RESOURCES.localized[$indx]; \
			iso: This:C1470.RESOURCES["ISO639-1"][$indx]; \
			legacy: This:C1470.RESOURCES.legacy[$indx]; \
			flag: This:C1470.RESOURCES.flag[$indx]; \
			regional: This:C1470.RESOURCES.regional[$indx]\
			}))
		
		$indx+=1
		
	End for each 
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get lprojFolders() : Collection
	
	return Folder:C1567(fk resources folder:K87:11; *).folders().query("extension = :1 & name != :2"; This:C1470.FOLDER_EXTENSION; "_@")
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get mainLanguage() : Text
	
	If (This:C1470.refLanguage#Null:C1517)
		
		return This:C1470.refLanguage
		
	End if 
	
	var $folders : Collection:=This:C1470.lprojFolders
	
	// First, we assume that the main language must be the system language
	var $langue : Text:=Get database localization:C1009(User system localization:K5:23; *)
	var $folder : 4D:C1709.Folder:=$folders.query("name = :1 OR name = :2"; $langue; $langue+"@").first()
	
	If ($folder#Null:C1517)
		
		This:C1470.refLanguage:=$folder.name
		return This:C1470.refLanguage
		
	End if 
	
	// As a second intention, let's look for the project's current language
	$langue:=Get database localization:C1009(Current localization:K5:22; *)
	$folder:=$folders.query("name = :1 OR name = :2"; $langue; $langue+"@").first()
	
	If ($folder#Null:C1517)
		
		This:C1470.refLanguage:=$folder.name
		return This:C1470.refLanguage
		
	End if 
	
	// Let's use English if it exists
	$folder:=$folders.query("name = :1 OR name = :2 OR name = :3"; "en"; "en@"; "English").first()
	
	If ($folder#Null:C1517)
		
		This:C1470.refLanguage:=$folder.name
		return This:C1470.refLanguage
		
	End if 
	
	// Finally, we take the 1st folder found, or as a last resort, the system language.
	This:C1470.refLanguage:=$folders.length>0\
		 ? $folders[0].name\
		 : Get database localization:C1009(User system localization:K5:23; *)
	
	return This:C1470.refLanguage
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function set mainLanguage($language)
	
	TRACE:C157
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function getFlag($code : Text) : Text
	
	var $source : Text:=This:C1470._source($code)
	//$code:=Split string($code; "-").first()  // Keep only the first 2 characters of a sub-language
	var $index : Integer:=This:C1470.RESOURCES[$source].indexOf($code)
	
	If ($index#-1)
		
		return This:C1470.RESOURCES.flag[$index]  // Emoji
		
	Else 
		
		return "❔"
		
	End if 
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _source($in : Text) : Text
	
	Case of 
			
			//______________________________________________________
		: (This:C1470.RESOURCES.lproj.includes($in))
			
			return "lproj"  // Language-Regional Codes
			
			//______________________________________________________
		: (This:C1470.RESOURCES.localized.includes($in))
			
			return "localized"
			
			//______________________________________________________
		: (This:C1470.RESOURCES.intl.includes($in))
			
			return "intl"
			
			//______________________________________________________
		: (This:C1470.RESOURCES.legacy.includes($in))
			
			return "legacy"
			
			//______________________________________________________
	End case 
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function language($code : Text) : Object
	
	$code:=$code || This:C1470.mainLanguage
	
	return This:C1470.LANGUAGES.query(This:C1470._source($code)+" = :1"; $code).first()
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function targetLanguages($ref : Text) : Collection
	
	$ref:=$ref || This:C1470.refLanguage
	
	var $languages:=[]
	var $folder : 4D:C1709.Folder
	
	For each ($folder; This:C1470.lprojFolders.query("name != :1"; $ref).orderBy("name"))
		
		$languages.push(This:C1470.LANGUAGES.query("lproj = :1"; $folder.name).first()\
			 || This:C1470.LANGUAGES.query("legacy = :1"; $folder.name).first())
		
	End for each 
	
	return $languages
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function languages() : Collection
	
	var $languages:=[]
	var $folder : 4D:C1709.Folder
	
	For each ($folder; This:C1470.lprojFolders.query("name != :1"; This:C1470.refLanguage).orderBy("name"))
		
		$languages.push(This:C1470.LANGUAGES.query("lproj = :1"; $folder.name).first()\
			 || This:C1470.LANGUAGES.query("legacy = :1"; $folder.name).first())
		
	End for each 
	
	return $languages