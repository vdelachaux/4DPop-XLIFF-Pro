// ----------------------------------------------------
// Form method : EDITOR - (4DPop XLIFF Pro)
// ID[B8C9176257A840ABA0B5C1D9E9114A11]
// Created #12-10-2015 by Vincent de Lachaux
// ----------------------------------------------------
// Declarations
C_LONGINT:C283($Lon_formEvent; $Lon_page)

// ----------------------------------------------------
// Initialisations
$Lon_formEvent:=Form event code:C388

//ASSERT(4D_LOG (Current method name+" ["+String($Lon_formEvent)+"]"))

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: ($Lon_formEvent=On Load:K2:1)
		
		EDITOR_INIT
		
		EDITOR_ON_LOAD
		
		// 'On Page Change' event is not triggered when the form is loaded
		CALL FORM:C1391(Form:C1466.window; "EDITOR_ON_PAGE_CHANGE")
		
		EDITOR_UI
		
		GOTO OBJECT:C206(*; Form:C1466.widgets.files)
		
		SET TIMER:C645(-1)
		
		//______________________________________________________
	: ($Lon_formEvent=On Menu Selected:K2:14)
		
		EDITOR_ACTIONS(Get selected menu item parameter:C1005)
		
		//______________________________________________________
	: ($Lon_formEvent=On Unload:K2:2)
		
		EDITOR_ON_UNLOAD
		
		//______________________________________________________
	: ($Lon_formEvent=On Timer:K2:25)
		
		SET TIMER:C645(0)
		
		OBJECT SET VISIBLE:C603(*; "wrap"; False:C215)
		
		//______________________________________________________
	: ($Lon_formEvent=On Page Change:K2:54)
		
		EDITOR_ON_PAGE_CHANGE
		
		//______________________________________________________
	: ($Lon_formEvent=On Data Change:K2:15)
		
		//debug_SAVE (Form)
		
		//______________________________________________________
	: ($Lon_formEvent=On Resize:K2:27)
		
		obj_CENTER("wrap"; Form:C1466.widgets.strings; Horizontally centered:K39:1)
		obj_CENTER("welcome"; "0.backgound"; Horizontally centered:K39:1)
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
		
		//______________________________________________________
End case 
