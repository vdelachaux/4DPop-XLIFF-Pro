  // ----------------------------------------------------
  // Object method : LOCALIZATION.unit.note - (4DPop XLIFF Pro)
  // ID[B66559E232004B68BE005A07BDA979E4]
  // Created #2-1-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($Lon_bottom;$Lon_formEvent;$Lon_left;$Lon_right;$Lon_top)
C_POINTER:C301($Ptr_me)
C_TEXT:C284($Txt_me)

  // ----------------------------------------------------
  // Initialisations
$Lon_formEvent:=Form event code:C388
$Txt_me:=OBJECT Get name:C1087(Object current:K67:2)
$Ptr_me:=OBJECT Get pointer:C1124(Object current:K67:2)

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($Lon_formEvent=On Clicked:K2:4)
		
		If (OBJECT Get visible:C1075(*;"NOTE"))
			
			  // Hide note UI
			OBJECT SET VISIBLE:C603(*;"NOTE";False:C215)
			
		Else 
			
			  // Set the value
			(Form:C1466.dynamic("NOTE"))->:=Form:C1466.$current.note
			
			  // Show note UI
			OBJECT GET COORDINATES:C663(*;"unit.source";$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
			OBJECT SET COORDINATES:C1248(*;"NOTE";$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
			OBJECT SET VISIBLE:C603(*;"NOTE";True:C214)
			GOTO OBJECT:C206(*;"NOTE")
			
		End if 
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
		
		  //______________________________________________________
End case 