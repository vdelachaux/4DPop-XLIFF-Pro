//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : obj_OFF_SCREEN
  // Database: 4DPop XLIFF Pro
  // ID[058507B4A2DF4AE2AF0DAFB8237E0CBC]
  // Created #2-1-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($1)
C_TEXT:C284(${2})

C_LONGINT:C283($Lon_i;$Lon_parameters)
C_TEXT:C284($Txt_object)

If (False:C215)
	C_TEXT:C284(obj_OFF_SCREEN ;$1)
	C_TEXT:C284(obj_OFF_SCREEN ;${2})
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  //NO PARAMETERS REQUIRED
	
	  //Optional parameters
	If ($Lon_parameters>=1)
		
		$Txt_object:=$1  //object name (current object if omitted)
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If (Length:C16($Txt_object)=0)
	
	$Txt_object:=OBJECT Get name:C1087(Object current:K67:2)
	
	OBJECT SET COORDINATES:C1248(*;$Txt_object;-100;-100;-100;-100)
	
Else 
	
	For ($Lon_i;1;$Lon_parameters;1)
		
		OBJECT SET COORDINATES:C1248(*;${$Lon_i};-100;-100;-100;-100)
		
	End for 
End if 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End 