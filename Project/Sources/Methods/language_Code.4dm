//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : language_Code
  // Database: 4DPop XLIFF Pro
  // ID[025E9E9134A44C0A92EFF21AE1CD9CD7]
  // Created #12-10-2015 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Return the language-regional code (lproj folder name) from the legacy language
  // Name or ISO639-1 language coding or language-Regional code
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($0)
C_TEXT:C284($1)

C_LONGINT:C283($Lon_index;$Lon_parameters)
C_TEXT:C284($Txt_language)
C_OBJECT:C1216($Obj_resources)

If (False:C215)
	C_TEXT:C284(language_Code ;$0)
	C_TEXT:C284(language_Code ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Txt_language:=$1  // Language code
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
	$Obj_resources:=JSON Parse:C1218(Document to text:C1236(Get 4D folder:C485(Current resources folder:K5:16)+"languages.json"))
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: (Match regex:C1019("(?mi-s)^[a-zA-Z]{2}-[a-zA-Z]{2,}$";$Txt_language;1))
		
		  // Language-Regional Codes
		$Lon_index:=$Obj_resources["lproj"].indexOf($Txt_language)
		
		  //______________________________________________________
	: (Match regex:C1019("(?mi-s)^[a-zA-Z]{2}$";$Txt_language;1))
		
		  // ISO639-1
		$Lon_index:=$Obj_resources["ISO639-1"].indexOf($Txt_language)
		
		  //______________________________________________________
	Else 
		
		  // Legacy
		$Lon_index:=$Obj_resources["legacy"].indexOf($Txt_language)
		
		  //______________________________________________________
End case 

If ($Lon_index#-1)
	
	$Txt_language:=$Obj_resources["lproj"][$Lon_index]
	
End if 

  // ----------------------------------------------------
  // Return
$0:=$Txt_language

  // ----------------------------------------------------
  // End