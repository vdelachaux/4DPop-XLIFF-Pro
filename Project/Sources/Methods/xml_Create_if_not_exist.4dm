//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : xml_Create_if_not_exist
  // Database: 4DPop XLIFF Pro
  // ID[59219C8318A3486A862603E2D781A8C3]
  // Created #14-1-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($0)
C_TEXT:C284($1)
C_TEXT:C284($2)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Dom_element;$Dom_reference;$Txt_xpath)

If (False:C215)
	C_TEXT:C284(xml_Create_if_not_exist ;$0)
	C_TEXT:C284(xml_Create_if_not_exist ;$1)
	C_TEXT:C284(xml_Create_if_not_exist ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=2;"Missing parameter"))
	
	  //Required parameters
	$Dom_reference:=$1
	$Txt_xpath:=$2
	
	  //Optional parameters
	If ($Lon_parameters>=3)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
$Dom_element:=DOM Find XML element:C864($Dom_reference;$Txt_xpath)

If (OK=0)
	
	$Dom_element:=DOM Create XML element:C865($Dom_reference;$Txt_xpath)
	
End if 

  // ----------------------------------------------------
  // Return
$0:=$Dom_element

  // ----------------------------------------------------
  // End