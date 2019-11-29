//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : xml_SAVE_IN_FILE
  // Database: 4DPop XLIFF Pro
  // ID[D266F7B7383F497489547640F82B1C12]
  // Created #23-6-2016 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($1)
C_TEXT:C284($2)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Dom_ref;$Dom_root;$File_path;$File_pathname)

If (False:C215)
	C_TEXT:C284(xml_SAVE_IN_FILE ;$1)
	C_TEXT:C284(xml_SAVE_IN_FILE ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=2;"Missing parameter"))
	
	  //Required parameters
	$Dom_ref:=$1
	$File_pathname:=$2
	
	  //Optional parameters
	If ($Lon_parameters>=3)
		
		  // <NONE>
		
	End if 
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
$Dom_root:=xml_cleanup (DOM Get root XML element:C1053($Dom_ref))

DOM EXPORT TO FILE:C862($Dom_root;$File_pathname)

ASSERT:C1129(OK=1)

DOM CLOSE XML:C722($Dom_root)

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End