//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : xml_GET_ELEMENT_VALUE
  // Database: 4DPop XLIFF Pro
  // ID[97A6B43F06154274ACDBBB774F0B8C1C]
  // Created #27-10-2015 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($1)
C_POINTER:C301($2)

C_LONGINT:C283($Lon_parameters)
C_POINTER:C301($Ptr_value)
C_TEXT:C284($Dom_elementRef;$Txt_data;$Txt_source)

If (False:C215)
	C_TEXT:C284(xml_GET_ELEMENT_VALUE ;$1)
	C_POINTER:C301(xml_GET_ELEMENT_VALUE ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=2;"Missing parameter"))
	
	  //Required parameters
	$Dom_elementRef:=$1  //dom reference
	$Ptr_value:=$2  //variable to populate
	
	  //Optional parameters
	If ($Lon_parameters>=3)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If (Asserted:C1132(xml_IsValidReference ($Dom_elementRef)))
	
	DOM GET XML ELEMENT VALUE:C731($Dom_elementRef;$Txt_source;$Txt_data)
	
	If (Length:C16($Txt_data)>0)
		
		$Txt_source:=$Txt_data
		
	End if 
End if 

  // ----------------------------------------------------
  // Return
$Ptr_value->:=$Txt_source

  // ----------------------------------------------------
  // End