//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : language_Find
  // Database: 4DPop XLIFF Pro
  // ID[AAD0C22582DE48728E7A95537E5BBBAB]
  // Created #17-5-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Return the collection of managed languages for the project
  // ----------------------------------------------------
  // Declarations
C_COLLECTION:C1488($0)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Txt_language)
C_COLLECTION:C1488($Col_languages;$Col_localizations)

If (False:C215)
	C_COLLECTION:C1488(language_Find ;$0)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // NO PARAMETERS REQUIRED
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
$Col_languages:=New collection:C1472(New object:C1471)  // The first element will be the reference language

  //#WARNING - could be constant files
$Col_localizations:=doc_Folder (Get 4D folder:C485(Current resources folder:K5:16;*)).folders.query("extension = .lproj & name != _@").extract("name").sort()

If ($Col_localizations.length>0)
	
	For each ($Txt_language;$Col_localizations)
		
		If ($Txt_language=Form:C1466.language)  // Reference language
			
			$Col_languages[0].language:=Form:C1466.language
			$Col_languages[0].regional:=language_Flag (Form:C1466.language)
			
		Else   // Localization
			
			$Col_languages.push(New object:C1471(\
				"language";$Txt_language;\
				"regional";language_Flag ($Txt_language)))
			
		End if 
	End for each 
	
Else 
	
	$Col_languages[0].language:=Form:C1466.language
	$Col_languages[0].regional:=language_Flag (Form:C1466.language)
	
	CREATE FOLDER:C475(Get 4D folder:C485(Current resources folder:K5:16;*)+Form:C1466.language;*)
	
End if 

  // ----------------------------------------------------
  // Return
$0:=$Col_languages

  // ----------------------------------------------------
  // End