  // ----------------------------------------------------
  // Object method : EDITOR.DISPLAY - (4DPop XLIFF Pro)
  // ID[B760DAD3EB48423E904F5CE07DDFA261]
  // Created #30-5-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($Lon_formEvent)
C_POINTER:C301($Ptr_me)
C_TEXT:C284($Txt_me)

  // ----------------------------------------------------
  // Initialisations
$Lon_formEvent:=Form event code:C388
$Txt_me:=OBJECT Get name:C1087(Object current:K67:2)
$Ptr_me:=OBJECT Get pointer:C1124(Object current:K67:2)

  // ----------------------------------------------------
Case of 
		
	: ($Lon_formEvent<0)  //subform call
		
		$Lon_formEvent:=Abs:C99($Lon_formEvent)
		
		Case of 
				  //…………………………………………………………………………………………………
			: ($Lon_formEvent=On Data Change:K2:15)
				
				  // Place a "modification on hold" flag
				Form:C1466.$wait:=True:C214
				
				  //…………………………………………………………………………………………………
			: (False:C215)
				
				
				
				  //…………………………………………………………………………………………………
			Else 
				
				ASSERT:C1129(False:C215;"Unknown call from subform ("+String:C10(-$Lon_formEvent)+")")
				
				  //…………………………………………………………………………………………………
		End case 
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
		
		  //______________________________________________________
End case 