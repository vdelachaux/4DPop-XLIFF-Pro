  // ----------------------------------------------------
  // Object method : DISPLAY.unit.notranslate - (4DPop XLIFF Pro)
  // ID[9DEFD1365A3B4ED7ADA438A86179BA5D]
  // Created #14-10-2015 by Vincent de Lachaux
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
	: ($Lon_formEvent=On Clicked:K2:4)
		
		If ($Ptr_me->=1)  // Translate="no"
			
			Form:C1466.$current.noTranslate:=True:C214
			
			OBJECT SET VISIBLE:C603(*;"lang_@";False:C215)
			
		Else 
			
			OB REMOVE:C1226(Form:C1466.$current;"noTranslate")
			
			OBJECT SET VISIBLE:C603(*;"lang_@";True:C214)
			
		End if 
		
		Form:C1466.message(New object:C1471(\
			"target";"translate"))
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
		
		  //______________________________________________________
End case 