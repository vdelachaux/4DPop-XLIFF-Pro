//%attributes  = {"invisible":true}
  // ----------------------------------------------------
  // Project method : convert_titleCase
  // Database: 4DPop XLIFF Pro
  // ID[6384C169C12249C79AECDC55FD00562A]
  // Created #31-7-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
C_TEXT:C284($0)
C_TEXT:C284($1)

C_LONGINT:C283($Lon_i;$Lon_number;$Lon_parameters)
C_TEXT:C284($Txt_out;$Txt_source)

ARRAY TEXT:C222($tTxt_words;0)

If (False:C215)
	C_TEXT:C284(convert_titleCase ;$0)
	C_TEXT:C284(convert_titleCase ;$1)
End if 

  // ----------------------------------------------------
  // Declarations

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  //Required parameters
	$Txt_source:=$1
	
	  //Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
	GET TEXT KEYWORDS:C1141($Txt_source;$tTxt_words)
	$Lon_number:=Size of array:C274($tTxt_words)
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If ($Lon_number>0)
	
	$tTxt_words{1}[[1]]:=Uppercase:C13($tTxt_words{1}[[1]])
	$Txt_out:=$tTxt_words{1}
	
	For ($Lon_i;2;$Lon_number;1)
		
		$tTxt_words{$Lon_i}[[1]]:=Uppercase:C13($tTxt_words{$Lon_i}[[1]])
		$Txt_out:=$Txt_out+" "+$tTxt_words{$Lon_i}
		
	End for 
End if 

  // ----------------------------------------------------
  // Return
$0:=$Txt_out

  // ----------------------------------------------------
  // End 