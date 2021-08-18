//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : EDITOR_INIT
// Database: 4DPop XLIFF Pro
// ID[CA61B8A533794A3183C3E8BE48317D0E]
// Created #12-10-2015 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
C_LONGINT:C283($Lon_parameters)
C_OBJECT:C1216($Obj_file; $Obj_preferences)
C_COLLECTION:C1488($Col_project)

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0; "Missing parameter"))
	
	// NO PARAMETERS REQUIRED
	
	// Optional parameters
	If ($Lon_parameters>=1)
		
		// <NONE>
		
	End if 
	
	// ASSERT(4D_LOG (Current method name))
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
If (Length:C16(Storage:C1525.editor.directory)>0)
	
	If (env_Component)
		
		// Database name
		Form:C1466.project:=Path to object:C1547(Structure file:C489(*)).name
		
	Else 
		
		If (Structure file:C489=Structure file:C489(*))
			
			// Matrix database
			Form:C1466.project:=Path to object:C1547(Structure file:C489).name
			
		Else 
			
			// Folder name
			Form:C1466.project:=Path to object:C1547(Storage:C1525.editor.directory).name
			
		End if 
	End if 
	
	Form:C1466.window:=Current form window:C827
	
	// Widgets
	Form:C1466.widgets:=New object:C1471
	Form:C1466.widgets.files:="file.list"
	Form:C1466.widgets.strings:="string.list"
	Form:C1466.widgets.localizations:="DISPLAY"
	
	// Methods
	Form:C1466.dynamic:=Formula:C1597(obj_Dynamic)
	Form:C1466.touch:=Formula:C1597(obj_TOUCH)
	Form:C1466.focus:=Formula:C1597(OBJECT Get pointer:C1124(Object with focus:K67:3))
	Form:C1466.redraw:=Formula:C1597(SET TIMER:C645(8))
	
	Form:C1466.referenceFolder:=Formula:C1597(Storage:C1525.editor.directory+This:C1470.language+".lproj"+Folder separator:K24:12)
	
	Form:C1466.transUnit:=Formula:C1597(xlf_Dom_unit)
	Form:C1466.findTransUnit:=Formula:C1597(xlf_Find_trans_unit)
	Form:C1466.findTarget:=Formula:C1597(xlf_Find_target)
	Form:C1466.source:=Formula:C1597(xlf_Dom_source)
	Form:C1466.target:=Formula:C1597(xlf_Dom_target)
	Form:C1466.setAttribute:=Formula:C1597(xlf_SET_ATTRIBUTE)
	Form:C1466.setValue:=Formula:C1597(xlf_SET_VALUE)
	Form:C1466.save:=Formula:C1597(xlf_SAVE)
	Form:C1466.parse:=Formula from string:C1601("CALL FORM:C1391(This:C1470.window;\"FILE_PARSE\";$1)")
	Form:C1466.refresh:=Formula from string:C1601("CALL FORM:C1391(This:C1470.window;\"EDITOR_UI\";$1)")
	
	//Form.showLocalization:=Formula("CALL FORM:C1391(This:C1470.window;\"EDITOR_DISPLAY\")")
	Form:C1466.message:=Formula from string:C1601("CALL FORM:C1391(Current form window:C827;\"EDITOR_CALL\";$1)")
	
	Form:C1466.isUnit:=Formula:C1597(String:C10(Form:C1466.$target)="unit")
	Form:C1466.isConstant:=Formula:C1597(String:C10(Form:C1466.$datatype)="x-4DK#")
	
	
	$Obj_preferences:=EDITOR_Preferences
	
	Form:C1466.language:=String:C10($Obj_preferences.reference)
	
	// Retrieve the project languages
	Form:C1466.languages:=language_Find
	
	$Col_project:=New collection:C1472  // Hierarchy
	Form:C1466.files:=New collection:C1472
	
	For each ($Obj_file; doc_Folder(Form:C1466.referenceFolder()).files.query("extension = .xlf"))
		
		$Col_project.push(Form:C1466.project)
		Form:C1466.files.push($Obj_file)
		
	End for each 
	
	If (Form:C1466.files.length=0)
		
		// Put a dummy file
		$Col_project.push(Form:C1466.project)
		Form:C1466.files.push(New object:C1471(\
			"name"; ""))
		
	End if 
	
	//=================================================================================================================
	If (False:C215)  //#IN_WORKS - must manage files at the root of the resources folder
		
		For each ($Obj_file; doc_Folder(Get 4D folder:C485(Current resources folder:K5:16; *)).files.query("extension = .xlf"))
			
			// Mark as common
			$Obj_file.shared:=True:C214
			
			$Col_project.insert(0; Form:C1466.project)
			Form:C1466.files.insert(0; $Obj_file)
			
		End for each 
	End if 
	
	//=================================================================================================================
	
	// Keep the  file list
	$Obj_preferences.files:=Form:C1466.files.extract("name")
	
	// Populate listboxes' arrays
	//%W-518.1
	COLLECTION TO ARRAY:C1562($Col_project; Form:C1466.dynamic("project")->)
	COLLECTION TO ARRAY:C1562($Obj_preferences.files; Form:C1466.dynamic("file")->)
	COLLECTION TO ARRAY:C1562(Form:C1466.files; Form:C1466.dynamic("file.object")->)
	//%W+518.1
	
	If (Form:C1466.files[0].platformPath=Null:C1517)  // No file
		
		// Collapse
		LISTBOX COLLAPSE:C1101(*; Form:C1466.widgets.files; True:C214; lk level:K53:19; 1)
		
	Else 
		
		// Sort
		LISTBOX SORT COLUMNS:C916(*; Form:C1466.widgets.files; 2; >)
		
	End if 
	
	// Prepare the UI
	EXECUTE METHOD IN SUBFORM:C1085(Form:C1466.widgets.localizations; "DISPLAY_INIT"; *; Form:C1466)
	
	// Save preference
	EDITOR_Preferences(New object:C1471(\
		"set"; True:C214; \
		"value"; $Obj_preferences))
	
End if 

// ----------------------------------------------------
// Return
// <NONE>
// ----------------------------------------------------
// End 