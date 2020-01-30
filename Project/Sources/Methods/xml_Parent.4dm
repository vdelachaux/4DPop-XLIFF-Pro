//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : xml_Parent
  // Database: 4DPop XLIFF Pro
  // ID[14F5A569313E4C768D0810CD68B72D8C]
  // Created #27-10-2015 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Reach back in the parent's hierarchy to retrieve the parent's reference whose
  // name is equal to $2 if passed.
  // If $2 is omitted, returns the immediate parent of $1
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($0)
C_TEXT:C284($1)
C_TEXT:C284($2)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Dom_ref;$Dom_root;$Txt_buffer;$Txt_name)

If (False:C215)
	C_TEXT:C284(xml_Parent ;$0)
	C_TEXT:C284(xml_Parent ;$1)
	C_TEXT:C284(xml_Parent ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  //Required parameters
	$Dom_ref:=$1  //XML reference
	
	  //Optional parameters
	If ($Lon_parameters>=2)
		
		$Txt_name:=$2  //Name of the parent element to search for
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If (Asserted:C1132(xml_IsValidReference ($Dom_ref)))
	
	If ($Lon_parameters>=2)
		
		$Dom_root:=DOM Get root XML element:C1053($Dom_ref)
		
		DOM GET XML ELEMENT NAME:C730($Dom_ref;$Txt_buffer)
		
		While ($Txt_name#$Txt_buffer)\
			 & ($Dom_ref#$Dom_root)
			
			$Dom_ref:=DOM Get parent XML element:C923($Dom_ref;$Txt_buffer)
			
		End while 
		
		If ($Dom_ref=$Dom_root)\
			 & ($Txt_name#$Txt_name)
			
			CLEAR VARIABLE:C89($Dom_ref)
			
		End if 
		
	Else 
		
		$Dom_ref:=DOM Get parent XML element:C923($Dom_ref)
		
	End if 
End if 

  // ----------------------------------------------------
  // Return
$0:=$Dom_ref  //Found XML reference (Empty if not found)

  // ----------------------------------------------------
  // End 