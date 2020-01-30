//%attributes  = {"invisible":true}
  // ----------------------------------------------------
  // Project method : convert_Unicode_to_UTF16
  // Database: 4DPop XLIFF Pro
  // ID[2F43DE1F4AE24CE1B2AB68063170CD63]
  // Created #12-10-2015 by Vincent de Lachaux
  // From JPR
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($0)
C_TEXT:C284($1)
C_POINTER:C301($2)

C_LONGINT:C283($Lon_parameters)
C_POINTER:C301($Ptr_UTF16)
C_REAL:C285($Num_high;$Num_low;$Num_value;$Num_valueR)
C_TEXT:C284($Txt_char;$Txt_unicode;$Txt_UTF16)

If (False:C215)
	C_TEXT:C284(convert_Unicode_to_UTF16 ;$0)
	C_TEXT:C284(convert_Unicode_to_UTF16 ;$1)
	C_POINTER:C301(convert_Unicode_to_UTF16 ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Txt_unicode:=$1
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		$Ptr_UTF16:=$2
		
	End if 
	
	$Txt_unicode:=Replace string:C233($Txt_unicode;"U+";"")
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
$Num_valueR:=convert_Hex_to_Real ($Txt_unicode)
$Num_value:=$Num_valueR

Case of 
		
		  //________________________________________
	: (($Num_valueR>0) & ($Num_valueR<=55295))  // U+0000 to U+D7FF
		
		$Num_low:=$Num_value
		$Txt_char:=Char:C90($Num_low)
		
		$Txt_UTF16:=String:C10($Num_low;"&x")
		
		  //________________________________________
	: (($Num_valueR>=55296) & ($Num_valueR<=57343))  // U+D800 to U+DFFF
		
		  // No encoding
		
		  //________________________________________
	: (($Num_valueR>=57344) & ($Num_valueR<=65535))  // U+E000 to U+FFFF
		
		$Num_low:=$Num_value
		$Txt_char:=Char:C90($Num_low)
		
		$Txt_UTF16:=String:C10($Num_low;"&x")
		
		  //________________________________________
	: (($Num_valueR>=65536) & ($Num_valueR<=1114111))  // U+10000 to U+10FFFF
		
		$Num_value:=$Num_value-0x00010000  // Because this is the way it works...
		$Num_high:=($Num_value >> 10)+0xD800  // Top 10 bits for for the high char + 0xD800
		$Num_low:=($Num_value & 0x03FF)+0xDC00  // 56320 or 0xDC00 or 1101 1100 0000 0000 for the low char
		$Txt_char:=Char:C90($Num_high)+Char:C90($Num_low)
		
		$Txt_UTF16:=String:C10($Num_high;"&x")+"  "+Substring:C12(String:C10($Num_low;"&x");3)
		
		  //________________________________________
	Else 
		
		  // No encoding
		
		  //________________________________________
End case 

  // ----------------------------------------------------
  // Return
$0:=$Txt_char

If (Not:C34(Is nil pointer:C315($Ptr_UTF16)))
	
	$Ptr_UTF16->:=$Txt_UTF16
	
End if 

  // ----------------------------------------------------
  // End 