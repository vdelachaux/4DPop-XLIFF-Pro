//%attributes  = {"invisible":true}
  // ----------------------------------------------------
  // Project method : convert_camelCase
  // Database: 4DPop XLIFF Pro
  // ID[A917FA7DF0CE4B279EE333F5B52A432D]
  // Created #20-12-2016 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
C_TEXT:C284($0)
C_TEXT:C284($1)

C_LONGINT:C283($Lon_count;$Lon_i;$Lon_parameters)
C_TEXT:C284($Txt_out;$Txt_source)

ARRAY TEXT:C222($tTxt_words;0)

If (False:C215)
	C_TEXT:C284(convert_camelCase ;$0)
	C_TEXT:C284(convert_camelCase ;$1)
End if 

  // ----------------------------------------------------
  // Declarations

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Txt_source:=$1
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
	$Txt_source:=Lowercase:C14(Replace string:C233($Txt_source;"_";" "))
	GET TEXT KEYWORDS:C1141($Txt_source;$tTxt_words)
	$Lon_count:=Size of array:C274($tTxt_words)
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If ($Lon_count>0)
	
	  // First word is in lower case
	$Txt_out:=$tTxt_words{1}
	
	For ($Lon_i;2;$Lon_count;1)
		
		  // Capitalize the first letter of the word
		$tTxt_words{$Lon_i}[[1]]:=Uppercase:C13($tTxt_words{$Lon_i}[[1]])
		$Txt_out:=$Txt_out+$tTxt_words{$Lon_i}
		
	End for 
End if 

  // ----------------------------------------------------
  // Return
$0:=$Txt_out

  // ----------------------------------------------------
  // End 