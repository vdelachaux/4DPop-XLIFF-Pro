//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : ui_SET_EMOJI_FONT
  // Database: 4DPop XLIFF Pro
  // ID[A7B234E798C04DD1A6EE8752F75DA9D8]
  // Created #14-10-2015 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($1)
C_TEXT:C284(${2})

C_LONGINT:C283($Lon_i;$Lon_parameters;$Lon_platform;$Lon_x)
C_TEXT:C284($Txt_object)

ARRAY TEXT:C222($tTxt_buffer;0)

If (False:C215)
	C_TEXT:C284(ui_SET_EMOJI_FONT ;$1)
	C_TEXT:C284(ui_SET_EMOJI_FONT ;${2})
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  //Required parameters
	$Txt_object:=$1
	
	  //Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
_O_PLATFORM PROPERTIES:C365($Lon_platform)

If ($Lon_platform=Windows:K25:3)
	
	FONT LIST:C460($tTxt_buffer)
	
	ARRAY TEXT:C222($tTxt_search;3)
	$tTxt_search{1}:="Segoe UI Symbol"
	$tTxt_search{2}:="Yu Mincho"
	$tTxt_search{3}:="Yu Gothic"
	
	For ($Lon_i;1;3;1)
		
		$Lon_x:=Find in array:C230($tTxt_buffer;$tTxt_search{$Lon_i})
		
		If ($Lon_x>0)
			
			For ($Lon_i;1;$Lon_parameters;1)
				
				$Txt_object:=${$Lon_i}
				OBJECT SET FONT:C164(*;$Txt_object;$tTxt_search{$Lon_i})
				
			End for 
			
			$Lon_i:=MAXLONG:K35:2-1  //Go out
			
		End if 
	End for 
End if 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End