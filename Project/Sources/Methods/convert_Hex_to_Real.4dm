//%attributes  = {"invisible":true}
  // ----------------------------------------------------
  // Project method : convert_Hex_to_Real
  // Database: 4DPop XLIFF Pro
  // ID[DD5947918BA748779CFC5106B24D868A]
  // Created #12-10-2015 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_REAL:C285($0)
C_TEXT:C284($1)

C_BOOLEAN:C305($Boo_OK)
C_LONGINT:C283($Lon_ascii;$Lon_digit;$Lon_i;$Lon_length;$Lon_parameters;$Lon_sign)
C_REAL:C285($Num_real;$Num_result)
C_TEXT:C284($Txt_hex)

If (False:C215)
	C_REAL:C285(convert_Hex_to_Real ;$0)
	C_TEXT:C284(convert_Hex_to_Real ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  //Required parameters
	$Txt_hex:=$1
	
	  //Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
$Lon_length:=Length:C16($Txt_hex)

If ($Lon_length>0)
	
	$Txt_hex:=Uppercase:C13($Txt_hex)
	$Lon_digit:=0
	$Lon_sign:=1
	
	For ($Lon_i;1;$Lon_length;1)
		
		$Lon_ascii:=Character code:C91($Txt_hex[[$Lon_i]])
		$Boo_OK:=True:C214
		
		If (($Lon_ascii>47) & ($Lon_ascii<58))
			
			$Lon_digit:=$Lon_ascii-48
			
		Else 
			
			If (($Lon_ascii>64) & ($Lon_ascii<71))
				
				$Lon_digit:=$Lon_ascii-55
				
			Else 
				
				$Boo_OK:=False:C215
				
			End if 
		End if 
		
		If (($Lon_length=8) & ($Lon_i=1))  //uLong8  -> Have to test the sign bit
			
			If ($Lon_digit>7)
				
				$Lon_sign:=-1
				$Lon_digit:=$Lon_digit-8
				
			End if 
		End if 
		
		If ($Boo_OK)
			
			$Num_real:=($Lon_digit*(16^($Lon_length-$Lon_i)))
			$Num_result:=$Num_result+$Num_real
			
		End if 
	End for 
	
	If ($Lon_sign=-1)
		
		$Num_result:=($Num_result-MAXLONG:K35:2-1)
		
	End if 
End if 

  // ----------------------------------------------------
  // Return
$0:=$Num_result

  // ----------------------------------------------------
  // End 