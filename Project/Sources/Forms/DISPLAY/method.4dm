  // ----------------------------------------------------
  // Form method : LANGUAGES - (4DPop XLIFF Pro)
  // ID[8D74C2132828494080CE487ED27235FF]
  // Created #12-10-2015 by Vincent de Lachaux
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($Lon_formEvent)

  // ----------------------------------------------------
  // Initialisations
$Lon_formEvent:=Form event code:C388

  // ----------------------------------------------------

Case of 
		
		  //______________________________________________________
	: ($Lon_formEvent=On Load:K2:1)
		
		ui_SET_EMOJI_FONT ("unit.flag")
		
		SET TIMER:C645(-1)
		
		  //______________________________________________________
	: ($Lon_formEvent=On Timer:K2:25)
		
		SET TIMER:C645(0)
		
		  //______________________________________________________
	: ($Lon_formEvent=On Activate:K2:9)
		
		If (OBJECT Get name:C1087(Object with focus:K67:3)=Form:C1466.widgets.localizations)\
			 | (OBJECT Get name:C1087(Object with focus:K67:3)="")
			
			GOTO OBJECT:C206(*;"resname.box")
			
		End if 
		
		  //______________________________________________________
	: ($Lon_formEvent=On Bound Variable Change:K2:52)
		
		DISPLAY 
		
		  //______________________________________________________
	: ($Lon_formEvent=On Unload:K2:2)
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
		
		  //______________________________________________________
End case 