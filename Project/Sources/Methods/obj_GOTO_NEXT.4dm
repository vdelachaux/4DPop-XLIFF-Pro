//%attributes  = {"invisible":true}
  // ----------------------------------------------------
  // Project method : obj_GOTO_NEXT
  // Database: 4DPop XLIFF Pro
  // ID[CA076C2A88764C0E9BF0A197E2D0C86B]
  // Created #7-3-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($1)

C_LONGINT:C283($Lon_current;$Lon_objectNumber;$Lon_parameters;$Lon_x)
C_TEXT:C284($Txt_current;$Txt_me)

ARRAY TEXT:C222($tTxt_entryOrder;0)

If (False:C215)
	C_TEXT:C284(obj_GOTO_NEXT ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  //NO PARAMETERS REQUIRED
	
	  //Optional parameters
	If ($Lon_parameters>=1)
		
		$Txt_current:=$1
		
	Else 
		
		$Txt_current:=OBJECT Get name:C1087(Object current:K67:2)
		
	End if 
	
	FORM GET ENTRY ORDER:C1469($tTxt_entryOrder;FORM Get current page:C276)
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
$Lon_objectNumber:=Size of array:C274($tTxt_entryOrder)

If ($Lon_objectNumber>0)
	
	$Lon_x:=Find in array:C230($tTxt_entryOrder;$Txt_current)
	
	If ($Lon_x>0)
		
		$Lon_current:=$Lon_x
		
		Repeat 
			
			$Lon_x:=$Lon_x+1
			
			If ($Lon_x>$Lon_objectNumber)
				
				$Lon_x:=1
				
			End if 
			
			If (OBJECT Get visible:C1075(*;$tTxt_entryOrder{$Lon_x}))
				
				GOTO OBJECT:C206(*;$tTxt_entryOrder{$Lon_x})
				$Lon_x:=-1
				
			End if 
		Until ($Lon_x=-1)\
			 | ($Lon_x=$Lon_current)
	End if 
End if 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End 