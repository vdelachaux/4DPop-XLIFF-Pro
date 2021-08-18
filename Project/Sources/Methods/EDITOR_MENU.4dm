//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : EDITOR_MENU
// Database: 4DPop XLIFF Pro
// ID[62B8270910FF48EE8DAE05AF0D719130]
// Created #15-5-2018 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
C_TEXT:C284($1)

C_LONGINT:C283($Lon_column; $Lon_parameters; $Lon_row; $Lon_version)
C_TEXT:C284($Mnu_bar; $Mnu_main; $Mnu_menu; $Mnu_sub; $Txt_action)

If (False:C215)
	C_TEXT:C284(EDITOR_MENU; $1)
End if 

// ----------------------------------------------------
// Initialisations
If (Count parameters:C259>=1)
	
	$Txt_action:=$1
	
Else 
	
	$Txt_action:=OBJECT Get name:C1087(Object current:K67:2)
	
End if 


// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: ($Txt_action="file.list")  // Contextual
		
		$Mnu_main:=Create menu:C408
		
		LISTBOX GET CELL POSITION:C971(*; $Txt_action; $Lon_column; $Lon_row)
		
		Case of 
				
				//………………………………………………………………………………………
			: ($Lon_row=0)  // On background
				
				APPEND MENU ITEM:C411($Mnu_main; Get localized string:C991("projectSettings"))
				SET MENU ITEM PARAMETER:C1004($Mnu_main; -1; "projectSettings")
				
				APPEND MENU ITEM:C411($Mnu_main; "-")
				
				APPEND MENU ITEM:C411($Mnu_main; Get localized string:C991("import"))
				SET MENU ITEM PARAMETER:C1004($Mnu_main; -1; "import")
				
				//………………………………………………………………………………………
			: ($Lon_column=1)  // Project
				
				APPEND MENU ITEM:C411($Mnu_main; Get localized string:C991("projectSettings"))
				SET MENU ITEM PARAMETER:C1004($Mnu_main; -1; "projectSettings")
				
				APPEND MENU ITEM:C411($Mnu_main; "-")
				
				APPEND MENU ITEM:C411($Mnu_main; Get localized string:C991("import"))
				SET MENU ITEM PARAMETER:C1004($Mnu_main; -1; "import")
				
				//………………………………………………………………………………………
			Else   // File
				
				APPEND MENU ITEM:C411($Mnu_main; Get localized string:C991("projectSettings"))
				SET MENU ITEM PARAMETER:C1004($Mnu_main; -1; "projectSettings")
				
				APPEND MENU ITEM:C411($Mnu_main; "-")
				
				APPEND MENU ITEM:C411($Mnu_main; Get localized string:C991("fileInformations"))
				SET MENU ITEM PARAMETER:C1004($Mnu_main; -1; "fileInfos")
				
				APPEND MENU ITEM:C411($Mnu_main; Get localized string:C991("showOnDisk"))
				SET MENU ITEM PARAMETER:C1004($Mnu_main; -1; "show")
				
				APPEND MENU ITEM:C411($Mnu_main; Get localized string:C991("delete"))
				SET MENU ITEM PARAMETER:C1004($Mnu_main; -1; "delete")
				
				APPEND MENU ITEM:C411($Mnu_main; "-")
				
				APPEND MENU ITEM:C411($Mnu_main; Get localized string:C991("import"))
				SET MENU ITEM PARAMETER:C1004($Mnu_main; -1; "import")
				
				//APPEND MENU ITEM($Mnu_main;"-")
				
				//APPEND MENU ITEM($Mnu_main;"Export…")
				//SET MENU ITEM PARAMETER($Mnu_main;-1;"export")
				
				//………………………………………………………………………………………
		End case 
		
		If (Count menu items:C405($Mnu_main)>0)
			
			EDITOR_ACTIONS(Dynamic pop up menu:C1006($Mnu_main))
			
		End if 
		
		RELEASE MENU:C978($Mnu_main)
		
		
		//______________________________________________________
	: ($Txt_action="install")  // Menu bar definition
		
		var $menuBar; $menu; $sub : cs:C1710.menu
		
		$menuBar:=cs:C1710.menu.new()
		
		// File menu
		$menu:=cs:C1710.menu.new()
		
		$sub:=cs:C1710.menu.new()
		
		If (String:C10(EDITOR.mode)="editor")
			
			$sub.append(":xliff:MenuProject"; "new_project").shortcut("P")
			
		End if 
		
		$sub.append(":xliff:Menuxliff"; "new_file").shortcut("N")
		$sub.append(":xliff:MenuGroup"; "new_group").shortcut("G")
		$sub.append(":xliff:MenuLine"; "new_unit").shortcut("L")
		
		$menu.append(":xliff:MenuNew"; $sub)
		
		APPEND MENU ITEM:C411($Mnu_menu; "-")
		$menu.line()
		
		$menu.append(":xliff:CommonClose"; "close")
		
		If (Is Windows:C1573)
			
			$menu.shortcut(New object:C1471("key"; Shortcut with F4:K75:4; "modifier"; Option key mask:K16:7))
			
		Else 
			
			$menu.shortcut("W")
			
		End if 
		
		$menuBar.append(":xliff:CommonMenuFile"; $menu)
		
		// Edit menu
		$menuBar.append(":xliff:CommonMenuEdit"; cs:C1710.menu.new().edit())
		
		$menuBar.setBar()
		
		//______________________________________________________
	Else 
		
		
		
		//______________________________________________________
End case 