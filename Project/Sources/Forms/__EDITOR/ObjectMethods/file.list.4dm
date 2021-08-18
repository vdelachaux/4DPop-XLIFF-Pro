// ----------------------------------------------------
// Object method : EDITOR.file.list - (4DPop XLIFF Pro)
// ID[181BCE5204164614A0BFD8392CCB4444]
// Created #12-10-2015 by Vincent de Lachaux
// ----------------------------------------------------
// Declarations
var $me : Text
var $column; $row : Integer
var $e : Object

// ----------------------------------------------------
// Initialisations
$e:=FORM Event:C1606
$me:=OBJECT Get name:C1087(Object current:K67:2)

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: ($e.code=On Load:K2:1)
		
		//
		
		//______________________________________________________
	: ($e.code=On Clicked:K2:4)
		
		If (Contextual click:C713)
			
			EDITOR_MENU($me)
			
		End if 
		
		//______________________________________________________
	: ($e.code=On Selection Change:K2:29)
		
		LISTBOX GET CELL POSITION:C971(*; $me; $column; $row)
		
		If ($row>0)
			
			If ($column=1)
				
				// Project break row
				EDITOR_CLEANUP
				
			Else 
				
				// File row
				If (Form:C1466.files[Form:C1466.files.extract("name").indexOf((Form:C1466.dynamic("file"))->{$row})].platformPath#Null:C1517)
					
					// Open the file
					CALL FORM:C1391(Form:C1466.window; "FILE_PARSE"; $row)
					
				End if 
			End if 
			
		Else 
			
			// No selection
			EDITOR_CLEANUP
			
		End if 
		
		// Update UI
		Form:C1466.refresh(Null:C1517)
		
		//______________________________________________________
	: ($e.code=On Collapse:K2:42)
		
		// Clear selection
		Form:C1466.file:=Null:C1517
		
		EDITOR_CLEANUP
		
		// Update UI
		Form:C1466.refresh(Null:C1517)
		
		//______________________________________________________
	: ($e.code=On Expand:K2:41)
		
		LISTBOX GET CELL POSITION:C971(*; $me; $column; $row)
		
		If (Form:C1466.files[$row-1].platformPath=Null:C1517)
			
			// No file -> Refuse expansion
			LISTBOX COLLAPSE:C1101(*; $me; lk break row:K53:18; $row; 1)
			LISTBOX SELECT BREAK:C1117(*; $me; $row; 1)
			
		End if 
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+$e.description+")")
		
		//______________________________________________________
End case 