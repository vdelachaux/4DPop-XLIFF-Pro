//%attributes  = {"invisible":true}
  // ----------------------------------------------------
  // Project method : xml_REMOVE_ATTRIBUTE
  // Project method : xml_remove_attribute
  // ID[B0A9467A327349E18F9561833BE4B74F]
  // Created 01/07/11 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Remove an attribute without error ( if exist)
  // ----------------------------------------------------
  // xml_REMOVE_ATTRIBUTE ( ref ; key )
  //  -> ref (Text)
  //  -> key (Text)
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($1)
C_TEXT:C284($2)

C_LONGINT:C283($Lon_i;$Lon_parameters)
C_TEXT:C284($Dom_ref;$Txt_;$Txt_key;$Txt_name)

If (False:C215)
	C_TEXT:C284(xml_REMOVE_ATTRIBUTE ;$1)
	C_TEXT:C284(xml_REMOVE_ATTRIBUTE ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=2;"Missing parameter"))
	
	  //Required parameters
	$Dom_ref:=$1
	$Txt_key:=$2
	
	  //Optional parameters
	If ($Lon_parameters>=3)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
For ($Lon_i;1;DOM Count XML attributes:C727($Dom_ref);1)
	
	DOM GET XML ATTRIBUTE BY INDEX:C729($Dom_ref;$Lon_i;$Txt_name;$Txt_)
	
	If ($Txt_name=$Txt_key)
		
		DOM REMOVE XML ATTRIBUTE:C1084($Dom_ref;$Txt_key)
		$Lon_i:=MAXLONG:K35:2-1  //Go out
		
	End if 
End for 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End 