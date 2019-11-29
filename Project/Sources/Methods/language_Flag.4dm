//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : language_Flag
  // Database: 4DPop XLIFF Pro
  // ID[400CE9D5A1FE46D5AD92A12550A27277]
  // Created #12-10-2015 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Return the UTF-16 character flag for the language code
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($0)
C_TEXT:C284($1)

C_LONGINT:C283($Lon_first;$Lon_i;$Lon_last;$Lon_parameters;$Lon_x)
C_TEXT:C284($Txt_code;$Txt_flag)
C_OBJECT:C1216($Obj_standard)

ARRAY TEXT:C222($tTxt_buffer;0)

If (False:C215)
	C_TEXT:C284(language_Flag ;$0)
	C_TEXT:C284(language_Flag ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Txt_code:=$1  // Language code
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
	If (Length:C16($Txt_code)=0)
		
		$Txt_code:="en"
		
	End if 
	
	$Obj_standard:=JSON Parse:C1218(Document to text:C1236(Get 4D folder:C485(Current resources folder:K5:16)+"languages.json"))
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: (Match regex:C1019("(?mi-s)^[a-zA-Z]{2}-[a-zA-Z]{2,}$";$Txt_code;1))
		
		  // Language-Regional Codes
		OB GET ARRAY:C1229($Obj_standard;"lproj";$tTxt_buffer)
		
		  //______________________________________________________
	: (Match regex:C1019("(?mi-s)^[a-zA-Z]{2}$";$Txt_code;1))
		
		  // ISO639-1
		OB GET ARRAY:C1229($Obj_standard;"ISO639-1";$tTxt_buffer)
		
		  //______________________________________________________
	Else 
		
		  // Legacy
		OB GET ARRAY:C1229($Obj_standard;"legacy";$tTxt_buffer)
		
		  //______________________________________________________
End case 

$Lon_x:=Find in array:C230($tTxt_buffer;$Txt_code)

If ($Lon_x>0)
	
	OB GET ARRAY:C1229($Obj_standard;"flag";$tTxt_buffer)
	$Txt_flag:=$tTxt_buffer{$Lon_x}
	
Else 
	
	If (Length:C16($Txt_code)>4)
		
		$Txt_code:=Substring:C12($Txt_code;4)
		
		ARRAY TEXT:C222($tTxt_char;26)
		ARRAY TEXT:C222($tTxt_unicode;26)
		
		For ($Lon_i;1;26;1)
			
			$tTxt_char{$Lon_i}:=Char:C90(64+$Lon_i)
			$tTxt_unicode{$Lon_i}:=String:C10(127461+$Lon_i;"&x")
			
		End for 
		
		$Lon_first:=Find in array:C230($tTxt_char;$Txt_code[[1]])
		$Lon_last:=Find in array:C230($tTxt_char;$Txt_code[[2]])
		
		$Txt_flag:=convert_Unicode_to_UTF16 ($tTxt_unicode{$Lon_first})+convert_Unicode_to_UTF16 ($tTxt_unicode{$Lon_last})
		
	End if 
End if 

  // ----------------------------------------------------
  // Return
$0:=$Txt_flag  // UTF-16 flag

  // ----------------------------------------------------
  // End