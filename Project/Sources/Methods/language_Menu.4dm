//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : language_Menu
  // Database: 4DPop XLIFF Pro
  // ID[9F81003CBFF8478685D4B38DA38F8647]
  // Created #23-2-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Display the managed languages menu
  // and return the user selected language-regional code
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($0)
C_OBJECT:C1216($1)

C_BOOLEAN:C305($Boo_displayIsoLanguageCodes)
C_LONGINT:C283($Lon_index;$Lon_parameters)
C_TEXT:C284($File_iso;$Mnu_pop;$Txt_code;$Txt_flag;$Txt_folder)
C_OBJECT:C1216($Obj_buffer;$Obj_in)
C_COLLECTION:C1488($Col_languages)

If (False:C215)
	C_TEXT:C284(language_Menu ;$0)
	C_OBJECT:C1216(language_Menu ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // NO PARAMETERS REQUIRED
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		$Obj_in:=$1
		
		If ($Obj_in.inactivated#Null:C1517)
			
			$Col_languages:=$Obj_in.inactivated
			
		Else 
			
			$Col_languages:=New collection:C1472
			$Col_languages.push("")
			
		End if 
		
		$Boo_displayIsoLanguageCodes:=Bool:C1537($Obj_in.displayIsoLanguageCodes)
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
$File_iso:=Get 4D folder:C485(Current resources folder:K5:16)+"languages.json"

If (Asserted:C1132(Test path name:C476($File_iso)=Is a document:K24:1))
	
	$Obj_buffer:=JSON Parse:C1218(Document to text:C1236($File_iso))
	
	$Mnu_pop:=Create menu:C408
	
	For each ($Txt_flag;$Obj_buffer.flag)
		
		$Txt_folder:=$Obj_buffer.lproj[$Lon_index]
		
		If ($Boo_displayIsoLanguageCodes)
			
			APPEND MENU ITEM:C411($Mnu_pop;$Txt_flag+" "+$Obj_buffer.localized[$Lon_index]+" ["+$Txt_folder+"]";*)
			
		Else 
			
			APPEND MENU ITEM:C411($Mnu_pop;$Txt_flag+" "+$Obj_buffer.localized[$Lon_index];*)
			
		End if 
		
		SET MENU ITEM PARAMETER:C1004($Mnu_pop;-1;$Txt_folder)
		
		If ($Txt_folder=String:C10($Obj_in.selected))
			
			SET MENU ITEM MARK:C208($Mnu_pop;-1;Char:C90(18))
			
		End if 
		
		If ($Col_languages.indexOf($Txt_folder)#-1)
			
			DISABLE MENU ITEM:C150($Mnu_pop;-1)
			
		End if 
		
		$Lon_index:=$Lon_index+1
		
	End for each 
	
	$Txt_code:=Dynamic pop up menu:C1006($Mnu_pop)
	RELEASE MENU:C978($Mnu_pop)
	
End if 

  // ----------------------------------------------------
  // Return
$0:=$Txt_code

  // ----------------------------------------------------
  // End