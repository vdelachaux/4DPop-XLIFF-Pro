//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : xml_GET_ATTRIBUTES
  // Database: 4DPop XLIFF Pro
  // ID[C2CE6E583E924ACF8B7FD9A1647F4398]
  // Created #12-10-2015 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($1)
C_POINTER:C301($2)
C_POINTER:C301($3)

C_LONGINT:C283($Lon_found;$Lon_i;$Lon_parameters;$Lon_x)
C_POINTER:C301($Ptr_arrayAttributes;$Ptr_arrayValuePointer)
C_TEXT:C284($Dom_elementRef;$Txt_buffer;$Txt_name)

If (False:C215)
	C_TEXT:C284(xml_GET_ATTRIBUTES ;$1)
	C_POINTER:C301(xml_GET_ATTRIBUTES ;$2)
	C_POINTER:C301(xml_GET_ATTRIBUTES ;$3)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=3;"Missing parameter"))
	
	  //Required parameters
	$Dom_elementRef:=$1
	$Ptr_arrayAttributes:=$2
	$Ptr_arrayValuePointer:=$3
	
	  //Optional parameters
	If ($Lon_parameters>=4)
		
		  // <NONE>
		
	End if 
	
	  //clear target variables {
	For ($Lon_i;1;Size of array:C274($Ptr_arrayValuePointer->);1)
		
		CLEAR VARIABLE:C89(($Ptr_arrayValuePointer->{$Lon_i})->)
		
	End for   //}
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If (Asserted:C1132(xml_IsValidReference ($Dom_elementRef)))
	
	  //Populate with requested attributes 
	
	For ($Lon_i;1;DOM Count XML attributes:C727($Dom_elementRef);1)
		
		DOM GET XML ATTRIBUTE BY INDEX:C729($Dom_elementRef;$Lon_i;$Txt_name;$Txt_buffer)
		
		$Lon_x:=Find in array:C230($Ptr_arrayAttributes->;$Txt_name)
		
		If ($Lon_x>0)
			
			DOM GET XML ATTRIBUTE BY NAME:C728($Dom_elementRef;$Txt_name;($Ptr_arrayValuePointer->{$Lon_x})->)
			
			$Lon_found:=$Lon_found+1
			
			If ($Lon_found=Size of array:C274($Ptr_arrayAttributes->))
				
				$Lon_i:=MAXLONG:K35:2-1  //Go out
				
			End if 
		End if 
	End for 
End if 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End