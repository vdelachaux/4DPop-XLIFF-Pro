//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : xlf_Dom_unit
  // Database: 4DPop XLIFF Pro
  // ID[813C9C86959948919115044A8C3F21E5]
  // Created #27-10-2015 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // From a reference into the "trans-unit", returns the reference of the "trans-unit"
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($0)
C_TEXT:C284($1)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Dom_ref;$Dom_root;$Txt_name)

If (False:C215)
	C_TEXT:C284(xlf_Dom_unit ;$0)
	C_TEXT:C284(xlf_Dom_unit ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  //Required parameters
	$Dom_ref:=$1  // XML reference
	
	  //Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
	$Dom_root:=DOM Get root XML element:C1053($Dom_ref)
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
DOM GET XML ELEMENT NAME:C730($Dom_ref;$Txt_name)

While ($Txt_name#"trans-unit")\
 & ($Dom_ref#$Dom_root)
	
	$Dom_ref:=DOM Get parent XML element:C923($Dom_ref;$Txt_name)
	
End while 

  // ----------------------------------------------------
  // Return
$0:=$Dom_ref

  // ----------------------------------------------------
  // End