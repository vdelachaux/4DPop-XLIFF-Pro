//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : xlf_To_translate
  // Database: 4DPop XLIFF Pro
  // ID[39B5490A271348C5B056AC1F253B90AD]
  // Created #21-2-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Returns true if the unit is translatable
  // ----------------------------------------------------
  // Declarations
C_BOOLEAN:C305($0)
C_TEXT:C284($1)

C_BOOLEAN:C305($Boo_translatable)
C_LONGINT:C283($Lon_i;$Lon_parameters)
C_TEXT:C284($Dom_ref;$Txt_buffer;$Txt_name;$Txt_value)

If (False:C215)
	C_BOOLEAN:C305(xlf_To_translate ;$0)
	C_TEXT:C284(xlf_To_translate ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  //Required parameters
	$Dom_ref:=$1
	
	  //Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
	ASSERT:C1129(Match regex:C1019("(?mi-s)^(?!^0*$)(?:[0-9A-F]{16}){1,2}$";$Dom_ref;1))
	
	  //default
	$Boo_translatable:=True:C214
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
For ($Lon_i;1;DOM Count XML attributes:C727($Dom_ref);1)
	
	DOM GET XML ATTRIBUTE BY INDEX:C729($Dom_ref;$Lon_i;$Txt_name;$Txt_buffer)
	
	If ($Txt_buffer="translate")
		
		DOM GET XML ATTRIBUTE BY NAME:C728($Dom_ref;"translate";$Txt_value)
		$Boo_translatable:=($Txt_value#"no")
		
		$Lon_i:=MAXLONG:K35:2-1  //Go out
		
	End if 
End for 

  // ----------------------------------------------------
  // Return
$0:=$Boo_translatable

  // ----------------------------------------------------
  // End