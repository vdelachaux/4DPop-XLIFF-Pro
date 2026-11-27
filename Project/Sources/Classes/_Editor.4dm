// MARK: Constants 🔐
property FILE_EXTENSION:=".xlf"
property FOLDER_EXTENSION:=".lproj"
property RESOURCES : Object:=JSON Parse:C1218(File:C1566("/RESOURCES/languages.json").getText())
property LANGS:=[]

// MARK: Other 💾
property refLanguage : Text

Class constructor
	
	var $indx : Integer
	var $key : Text
	
	For each ($key; This:C1470.RESOURCES.lproj)
		
		This:C1470.LANGS.push(cs:C1710.language.new({\
			lproj: $key; \
			intl: This:C1470.RESOURCES.intl[$indx]; \
			fr: This:C1470.RESOURCES.fr[$indx]; \
			localized: This:C1470.RESOURCES.localized[$indx]; \
			iso: This:C1470.RESOURCES["ISO639-1"][$indx]; \
			legacy: This:C1470.RESOURCES.legacy[$indx]; \
			flag: This:C1470.RESOURCES.flag[$indx]; \
			regional: This:C1470.RESOURCES.regional[$indx]}))
		
		$indx+=1
		
	End for each 
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get lprojFolders() : Collection
	
	return Folder:C1567(fk resources folder:K87:11; *).folders().query("extension = :1 & name != :2"; This:C1470.FOLDER_EXTENSION; "_@")
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	// True if the wizard must be shown: first launch, or the saved languages no longer match the lproj folders
Function wizardNeeded($pref : cs:C1710.Preferences) : Boolean
	
	If (Not:C34($pref.exists("wizard")))
		
		return True:C214
		
	End if 
	
	// Checking for changes…
	If ($pref.get("sourceLanguage")#This:C1470.getLanguage(This:C1470.mainLanguage).lproj)
		
		return True:C214
		
	End if 
	
	return Not:C34($pref.get("targetLanguages").equal(This:C1470.targetLanguages().extract("lproj")))
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get mainLanguage() : Text
	
	If (This:C1470.refLanguage#Null:C1517)
		
		return This:C1470.refLanguage
		
	End if 
	
	var $folders : Collection:=This:C1470.lprojFolders
	var $found : 4D:C1709.Folder
	
	// B38: the reference language chosen in the wizard comes first. The system language came first, so on a French
	// system with English files, choosing "en" in the wizard was never taken into account: EDITOR OPEN compared the
	// saved "en" with "fr" and opened the wizard again, proposing "fr", forever
	var $saved : Text:=String:C10(cs:C1710.Preferences.new().get("sourceLanguage"))
	
	If (Length:C16($saved)>0)
		
		$found:=$folders.query("name = :1"; $saved).first()
		
		If ($found#Null:C1517)
			
			This:C1470.refLanguage:=$found.name
			return This:C1470.refLanguage
			
		End if 
	End if 
	
	// Then the source language declared by the files (<file source-language="en">), before the system language
	var $declared : Text:=This:C1470._declaredSourceLanguage($folders)
	
	If (Length:C16($declared)>0)
		
		$found:=$folders.query("name = :1 OR name = :2"; $declared; Split string:C1554($declared; "-")[0]).first()
		
		If ($found#Null:C1517)
			
			This:C1470.refLanguage:=$found.name
			return This:C1470.refLanguage
			
		End if 
	End if 
	
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
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
	// The source-language most declared by the .xlf files of the lproj folders ("" if none)
Function _declaredSourceLanguage($folders : Collection) : Text
	
	var $folder : 4D:C1709.Folder
	var $file : 4D:C1709.File
	var $count : Object:={}
	var $best : Text
	var $pos; $len : Integer
	var $text : Text
	
	For each ($folder; $folders)
		
		For each ($file; $folder.files().query("extension = :1"; This:C1470.FILE_EXTENSION))
			
			$text:=Substring:C12($file.getText(); 1; 4000)  // the <file> element is at the beginning
			
			If (Match regex:C1019("(?i)<file[^>]*\\ssource-language=\"([^\"]+)\""; $text; 1; $pos; $len))
				
				// $pos/$len: the whole match; the attribute value is extracted below
				$text:=Substring:C12($text; $pos; $len)
				$text:=Substring:C12($text; Position:C15("source-language=\""; $text)+17)
				$text:=Substring:C12($text; 1; Position:C15("\""; $text)-1)
				$count[$text]:=Num:C11($count[$text])+1
				
				If (Length:C16($best)=0) || ($count[$text]>Num:C11($count[$best]))
					
					$best:=$text
					
				End if 
			End if 
		End for each 
	End for each 
	
	return $best
	
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
Function getLanguage($code : Text) : cs:C1710.language
	
	return This:C1470.LANGS.query(This:C1470._source($code)+" = :1"; $code).first()
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function sourceLanguage() : cs:C1710.language
	
	var $code : Text:=This:C1470.refLanguage
	
	return This:C1470.LANGS.query(This:C1470._source($code)+" = :1"; $code).first()
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function targetLanguages($ref : Text) : Collection
	
	$ref:=$ref || This:C1470.refLanguage
	
	var $c:=[]
	var $folder : 4D:C1709.Folder
	
	For each ($folder; This:C1470.lprojFolders.query("name != :1"; $ref).orderBy("name"))
		
		$c.push(This:C1470.LANGS.query("lproj = :1"; $folder.name).first()\
			 || This:C1470.LANGS.query("legacy = :1"; $folder.name).first())
		
	End for each 
	
	return $c
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function getTargetLangs() : Collection
	
	var $c:=[]
	var $folder : 4D:C1709.Folder
	
	For each ($folder; This:C1470.lprojFolders.query("name != :1"; This:C1470.mainLanguage).orderBy("name"))
		
		$c.push(This:C1470.LANGS.query("lproj = :1"; $folder.name).first()\
			 || This:C1470.LANGS.query("legacy = :1"; $folder.name).first())
		
	End for each 
	
	return $c