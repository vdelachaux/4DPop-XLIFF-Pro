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

C_LONGINT:C283($Lon_column;$Lon_parameters;$Lon_row;$Lon_version)
C_TEXT:C284($Mnu_bar;$Mnu_main;$Mnu_menu;$Mnu_sub;$Txt_action)

If (False:C215)
	C_TEXT:C284(EDITOR_MENU ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // NO PARAMETERS REQUIRED
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		$Txt_action:=$1
		
	Else 
		
		$Txt_action:=OBJECT Get name:C1087(Object current:K67:2)
		
	End if 
	
	$Mnu_main:=Create menu:C408
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($Txt_action="file.list")  // Contextual
		
		LISTBOX GET CELL POSITION:C971(*;$Txt_action;$Lon_column;$Lon_row)
		
		Case of 
				
				  //………………………………………………………………………………………
			: ($Lon_row=0)  // On background
				
				APPEND MENU ITEM:C411($Mnu_main;Get localized string:C991("projectSettings"))
				SET MENU ITEM PARAMETER:C1004($Mnu_main;-1;"projectSettings")
				
				APPEND MENU ITEM:C411($Mnu_main;"-")
				
				APPEND MENU ITEM:C411($Mnu_main;Get localized string:C991("import"))
				SET MENU ITEM PARAMETER:C1004($Mnu_main;-1;"import")
				
				  //………………………………………………………………………………………
			: ($Lon_column=1)  // Project
				
				APPEND MENU ITEM:C411($Mnu_main;Get localized string:C991("projectSettings"))
				SET MENU ITEM PARAMETER:C1004($Mnu_main;-1;"projectSettings")
				
				APPEND MENU ITEM:C411($Mnu_main;"-")
				
				APPEND MENU ITEM:C411($Mnu_main;Get localized string:C991("import"))
				SET MENU ITEM PARAMETER:C1004($Mnu_main;-1;"import")
				
				  //………………………………………………………………………………………
			Else   // File
				
				APPEND MENU ITEM:C411($Mnu_main;Get localized string:C991("projectSettings"))
				SET MENU ITEM PARAMETER:C1004($Mnu_main;-1;"projectSettings")
				
				APPEND MENU ITEM:C411($Mnu_main;"-")
				
				APPEND MENU ITEM:C411($Mnu_main;Get localized string:C991("fileInformations"))
				SET MENU ITEM PARAMETER:C1004($Mnu_main;-1;"fileInfos")
				
				APPEND MENU ITEM:C411($Mnu_main;Get localized string:C991("showOnDisk"))
				SET MENU ITEM PARAMETER:C1004($Mnu_main;-1;"show")
				
				APPEND MENU ITEM:C411($Mnu_main;Get localized string:C991("delete"))
				SET MENU ITEM PARAMETER:C1004($Mnu_main;-1;"delete")
				
				APPEND MENU ITEM:C411($Mnu_main;"-")
				
				APPEND MENU ITEM:C411($Mnu_main;Get localized string:C991("import"))
				SET MENU ITEM PARAMETER:C1004($Mnu_main;-1;"import")
				
				  //APPEND MENU ITEM($Mnu_main;"-")
				
				  //APPEND MENU ITEM($Mnu_main;"Export…")
				  //SET MENU ITEM PARAMETER($Mnu_main;-1;"export")
				
				  //………………………………………………………………………………………
		End case 
		
		  //______________________________________________________
	: ($Txt_action="install")  // Menu bar definition
		
		$Mnu_bar:=Create menu:C408
		
		  // File menu
		$Mnu_menu:=Create menu:C408
		
		$Mnu_sub:=Create menu:C408
		
		If (Storage:C1525.editor.mode="editor")
			
			APPEND MENU ITEM:C411($Mnu_sub;":xliff:MenuProject")
			SET MENU ITEM PARAMETER:C1004($Mnu_sub;-1;"new_project")
			SET MENU ITEM SHORTCUT:C423($Mnu_sub;-1;"P";Command key mask:K16:1)
			
		End if 
		
		APPEND MENU ITEM:C411($Mnu_sub;":xliff:Menuxliff")
		SET MENU ITEM PARAMETER:C1004($Mnu_sub;-1;"new_file")
		SET MENU ITEM SHORTCUT:C423($Mnu_sub;-1;"N";Command key mask:K16:1)
		
		APPEND MENU ITEM:C411($Mnu_sub;":xliff:MenuGroup")
		SET MENU ITEM PARAMETER:C1004($Mnu_sub;-1;"new_group")
		SET MENU ITEM SHORTCUT:C423($Mnu_sub;-1;"R";Command key mask:K16:1)
		
		APPEND MENU ITEM:C411($Mnu_sub;":xliff:MenuLine")
		SET MENU ITEM PARAMETER:C1004($Mnu_sub;-1;"new_unit")
		SET MENU ITEM SHORTCUT:C423($Mnu_sub;-1;"L";Command key mask:K16:1)
		
		APPEND MENU ITEM:C411($Mnu_menu;":xliff:MenuNew";$Mnu_sub)
		RELEASE MENU:C978($Mnu_sub)
		
		APPEND MENU ITEM:C411($Mnu_menu;"-")
		
		APPEND MENU ITEM:C411($Mnu_menu;":xliff:CommonClose")
		SET MENU ITEM PARAMETER:C1004($Mnu_menu;-1;"close")
		
		If (Is Windows:C1573)
			
			SET MENU ITEM SHORTCUT:C423($Mnu_menu;-1;Shortcut with F4:K75:4;Option key mask:K16:7)
			
		Else 
			
			SET MENU ITEM SHORTCUT:C423($Mnu_menu;-1;"W";Command key mask:K16:1)
			
		End if 
		
		APPEND MENU ITEM:C411($Mnu_bar;":xliff:CommonMenuFile";$Mnu_menu)
		RELEASE MENU:C978($Mnu_menu)
		
		  // Edit menu
		$Mnu_menu:=Create menu:C408
		
		$Lon_version:=Num:C11(Application version:C493)
		
		APPEND MENU ITEM:C411($Mnu_menu;":xliff:CommonMenuItemUndo")
		SET MENU ITEM PROPERTY:C973($Mnu_menu;-1;Associated standard action:K28:8;ak undo:K76:51)
		SET MENU ITEM SHORTCUT:C423($Mnu_menu;-1;"Z";Command key mask:K16:1)
		
		APPEND MENU ITEM:C411($Mnu_menu;":xliff:CommonMenuRedo")
		SET MENU ITEM PROPERTY:C973($Mnu_menu;-1;Associated standard action:K28:8;ak redo:K76:52)
		SET MENU ITEM SHORTCUT:C423($Mnu_menu;-1;"Z";Shift key mask:K16:3)
		
		APPEND MENU ITEM:C411($Mnu_menu;"-")
		
		APPEND MENU ITEM:C411($Mnu_menu;":xliff:CommonMenuItemCut")
		SET MENU ITEM PROPERTY:C973($Mnu_menu;-1;Associated standard action:K28:8;ak cut:K76:53)
		SET MENU ITEM SHORTCUT:C423($Mnu_menu;-1;"X";Command key mask:K16:1)
		
		APPEND MENU ITEM:C411($Mnu_menu;":xliff:CommonMenuItemCopy")
		SET MENU ITEM PROPERTY:C973($Mnu_menu;-1;Associated standard action:K28:8;ak copy:K76:54)
		SET MENU ITEM SHORTCUT:C423($Mnu_menu;-1;"C";Command key mask:K16:1)
		
		APPEND MENU ITEM:C411($Mnu_menu;":xliff:CommonMenuItemPaste")
		SET MENU ITEM PROPERTY:C973($Mnu_menu;-1;Associated standard action:K28:8;ak paste:K76:55)
		SET MENU ITEM SHORTCUT:C423($Mnu_menu;-1;"V";Command key mask:K16:1)
		
		APPEND MENU ITEM:C411($Mnu_menu;":xliff:CommonMenuItemClear")
		SET MENU ITEM PROPERTY:C973($Mnu_menu;-1;Associated standard action:K28:8;ak clear:K76:56)
		
		APPEND MENU ITEM:C411($Mnu_menu;":xliff:CommonMenuItemSelectAll")
		SET MENU ITEM PROPERTY:C973($Mnu_menu;-1;Associated standard action:K28:8;ak select all:K76:57)
		SET MENU ITEM SHORTCUT:C423($Mnu_menu;-1;"A";Command key mask:K16:1)
		
		APPEND MENU ITEM:C411($Mnu_menu;"(-")
		
		APPEND MENU ITEM:C411($Mnu_menu;":xliff:CommonMenuItemShowClipboard")
		SET MENU ITEM PROPERTY:C973($Mnu_menu;-1;Associated standard action:K28:8;ak show clipboard:K76:58)
		
		APPEND MENU ITEM:C411($Mnu_bar;":xliff:CommonMenuEdit";$Mnu_menu)
		RELEASE MENU:C978($Mnu_menu)
		
		SET MENU BAR:C67($Mnu_bar)
		RELEASE MENU:C978($Mnu_bar)
		
		  //______________________________________________________
	Else 
		
		  //______________________________________________________
End case 

If (Count menu items:C405($Mnu_main)>0)
	
	EDITOR_ACTIONS (Dynamic pop up menu:C1006($Mnu_main))
	
End if 

RELEASE MENU:C978($Mnu_main)

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End 