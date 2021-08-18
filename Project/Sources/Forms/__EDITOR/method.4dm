// ----------------------------------------------------
// Form method : EDITOR - (4DPop XLIFF Pro)
// ID[B8C9176257A840ABA0B5C1D9E9114A11]
// Created #12-10-2015 by Vincent de Lachaux
// ----------------------------------------------------
// Declarations
var $t : Text
var $column; $row : Integer
var $e; $o : Object
var $c : Collection
ARRAY TEXT:C222($tabOrder; 0)

// ----------------------------------------------------
// Initialisations
$e:=FORM Event:C1606

//ASSERT(4D_LOG (Current method name+" ["+String($Lon_formEvent)+"]"))

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: ($e.code=On Load:K2:1)
		
		//EDITOR_INIT
		
		//===============================================================================
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
		//===============================================================================
		
		$c:=New collection:C1472
		Form:C1466.files:=New collection:C1472
		
		For each ($o; Form:C1466.getFiles())
			
			$c.push(Form:C1466.project)
			Form:C1466.files.push($o)
			
		End for each 
		
		//===============================================================================
		If (False:C215)  //#IN_WORKS - must manage files at the root of the resources folder
			
			For each ($o; Form:C1466.project.files().query("extension = .xlf"))
				
				// Mark as common
				$o.shared:=True:C214
				
				$c.insert(0; Form:C1466.project)
				Form:C1466.files.insert(0; $o)
				
			End for each 
		End if 
		//===============================================================================
		
		If (Form:C1466.files.length=0)
			
			// Put a dummy file
			$c.push(Form:C1466.project)
			Form:C1466.files.push(New object:C1471(\
				"name"; ""))
			
		End if 
		
		// Keep the  file list
		Form:C1466.preferences.files:=Form:C1466.files.extract("name")
		
		// Populate listboxes' arrays
		//%W-518.1
		COLLECTION TO ARRAY:C1562($c; obj_Dynamic("project")->; "name")
		COLLECTION TO ARRAY:C1562(Form:C1466.preferences.files; obj_Dynamic("file")->)
		COLLECTION TO ARRAY:C1562(Form:C1466.files; obj_Dynamic("file.object")->)
		//%W+518.1
		
		If (Form:C1466.files[0].path=Null:C1517)  // No file
			
			// Collapse
			LISTBOX COLLAPSE:C1101(*; "file.list"; True:C214; lk level:K53:19; 1)
			
		Else 
			
			// Sort
			LISTBOX SORT COLUMNS:C916(*; "file.list"; 2; >)
			
		End if 
		
		// Prepare the UI
		EXECUTE METHOD IN SUBFORM:C1085("DISPLAY"; "DISPLAY_INIT"; *; Form:C1466)
		
		Form:C1466.savePreferences()
		
		//EDITOR_ON_LOAD
		
		// 'On Page Change' event is not triggered when the form is loaded
		//CALL FORM(Form.window; "EDITOR_ON_PAGE_CHANGE")
		LISTBOX GET CELL POSITION:C971(*; "file.list"; $column; $row)
		
		If ($row=0)
			
			$t:=String:C10(Form:C1466.preferences.file)
			
			If (Length:C16($t)>0)
				
				$row:=Find in array:C230(obj_Dynamic("file")->; $t)
				
			End if 
			
			If ($row>0)
				
				LISTBOX SELECT ROW:C912(*; "file.list"; $row)
				CALL FORM:C1391(Form:C1466.window; "FILE_PARSE"; $row)
				
			Else 
				
				LISTBOX SELECT ROW:C912(*; "file.list"; $row; lk remove from selection:K53:3)
				
			End if 
		End if 
		
		APPEND TO ARRAY:C911($tabOrder; "file.list")
		APPEND TO ARRAY:C911($tabOrder; "string.list")
		APPEND TO ARRAY:C911($tabOrder; "DISPLAY")
		
		FORM SET ENTRY ORDER:C1468($tabOrder)
		
		If (Is Windows:C1573)
			
			OBJECT SET SHORTCUT:C1185(*; "_close"; Shortcut with F4:K75:4; Option key mask:K16:7)
			
		End if 
		
		//EDITOR_UI
		
		//GOTO OBJECT(*; Form.widgets.files)
		
		SET TIMER:C645(-1)
		
		//______________________________________________________
	: ($e.code=On Menu Selected:K2:14)
		
		//EDITOR_ACTIONS(Get selected menu item parameter)
		
		//______________________________________________________
	: ($e.code=On Unload:K2:2)
		
		//EDITOR_ON_UNLOAD
		
		//______________________________________________________
	: ($e.code=On Close Box:K2:21)
		
		If (Shift down:C543)
			
			// Force close
			CANCEL:C270
			KILL WORKER:C1390(Window process:C446(Form:C1466.window))
			
		Else 
			
			// Keep worker
			HIDE PROCESS:C324(Window process:C446(Form:C1466.window))
			
		End if 
		
		//______________________________________________________
	: ($e.code=On Timer:K2:25)
		
		SET TIMER:C645(0)
		
		OBJECT SET VISIBLE:C603(*; "wrap"; False:C215)
		
		//______________________________________________________
	: ($e.code=On Page Change:K2:54)
		
		//EDITOR_ON_PAGE_CHANGE
		
		//______________________________________________________
	: ($e.code=On Data Change:K2:15)
		
		//debug_SAVE (Form)
		
		//______________________________________________________
	: ($e.code=On Resize:K2:27)
		
		obj_CENTER("wrap"; Form:C1466.widgets.strings; Horizontally centered:K39:1)
		obj_CENTER("welcome"; "0.backgound"; Horizontally centered:K39:1)
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+$e.description+")")
		
		//______________________________________________________
End case 