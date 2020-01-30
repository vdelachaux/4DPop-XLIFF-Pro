//%attributes  = {"invisible":true}
  // ----------------------------------------------------
  // Project method : EDITOR_ACTIONS
  // Database: 4DPop XLIFF Pro
  // ID[A67EAB147D5648AC838B1387C2256628]
  // Created #24-5-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($1)

C_LONGINT:C283($Lon_parameters;$Win_hdl)
C_TEXT:C284($Txt_action)
C_OBJECT:C1216($Obj_file)

If (False:C215)
	C_TEXT:C284(EDITOR_ACTIONS ;$1)
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
		
		$Txt_action:=Get selected menu item parameter:C1005
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: (Length:C16($Txt_action)=0)
		
		  // Nothing selected
		  //______________________________________________________
	: ($Txt_action="new_file")
		
		FILE_NEW 
		
		  //______________________________________________________
	: ($Txt_action="new_group")
		
		EDITOR_NEW_GROUP 
		
		  //______________________________________________________
	: ($Txt_action="new_unit")
		
		EDITOR_NEW_UNIT 
		
		  //______________________________________________________
	: ($Txt_action="projectSettings")
		
		FORM GOTO PAGE:C247(2)
		
		  //______________________________________________________
	: ($Txt_action="fileInfos")
		
		$Win_hdl:=Open form window:C675("FILE_INFOS";Sheet form window:K39:12)
		DIALOG:C40("FILE_INFOS";New object:C1471(\
			"nativePath";Form:C1466.file.nativePath))
		
		CLOSE WINDOW:C154
		
		  //______________________________________________________
	: ($Txt_action="show")
		
		SHOW ON DISK:C922(Form:C1466.file.nativePath)
		
		  //______________________________________________________
	: ($Txt_action="delete")
		
		FILE_DELETE 
		
		  //______________________________________________________
	: ($Txt_action="import")  // Import from another project
		
		$Obj_file:=New object:C1471
		$Obj_file.name:=Select document:C905(8858;".xlf";Get localized string:C991("selectTheXliffFileToImport");Package open:K24:8+Use sheet window:K24:11)
		
		If (OK=1)
			
			EDITOR_CLEANUP 
			
			FILE_IMPORT (DOCUMENT)
			
		End if 
		
		  //______________________________________________________
	: ($Txt_action="export")
		
		  //#TO_BE_DONE
		
		  //______________________________________________________
	: ($Txt_action="close")
		
		CANCEL:C270
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Unknown menu action ("+$Txt_action+")")
		
		  //______________________________________________________
End case 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End 