  // ----------------------------------------------------
  // Object method : DISPLAY.unit.source - (4DPop XLIFF Pro)
  // ID[5E384C037A0E44EFBEF42B690E6EF520]
  // Created #2-11-2015 by Vincent de Lachaux
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
	: ($Lon_formEvent=On Getting Focus:K2:7)
		
		HIGHLIGHT TEXT:C210(*;$Txt_me;1;MAXLONG:K35:2)
		
		SPELL SET CURRENT DICTIONARY:C904(Form:C1466.languages[0].language)
		
		  //______________________________________________________
	: ($Lon_formEvent=On Data Change:K2:15)
		
		  // Update XLIFF files
		Form:C1466.message(New object:C1471(\
			"target";"source";\
			"oldValue";String:C10(Form:C1466.$current.source.value)))
		
		  // Update project
		Form:C1466.$current.source.value:=$Ptr_me->
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
		
		  //______________________________________________________
End case 