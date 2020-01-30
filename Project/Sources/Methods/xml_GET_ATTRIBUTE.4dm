//%attributes  = {"invisible":true}
  // ----------------------------------------------------
  // Project method : xml_GET_ATTRIBUTE
  // Database: 4DPop XLIFF Pro
  // ID[C2CE6E583E924ACF8B7FD9A1647F4398]
  // Created #12-10-2015 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($1)
C_TEXT:C284($2)
C_POINTER:C301($3)

C_LONGINT:C283($Lon_i;$Lon_parameters)
C_POINTER:C301($Ptr_value)
C_TEXT:C284($Dom_elementRef;$Txt_attributeName;$Txt_buffer;$Txt_name)

If (False:C215)
	C_TEXT:C284(xml_GET_ATTRIBUTE ;$1)
	C_TEXT:C284(xml_GET_ATTRIBUTE ;$2)
	C_POINTER:C301(xml_GET_ATTRIBUTE ;$3)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=3;"Missing parameter"))
	
	  //Required parameters
	$Dom_elementRef:=$1
	$Txt_attributeName:=$2
	$Ptr_value:=$3
	
	  //Optional parameters
	If ($Lon_parameters>=4)
		
		  // <NONE>
		
	End if 
	
	CLEAR VARIABLE:C89($Ptr_value->)
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If (Asserted:C1132(xml_IsValidReference ($Dom_elementRef)))
	
	For ($Lon_i;1;DOM Count XML attributes:C727($Dom_elementRef);1)
		
		DOM GET XML ATTRIBUTE BY INDEX:C729($Dom_elementRef;$Lon_i;$Txt_name;$Txt_buffer)
		
		If ($Txt_name=$Txt_attributeName)
			
			DOM GET XML ATTRIBUTE BY NAME:C728($Dom_elementRef;$Txt_attributeName;$Ptr_value->)
			$Lon_i:=MAXLONG:K35:2-1  //Go out
			
		End if 
	End for 
End if 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End 