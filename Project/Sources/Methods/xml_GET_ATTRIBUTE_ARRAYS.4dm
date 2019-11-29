//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : xml_GET_ATTRIBUTE_ARRAYS
  // Database: 4DPop XLIFF Pro
  // ID[C46C8354252C4739A51CC96D38D885BE]
  // Created #2-11-2015 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($1)
C_POINTER:C301($2)
C_POINTER:C301($3)

C_LONGINT:C283($Lon_i;$Lon_number;$Lon_parameters)
C_POINTER:C301($Ptr_arrayAttributes;$Ptr_arrayValuePointer)
C_TEXT:C284($Dom_reference)

If (False:C215)
	C_TEXT:C284(xml_GET_ATTRIBUTE_ARRAYS ;$1)
	C_POINTER:C301(xml_GET_ATTRIBUTE_ARRAYS ;$2)
	C_POINTER:C301(xml_GET_ATTRIBUTE_ARRAYS ;$3)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=2;"Missing parameter"))
	
	  //Required parameters
	$Dom_reference:=$1  //XML Reference where to retrieve attributes
	$Ptr_arrayAttributes:=$2  //will contain attribute names
	
	  //Optional parameters
	If ($Lon_parameters>=3)
		
		$Ptr_arrayValuePointer:=$3  //If passed, will contain the attribute values
		CLEAR VARIABLE:C89($Ptr_arrayValuePointer->)
		
	End if 
	
	CLEAR VARIABLE:C89($Ptr_arrayAttributes->)
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If (Asserted:C1132(xml_IsValidReference ($Dom_reference)))
	
	$Lon_number:=DOM Count XML attributes:C727($Dom_reference)
	
	ARRAY TEXT:C222($tTxt_keys;$Lon_number)
	ARRAY TEXT:C222($tTxt_values;$Lon_number)
	
	For ($Lon_i;1;$Lon_number;1)
		
		DOM GET XML ATTRIBUTE BY INDEX:C729($Dom_reference;$Lon_i;$tTxt_keys{$Lon_i};$tTxt_values{$Lon_i})
		
	End for 
	
Else 
	
	ARRAY TEXT:C222($tTxt_keys;0x0000)
	ARRAY TEXT:C222($tTxt_values;0x0000)
	
End if 

  // ----------------------------------------------------
  // Return
  //%W-518.1
COPY ARRAY:C226($tTxt_keys;$Ptr_arrayAttributes->)

If ($Lon_parameters>=3)
	
	COPY ARRAY:C226($tTxt_values;$Ptr_arrayValuePointer->)
	
End if 
  //%W+518.1

  // ----------------------------------------------------
  // End