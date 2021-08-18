//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : EDITOR_CLEANUP
// Database: 4DPop XLIFF Pro
// ID[344198ACF02A45BF8E4113E853CCB375]
// Created 22/04/2018 by Designer
// ----------------------------------------------------
// Description:
// Cleanup translation files, if any
// ----------------------------------------------------
// Declarations
C_COLLECTION:C1488($1)

C_LONGINT:C283($Lon_parameters)
C_OBJECT:C1216($Obj_language)
C_COLLECTION:C1488($Col_languages)

If (False:C215)
	C_COLLECTION:C1488(EDITOR_CLEANUP; $1)
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0; "Missing parameter"))
	
	// NO PARAMETERS REQUIRED
	
	// Optional parameters
	If ($Lon_parameters>=1)
		
		$Col_languages:=$1
		
	Else 
		
		$Col_languages:=Form:C1466.languages
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
For each ($Obj_language; $Col_languages)
	
	If ($Obj_language.file.$dom#Null:C1517)
		
		If ($Obj_language.language#Form:C1466.language)
			
			DOM CLOSE XML:C722($Obj_language.file.$dom)
			OB REMOVE:C1226($Obj_language.file; "$dom")
			
		End if 
	End if 
End for each 

// Clean up dialog
OB REMOVE:C1226(Form:C1466; "$current")
OB REMOVE:C1226(Form:C1466; "$target")

// ----------------------------------------------------
// End 