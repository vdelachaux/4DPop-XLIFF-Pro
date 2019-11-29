//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : EDITOR_DELETE
  // Database: 4DPop XLIFF Pro
  // ID[6C9D2732309C44EC957F8FBE81C9FCE5]
  // Created #12-12-2016 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($Lon_column;$Lon_number;$Lon_parameters;$Lon_row;$Lon_x)
C_TEXT:C284($Dom_;$Dom_group;$Dom_root;$Dom_unit)
C_OBJECT:C1216($Obj_language)

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // NO PARAMETERS REQUIRED
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
CONFIRM:C162(Replace string:C233(\
Get localized string:C991(Choose:C955(Form:C1466.$target="unit";"DeleteItem";"DeleteGroup"));\
"{item}";Form:C1466.$current.resname))

If (OK=1)
	
	If (Form:C1466.$target="unit")
		
		  // Update files [
		For each ($Obj_language;Form:C1466.languages)
			
			If ($Obj_language.language=Form:C1466.language)
				
				$Dom_unit:=Form:C1466.transUnit(Form:C1466.$current.$dom)
				
			Else 
				
				If (Bool:C1537(Form:C1466.file.uniqueID))
					
					$Dom_unit:=DOM Find XML element by ID:C1010($Obj_language.file.$dom;Form:C1466.$current.id)
					
				Else 
					
					  // Find the unit with resname & id
					$Dom_unit:=Form:C1466.findTransUnit($Obj_language.file.$dom;Form:C1466.$current.resname;Form:C1466.$current.id)
					
				End if 
			End if 
			
			If (xml_IsValidReference ($Dom_unit))
				
				  // Keep a valid reference
				$Dom_:=DOM Get parent XML element:C923($Dom_unit)
				
				  // Remove the unit
				DOM REMOVE XML ELEMENT:C869($Dom_unit)
				
				  // Save the file
				Form:C1466.save($Dom_;$Obj_language.file.nativePath)
				
			End if 
		End for each 
		  //]
		
		  // Update project [
		If (Form:C1466.$current.group.units.length=1)  // Last one
			
			$Lon_number:=0  // Don't remove line (it's the group !)
			
		Else 
			
			  // Remove the unit
			$Lon_x:=Form:C1466.$current.group.units.indexOf(Form:C1466.$current)
			Form:C1466.$current.group.units.remove($Lon_x;1)
			
			$Lon_number:=1  // One line to remove
			
		End if 
		  //]
		
	Else 
		
		  // Update files [
		For each ($Obj_language;Form:C1466.languages)
			
			  // Get the group reference
			If ($Obj_language.language=Form:C1466.language)
				
				$Dom_group:=Form:C1466.$current.$dom
				
			Else 
				
				$Dom_root:=DOM Get root XML element:C1053($Obj_language.file.$dom)
				$Dom_group:=xlf_Dom_group_from_resname ($Dom_root;Form:C1466.$current.resname)
				
			End if 
			
			If (xml_IsValidReference ($Dom_group))
				
				  // Keep a valid reference
				$Dom_:=DOM Get root XML element:C1053($Dom_group)
				
				  // Remove the group
				DOM REMOVE XML ELEMENT:C869($Dom_group)
				
				  // Save the localized file
				Form:C1466.save($Dom_;$Obj_language.file.nativePath)
				
			End if 
		End for each 
		  //]
		
		  // Update project [
		$Lon_x:=Form:C1466.file.groups.indexOf(Form:C1466.$current)
		$Lon_number:=Form:C1466.file.groups[$Lon_x].units.length  // The number of lines to remove
		
		  // Remove the group
		Form:C1466.file.groups.remove($Lon_x;1)
		  //]
		
	End if 
	
	  // UI [
	$Lon_row:=Find in array:C230((Form:C1466.dynamic(Form:C1466.widgets.strings))->;True:C214)
	
	If ($Lon_row=-1)  // Group
		
		LISTBOX GET CELL POSITION:C971(*;Form:C1466.widgets.strings;$Lon_column;$Lon_row)
		
	End if 
	
	If ($Lon_number>0)
		
		LISTBOX DELETE ROWS:C914(*;Form:C1466.widgets.strings;$Lon_row;$Lon_number)
		
	Else 
		
		  // Empty group [
		If (Form:C1466.$target="unit")
			
			Form:C1466.$current.group.units:=New collection:C1472
			
			(Form:C1466.dynamic("group"))->{$Lon_row}:=Form:C1466.$current.group.resname
			(Form:C1466.dynamic("unit"))->{$Lon_row}:="..."
			(Form:C1466.dynamic("content"))->{$Lon_row}:=Form:C1466.$current.group
			
			  // Collapse & select
			LISTBOX COLLAPSE:C1101(*;Form:C1466.widgets.strings;True:C214;lk break row:K53:18;$Lon_row;1)
			LISTBOX SELECT ROW:C912(*;Form:C1466.widgets.strings;$Lon_row;lk replace selection:K53:1)
			LISTBOX SELECT BREAK:C1117(*;Form:C1466.widgets.strings;$Lon_row;1;lk replace selection:K53:1)
			
		Else 
			
			Form:C1466.$current.units:=New collection:C1472
			
			LISTBOX DELETE ROWS:C914(*;Form:C1466.widgets.strings;$Lon_row;1)
			
		End if 
		  //]
		
	End if 
	
	  // Unselect all
	LISTBOX SELECT ROW:C912(*;Form:C1466.widgets.strings;0;lk remove from selection:K53:3)
	OB REMOVE:C1226(Form:C1466;"$target")
	OB REMOVE:C1226(Form:C1466;"$current")
	
	EDITOR_UI 
	
	  // Check for duplicate resname
	Form:C1466.message(New object:C1471(\
		"target";"duplicateResname"))
	  //]
	
	  // ASSERT(debug_SAVE (Form))
	
End if 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End