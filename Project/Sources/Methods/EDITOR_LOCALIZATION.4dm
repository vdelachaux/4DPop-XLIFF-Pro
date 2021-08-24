//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : EDITOR_LOCALIZATION
// Database: 4DPop XLIFF 2
// ID[6EB70A89DD534DBCA26CD988FFBB8847]
// Created #18-5-2018 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
C_LONGINT:C283($Lon_parameters; $Lon_x)
C_TEXT:C284($kTxt_indent; $Mnu_main; $Txt_choice; $Txt_me)
C_OBJECT:C1216($Obj_language; $Obj_languages)

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0; "Missing parameter"))
	
	// NO PARAMETERS REQUIRED
	
	// Optional parameters
	If ($Lon_parameters>=1)
		
		// <NONE>
		
	End if 
	
	$kTxt_indent:=Get localized string:C991("Languages")+"  "
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
$Mnu_main:=Create menu:C408

APPEND MENU ITEM:C411($Mnu_main; "🌍 "+Get localized string:C991("all"))
SET MENU ITEM PARAMETER:C1004($Mnu_main; -1; "all")

If (Length:C16(String:C10(Form:C1466.localization))=0)
	
	SET MENU ITEM MARK:C208($Mnu_main; -1; Char:C90(18))
	
End if 

APPEND MENU ITEM:C411($Mnu_main; "-")

$Obj_languages:=JSON Parse:C1218(File:C1566("/RESOURCES/languages.json").getText())

For each ($Obj_language; Form:C1466.languages)
	
	$Lon_x:=$Obj_languages.lproj.indexOf($Obj_language.language)
	APPEND MENU ITEM:C411($Mnu_main; $Obj_language.regional+" "+$Obj_languages.localized[$Lon_x])
	SET MENU ITEM PARAMETER:C1004($Mnu_main; -1; $Obj_language.language)
	
	If ($Obj_language.language=String:C10(Form:C1466.localization))
		
		SET MENU ITEM MARK:C208($Mnu_main; -1; Char:C90(18))
		
	End if 
End for each 

$Txt_choice:=Dynamic pop up menu:C1006($Mnu_main)
RELEASE MENU:C978($Mnu_main)

If (Length:C16($Txt_choice)#0)
	
	$Txt_me:=OBJECT Get name:C1087(Object current:K67:2)
	
	If ($Txt_choice="all")
		
		OB REMOVE:C1226(Form:C1466; "localization")
		CLEAR VARIABLE:C89($Txt_choice)
		
		OBJECT SET TITLE:C194(*; $Txt_me; $kTxt_indent+"🌐")
		
		$Obj_language:=Form:C1466
		
	Else 
		
		Form:C1466.localization:=$Txt_choice
		
		OBJECT SET TITLE:C194(*; $Txt_me; $kTxt_indent+Form:C1466.languages[Form:C1466.languages.extract("language").indexOf($Txt_choice)].regional)
		
		$Obj_language:=New object:C1471(\
			"language"; Form:C1466.language; \
			"languages"; New collection:C1472(Form:C1466.languages[Form:C1466.languages.extract("language").indexOf($Txt_choice)]))
		
	End if 
	
	EXECUTE METHOD IN SUBFORM:C1085(Form:C1466.widgets.localizations; "DISPLAY_INIT"; *; $Obj_language)
	
	EDITOR_Preferences(New object:C1471(\
		"set"; True:C214; \
		"key"; "localization"; \
		"value"; $Txt_choice))
	
End if 

// ----------------------------------------------------
// Return
// <NONE>
// ----------------------------------------------------
// End 