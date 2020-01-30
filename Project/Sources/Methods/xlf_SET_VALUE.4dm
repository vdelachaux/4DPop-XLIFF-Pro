//%attributes  = {"invisible":true}
  // ----------------------------------------------------
  // Project method : xlf_SET_VALUE
  // Database: 4DPop XLIFF Pro
  // ID[6C2F2ECC58314280AF68A6F6246E103D]
  // Created #2-11-2015 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($1)
C_TEXT:C284($2)
C_TEXT:C284($3)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Dom_ref;$File_path;$Txt_value)

If (False:C215)
	C_TEXT:C284(xlf_SET_VALUE ;$1)
	C_TEXT:C284(xlf_SET_VALUE ;$2)
	C_TEXT:C284(xlf_SET_VALUE ;$3)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=2;"Missing parameter"))
	
	  //Required parameters
	$Dom_ref:=$1  //element reference
	$Txt_value:=$2
	
	  //Optional parameters
	If ($Lon_parameters>=3)
		
		$File_path:=$3  //if path is given, the file will be saved
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If (Asserted:C1132(xml_IsValidReference ($Dom_ref)))
	
	DOM SET XML ELEMENT VALUE:C868($Dom_ref;$Txt_value)
	
	ASSERT:C1129(OK=1)
	
	If ($Lon_parameters>=3)
		
		  //Save
		xlf_SAVE ($Dom_ref;$File_path)
		
	End if 
End if 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End 