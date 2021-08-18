//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : EDITOR_NEW_UNIT
// Database: 4DPop XLIFF Pro
// ID[84F9C8A57CF940FFA0672362CCB4BD0B]
// Created #12-12-2016 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
C_LONGINT:C283($Lon_count; $Lon_number; $Lon_parameters; $Lon_row)
C_TEXT:C284($Dom_group; $Dom_node; $Txt_resname)
C_OBJECT:C1216($Obj_group; $Obj_language; $Obj_unit)

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0; "Missing parameter"))
	
	// NO PARAMETERS REQUIRED
	
	// Optional parameters
	If ($Lon_parameters>=1)
		
		// <NONE>
		
	End if 
	
	$Obj_group:=Choose:C955(Form:C1466.$target="unit"; Form:C1466.$current.group; Form:C1466.$current)
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
// Create the unit [
$Txt_resname:=Get localized string:C991("NewItem")
$Lon_count:=Count in array:C907(Form:C1466.dynamic("unit")->; $Txt_resname+"@")

$Obj_unit:=xlf_New_unit(New object:C1471(\
"group"; $Obj_group.$dom; \
"id"; Delete string:C232(Generate digest:C1147(Generate UUID:C1066; 4D digest:K66:3); 23; 2); \
"resname"; Choose:C955($Lon_count=1; $Txt_resname; $Txt_resname+" "+String:C10($Lon_count+1)); \
"master"; True:C214))
//]

$Obj_unit.group:=$Obj_group

For each ($Obj_language; Form:C1466.languages)
	
	If ($Obj_language.language=Form:C1466.language)  // Reference file
		
		$Dom_node:=$Obj_group.$dom
		
		If ($Obj_group.units=Null:C1517)
			
			$Obj_group.units:=New collection:C1472
			
		End if 
		
		$Obj_group.units.push($Obj_unit)
		//]
		
		Form:C1466.$target:="unit"
		Form:C1466.$current:=$Obj_unit
		
	Else 
		
		$Dom_group:=xlf_Dom_group_from_resname($Obj_language.file.$dom; $Obj_group.resname)
		
		If (xml_IsValidReference($Dom_group))
			
			// Append the new trans-unit
			$Dom_node:=DOM Append XML element:C1082($Dom_group; $Obj_unit.$dom)
			
			// Set as new string
			DOM SET XML ATTRIBUTE:C866(Form:C1466.target($Dom_node); \
				"state"; "new")
			
			// Update the project [
			$Obj_unit[$Obj_language.language]:=New object:C1471(\
				"$dom"; $Dom_node; \
				"value"; ""; \
				"state"; "new")
			//]
			
		End if 
	End if 
	
	// Set & save the file
	Form:C1466.save($Dom_node; $Obj_language.file.platformPath)
	
End for each 

//ASSERT(debug_SAVE (Form))

// Update string list [
$Lon_row:=Find in array:C230(Form:C1466.dynamic(Form:C1466.widgets.strings)->; True:C214)+1
$Lon_number:=$Obj_group.units.length  // Number of units

If ($Lon_row=0)  // Group
	
	// Find the first occurence of the resname
	$Lon_row:=Find in array:C230(Form:C1466.dynamic("group")->; $Obj_group.resname)
	
	If ($Lon_number=1)\
		 & ((Form:C1466.dynamic("unit"))->{$Lon_row}="...")  // New group
		
		// Just expand the hidden line
		LISTBOX EXPAND:C1100(*; Form:C1466.widgets.strings; False:C215; lk selection:K53:17; $Lon_row)
		
	Else 
		
		$Lon_row:=$Lon_row+$Lon_number-1  // For the group
		LISTBOX INSERT ROWS:C913(*; Form:C1466.widgets.strings; $Lon_row; 1)
		LISTBOX EXPAND:C1100(*; Form:C1466.widgets.strings; False:C215; lk selection:K53:17; $Lon_row)
		
	End if 
	
Else 
	
	LISTBOX INSERT ROWS:C913(*; Form:C1466.widgets.strings; $Lon_row; 1)
	LISTBOX EXPAND:C1100(*; Form:C1466.widgets.strings; False:C215; lk break row:K53:18; $Lon_row; $Lon_number)
	
End if 

(Form:C1466.dynamic("group"))->{$Lon_row}:=$Obj_group.resname
(Form:C1466.dynamic("unit"))->{$Lon_row}:=$Obj_unit.resname
(Form:C1466.dynamic("content"))->{$Lon_row}:=$Obj_unit

Form:C1466.refresh(New object:C1471(\
"target"; "row"; \
"action"; "new"; \
"row"; $Lon_row; \
"col"; 2))
//]

OBJECT SET VISIBLE:C603(*; Form:C1466.widgets.localizations; True:C214)

// Give focus to resname
GOTO OBJECT:C206(*; Form:C1466.widgets.localizations)

// Touch the localization subform for the update
(Form:C1466.dynamic(Form:C1466.widgets.localizations))->:=Form:C1466

// Check for duplicate resname
Form:C1466.message(New object:C1471(\
"target"; "duplicateResname"))

// ----------------------------------------------------
// Return
// <NONE>
// ----------------------------------------------------
// End 