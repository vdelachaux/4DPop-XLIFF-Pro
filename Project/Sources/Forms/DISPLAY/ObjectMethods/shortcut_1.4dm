  // ----------------------------------------------------
  // Object method : LOCALIZATION.shortcut_1 - (4DPop XLIFF Pro)
  // ID[8DD937D0F99C4EC2AF65BBDD9B9C6C88]
  // Created #2-1-2017 by Vincent de Lachaux
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
		
		  //______________________________________________________
	: ($Lon_formEvent=On Load:K2:1)
		
		  // Hide me
		obj_OFF_SCREEN 
		
		  //______________________________________________________
	: ($Lon_formEvent=On Clicked:K2:4)
		
		Form:C1466.message(New object:C1471(\
			"target";"propagate_reference";\
			"value";(OBJECT Get pointer:C1124(Object named:K67:5;"unit.source"))->))
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
		
		  //______________________________________________________
End case 