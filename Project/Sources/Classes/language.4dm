Class constructor
	
	// Default is the host database folder
	This:C1470.project:=Folder:C1567(fk resources folder:K87:11; *)
	This:C1470.resources:=JSON Parse:C1218(File:C1566("/RESOURCES/languages.json").getText())
	
	This:C1470.reload()
	
	This:C1470.reference:=This:C1470.getReferenceLanguage()
	
	// === === === === === === === === === === === === === === === === === === ===
Function reload
	
	This:C1470.localizations:=This:C1470.project.folders().query("extension = .lproj & name != _@")
	
	// === === === === === === === === === === === === === === === === === === ===
	// Returns the current source language
Function getReferenceLanguage()->$language : Text
	var $node; $source; $target : Text
	var $attributes; $xml : Object
	var $languages : Collection
	var $file : 4D:C1709.File
	var $folder : 4D:C1709.Folder
	
	// Default is the os language
	$languages:=New collection:C1472(Get system info:C1571.osLanguage)
	
	For each ($folder; This:C1470.localizations)
		
		For each ($file; $folder.files().query("extension = .xlf"))
			
			$xml:=cs:C1710.xml.new().load($file)
			
			If ($xml.success)
				
				$node:=$xml.findByXPath("xliff/file")
				
				If ($xml.success)
					
					$attributes:=$xml.getAttributes($node)
					
					$source:=String:C10($attributes["source-language"])
					
					If ($source#"x-none")  // "x-none" is for constant file
						
						If (Match regex:C1019("(?mi-s)^[a-zA-Z]{2}-[a-zA-Z]{2,}$"; $source; 1))  // Language-Regional Codes
							
							// Keep the Language code
							$source:=Substring:C12($source; 1; 2)
							
						End if 
						
						// Keep the source language
						$languages.push($source)
						
						$target:=String:C10($attributes["target-language"])
						
						Case of 
								
								//______________________________________________________
							: ($source=$target)
								
								$language:=$source
								
								//______________________________________________________
							: (This:C1470.getCode($target)=$source)  // En : en-us
								
								$language:=$target
								
								//______________________________________________________
							Else 
								
								// ??
								
								//______________________________________________________
						End case 
					End if 
				End if 
				
				$xml.close()
				
			End if 
		End for each 
	End for each 
	
	$languages:=$languages.distinct()
	
	If ($languages.indexOf($language)#-1)
		
		$language:=This:C1470.getCode($language)
		
	Else 
		
		If ($languages.length=1)
			
			$language:=This:C1470.getCode($languages[0])
			
		Else 
			
			If ($languages.indexOf($languages[0])#-1)
				
				// Remove the system language
				$languages.remove($languages.indexOf($languages[0]))
				
			End if 
			
			$language:=$languages.join(",")
			
		End if 
	End if 
	
	// === === === === === === === === === === ====== === === === === === === ===
	// Returns the collection of managed languages
Function languages()->$languages : Collection
	
	$languages:=New collection:C1472
	
	var $language : Text
	var $localizations : Collection
	$localizations:=This:C1470.localizations.extract("name").orderBy()
	
	If ($localizations.length>0)
		
		For each ($language; $localizations)
			
			If ($language=This:C1470.reference)  // Reference language
				
				$languages[0].language:=This:C1470.reference
				$languages[0].regional:=This:C1470.getFlag(This:C1470.reference)
				
			Else   // Localization
				
				$languages.push(New object:C1471(\
					"language"; $language; \
					"regional"; This:C1470.getFlag($language)))
				
			End if 
		End for each 
		
	Else 
		
		$languages[0].language:=This:C1470.reference
		$languages[0].regional:=This:C1470.getFlag(This:C1470.reference)
		
		CREATE FOLDER:C475(Get 4D folder:C485(Current resources folder:K5:16; *)+This:C1470.reference; *)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === ===
	// Returns the UTF-16 flag characters
Function getFlag($code : Text)->$flag : Text
	
	var $i; $indx : Integer
	ARRAY TEXT:C222($arrayText; 0)
	ARRAY TEXT:C222($arrayChar; 0)
	ARRAY TEXT:C222($arrayUnicode; 0)
	
	Case of 
			
			//______________________________________________________
		: (Match regex:C1019("(?mi-s)^[a-zA-Z]{2}-[a-zA-Z]{2,}$"; $code; 1))
			
			// Language-Regional Codes
			OB GET ARRAY:C1229(This:C1470.resources; "lproj"; $arrayText)
			
			//______________________________________________________
		: (Match regex:C1019("(?mi-s)^[a-zA-Z]{2}$"; $code; 1))
			
			// ISO639-1
			OB GET ARRAY:C1229(This:C1470.resources; "ISO639-1"; $arrayText)
			
			//______________________________________________________
		Else 
			
			// Legacy
			OB GET ARRAY:C1229(This:C1470.resources; "legacy"; $arrayText)
			
			//______________________________________________________
	End case 
	
	$indx:=Find in array:C230($arrayText; $code)
	
	If ($indx>0)
		
		OB GET ARRAY:C1229(This:C1470.resources; "flag"; $arrayText)
		$flag:=$arrayText{$indx}
		
	Else 
		
		If (Length:C16($code)>4)
			
			$code:=Substring:C12($code; 4)
			
			For ($i; 1; 26; 1)
				
				$arrayChar{$i}:=Char:C90(64+$i)
				$arrayUnicode{$i}:=String:C10(127461+$i; "&x")
				
			End for 
			
			$flag:=convert_Unicode_to_UTF16($arrayUnicode{Find in array:C230($arrayChar; $code[[1]])})+convert_Unicode_to_UTF16($arrayUnicode{Find in array:C230($arrayChar; $code[[2]])})
			
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === ===
	// Return the language-regional code (lproj folder name) from
	// • the legacy language name
	// • or ISO639-1 language coding
	// • or language-Regional code
Function getCode($code : Text)->$language : Text
	var $index : Integer
	
	Case of 
			
			//______________________________________________________
		: (Match regex:C1019("(?mi-s)^[a-zA-Z]{2}-[a-zA-Z]{2,}$"; $code; 1))
			
			// Language-Regional Codes
			$index:=This:C1470.resources.lproj.indexOf($code)
			
			//______________________________________________________
		: (Match regex:C1019("(?mi-s)^[a-zA-Z]{2}$"; $code; 1))
			
			// ISO639-1
			$index:=This:C1470.resources["ISO639-1"].indexOf($code)
			
			//______________________________________________________
		Else 
			
			// Legacy
			$index:=This:C1470.resources.legacy.indexOf($code)
			
			//______________________________________________________
	End case 
	
	If ($index#-1)
		
		$language:=This:C1470.resources.lproj[$index]
		
	End if 