//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : xlf_Copyright
  // Database: 4DPop XLIFF Pro
  // ID[11A5BC1822C3403B95CE38816CA0E610]
  // Created #15-12-2016 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($0)
C_TEXT:C284($1)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Dom_root;$Txt_buffer)

If (False:C215)
	C_TEXT:C284(xlf_Copyright ;$0)
	C_TEXT:C284(xlf_Copyright ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  //Required parameters
	$Dom_root:=$1
	
	  //Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
DOM EXPORT TO VAR:C863($Dom_root;$Txt_buffer)

If (0=Rgx_SubstituteText ("(?msi)(<!--.*Copyright.*\\d{4})-\\d{4}([^>]*>)";"\\1-"+String:C10(Year of:C25(Current date:C33))+"\\2";->$Txt_buffer))
	
	DOM CLOSE XML:C722($Dom_root)
	
	$Dom_root:=DOM Parse XML variable:C720($Txt_buffer)
	
End if 

  // ----------------------------------------------------
  // Return
$0:=$Dom_root

  // ----------------------------------------------------
  // End