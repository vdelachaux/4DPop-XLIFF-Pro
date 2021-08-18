//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method: EDITOR_OPEN
// Database: 4DPop XLIFF Pro
// ID[99D2098F1A1C4BE4B27439E00751EB1B]
// Created #13-10-2015 by Vincent de Lachaux
// ----------------------------------------------------
// Description
//
// ----------------------------------------------------
// Declarations
var $1 : Text

If (False:C215)
	C_TEXT:C284(EDITOR_OPEN; $1)
End if 

var $t : Text
var $resetGeometry : Boolean

// ----------------------------------------------------
If (Count parameters:C259=0)
	
	CALL WORKER:C1389("$4DPop XLIFF Pro"; Current method name:C684; "*")
	
Else 
	
	// First launch of this method executed in a new process
	COMPILER_EDITOR
	
	// Allow assertions for the matrix database | me
	SET ASSERT ENABLED:C1131((Structure file:C489=Structure file:C489(*))\
		 | (Test path name:C476(Get 4D folder:C485(Active 4D Folder:K5:10)+"_vdl")#-43); *)
	
	If (EDITOR=Null:C1517)
		
		EDITOR:=cs:C1710.EDITOR.new()
		
		If (EDITOR.mode="component")
			
			// Get reference language
			$t:=String:C10(EDITOR.preferences.reference)
			
			If (Length:C16($t)=0)
				
				// Determine the probable reference language
				$t:=EDITOR.getReferenceLanguage()
				
				// #WARNING May not be unique
				// #TO_BE_DONE - Retrieve the first found lproj
				
				EDITOR.setPreference("reference"; $t)
				
			End if 
			
		Else 
			
			// #TO_BE_DONE
			
		End if 
		
		// Display the editor
		EDITOR_MENU("install")
		
		$t:="EDITOR"
		EDITOR.window:=Open form window:C675($t; Plain form window:K39:10; Horizontally centered:K39:1; Vertically centered:K39:4; *)
		DIALOG:C40($t; EDITOR; *)
		
	Else 
		
		// Bring to front
		SHOW PROCESS:C325(Window process:C446(EDITOR.window))
		BRING TO FRONT:C326(Window process:C446(EDITOR.window))
		
		EDITOR.update()
		
/*
Detect a project modification (adding or deleting a language)
since the last editor use
*/
		
		If (EDITOR.preferences.languages#Null:C1517)
			
			// Compare to last use
			$resetGeometry:=Not:C34(EDITOR.localizations.extract("name").orderBy().equal(EDITOR.preferences.languages.orderBy()))
			
			If ($resetGeometry & Not:C34(EDITOR.component)) | Shift down:C543
				
				// Reinit geometry
				//env_DELETE_GEOMETRY(Path to object(Structure file).name+"/"+"[projectForm]/EDITOR.json")
				
			End if 
		End if 
	End if 
End if 