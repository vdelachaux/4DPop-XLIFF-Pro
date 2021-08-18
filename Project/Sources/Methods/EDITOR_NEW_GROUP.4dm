//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : EDITOR_NEW_GROUP
// Database: 4DPop XLIFF Pro
// ID[3020985D2120488D9ED93385839AE3D0]
// Created #16-12-2016 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
C_LONGINT:C283($Lon_count; $Lon_parameters; $Lon_row)
C_TEXT:C284($Dom_group; $Dom_node; $Txt_resname)
C_OBJECT:C1216($Obj_language)

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0; "Missing parameter"))
	
	// NO PARAMETERS REQUIRED
	
	// Optional parameters
	If ($Lon_parameters>=1)
		
		// <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
If (Asserted:C1132(xml_IsValidReference(String:C10(Form:C1466.$dom))))
	
	// Create the group [
	$Txt_resname:=Get localized string:C991("NewGroup")
	$Lon_count:=Form:C1466.$groups.length
	$Txt_resname:=Choose:C955($Lon_count=0; $Txt_resname; $Txt_resname+" "+String:C10($Lon_count+1))
	
	$Dom_group:=DOM Create XML element:C865(Form:C1466.$dom; "/xliff/file/body/group"; \
		"resname"; $Txt_resname)
	//]
	
	If (Asserted:C1132(OK=1))
		
		For each ($Obj_language; Form:C1466.languages)
			
			If ($Obj_language.language=Form:C1466.language)  // Reference file
				
				$Dom_node:=$Dom_group
				
			Else 
				
				If (Asserted:C1132(xml_IsValidReference($Obj_language.file.$dom)))
					
					// Get the body part
					$Dom_node:=DOM Find XML element:C864($Obj_language.file.$dom; "/xliff/file/body")
					
					If (Asserted:C1132(OK=1))
						
						// Append the group
						$Dom_node:=DOM Append XML element:C1082($Dom_node; $Dom_group)
						
					End if 
				End if 
			End if 
			
			If (Asserted:C1132(OK=1))
				
				// Set & save the file
				Form:C1466.save($Dom_node; $Obj_language.file.platformPath)
				
			End if 
		End for each 
		
		// Update the project [
		Form:C1466.$current:=New object:C1471(\
			"$dom"; $Dom_group; \
			"resname"; $Txt_resname; \
			"units"; New collection:C1472)
		
		If (Form:C1466.$groups=Null:C1517)
			
			Form:C1466.$groups:=New collection:C1472
			
		End if 
		
		Form:C1466.$groups.push(Form:C1466.$current)
		
		Form:C1466.$target:="group"
		//]
		
		// Update string list [
		$Lon_row:=LISTBOX Get number of rows:C915(*; Form:C1466.widgets.strings)+1
		LISTBOX INSERT ROWS:C913(*; Form:C1466.widgets.strings; $Lon_row)
		
		// Populate [
		(Form:C1466.dynamic("group"))->{$Lon_row}:=$Txt_resname
		(Form:C1466.dynamic("unit"))->{$Lon_row}:="..."
		(Form:C1466.dynamic("content"))->{$Lon_row}:=Form:C1466.$current
		//]
		
		// Collapse & select
		Form:C1466.refresh(New object:C1471(\
			"target"; "break"; \
			"action"; "new"; \
			"row"; $Lon_row))
		
	End if 
End if 

// ----------------------------------------------------
// Return
// <NONE>
// ----------------------------------------------------
// End 