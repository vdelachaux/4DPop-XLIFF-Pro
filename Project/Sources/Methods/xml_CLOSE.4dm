//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : xml_CLOSE
  // Database: 4DPop XLIFF Pro
  // ID[67D641DDEC9B4A7182161C5AD57647B7]
  // Created #4-1-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($1)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Dom_ref)

If (False:C215)
	C_TEXT:C284(xml_CLOSE ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  //Required parameters
	$Dom_ref:=$1
	
	  //Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If (Asserted:C1132(Match regex:C1019("(?mi-s)^(?!^0*$)(?:[0-9A-F]{16}){1,2}$";$Dom_ref;1)))
	
	DOM CLOSE XML:C722(DOM Get root XML element:C1053($Dom_ref))
	
End if 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End 