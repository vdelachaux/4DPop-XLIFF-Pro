//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : language_Menu
// Database: 4DPop XLIFF Pro
// ID[9F81003CBFF8478685D4B38DA38F8647]
// Created #23-2-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// Display the managed languages menu
// And return the user selected language-regional code
// ----------------------------------------------------
// Declarations
#DECLARE($in : Object) : Text

If (False:C215)
	C_OBJECT:C1216(language_Menu; $1)
	C_TEXT:C284(language_Menu; $0)
End if 

var $flag; $languageCode; $menu : Text
var $displayIsoLanguageCodes : Boolean
var $index : Integer
var $o : Object
var $languages : Collection
var $file : 4D:C1709.File
var $folder; $resources : 4D:C1709.Folder

$languages:=$in.inactivated ? $in.inactivated : New collection:C1472("")
$displayIsoLanguageCodes:=Bool:C1537($in.displayIsoLanguageCodes)

$file:=Folder:C1567(fk resources folder:K87:11).file("languages.json")

If ($file.exists)
	
	$o:=JSON Parse:C1218($file.getText())
	
	$resources:=Folder:C1567(fk resources folder:K87:11; *)
	
	$menu:=Create menu:C408
	
	For each ($flag; $o.flag)
		
		$folder:=$resources.folder($o.lproj[$index]+".lproj")
		
		If ($displayIsoLanguageCodes)
			
			APPEND MENU ITEM:C411($menu; $flag+" "+$o.localized[$index]+" ["+$folder.name+"]"; *)
			
		Else 
			
			APPEND MENU ITEM:C411($menu; $flag+" "+$o.localized[$index]; *)
			
		End if 
		
		SET MENU ITEM PARAMETER:C1004($menu; -1; $folder.name)
		
		If ($folder.name=String:C10($in.selected))
			
			SET MENU ITEM MARK:C208($menu; -1; Char:C90(18))
			
		End if 
		
		If ($languages.indexOf($folder.name)#-1)
			
			DISABLE MENU ITEM:C150($menu; -1)
			
		End if 
		
		$index+=1
		
	End for each 
	
	$languageCode:=Dynamic pop up menu:C1006($menu)
	RELEASE MENU:C978($menu)
	
	return $languageCode
	
End if 