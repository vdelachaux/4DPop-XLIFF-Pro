//%attributes  = {"invisible":true}
  // ----------------------------------------------------
  // Method :  doc_getFromPath
  // Created 20/05/10 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($0)
C_TEXT:C284($1)
C_TEXT:C284($2)
C_TEXT:C284($3)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($kTxt_separator;$Txt_pathName;$Txt_pattern;$Txt_result;$Txt_selector)

ARRAY LONGINT:C221($tLon_lengths;0)
ARRAY LONGINT:C221($tLon_positions;0)

If (False:C215)
	C_TEXT:C284(doc_getFromPath ;$0)
	C_TEXT:C284(doc_getFromPath ;$1)
	C_TEXT:C284(doc_getFromPath ;$2)
	C_TEXT:C284(doc_getFromPath ;$3)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

$kTxt_separator:=Folder separator:K24:12
$kTxt_separator:=$kTxt_separator+($kTxt_separator*Num:C11($kTxt_separator="\\"))

If (Asserted:C1132($Lon_parameters>=2))
	
	$Txt_selector:=$1  //"parent", "fullName", "shortName", "extension"
	$Txt_pathName:=$2
	
	If ($Lon_parameters>=3)
		
		$kTxt_separator:=$3
		
	End if 
	
	If ($kTxt_separator="\\")
		
		  //The antislash must be escaped in a regular expression !
		$kTxt_separator:=$kTxt_separator*2
		
	End if 
	
End if 

Case of 
		
		  //……………………………………………………………………
	: ($Txt_selector="parent")
		
		$Txt_pattern:="(?s)^(.*?"+$kTxt_separator+")[^"+$kTxt_separator+"]+"+$kTxt_separator+"*$"
		
		  //……………………………………………………………………
	: ($Txt_selector="fullName")
		
		$Txt_pattern:="(?s)([^"+$kTxt_separator+"]+?)"+$kTxt_separator+"*$"
		
		  //……………………………………………………………………
	: ($Txt_selector="shortName")
		
		$Txt_pattern:="(?s)(?:[^"+$kTxt_separator+"]*"+$kTxt_separator+")*([^"+$kTxt_separator+"\\.]+)"+$kTxt_separator+"*"
		
		  //……………………………………………………………………
	: ($Txt_selector="extension")
		
		$Txt_pattern:="(?s)[^\\.]+\\.([^\\.]+)$"
		
		  //……………………………………………………………………
	Else 
		
		ASSERT:C1129(False:C215;"TRACE")
		
		  //……………………………………………………………………
End case 

  // ----------------------------------------------------

If (Match regex:C1019($Txt_pattern;$Txt_pathName;1;$tLon_positions;$tLon_lengths))
	
	$Txt_result:=Substring:C12($Txt_pathName;$tLon_positions{1};$tLon_lengths{1})
	
End if 

$0:=$Txt_result