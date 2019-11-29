  // ----------------------------------------------------
  // Object method : EDITOR.welcome - (4DPop XLIFF Pro)
  // ID[ACC4634EBF924C1C9532BC24DB71C6F4]
  // Created #17-5-2018 by Vincent de Lachaux
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

  //ASSERT(4D_LOG ($Txt_me+" ["+String($Lon_formEvent)+"]"))

  // ----------------------------------------------------
Case of 
		
		  //________________________________________
	: ($Lon_formEvent<0)  // Subform call
		
		$Lon_formEvent:=Abs:C99($Lon_formEvent)
		
		Case of 
				
				  //…………………………………………………………………………………………………
			: ($Lon_formEvent=On Validate:K2:3)
				
				EXECUTE METHOD IN SUBFORM:C1085(Form:C1466.widgets.localizations;"DISPLAY_INIT";*;Form:C1466)
				
				  //…………………………………………………………………………………………………
			: ($Lon_formEvent=On Close Box:K2:21)
				
				  // NOTHING MORE TO DO
				
				  //…………………………………………………………………………………………………
			Else 
				
				ASSERT:C1129(False:C215;"Unknown call from subform ("+String:C10(-$Lon_formEvent)+")")
				
				  //…………………………………………………………………………………………………
		End case 
		
		FORM GOTO PAGE:C247(1;*)
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
		
		  //______________________________________________________
End case 