//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : xlf_SET_VALUE
  // Database: 4DPop XLIFF Pro
  // ID[824E6A19B621496E8E769A097BB8D19A]u
  // Created #27-10-2015 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($1)
C_TEXT:C284($2)
C_POINTER:C301($3)
C_TEXT:C284($4)

C_LONGINT:C283($Lon_parameters)
C_POINTER:C301($Ptr_value)
C_TEXT:C284($Dom_ref;$File_path;$Txt_key)

If (False:C215)
	C_TEXT:C284(xlf_SET_ATTRIBUTE ;$1)
	C_TEXT:C284(xlf_SET_ATTRIBUTE ;$2)
	C_POINTER:C301(xlf_SET_ATTRIBUTE ;$3)
	C_TEXT:C284(xlf_SET_ATTRIBUTE ;$4)
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
		
		$Ptr_value:=$3
		
		If ($Lon_parameters>=4)
			
			$File_path:=$4
			
		End if 
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If (Asserted:C1132(xml_IsValidReference ($Dom_ref)))
	
	If (Not:C34(Is nil pointer:C315($Ptr_value)))
		
		If (Length:C16($Ptr_value->)>0)
			
			DOM SET XML ATTRIBUTE:C866($Dom_ref;\
				$Txt_key;$Ptr_value->)
			
		Else 
			
			xml_REMOVE_ATTRIBUTE ($Dom_ref;$Txt_key)
			
		End if 
		
	Else 
		
		xml_REMOVE_ATTRIBUTE ($Dom_ref;$Txt_key)
		
	End if 
	
	ASSERT:C1129(OK=1)
	
	If ($Lon_parameters>=4)
		
		  //save
		xlf_SAVE ($Dom_ref;$File_path)
		
	End if 
End if 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End