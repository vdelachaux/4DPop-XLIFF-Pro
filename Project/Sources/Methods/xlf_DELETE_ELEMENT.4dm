//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : xlf_DELETE_ELEMENT
  // Database: 4DPop XLIFF Pro
  // ID[BB556D089D384C8B9B65F909D68D4398]
  // Created #3-1-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($1)
C_TEXT:C284($2)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Dom_ref;$Dom_root;$File_path)

If (False:C215)
	C_TEXT:C284(xlf_DELETE_ELEMENT ;$1)
	C_TEXT:C284(xlf_DELETE_ELEMENT ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Dom_ref:=$1  // Element reference
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		$File_path:=$2  // If path is given, the file will be saved
		
		  // Keep the root reference for saving
		$Dom_root:=DOM Get root XML element:C1053($Dom_ref)
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If (Asserted:C1132(xml_IsValidReference ($Dom_ref)))
	
	DOM REMOVE XML ELEMENT:C869($Dom_ref)
	
	ASSERT:C1129(OK=1)
	
	If ($Lon_parameters>=2)
		
		  // Save
		Form:C1466.save($Dom_root;$File_path)
		
	End if 
End if 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End 