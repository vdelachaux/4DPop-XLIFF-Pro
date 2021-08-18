//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : EDITOR_CALL
// Database: 4DPop XLIFF Pro
// ID[EA718A7A2DE34A84BCF21EEF92319AEE]
// Created #12-12-2016 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
C_OBJECT:C1216($1)

C_BOOLEAN:C305($Boo_translate)
C_LONGINT:C283($Lon_column; $Lon_fileIndex; $Lon_groupIndex; $Lon_parameters; $Lon_row; $Lon_x)
C_POINTER:C301($Ptr_target)
C_TEXT:C284($Dom_note; $Dom_source; $Dom_target; $Dom_unit; $File_xlf; $Txt_source)
C_TEXT:C284($Txt_state; $Txt_target; $Txt_value)
C_OBJECT:C1216($Obj_current; $Obj_in; $Obj_language)

If (False:C215)
	C_OBJECT:C1216(EDITOR_CALL; $1)
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1; "Missing parameter"))
	
	// Required parameters
	$Obj_in:=$1
	
	// Optional parameters
	If ($Lon_parameters>=2)
		
		// <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: ($Obj_in.target="postClick")
		
		POST CLICK:C466($Obj_in.x; $Obj_in.y)
		
		//______________________________________________________
	: ($Obj_in.target="localization")
		
		$Dom_target:=Form:C1466.$current[$Obj_in.language].$dom
		
		$File_xlf:=Form:C1466.languages[Form:C1466.languages.extract("language").indexOf($Obj_in.language)].file.platformPath
		
		If (Length:C16($Obj_in.value)>0)
			
			// Update project
			Form:C1466.$current[$Obj_in.language].value:=$Obj_in.value
			OB REMOVE:C1226(Form:C1466.$current[$Obj_in.language]; "state")
			
			Form:C1466.setAttribute($Dom_target; "state")  // Remove, if any, "needs-translation"
			Form:C1466.setValue($Dom_target; $Obj_in.value; $File_xlf)
			
		Else 
			
			// Update project
			Form:C1466.$current[$Obj_in.language].value:=Form:C1466.$current.source.value
			Form:C1466.$current[$Obj_in.language].state:="new"
			
			DOM SET XML ATTRIBUTE:C866($Dom_target; \
				"state"; Form:C1466.$current[$Obj_in.language].state)
			
			Form:C1466.setValue($Dom_target; Form:C1466.$current.source.value; $File_xlf)
			
		End if 
		
		// UI
		Form:C1466.touch("DISPLAY")
		
		Form:C1466.file.modified:=True:C214
		
		// Remove the "modification on hold" flag
		OB REMOVE:C1226(Form:C1466; "$wait")
		
		//______________________________________________________
	: ($Obj_in.target="source")
		
		$Boo_translate:=Not:C34(Bool:C1537(Form:C1466.$current.noTranslate))
		
		// Updating for all languages
		For each ($Obj_language; Form:C1466.languages)
			
			If ($Obj_language.language=Form:C1466.language)
				
				Form:C1466.setValue(Form:C1466.$current.source.$dom; Form:C1466.$current.source.value)
				
				// For the reference file, assign the source value to the target
				If ($Boo_translate)
					
					Form:C1466.setValue(Form:C1466.target(Form:C1466.$current.source.$dom); Form:C1466.$current.source.value)
					
				End if 
				
				$Dom_source:=Form:C1466.$current.source.$dom
				
			Else 
				
				If ($Boo_translate)
					
					DOM GET XML ELEMENT VALUE:C731(Form:C1466.$current[$Obj_language.language].$dom; $Txt_target)
					xml_GET_ATTRIBUTE(Form:C1466.$current[$Obj_language.language].$dom; "state"; ->$Txt_state)
					
					If (Length:C16($Txt_target)=0)\
						 | ($Txt_state="needs-translation")\
						 | ($Txt_state="new")
						
						$Txt_state:=Choose:C955(Length:C16($Txt_state)=0; "needs-translation"; $Txt_state)
						
						Form:C1466.setAttribute(Form:C1466.$current[$Obj_language.language].$dom; "state"; ->$Txt_state)
						Form:C1466.setValue(Form:C1466.$current[$Obj_language.language].$dom; Form:C1466.$current.source.value)
						
						// Update project
						Form:C1466.$current[$Obj_language.language].value:=Form:C1466.$current.source.value
						
					Else 
						
						// Mark as modified
						$Txt_state:="needs-review-translation"
						Form:C1466.setAttribute(Form:C1466.$current[$Obj_language.language].$dom; "state"; ->$Txt_state)
						
					End if 
					
					Form:C1466.$current[$Obj_language.language].state:=$Txt_state
					
					$Dom_source:=Form:C1466.source(Form:C1466.$current[$Obj_language.language].$dom)
					
				Else 
					
					// Find the <target>
					$Dom_source:=Form:C1466.findTarget($Obj_language.file.$dom; Form:C1466.$current.resname; Form:C1466.$current.id)
					
				End if 
			End if 
			
			// Set & save the file
			Form:C1466.setValue($Dom_source; Form:C1466.$current.source.value; $Obj_language.file.platformPath)
			
		End for each 
		
		// For the "themes" group of a constantes file
		// We must update the strings list {
		If (Form:C1466.isConstant())
			
			$Lon_fileIndex:=Form:C1466.files.extract("name").indexOf(Form:C1466.$currentFile)
			$Lon_groupIndex:=Form:C1466.files[$Lon_fileIndex].groups.extract("$dom").indexOf(Form:C1466.$current.group.$dom)
			
			If ($Lon_groupIndex=0)  // First group
				
				$Ptr_target:=Form:C1466.dynamic("group")
				
				Repeat 
					
					$Lon_x:=Find in array:C230($Ptr_target->; $Obj_in.oldValue; $Lon_x+1)
					
					If ($Lon_x>0)
						
						$Ptr_target->{$Lon_x}:=Form:C1466.$current.source.value
						
					End if 
				Until ($Lon_x=-1)
			End if 
		End if 
		
		// UI
		Form:C1466.touch("DISPLAY")
		
		Form:C1466.file.modified:=True:C214
		
		//______________________________________________________
	: ($Obj_in.target="translate")
		
		$Boo_translate:=Not:C34(Bool:C1537(Form:C1466.$current.noTranslate))
		$Txt_value:=Choose:C955($Boo_translate; ""; "no")
		
		// Update project
		Form:C1466.$current.noTranslate:=Not:C34($Boo_translate)
		
		For each ($Obj_language; Form:C1466.languages)
			
			If ($Obj_language.language=Form:C1466.language)  // Reference file
				
				If ($Boo_translate)
					
					// Create the <target> if any
					$Dom_target:=xml_Create_if_not_exist(Form:C1466.$current.$dom; "target")
					
					If (Asserted:C1132(OK=1))
						
						// Copy the source value into the target
						DOM GET XML ELEMENT VALUE:C731(Form:C1466.source(Form:C1466.$current.$dom); $Txt_source)
						DOM SET XML ELEMENT VALUE:C868($Dom_target; $Txt_source)
						
					End if 
					
				Else 
					
					// Remove the <target>
					DOM REMOVE XML ELEMENT:C869(Form:C1466.target(Form:C1466.$current.$dom))
					
				End if 
				
				$Dom_unit:=Form:C1466.$current.$dom
				
			Else 
				
				If ($Boo_translate)
					
					// Create the <target> if any
					$Dom_target:=Form:C1466.findTarget($Obj_language.file.$dom; Form:C1466.$current.resname; Form:C1466.$current.id)
					
					$Dom_unit:=Form:C1466.transUnit($Dom_target)
					
					$Dom_target:=xml_Create_if_not_exist($Dom_unit; "target")
					
					If (Asserted:C1132(OK=1))
						
						If (Form:C1466.$current[$Obj_language.language]=Null:C1517)
							
							Form:C1466.$current[$Obj_language.language]:=New object:C1471
							
						End if 
						
						Form:C1466.$current[$Obj_language.language].$dom:=$Dom_target
						
						// Restore the current session value & state, if any
						If (Length:C16(String:C10(Form:C1466.$current[$Obj_language.language].value))>0)
							
							DOM SET XML ELEMENT VALUE:C868($Dom_target; Form:C1466.$current[$Obj_language.language].value)
							
							If (Length:C16(String:C10(Form:C1466.$current[$Obj_language.language].state))>0)
								
								DOM SET XML ATTRIBUTE:C866($Dom_target; \
									"state"; Form:C1466.$current[$Obj_language.language].state)
								
							Else 
								
								Form:C1466.$current[$Obj_language.language].state:="needs-translation"
								
							End if 
							
						Else 
							
							// Copy the source value into the target
							DOM SET XML ELEMENT VALUE:C868($Dom_target; $Txt_source)
							
							// & set the state
							DOM SET XML ATTRIBUTE:C866($Dom_target; \
								"state"; "needs-translation")
							
							// Update project
							Form:C1466.$current[$Obj_language.language].value:=$Txt_source
							Form:C1466.$current[$Obj_language.language].state:="needs-translation"
							
						End if 
					End if 
					
				Else 
					
					// Keep the unit reference
					$Dom_target:=Form:C1466.target(Form:C1466.$current[$Obj_language.language].$dom)
					$Dom_unit:=Form:C1466.transUnit($Dom_target)
					
					// Remove the <target>
					DOM REMOVE XML ELEMENT:C869($Dom_target)
					
				End if 
			End if 
			
			// Set & save the file
			Form:C1466.setAttribute($Dom_unit; $Obj_in.target; ->$Txt_value; $Obj_language.file.platformPath)
			
		End for each 
		
		// UI
		Form:C1466.touch("DISPLAY")
		
		Form:C1466.file.modified:=True:C214
		
		//______________________________________________________
	: ($Obj_in.target="note")
		
		$Txt_value:=String:C10($Obj_in.value)
		$Boo_translate:=Not:C34(Bool:C1537(Form:C1466.$current.noTranslate))
		
		Form:C1466.$current.note:=$Txt_value
		
		If (Length:C16($Txt_value)#0)
			
			// Set the value
			For each ($Obj_language; Form:C1466.languages)
				
				If ($Obj_language.language=Form:C1466.language)  // Reference file
					
					// Get the <note> reference
					$Dom_unit:=Form:C1466.transUnit(Form:C1466.$current.$dom)
					
				Else 
					
					// Find the <trans-unit>
					$Dom_unit:=Form:C1466.findTransUnit($Obj_language.file.$dom; Form:C1466.$current.resname; Form:C1466.$current.id)
					
				End if 
				
				$Dom_note:=DOM Find XML element:C864($Dom_unit; "trans-unit/note")
				
				If (OK=0)
					
					$Dom_note:=DOM Create XML element:C865($Dom_unit; "note")
					
				End if 
				
				// Set & save the file
				Form:C1466.setValue($Dom_note; $Txt_value; $Obj_language.file.platformPath)
				
			End for each 
			
		Else 
			
			// Delete element <note>
			For each ($Obj_language; Form:C1466.languages)
				
				If ($Obj_language.language=Form:C1466.language)  // Reference file
					
					$Dom_unit:=Form:C1466.transUnit(Form:C1466.$current.$dom)
					
				Else 
					
					// Find the <trans-unit>
					$Dom_unit:=Form:C1466.findTransUnit($Obj_language.file.$dom; Form:C1466.$current.resname; Form:C1466.$current.id)
					
				End if 
				
				$Dom_note:=DOM Find XML element:C864($Dom_unit; "trans-unit/note")
				
				If (OK=1)
					
					// Set & save the file
					xlf_DELETE_ELEMENT($Dom_note; $Obj_language.file.platformPath)
					
				End if 
			End for each 
		End if 
		
		Form:C1466.file.modified:=True:C214
		
		//______________________________________________________
	: ($Obj_in.target="d4:includeIf")
		
		$Txt_value:=String:C10(Form:C1466.$current["d4:includeIf"])
		
		If (Length:C16($Txt_value)>0)
			
			$Txt_value:=Choose:C955($Txt_value="all"; ""; $Txt_value)
			
		End if 
		
		For each ($Obj_language; Form:C1466.languages)
			
			If ($Obj_language.language=Form:C1466.language)  // Reference file
				
				$Dom_unit:=Form:C1466.transUnit(Form:C1466.$current.$dom)
				
			Else 
				
				$Dom_unit:=Form:C1466.findTransUnit($Obj_language.file.$dom; Form:C1466.$current.resname; Form:C1466.$current.id)
				
			End if 
			
			// Set & save the file
			Form:C1466.setAttribute($Dom_unit; $Obj_in.target; ->$Txt_value; $Obj_language.file.platformPath)
			
		End for each 
		
		// Check for duplicate resname
		Form:C1466.message(New object:C1471(\
			"target"; "duplicateResname"))
		
		Form:C1466.file.modified:=True:C214
		
		//______________________________________________________
	: ($Obj_in.target="propagate_reference")
		
		For each ($Obj_language; Form:C1466.languages)
			
			If ($Obj_language.language#Form:C1466.language)  // Not for the reference file
				
				$Obj_language.value:=Form:C1466.$current.source.value
				
				$Dom_target:=Form:C1466.$current[$Obj_language.language].$dom
				
				// Set & save the localized file
				DOM SET XML ATTRIBUTE:C866(Form:C1466.$current[$Obj_language.language].$dom; \
					"state"; "needs-translation")
				
				Form:C1466.setValue(Form:C1466.$current[$Obj_language.language].$dom; Form:C1466.$current.source.value; $Obj_language.file.platformPath)
				
				// UI
				Form:C1466.$current[$Obj_language.language].value:=Form:C1466.$current.source.value
				Form:C1466.$current[$Obj_language.language].state:="needs-translation"
				
			End if 
		End for each 
		
		Form:C1466.touch("DISPLAY")
		
		Form:C1466.file.modified:=True:C214
		
		//______________________________________________________
	: ($Obj_in.target="id")\
		 | ($Obj_in.target="resname")
		
		$Obj_current:=Form:C1466.$current
		
		// Keep the old value
		$Txt_value:=$Obj_current[$Obj_in.target]
		
		// Set the new value
		$Obj_current[$Obj_in.target]:=$Obj_in.value
		
		For each ($Obj_language; Form:C1466.languages)
			
			If ($Obj_language.language=Form:C1466.language)
				
				$Dom_target:=$Obj_current.$dom
				
			Else 
				
				If (Form:C1466.$target="unit")
					
					// Find the <trans-unit>
					$Dom_target:=Form:C1466.findTransUnit($Obj_language.file.$dom; $Txt_value; $Obj_current.id)
					
				Else 
					
					// Get the <group> reference
					$Dom_target:=xlf_Dom_group_from_resname($Obj_language.file.$dom; $Txt_value)
					
				End if 
			End if 
			
			// Set & save the file
			DOM SET XML ATTRIBUTE:C866($Dom_target; \
				$Obj_in.target; $Obj_in.value)
			
			Form:C1466.save($Dom_target; $Obj_language.file.platformPath)
			
		End for each 
		
		If ($Obj_in.target="resname")
			
			// Update string list
			If (Not:C34(Bool:C1537($Obj_in.fromList)))
				
				$Lon_row:=Find in array:C230((Form:C1466.dynamic(Form:C1466.widgets.strings))->; True:C214)
				
				If ($Lon_row=-1)  // Group
					
					LISTBOX GET CELL POSITION:C971(*; Form:C1466.widgets.strings; $Lon_column; $Lon_row)
					$Ptr_target:=Form:C1466.dynamic("group")
					
				Else 
					
					$Ptr_target:=Form:C1466.dynamic("unit")
					
				End if 
				
				$Ptr_target->{$Lon_row}:=$Obj_in.value
				
			End if 
			
			// Update string list
			If (Form:C1466.$target="unit")
				
				LISTBOX SELECT ROW:C912(*; Form:C1466.widgets.strings; $Lon_row; lk replace selection:K53:1)
				
				// Check for duplicate resname
				Form:C1466.message(New object:C1471(\
					"target"; "duplicateResname"))
				
				// Sort
				LISTBOX SORT COLUMNS:C916(*; Form:C1466.widgets.strings; 2; >)
				OBJECT SET SCROLL POSITION:C906(*; Form:C1466.widgets.strings; $Lon_row)
				
			Else 
				
				// Keep update the hierarchy {
				$Lon_row:=0
				
				Repeat 
					
					$Lon_row:=Find in array:C230($Ptr_target->; $Txt_value; $Lon_row+1)
					
					If ($Lon_row>0)
						
						$Ptr_target->{$Lon_row}:=$Obj_current.resname
						
					End if 
				Until ($Lon_row=-1)
				//}
				
				// Sort
				LISTBOX SORT COLUMNS:C916(*; Form:C1466.widgets.strings; 2; >)
				
				// Restore selection
				$Lon_row:=Find in array:C230($Ptr_target->; $Obj_current.resname)
				OBJECT SET SCROLL POSITION:C906(*; Form:C1466.widgets.strings; $Lon_row; *)
				LISTBOX SELECT BREAK:C1117(*; Form:C1466.widgets.strings; $Lon_row; 1; lk replace selection:K53:1)
				
			End if 
		End if 
		
		Form:C1466.file.modified:=True:C214
		
		//______________________________________________________
	: ($Obj_in.target="duplicateResname")
		
		Form:C1466.$duplicateResname:=EDITOR_Highlight_duplicated(Form:C1466.dynamic("unit"); Form:C1466.dynamic("content"))
		
		Form:C1466.touch("DISPLAY")
		
		//______________________________________________________
		
	Else 
		
		ASSERT:C1129(False:C215; "Unknown entry point: \""+$Obj_in.target+"\"")
		
		//______________________________________________________
End case 

// ----------------------------------------------------
// Return
// <NONE>
// ----------------------------------------------------
// End 