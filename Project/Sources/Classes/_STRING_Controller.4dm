/*
Class: _STRING_Controller - (4DPop XLIFF Pro)
Created 20-2-2023 by Vincent de Lachaux
*/

// MARK: Default values ⚙️
property isSubform:=True:C214
property toBeInitialized:=False:C215

// MARK: Delegates 📦
property form : cs:C1710.form
property str : cs:C1710.str:=cs:C1710.str.new()

// MARK: Widgets 🧱
property resname; flag; lang; source : cs:C1710.input
property action; handleButton; noteIndicator; noTranslate; propagate : cs:C1710.button
property handle; mac; win : cs:C1710.static
property note : cs:C1710.widget
property unitGroup; languageGroup; movable : cs:C1710.group

// MARK: Constants 🔐

// MARK: Other 💾

Class constructor
	
	// MARK:-Delegates 📦
	This:C1470.form:=cs:C1710.form.new(This:C1470)
	
	This:C1470.form.init()
	
	// MARK:-[Standard Suite]
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function init()
	
	// MARK: Callback
	This:C1470.form.callback:=Formula:C1597(EDITOR CALLBACK).source
	
	// MARK:Wigets
	This:C1470.resname:=This:C1470.form.Input("resname.box")
	This:C1470.action:=This:C1470.form.Button("action")
	
	var $group : cs:C1710.group
	This:C1470.unitGroup:=This:C1470.form.Group()
	This:C1470.flag:=This:C1470.form.Input("unit.flag").addToGroup(This:C1470.unitGroup)
	This:C1470.handle:=This:C1470.form.Static("unit.handle").addToGroup(This:C1470.unitGroup)
	This:C1470.handleButton:=This:C1470.form.Button("unit.handle.button").addToGroup(This:C1470.unitGroup)
	This:C1470.lang:=This:C1470.form.Input("unit.lang").addToGroup(This:C1470.unitGroup)
	This:C1470.mac:=This:C1470.form.Static("unit.mac").addToGroup(This:C1470.unitGroup)
	This:C1470.noteIndicator:=This:C1470.form.Button("unit.note").addToGroup(This:C1470.unitGroup)
	This:C1470.noTranslate:=This:C1470.form.Button("unit.notranslate").addToGroup(This:C1470.unitGroup)
	This:C1470.source:=This:C1470.form.Input("unit.source").addToGroup(This:C1470.unitGroup)
	This:C1470.win:=This:C1470.form.Static("unit.win").addToGroup(This:C1470.unitGroup)
	
	This:C1470.propagate:=This:C1470.form.Button("shortcut")
	
	This:C1470.note:=This:C1470.form.Widget("NOTE")
	
	// Widgets to be moved when the source is resized vertically
	This:C1470.movable:=This:C1470.form.Group(New collection:C1472(This:C1470.noTranslate; This:C1470.noteIndicator; This:C1470.mac; This:C1470.win))
	
	// Language sub-forms to be populated later: initGeometry()
	This:C1470.languageGroup:=This:C1470.form.Group()
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function handleEvents($e : cs:C1710.evt)
	
	$e:=$e || cs:C1710.evt.new()
	
	//TRACE
	
	// MARK:Form Method
	If ($e.objectName=Null:C1517)  // <== FORM METHOD
		
		Case of 
				
				//______________________________________________________
			: ($e.code=On Load:K2:1)
				
				This:C1470.form.onLoad()
				
				//______________________________________________________
			: ($e.code=On Timer:K2:25)
				
				This:C1470.form.update()
				
				//______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215; "Is the event \""+$e.description+"\" needed to be activated?")
				
				//______________________________________________________
		End case 
		
	Else 
		
		// MARK: Widget Methods
		Case of 
				
				//==============================================
			: (This:C1470.resname.catch($e; On Losing Focus:K2:8))
				
				This:C1470._resnameManager($e)
				
				//==============================================
			: (This:C1470.source.catch($e))
				
				This:C1470._sourceManager($e)
				
				//==============================================
			: (This:C1470.action.catch($e))
				
				This:C1470._actionManager($e)
				
				//==============================================
			: (This:C1470.noteIndicator.catch($e))
				
				This:C1470.updateSource()
				
				If (This:C1470.note.visible)
					
					This:C1470.note.hide()
					
				Else 
					
					This:C1470.note.setCoordinates(This:C1470.source.getCoordinates()).show().focus()
					
				End if 
				
				//==============================================
			: (This:C1470.note.catch($e))
				
				If ($e.code=On Losing Focus:K2:8)
					
					If (Form:C1466.string.note#Form:C1466.string.$note)
						
						This:C1470.form.callMeBack("_UPDATE_NOTE"; This:C1470.context())
						
					End if 
					
					OB REMOVE:C1226(Form:C1466.string; "$note")
					
					This:C1470.update()
					
				End if 
				
				//==============================================
			: (This:C1470.noTranslate.catch($e))
				
				This:C1470.updateSource()
				
				If (This:C1470.noTranslate.getValue())
					
					Form:C1466.string.attributes.translate:="no"
					This:C1470.languageGroup.hide()
					
				Else 
					
					OB REMOVE:C1226(Form:C1466.string.attributes; "translate")
					This:C1470.languageGroup.show()
					
				End if 
				
				This:C1470.form.callMeBack("_UPDATE_TRANSLATE"; This:C1470.context())
				
				//==============================================
			: (This:C1470.handleButton.catch($e))
				
				This:C1470._handleManager($e)
				
				//==============================================
			: (This:C1470.propagate.catch($e))
				
				This:C1470.updateSource()
				This:C1470.form.callMeBack("_PROPAGATE_REFERENCE")
				
				//==============================================
		End case 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function onLoad()
	
	This:C1470.flag.font:="emoji"
	This:C1470.noTranslate.bestSize()
	This:C1470.propagate.hiddenFromView()
	
	// Add events that we cannot select in the form properties 😇
	This:C1470.form.appendEvents([On Alternative Click:K2:36; On Long Click:K2:37])
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function update()
	
	var $parent : cs:C1710._EDITOR_Controller:=This:C1470.form.container
	
	If (This:C1470.form.toBeInitialized)
		
		This:C1470.initGeometry($parent)
		This:C1470.form.toBeInitialized:=False:C215
		
	End if 
	
	var $string : cs:C1710.Xliff:=$parent.stringList.item || Form:C1466.string
	
	// Set shortcuts
	Form:C1466.main:=$parent.main
	Form:C1466.string:=$string
	
	// Keep the current version
	Form:C1466.$backup:=OB Copy:C1225($string)
	
	If ($string=Null:C1517)
		
		return 
		
	End if 
	
	var $colour : cs:C1710.colour:=cs:C1710.colour.new()
	$colour.foreground:=Foreground color:K23:1
	$colour.background:=Background color:K23:2
	
	var $isConstant : Boolean
	If (OB Instance of:C1731($string; cs:C1710.XliffUnit))
		
		$isConstant:=String:C10($string.attributes.restype)="x-4DK#"
		
		If ($isConstant)
			
			// TODO: Managing constant files
			
/*
			
// Hide resname if any
This.adjustResname(False)
			
*/
			
		Else 
			
			// Show resname if any
			This:C1470.adjustResname(True:C214)
			
		End if 
		
		This:C1470.unitGroup.show()
		
		// Close comment widget, if any
		This:C1470.note.hide()
		
		// Highlight duplicate resname
		$colour.foreground:=Bool:C1537($string.duplicateResname) ? "white" : Foreground color:K23:1
		$colour.background:=Bool:C1537($string.duplicateResname) ? "red" : Background color:K23:2
		
		// Set the note
		This:C1470.note.setValue($string)
		This:C1470.noteIndicator.setPicture("#Images/note_"+($string.note ? "on" : "off")+".png")
		
		// Set the platform indicator
		// TODO:platFormIndicator like note
		This:C1470.mac.show(String:C10($string.attributes["d4:includeIf"])="mac")
		
		This:C1470.win.show(String:C10($string.attributes["d4:includeIf"])="win")
		
		// Show or hide translations in accordance with Translate property & localization filter
		If (Bool:C1537($string.noTranslate))
			
			This:C1470.languageGroup.hide()
			return 
			
		Else 
			
			// TODO:Filter
			This:C1470.languageGroup.show()
			
		End if 
		
		// Update all languages
		var $language : cs:C1710.language
		For each ($language; $parent.languages)
			
			If ($isConstant)
				
				// TODO: Managing constant files
				continue
				
			End if 
			
			If ($language.root=Null:C1517)
				
				// FIXME:Should not!
				TRACE:C157
				continue
				
			End if 
			
			var $localisation : Object:=OB Copy:C1225($language)
			var $xliff : cs:C1710.Xliff:=$parent.cache.query("root = :1"; $localisation.root).first()
			
			If ($xliff=Null:C1517)
				
				// FIXME:Should not!
				TRACE:C157
				continue
				
			End if 
			
			// The ref string
			$localisation.string:=$string
			
			// Get localisation
			var $node : Text:=$xliff.findById($localisation.string.id)
			
			If ($xliff.success)
				
				$localisation.value:=$xliff.targetValue($node)
				$localisation.properties:=$xliff.targetAttributes($node)
				
			Else 
				
				$localisation.value:=""
				$localisation.properties:={}
				
			End if 
			
			This:C1470["lang_"+$localisation.lproj].value:=$localisation
			
		End for each 
		
	Else   // <group>
		
		$colour.foreground:=Foreground color:K23:1
		$colour.background:=Background color:K23:2
		
		// Show resname if any
		This:C1470.adjustResname(True:C214)
		
		If ($isConstant)
			
			// TODO: Managing constant files
			
/*
			
// Display the theme label
This.resname.disable()
This.action.hide()
			
*/
			
		Else 
			
			This:C1470.resname.enable()
			This:C1470.action.show()
			
		End if 
		
		This:C1470.unitGroup.hide()
		This:C1470.languageGroup.hide()
		
	End if 
	
	This:C1470.resname.setColors($colour)
	
	// MARK:-[Managers]
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function _resnameManager($e : cs:C1710.evt)
	
	If ($e.code#On Losing Focus:K2:8)
		
		return 
		
	End if 
	
	var $parent : cs:C1710._EDITOR_Controller:=This:C1470.form.container
	var $string : Object:=Form:C1466.string
	
	// Don't allow empty value
	var $success : Boolean:=(Length:C16($string.resname)>0)
	
	If ($success)\
		 && ($string.resname=Form:C1466.$backup.resname)
		
		// Nothing was changed
		return 
		
	End if 
	
	If (Not:C34($success))
		
		ALERT:C41(Localized string:C991("theNameMustNotBeEmpty"))
		return 
		
	End if 
	
	// For a group, do not allow duplicate names
	If (OB Instance of:C1731($string; cs:C1710.XliffGroup))
		
		$success:=$parent.current.groups.query("name = :1"; $string.resname).first()=Null:C1517
		
		If (Not:C34($success))
			
			// TODO:diacritical
			
		End if 
		
		If (Not:C34($success))
			
			// Keep the previous name to allow the updating of the hierarchical list-box
			
			ALERT:C41(Replace string:C233(Localized string:C991("theNameIsAlreadyTaken"); "{name}"; $string.resname))
			$success:=Shift down:C543  // I know what I do ;-)
			
		End if 
		
		If ($success)
			
			$string.previous:=Form:C1466.$backup.resname
			
		End if 
	End if 
	
	If (Not:C34($success))
		
		// Restore the old value
		This:C1470.resname.value:=Form:C1466.$backup.resname
		This:C1470.resname.highlight().focus()
		
		return 
		
	End if 
	
	Form:C1466.$backup.resname:=$string.resname
	This:C1470.form.callMeBack("_UPDATE_RESNAME"; This:C1470.context())
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function _actionManager($e : cs:C1710.evt)
	
	var $string : Object:=Form:C1466.string
	
	If ($e.code=On Clicked:K2:4)
		
		This:C1470._menuManager("camelCase")
		
		return 
		
	End if 
	
	var $menu : cs:C1710.menu:=cs:C1710.menu.new()
	$menu.append("camelCase"; "camelCase")  //.shortcut("c"; Option key mask)
	
	If (OB Instance of:C1731($string; cs:C1710.XliffUnit))
		
		var $sub : cs:C1710.menu:=cs:C1710.menu.new()
		$sub.append("all"; "all").mark($string.attributes["d4:includeIf"]=Null:C1517)\
			.line()\
			.append("macOS"; "mac").icon("#images/maOS.png").mark(String:C10($string.attributes["d4:includeIf"])="mac")\
			.append("Windows"; "win").icon("#images/windows.png").mark(String:C10($string.attributes["d4:includeIf"])="win")
		
		$menu.append("operatingSystems"; $sub).line()
		
		If (This:C1470.note.visible)
			
			$menu.append("closeComment"; "comment").shortcut("N"; Option key mask:K16:7)
			
		Else 
			
			If ($string.note=Null:C1517)
				
				$menu.append("addComment"; "comment").shortcut("N"; Option key mask:K16:7)
				
			Else 
				
				$menu.append("editComment"; "comment").shortcut("N"; Option key mask:K16:7)
				
			End if 
		End if 
		
		If (Not:C34(Bool:C1537($string.noTranslate)))
			
			$menu.line()\
				.append("setReferenceValueToAllLanguages"; "propagateReference").shortcut(Shortcut with Down arrow:K75:30; Option key mask:K16:7)
			
		End if 
	End if 
	
	If ($menu.popup().selected)
		
		This:C1470.updateSource()
		This:C1470._menuManager($menu.choice)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function _menuManager($what : Text)
	
	var $string : Object:=Form:C1466.string
	
	Case of 
			
			//______________________________________________________
		: ($what="camelCase")
			
			If (This:C1470.isGroup($string))
				
				$string.previous:=$string.resname
				
			End if 
			
			$string.resname:=This:C1470.str.lowerCamelCase($string.resname)
			Form:C1466.$backup.resname:=$string.resname
			
			This:C1470.form.callMeBack("_UPDATE_RESNAME"; This:C1470.context())
			
			//______________________________________________________
		: ($what="comment")
			
			This:C1470.form.postKeyDown(Character code:C91("N"); Command key mask:K16:1 ?+ Option key bit:K16:8)
			
			//______________________________________________________
		: ($what="propagateReference")
			
			This:C1470.form.callMeBack("_PROPAGATE_REFERENCE")
			
			//______________________________________________________
		: ($what="mac")\
			 | ($what="win")\
			 | ($what="all")
			
			If ($what="all")
				
				OB REMOVE:C1226($string.attributes; "d4:includeIf")
				
			Else 
				
				$string.attributes["d4:includeIf"]:=$what
				
			End if 
			
			This:C1470.form.callMeBack("_UPDATE_PLATFORM"; This:C1470.context())
			
			// Set the platform indicator
			This:C1470.mac.show($what="mac")
			This:C1470.win.show($what="win")
			
			//______________________________________________________
	End case 
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function _sourceManager($e : cs:C1710.evt)
	
	Case of 
			
			//______________________________________________________
		: ($e.code=On Getting Focus:K2:7)
			
			SPELL SET CURRENT DICTIONARY:C904(Form:C1466.main.language.lproj)
			This:C1470.source.highlight()
			
			//______________________________________________________
		: ($e.code=On Losing Focus:K2:8)
			
			This:C1470.updateSource()
			
			//______________________________________________________
	End case 
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function _handleManager($e : cs:C1710.evt)
	
	var $moveV; $resize : Integer
	var $handle; $source : cs:C1710.coord
	var $language : cs:C1710.static
	
	$source:=This:C1470.source.coordinates
	
	$handle:=This:C1470.handleButton.coordinates
	$handle.top:=$source.bottom-This:C1470.handleButton.height
	$handle.bottom:=$source.bottom
	
	// Determine the resize value
	$resize:=This:C1470.handleButton.coordinates.bottom-$source.bottom
	
	If ((($source.bottom+$resize)-$source.top)>50)
		
		// Resize the source
		This:C1470.source.resizeVertically($resize)
		
		// Move the associates
		This:C1470.movable.moveVertically($resize)
		
		// Move and resize the language subforms
		For each ($language; This:C1470.languageGroup.members)
			
			$moveV:=$moveV+$resize
			$language.moveVertically($moveV).resizeVertically($resize)
			
		End for each 
		
		This:C1470.handle.setCoordinates($handle)
		
	Else 
		
		// Reset the handle position
		This:C1470.handle.setCoordinates($handle)
		This:C1470.handleButton.setCoordinates($handle)
		
	End if 
	
	// MARK:-
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function initGeometry($editor : cs:C1710._EDITOR_Controller)
	
	var $widget : Text
	var $index : Integer
	var $nil : Pointer
	
	var $coordinates; $position : cs:C1710.coord
	var $dimensions : cs:C1710.dim
	
	ARRAY TEXT:C222($objects; 0)
	ARRAY TEXT:C222($tabOrder; 0)
	
	$position:=This:C1470.source.coordinates
	$position.right+=18
	
	// Get the source line height…
	$dimensions:=This:C1470.source.dimensions
	$dimensions.height+=25
	
	// …and the total source height
	$coordinates:=This:C1470.noTranslate.coordinates
	$position.top:=$coordinates.bottom+2
	
	APPEND TO ARRAY:C911($tabOrder; "resname.box")
	APPEND TO ARRAY:C911($tabOrder; "unit.source")
	
	// Mask all lines
	This:C1470.languageGroup.hide()
	
	FORM GET OBJECTS:C898($objects; Form current page:K67:6)
	
	var $language : cs:C1710.language
	For each ($language; This:C1470.form.container.languages)
		
		$widget:="lang_"+$language.lproj
		
		If (Find in array:C230($objects; $widget)<0)
			
			// Create
			OBJECT DUPLICATE:C1111(*; "_template"; $widget; $nil; "lang_"+String:C10($index-1); 0; 0)
			This:C1470[$widget]:=This:C1470.form.Subform($widget).addToGroup(This:C1470.languageGroup)
			
		End if 
		
		// Position
		$coordinates:=This:C1470[$widget].coordinates
		$position.left:=$coordinates.left
		$position.bottom:=$position.top+$dimensions.height
		
		This:C1470[$widget].setCoordinates($position)
		This:C1470[$widget].hide()
		
		// Asign it the language object
		This:C1470[$widget].setValue($language)
		
		APPEND TO ARRAY:C911($tabOrder; $widget)
		
		$index+=1
		$position.top:=$position.bottom+5
		
	End for each 
	
	FORM SET ENTRY ORDER:C1468($tabOrder)
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function adjustResname($visible : Boolean)
	
	var $offset : Integer
	
	$offset:=30
	
	If ($visible)
		
		If (Not:C34(This:C1470.resname.visible))
			
			This:C1470.resname.show()
			This:C1470.unitGroup.moveVertically($offset)
			This:C1470.languageGroup.moveVertically($offset)
			
		End if 
		
	Else 
		
		If (This:C1470.resname.visible)
			
			This:C1470.resname.hide()
			This:C1470.unitGroup.moveVertically(-$offset)
			This:C1470.languageGroup.moveVertically(-$offset)
			
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function updateSource()
	
	If (Form:C1466.string.source.value#Form:C1466.$backup.source.value)  // Both are undefined for a group
		
		This:C1470.form.callMeBack("_UPDATE_SOURCE"; This:C1470.context())
		
		// Update backup value
		Form:C1466.$backup.source.value:=Form:C1466.string.source.value
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function isGroup($target : Object) : Boolean
	
	return OB Instance of:C1731($target; cs:C1710.XliffGroup)
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function context() : Object
	
	return {\
		string: Form:C1466.string; \
		parent: This:C1470.form.container; \
		file: This:C1470.form.container.current\
		}
	