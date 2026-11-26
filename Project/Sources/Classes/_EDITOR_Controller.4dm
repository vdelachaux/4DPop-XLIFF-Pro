/*
Class: _EDITOR_Controller - (4DPop XLIFF Pro)
Created 1-1-2023 by Vincent de Lachaux
*/

// MARK:-[PROPERTIES]

// MARK:- Default values ⚙️
property isSubform:=False:C215
property toBeInitialized:=False:C215
property main:={}

// MARK:- Delegates 📦
property form : cs:C1710.ui.form
property stringListConstraints  //: cs.ui.constraints
property Xliff  //: cs.Xliff
property menuBar : cs:C1710.ui.menuBar
property Preferences : cs:C1710.Preferences
property str:=cs:C1710.str.new()
property Editor:=cs:C1710._Editor.new()
property database:=cs:C1710.database.new()

// MARK:- Widgets 🧱
property lock; lockMessage : cs:C1710.ui.static
property wrap : cs:C1710.ui.widget
property _wrapTimer : Integer
property newFile; newGroup; newString; filterLanguage : cs:C1710.ui.button
property stringSplitter; lockButton : cs:C1710.ui.button
property detail; searchPicker : cs:C1710.ui.subform
property fileList; stringList : cs:C1710.ui.listbox
property strings; locked; withFile : cs:C1710.ui.group
property spinner : cs:C1710.ui.stepper

// TODO:Could be a preference
property AUTOSAVE:=True:C214  // Flag for automatic saving

// MARK:- Other 💾
property current : cs:C1710.Xliff
property folders; cache; languages : Collection
property default : Object

property groupPtr; resnamePtr; contentPtr : Pointer

// MARK:- Constants 🔐
property GENERATOR:=File:C1566(Structure file:C489; fk platform path:K87:2).name
// TODO:Retrieve component version
property VERSION:="3.0"

property DISPLAY_FILE:=-1
property LOAD_STRINGS:=-2

// MARK:- Form 📈
property files : Collection
property project : Text
property TRACE : Boolean

// MARK:-
Class constructor()
	
	// MARK:Delegates 📦
	This:C1470.form:=cs:C1710.ui.form.new(This:C1470)
	
	This:C1470.Preferences:=cs:C1710.Preferences.new()
	This:C1470.Xliff:=cs:C1710.Xliff.new()
	
	// MARK:Retrieving active lproj folders
	This:C1470.folders:=This:C1470.Editor.lprojFolders
	
	// MARK: Source language and existing files
	This:C1470.main.language:=This:C1470.Editor.getLanguage(This:C1470.Preferences.get("sourceLanguage"))
	This:C1470.main.files:=This:C1470.getFiles()
	
	// MARK: default
	This:C1470.default:={\
		language: This:C1470.main.language.lproj; \
		version: This:C1470.VERSION\
		}
	
	// MARK: Managed languages
	This:C1470.languages:=This:C1470.Editor.getTargetLangs()
	
	// MARK: Memorize open XML trees to be able to close them when unloading
	This:C1470.cache:=[]
	
	This:C1470.form.init()
	
	// MARK:-[STANDARD SUITE]
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function init()
	
	// MARK: Installing the menu bar
	var $menuHandle : Text:=Formula:C1597(formMenuHandle).source
	
	var $menuFile : cs:C1710.ui.menu:=cs:C1710.ui.menu.new()
	$menuFile.file()  // Get a standard file menu
	
	// Insert custom items at the beginning
	$menuFile.append(Localized string:C991("newFile"); "newFile"; 0).method($menuHandle)\
		.append(Localized string:C991("newGroup"); "newGroup"; 1).method($menuHandle).shortcut("N"; Option key mask:K16:7)\
		.append(Localized string:C991("newString"); "newString"; 2).method($menuHandle).shortcut("N")\
		.line(3)\
		.append(Localized string:C991("close"); "close"; 4).method($menuHandle).shortcut("W")\
		.line(5)
	
	var $menuEdit : cs:C1710.ui.menu:=cs:C1710.ui.menu.new().method($menuHandle)
	$menuEdit.edit()  // Get a standard edit menu
	
	// Modify the cut item (4) to be able to manage it ourselves
	$menuEdit.parameter("cut"; 4).method($menuHandle; 4).action(ak none:K76:35; 4)
	
	// Modify the copy item (5) to be able to manage it ourselves
	$menuEdit.parameter("copy"; 5).method($menuHandle; 5).action(ak none:K76:35; 5)
	
	// Modify the past item (6) to be able to manage it ourselves
	$menuEdit.parameter("paste"; 6).method($menuHandle; 6).action(ak none:K76:35; 6)
	
	// Insert custom copy items
	$menuEdit.append(Localized string:C991("CommonMenuItemCopy")+" "+Localized string:C991("copyResname"); "copyResname"; 5).method($menuHandle).shortcut("C"; Shift key mask:K16:3)
	$menuEdit.append(Localized string:C991("CommonMenuItemCopy")+" "+Localized string:C991("copyTheCode"); "copyCode"; 6).method($menuHandle).shortcut("C"; Option key mask:K16:7)
	
	// Insert custom items before the last
	$menuEdit.line()\
		.append(Localized string:C991("find"); "find"; -1).method($menuHandle).shortcut("F")\
		.append(Localized string:C991("findNext"); "findNext"; -1).method($menuHandle).shortcut("G")\
		.line(-1)
	
	This:C1470.menuBar:=cs:C1710.ui.menuBar.new([\
		Localized string:C991("CommonMenuFile"); $menuFile; \
		Localized string:C991("CommonMenuEdit"); $menuEdit]).set()
	
	// MARK: Callback
	
	// MARK: Toolbar buttons
	This:C1470.newFile:=This:C1470.form.Button("toolbarNewFile")
	
	This:C1470.withFile:=This:C1470.form.Group()
	This:C1470.newGroup:=This:C1470.form.Button("toolbarNewGroup").addToGroup(This:C1470.withFile)
	This:C1470.newString:=This:C1470.form.Button("toolbarNewTransUnit").addToGroup(This:C1470.withFile)
	
	This:C1470.filterLanguage:=This:C1470.form.Button("localization")
	
	// MARK: File list
	This:C1470.fileList:=This:C1470.form.Listbox("fileList")
	
	// MARK: String list
	This:C1470.stringSplitter:=This:C1470.form.Button("stringSplitter")
	
	This:C1470.strings:=This:C1470.form.Group()
	This:C1470.stringList:=This:C1470.form.Listbox("stringList").addToGroup(This:C1470.strings)
	This:C1470.wrap:=This:C1470.form.Widget("wrap").addToGroup(This:C1470.strings)
	
	// MARK: Detail subform
	This:C1470.detail:=This:C1470.form.Subform("detail"; {onDataChange: -On Data Change:K2:15}; This:C1470)
	
	// MARK: Lock
	This:C1470.locked:=This:C1470.form.Group()
	This:C1470.lock:=This:C1470.form.Static("lock").addToGroup(This:C1470.locked)
	This:C1470.lockMessage:=This:C1470.form.Static("lockMessage").addToGroup(This:C1470.locked)
	This:C1470.lockButton:=This:C1470.form.Button("lockButton").addToGroup(This:C1470.locked)
	
	// MARK: Search Picker
	This:C1470.searchPicker:=This:C1470.form.Subform("searchPicker"; {}; This:C1470)
	
	This:C1470.spinner:=This:C1470.form.Stepper("spinner")
	
	// MARK: Constraints
	This:C1470.stringListConstraints:=This:C1470.form.constraints
	
	This:C1470.stringListConstraints.add({\
		target: "spinner"; \
		type: "horizontal-alignment"; \
		alignment: "center"; \
		reference: "stringList"})
	
	This:C1470.stringListConstraints.add({\
		target: "wrap"; \
		type: "horizontal-alignment"; \
		alignment: "center"; \
		reference: "stringList"})
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function handleEvents($e : cs:C1710.ui.evt)
	
	$e:=$e || FORM Event:C1606
	
	// MARK:Form Method
	If ($e.objectName=Null:C1517)
		
		Case of 
				
				//______________________________________________________
			: ($e.code=On Load:K2:1)
				
				This:C1470.form.onLoad()
				
				//______________________________________________________
			: ($e.code=On Getting Focus:K2:7)\
				 | ($e.code=On Losing Focus:K2:8)
				
				This:C1470.form.update()
				
				//______________________________________________________
			: ($e.code=On Resize:K2:27)
				
				This:C1470.locked.center(True:C214)
				
				//______________________________________________________
			: ($e.code=On Activate:K2:9)
				
				This:C1470.updateMenus()
				
				//______________________________________________________
			: ($e.code=On Deactivate:K2:10)
				
				RELOAD PROJECT:C1739  // Force the reloading of XLIFF
				
				//______________________________________________________
			: ($e.code=On Unload:K2:2)
				
				RELOAD PROJECT:C1739  // Force the reloading of XLIFF
				
				This:C1470.deinit()
				
				//______________________________________________________
			: ($e.code=On Timer:K2:25)
				
				This:C1470.form.update()
				
				//______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215; "Is the event \""+$e.description+"\" needed to be activated?")
				
				//______________________________________________________
		End case 
		
		return 
		
	End if 
	
	// MARK: Widget Methods
	If ($e.objectName="stringSplitter")
		
		This:C1470.stringListConstraints.apply()
		
		return 
		
	End if 
	
	Case of 
			
			//==============================================
		: (This:C1470.fileList.catch($e))
			
			This:C1470._fileListManager($e)
			
			//==============================================
		: (This:C1470.stringList.catch($e))
			
			This:C1470._stringListManager($e)
			
			//==============================================
		: (This:C1470.newFile.catch($e))
			
			This:C1470.doNewFile()
			
			//==============================================
		: (This:C1470.newGroup.catch($e))
			
			This:C1470.doNewGroup()
			
			//==============================================
		: (This:C1470.newString.catch($e))
			
			This:C1470.doNewString()
			
			//==============================================
		: (This:C1470.lockButton.catch($e))
			
			This:C1470.deDuplicateIDs()
			
			//==============================================
		: (This:C1470.stringSplitter.catch($e))
			
			This:C1470.strings.center(True:C214)
			This:C1470.locked.center(True:C214)
			
			//==============================================
	End case 
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function onLoad()
	
	// Avoid the offset created if the vertical bar is not displayed
	This:C1470.fileList.setVerticalScrollbar(2)
	This:C1470.stringList.setVerticalScrollbar(2)
	
	Form:C1466.files:=This:C1470.main.files
	Form:C1466.project:=File:C1566(Structure file:C489(*); fk platform path:K87:2).name
	
	This:C1470.fileList.setColumnTitle(1; Form:C1466.project)
	
	// Pointers to the dynamics
	This:C1470.groupPtr:=OBJECT Get pointer:C1124(Object named:K67:5; "group")
	This:C1470.resnamePtr:=OBJECT Get pointer:C1124(Object named:K67:5; "unit")
	This:C1470.contentPtr:=OBJECT Get pointer:C1124(Object named:K67:5; "content")
	
	// Adjust the width of toolbar buttons to suit localized titles
	This:C1470.newFile.bestSize()
	This:C1470.withFile.distributeLeftToRight().disable()
	This:C1470.filterLanguage.bestSize()
	This:C1470.lockButton.bestSize()
	
	This:C1470.form.focus(This:C1470.fileList.name)
	
	This:C1470.form.setEntryOrder([This:C1470.fileList; This:C1470.stringList; This:C1470.detail])
	
	// Initialize the search widget
	This:C1470.searchPicker.data:={\
		value: Null:C1517; \
		start: 0; \
		borderColor: 0x00C0C0C0\
		}
	
	// Add events that we cannot select in the form properties 😇
	This:C1470.form.appendEvents([On Expand:K2:41; On Delete Action:K2:56; On Begin Drag Over:K2:44])
	
	This:C1470.stringListConstraints.apply()
	
	This:C1470.spinner.start(True:C214)
	
	// MARK: *************************** [DEV]
	If (This:C1470.database.isDebug)
		
		OBJECT SET VISIBLE:C603(*; "trace"; True:C214)
		OBJECT SET VISIBLE:C603(*; "button"; True:C214)
		
		CALL WORKER:C1389("DEBUG"; Formula:C1597(EDITOR_DEBUG).source)
		
	End if 
	
	This:C1470.form.refresh()
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function update()
	
	var $defered : Integer:=This:C1470.form.deferedTimer
	
	Case of 
			
			// ……………………………………………………………………………………………………
		: ($defered=This:C1470.DISPLAY_FILE)
			
			This:C1470.form.callMeBack(Null:C1517; "_DISPLAY_FILE")
			// ……………………………………………………………………………………………………
		: ($defered=This:C1470.LOAD_STRINGS)
			
			This:C1470.form.callMeBack(Null:C1517; "_LOAD_STRINGS")
			// ……………………………………………………………………………………………………
	End case 
	
	If (This:C1470.fileList.item=Null:C1517)\
		 && (This:C1470.fileList.rowsNumber>0)
		
		// Select last used file, if any…
		var $currentFile : Text:=This:C1470.Preferences.get("currentFile")
		var $c : Collection
		
		If ($currentFile#Null:C1517)\
			 && (Length:C16(String:C10($currentFile))>0)
			
			$c:=Form:C1466.files.indices("name = :1"; $currentFile)
			
		End if 
		
		// … or the first file if there is at least one file
		This:C1470.doSelectFile(Bool:C1537($c.length) ? $c[0]+1 : Bool:C1537(This:C1470.fileList.rowsNumber) ? 1 : 0)
		
	Else 
		
		//This.spinner.stop(True)
		
	End if 
	
	If (This:C1470.fileList.rowsNumber=0)
		
		This:C1470.spinner.stop(True:C214)  // No file to load: nothing to wait for
		
	End if 
	
	var $isWritable:=Not:C34(Bool:C1537(This:C1470.current.duplicateID)) && (This:C1470.fileList.item#Null:C1517)
	
	This:C1470.strings.show(This:C1470.current.error=Null:C1517)
	This:C1470.newGroup.enable($isWritable)
	This:C1470.newString.enable($isWritable && (This:C1470.stringList.item#Null:C1517))
	
	This:C1470.updateMenus($isWritable)
	
	If (Num:C11(This:C1470._wrapTimer)=0)
		
		This:C1470.wrap.hide()
		
	Else 
		
		This:C1470.form.refresh(This:C1470._wrapTimer)
		This:C1470._wrapTimer:=0
		
	End if 
	
	If (This:C1470.database.isDebug) && (This:C1470.stringList.item#Null:C1517)
		
		var $o : Object:=This:C1470.stringList.item
		CALL WORKER:C1389("DEBUG"; Formula:C1597(EDITOR_DEBUG("update"; $o)))
		
	End if 
	
	This:C1470.detail.show($isWritable && (This:C1470.stringList.item#Null:C1517))
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function updateMenus($isWritable : Boolean)
	
	$isWritable:=Count parameters:C259=1 ? $isWritable : Not:C34(Bool:C1537(This:C1470.current.duplicateID))
	
	var $item : Object:=This:C1470.stringList.item
	var $isSelected:=$item#Null:C1517
	
	This:C1470.menuBar.enableItem("newGroup"; $isWritable)
	This:C1470.menuBar.enableItem("newString"; $isWritable & $isSelected)
	
	If (This:C1470.form.focused=This:C1470.stringList.name)
		
		This:C1470.menuBar.enableItem("cut"; $isSelected)
		This:C1470.menuBar.enableItem("copy"; $isSelected && ($item.id#Null:C1517))
		
		var $x : Blob
		GET PASTEBOARD DATA:C401("pop.xliff"; $x)
		This:C1470.menuBar.enableItem("paste"; BLOB size:C605($x)>0)
		This:C1470.menuBar.enableItem("copyResname"; $isSelected)
		This:C1470.menuBar.enableItem("copyCode"; $isSelected)
		
	Else 
		
		var $text:=Get edited text:C655
		This:C1470.menuBar.enableItem("cut"; Length:C16($text)>0)
		This:C1470.menuBar.enableItem("copy"; Length:C16($text)>0)
		This:C1470.menuBar.enableItem("paste"; Length:C16(Get text from pasteboard:C524)>0)
		This:C1470.menuBar.disableItem("copyResname")
		This:C1470.menuBar.disableItem("copyCode")
		
	End if 
	
	If (This:C1470.fileList.item#Null:C1517)
		
		This:C1470.searchPicker.enable()
		
		This:C1470.menuBar.enableItem("find"; True:C214)
		This:C1470.menuBar.enableItem("findNext"; (This:C1470.searchPicker.data.value#Null:C1517) && (String:C10(This:C1470.searchPicker.data.value)#""))
		
	Else 
		
		This:C1470.searchPicker.disable()
		
		This:C1470.menuBar.disableItem("find")
		This:C1470.menuBar.disableItem("findNext")
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function deinit()
	
	CALL WORKER:C1389("$4DPop XLIFF Pro"; Formula:C1597(EDITOR CLOSE).source; Form:C1466)
	
	// MARK: *************************** [DEV]
	If (This:C1470.database.isDebug)
		
		KILL WORKER:C1390("DEBUG")
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function handleMenus($what : Text)
	
	$what:=$what || Get selected menu item parameter:C1005
	
	var $text; $key : Text
	var $start; $stop : Integer
	var $item; $o : Object
	var $x : Blob
	
	Case of 
			
			//______________________________________________________
		: ($what="find")
			
			This:C1470.form.focus(This:C1470.searchPicker)
			
			//______________________________________________________
		: ($what="findNext")
			
			This:C1470.doSearch()
			
			//______________________________________________________
		: ($what="newFile")
			
			This:C1470.doNewFile()
			
			//______________________________________________________
		: ($what="newGroup")
			
			This:C1470.doNewGroup()
			
			//______________________________________________________
		: ($what="newString")
			
			This:C1470.doNewString()
			
			//______________________________________________________
		: ($what="delete")
			
			This:C1470.doDeleteString()
			
			//______________________________________________________
		: ($what="cut")
			
			If (Is editing text:C1744)
				
				INVOKE ACTION:C1439(ak cut:K76:53)
				
				return 
				
			End if 
			
			$item:=OB Copy:C1225(This:C1470.stringList.item)
			
			If (This:C1470.isGroup($item))
				
				ASSERT:C1129(False:C215; "TODO: Paste a group")
				return 
				
			End if 
			
			For each ($o; $item.localizations)
				
				$o.localized:=$o.xliff.allUnits.query("id = :1"; $item.id).first()
				
			End for each 
			
			VARIABLE TO BLOB:C532($item; $x; *)
			CLEAR PASTEBOARD:C402
			APPEND DATA TO PASTEBOARD:C403("pop.xliff"; $x)
			
			// This.doDeleteString(False)
			
			//______________________________________________________
		: ($what="paste")
			
			If (Is editing text:C1744)
				
				INVOKE ACTION:C1439(ak paste:K76:55)
				
				return 
				
			End if 
			
			GET PASTEBOARD DATA:C401("pop.xliff"; $x)
			
			If (Not:C34(Bool:C1537(OK)))
				
				return 
				
			End if 
			
			BLOB TO VARIABLE:C533($x; $item)
			
			var $xliff : cs:C1710.Xliff:=This:C1470.current
			
			var $target : Object:=This:C1470.stringList.item
			var $id : Text
			
			If (This:C1470.isGroup($item))
				
				// TODO: Paste a group
				ASSERT:C1129(False:C215; "TODO: Paste a group")
				
			Else 
				
				If (This:C1470.isTransUnit($target))
					
					// Get parent group
					$target:=This:C1470.parentGroup($target)
					
				End if 
				
				$item.resname+=" (copy)"
				
				var $unit : cs:C1710.XliffUnit:=This:C1470.current.createUnit($target; $item.resname)
				
				For each ($key; $item.attributes)
					
					If ($key="resname") || ($key="id")
						
						continue
						
					End if 
					
					$xliff.setAttribute($unit.node; $key; $item.attributes[$key])
					
				End for each 
				
				$xliff.setValue($unit.source.node; $item.source.value)
				$xliff.setValue($unit.target.node; $item.source.value)
				This:C1470.save(This:C1470.current)
				
				// Update localized files
				For each ($o; $item.localizations)
					
					$xliff:=$o.xliff
					var $group : cs:C1710.XliffGroup:=$xliff.groups.query("xpath = :1"; $target.xpath).first()
					
					If (Asserted:C1132($group#Null:C1517))
						
						$unit:=$xliff.createUnit($group; $item.resname; $unit.id)
						
						For each ($key; $item.attributes)
							
							If ($key="resname") || ($key="id")
								
								continue
								
							End if 
							
							$xliff.setAttribute($unit.node; $key; $item.attributes[$key])
							
						End for each 
						
						var $localized : Object:=$o.localized
						
						//$xliff.setValue($unit.source.node; $item.source.value)
						//$xliff.setValue($unit.target.node; $o.value)
						
						This:C1470.save($xliff)
						
					End if 
				End for each 
				
				// Update UI
				If ($target.transunits.length=1)
					
					var $row : Integer:=Find in array:C230(This:C1470.groupPtr->; $target.resname)
					This:C1470.resnamePtr->{$row}:=$item.resname
					This:C1470.contentPtr->{$row}:=$unit
					
				Else 
					
					APPEND TO ARRAY:C911((This:C1470.groupPtr)->; $target.resname)
					APPEND TO ARRAY:C911((This:C1470.resnamePtr)->; $item.resname)
					APPEND TO ARRAY:C911((This:C1470.contentPtr)->; $unit)
					
				End if 
				
				This:C1470.stringList.sort(2)
				This:C1470.doSelectUnit(Find in array:C230((This:C1470.resnamePtr)->; $item.resname))
				
			End if 
			
			
			//______________________________________________________
		: ($what="copy")
			
			If (Is editing text:C1744)
				
				INVOKE ACTION:C1439(ak copy:K76:54)
				
			Else 
				
				SET TEXT TO PASTEBOARD:C523(":xliff:"+This:C1470.stringList.item.resname)  // XLIFF reference
				
			End if 
			
			//………………………………………………………………………………………
		: ($what="copyResname")
			
			SET TEXT TO PASTEBOARD:C523(This:C1470.stringList.item.resname)
			
			//………………………………………………………………………………………
		: ($what="copyCode")
			
			SET TEXT TO PASTEBOARD:C523(This:C1470.getItemCode(This:C1470.stringList.item))
			
			//______________________________________________________
		: ($what="showOnDisk")
			
			SHOW ON DISK:C922(This:C1470.current.file.platformPath)
			
			//______________________________________________________
		: ($what="close")
			
			CANCEL:C270
			
			//______________________________________________________
		: (Match regex:C1019("^\\d+$"; $what; 1))  // Window reference
			
			var $bottom; $left; $right; $top : Integer
			GET WINDOW RECT:C443($left; $top; $right; $bottom; Num:C11($what))
			SET WINDOW RECT:C444($left; $top; $right; $bottom; Num:C11($what))
			
			//______________________________________________________
		Else   // Copy with template
			
			SET TEXT TO PASTEBOARD:C523(This:C1470.getItemCode(This:C1470.stringList.item; $what))
			
			//______________________________________________________
	End case 
	
	//MARK:-[MANAGERS]
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function _fileListManager($e : cs:C1710.ui.evt)
	
	var $file : 4D:C1709.File
	
	$file:=This:C1470.current.file
	
	Case of 
			
			//______________________________________________________
		: ($e.code=On Selection Change:K2:29)
			
			This:C1470.stringList.unselect()
			
			// No current string while another file is displayed: the editor kept the string of the previous file
			// (its "…" menu then renamed it through _UPDATE_RESNAME in the new file, error -10713)
			This:C1470.stringList.item:=Null:C1517
			This:C1470.detail.hide()
			
			// Reset the search
			This:C1470.searchPicker.data.start:=0
			
			This:C1470.withFile.disable()
			This:C1470.strings.hide()
			This:C1470.stringList.hide()
			
			If (This:C1470.fileList.item=Null:C1517)
				
				return 
				
			End if 
			
			This:C1470.spinner.start(True:C214)
			This:C1470.form.deferTimer(This:C1470.DISPLAY_FILE)
			
			//______________________________________________________
		: ($e.code=On Clicked:K2:4)
			
			If (Contextual click:C713)
				
				var $menu : cs:C1710.ui.menu:=cs:C1710.ui.menu.new()
				
				$menu.append(Localized string:C991("projectSettings"); "projectSettings").disable()
				
				If ($e.row#Null:C1517)
					
					$menu.line().append(Localized string:C991("fileInformations"); "fileInformations").disable()\
						.append(Localized string:C991("showOnDisk"); "showOnDisk")\
						.append(Localized string:C991("renameFile"); "rename")\
						.append(Localized string:C991("delete"); "delete")
					
				End if 
				
				If (This:C1470.current.duplicateID)
					
					$menu.line()\
						.append(Localized string:C991("makeIdsUnique"); "uid")
					
				End if 
				
				$menu.line()\
					.append(Localized string:C991("import"); "import").disable()
				
				$menu.popup()
				
				Case of 
						//_____________________________________
					: (Not:C34($menu.selected))
						
						//
						
						//_____________________________________
					: ($menu.choice="rename")
						
						This:C1470.doRenameFile($file)
						
						//_____________________________________
					: ($menu.choice="delete")
						
						This:C1470.doDeleteFile($file; $e)
						
						//_____________________________________
					: ($menu.choice="uid")
						
						This:C1470.deDuplicateIDs()
						
						//_____________________________________
					: ($menu.choice="showOnDisk")
						
						SHOW ON DISK:C922($file.platformPath)
						
						//_____________________________________
					Else 
						
						TRACE:C157
						
						// TODO: more
						
						//_____________________________________
				End case 
			End if 
			
			//______________________________________________________
	End case 
	
	This:C1470.updateMenus()
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function _stringListManager($e : cs:C1710.ui.evt; $force : Boolean)
	
	If ($e.code=On Getting Focus:K2:7) || ($e.code=On Losing Focus:K2:8)
		
		// Focus events (enabled at the form level) carry no row: cellPosition() takes the row under the mouse,
		// 0 when the user clicks in a field of the string, which deselected the string (stringList.item:=Null)
		// and made "+ String" do nothing. The current string only changes on a click, a selection change or an expand
		return 
		
	End if 
	
	If (Not:C34(Bool:C1537($force)))
		
		This:C1470.stringList.cellPosition($e)
		
	End if 
	
	var $item : Object:=This:C1470.setCurrentString($e)
	
	Case of 
			
			//______________________________________________________
		: ($e.selectionChange)
			
			This:C1470.form.refresh()
			
			//______________________________________________________
		: ($e.click)
			
			If (Contextual click:C713)
				
				var $isWritable : Boolean:=Not:C34(Bool:C1537(This:C1470.current.duplicateID))
				var $menu : cs:C1710.ui.menu:=cs:C1710.ui.menu.new()
				
				If ($item#Null:C1517)
					
					var $copy : cs:C1710.ui.menu:=cs:C1710.ui.menu.new()
					$copy.append(Localized string:C991("copyAsXliffReference"); "copy").shortcut("C").enable(OB Instance of:C1731($item; cs:C1710.XliffUnit))\
						.append(Localized string:C991("copyResname"); "copyResname").shortcut("C"; Shift key mask:K16:3)\
						.append(Localized string:C991("copyTheCode"); "copyCode").shortcut("C"; Option key mask:K16:7)
					
					var $files : Collection:=Folder:C1567("/RESOURCES/4DPop xliff").files()
					
					If (Structure file:C489#Structure file:C489(*))
						
						// Append host files
						$files.combine(Folder:C1567("/RESOURCES/4DPop xliff"; *).files())
						
					End if 
					
					$files:=$files.query("extension = :1"; This:C1470.isGroup($item) ? ".group" : ".unit").orderBy("name")
					
					If ($files.length>0)
						
						$copy.line()
						
						var $file : 4D:C1709.File
						For each ($file; $files)
							
							$copy.append(Localized string:C991("codeFor")+$file.name; $file.name)  //.setStyle(Italic)
							
						End for each 
					End if 
					
					// TODO: Allow to copy/cut an item to paste it in another group/file
					
					$menu.append(Localized string:C991("CommonMenuItemCopy"); $copy)
					$menu.line()
					
				End if 
				
				$menu.append(Localized string:C991("newGroup"); "newGroup").shortcut("N"; Option key mask:K16:7).enable($isWritable)
				
				If ($item#Null:C1517)
					
					$menu.append(Localized string:C991("newString"); "newString").shortcut("N").enable($isWritable)\
						.line()\
						.append(Localized string:C991("duplicate"); "duplicate").shortcut("D").enable($isWritable)\
						.line()\
						.append(Localized string:C991("delete"); "delete").shortcut("[Del]").enable($isWritable)
					
				End if 
				
				If ($menu.popup().selected)
					
					This:C1470.handleMenus($menu.choice)
					
				End if 
			End if 
			
			This:C1470.form.refresh()
			
			//______________________________________________________
		: ($e.expand)
			
			This:C1470.doSelectGroup($e.row)
			
			If (This:C1470.stringList.item.transunits=Null:C1517) || (This:C1470.stringList.item.transunits.length=0)
				
				// No trans-unit, so no expansion
				This:C1470.stringList.collapse($e.row; lk selection:K53:17)
				
			End if 
			
			// Select the break line
			//This.stringList.selectBreak($e.row)
			This:C1470.form.refresh()
			
			//______________________________________________________
		: ($e.gettingFocus)
			
			//If ($item=Null) && (This.stringList.rowsNumber>0)
			//// Select the first group
			//This.doSelectGroup(1; $e)
			//  //This.form.refresh()
			//End if 
			
			//______________________________________________________
		: ($e.beginDragOver)
			
			var $t : Text
			var $isForm : Boolean
			
			$t:=Get window title:C450(Next window:C448(This:C1470.form.window.ref))
			
			If (Position:C15("-"; $t)>0)  // Compatibility with 4DPop Windows, if any
				
				$t:=Delete string:C232($t; 1; Position:C15("-"; $t)+1)
				
			End if 
			
			$isForm:=Position:C15(String:C10(Formula from string:C1601(":C1578(\"common_form\")").call()); $t)=1
			
			If (Macintosh option down:C545 | Windows Alt down:C563)
				
				$isForm:=Not:C34($isForm)
				
			End if 
			
			If (OB Instance of:C1731($item; cs:C1710.XliffUnit))
				
				If (Shift down:C543)
					
					If (Position:C15("\n"; $item.source.value)>0)
						
						$t:=$isForm ? $item.source.value : "/*\r"+Replace string:C233($item.source.value; "\n"; "\r")+"\r*/"
						
					Else 
						
						$t:=$isForm ? $item.source.value : "// "+$item.source.value
						
					End if 
					
				Else 
					
					$t:=$isForm ? ":xliff:"+$item.resname : This:C1470.getItemCode($item)
					
				End if 
				
				SET TEXT TO PASTEBOARD:C523($t)
				
			Else 
				
				If ($isForm)\
					 || ($item.transunits=Null:C1517)\
					 || ($item.transunits.length=0)
					
					return 
					
				End if 
				
				SET TEXT TO PASTEBOARD:C523(This:C1470.getItemCode($item))
				
			End if 
			
			//______________________________________________________
		: ($e.delete)
			
			This:C1470.doDeleteString()
			
			//______________________________________________________
		Else 
			
			This:C1470.updateMenus()
			
			//______________________________________________________
	End case 
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function doNewFile()
	
	var $name; $t : Text
	var $indx : Integer
	var $file : 4D:C1709.File
	
	// Create a new XLIFF file 
	$name:=Request:C163(Localized string:C991("FileName"))
	
	If (Not:C34(Bool:C1537(OK)))\
		 || (Length:C16($name)=0)
		
		return 
		
	End if 
	
	$name:=Replace string:C233($name; ".xliff"; "")
	$name:=Replace string:C233($name; ".xlf"; "")
	$name+=This:C1470.Editor.FILE_EXTENSION
	
	If (This:C1470.main.files.query("fullName= :1"; $name).pop()#Null:C1517)
		
		CONFIRM:C162(Replace string:C233(Localized string:C991("theFileAlreadyExists"); "{name}"; $name))
		
		If (Not:C34(Bool:C1537(OK)))
			
			return 
			
		End if 
	End if 
	
	//
	If (This:C1470.folders.length=0)
		
		var $folder : 4D:C1709.Folder
		$folder:=Folder:C1567(fk resources folder:K87:11; *).folder(This:C1470.main.language.lproj+This:C1470.Editor.FOLDER_EXTENSION)
		$folder.create()
		This:C1470.folders.push($folder)
		
	End if 
	
	$file:=File:C1566("/RESOURCES/template.xlf").copyTo(This:C1470.folders.query("name = :1"; This:C1470.main.language.lproj).first(); $name; fk overwrite:K87:5)
	
	$t:=$file.getText()
	PROCESS 4D TAGS:C816($t; $t; This:C1470.default)
	$file.setText($t)
	
	This:C1470.main.files:=This:C1470.getFiles()
	
	// Update UI
	Form:C1466.files:=This:C1470.main.files
	This:C1470.fileList.select(This:C1470.main.files.indices("fullName = :1"; $name)[0]+1)
	This:C1470.stringList.item:=Null:C1517
	This:C1470._fileListManager({code: On Selection Change:K2:29})
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function doNewGroup()
	
	If (This:C1470.current=Null:C1517)
		
		return  // No file displayed
		
	End if 
	
	// Trigger string update
	This:C1470.form.removeFocus()
	
	var $resname : Text:=This:C1470.uniqueResname("group")
	var $group : cs:C1710.XliffGroup:=This:C1470.current.createGroup($resname)
	This:C1470.save(This:C1470.current)
	
	// Update localized files
	var $language : cs:C1710.language
	For each ($language; This:C1470.current.languages)
		
		var $xliff : cs:C1710.Xliff:=$language.xliff
		$xliff.createGroup($resname)
		This:C1470.save($xliff)
		
	End for each 
	
	// Update UI
	APPEND TO ARRAY:C911(This:C1470.groupPtr->; $resname)
	APPEND TO ARRAY:C911(This:C1470.resnamePtr->; "")
	APPEND TO ARRAY:C911(This:C1470.contentPtr->; $group)
	
	This:C1470.stringList.sort(1)
	
	var $row : Integer:=Find in array:C230((This:C1470.groupPtr)->; $resname)
	This:C1470.doSelectGroup($row)
	This:C1470.stringList.collapse($row)
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function doNewString()
	
	If (This:C1470.current=Null:C1517)
		
		return  // No file displayed
		
	End if 
	
	var $target : Object:=This:C1470.stringList.item
	
/* Capture the localizations from the displayed item now, before $target is
	   reassigned to a freshly-queried parent group that has none populated */
	var $localizations : Collection:=$target.localizations
	
	// Trigger string update
	This:C1470.form.removeFocus()
	
	If (OB Instance of:C1731($target; cs:C1710.XliffUnit))
		
		// Get parent group
		$target:=This:C1470.parentGroup($target)
		
	End if 
	
	If ($target=Null:C1517)
		
		return  // No group to add the string to (no current item, or its group was not found)
		
	End if 
	
	var $resname : Text:=This:C1470.uniqueResname("trans-unit")
	var $unit : cs:C1710.XliffUnit:=This:C1470.current.createUnit($target; $resname)
	This:C1470.save(This:C1470.current)
	
	// Update localized files
	var $item : Object
	For each ($item; $localizations)
		
		var $xliff : cs:C1710.Xliff:=$item.xliff
		var $group : cs:C1710.XliffGroup:=$xliff.groups.query("xpath = :1"; $target.xpath).pop()
		
		If (Asserted:C1132($group#Null:C1517))
			
			$xliff.createUnit($group; $resname; $unit.id)
			This:C1470.save($xliff)
			
		End if 
	End for each 
	
	// Update UI
	// The rows of the group are found by their content, not by the group name: a group renamed without Tab before
	// "+ String" already has its new name here, the list keeps the old one until the _UPDATE_RESNAME callback (CALL FORM)
	// runs after this event: Find in array returned -1 for an empty group, error 53
	var $c : Collection:=[]
	ARRAY TO COLLECTION:C1563($c; This:C1470.contentPtr->)
	var $row : Integer:=0
	var $other : Object
	
	If ($target.transunits.length=1)
		
		$row:=$c.indexOf($target)+1  // The row of the empty group shows the group
		
	Else 
		
		For each ($other; $target.transunits)
			
			If ($row=0) && ($other.id#$unit.id)
				
				$row:=$c.indexOf($other)+1  // A row of another string of the group
				
			End if 
		End for each 
	End if 
	
	If ($target.transunits.length=1) && ($row>0)
		
		This:C1470.resnamePtr->{$row}:=$resname
		This:C1470.contentPtr->{$row}:=$unit
		
	Else 
		
		// Same group name as the other rows of the group (the callback renames them together)
		APPEND TO ARRAY:C911((This:C1470.groupPtr)->; ($row>0) ? (This:C1470.groupPtr)->{$row} : $target.resname)
		APPEND TO ARRAY:C911((This:C1470.resnamePtr)->; $resname)
		APPEND TO ARRAY:C911((This:C1470.contentPtr)->; $unit)
		
	End if 
	
	This:C1470.stringList.sort(2)
	This:C1470.doSelectUnit(Find in array:C230((This:C1470.resnamePtr)->; $resname))
	
	This:C1470._HIGHLIGHTING_DUPLICATES()
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function _searchPickerManager($e : cs:C1710.ui.evt)
	
	$e:=$e || cs:C1710.ui.evt.new()
	
	If ($e.dataChange)
		
		// Perform the search
		This:C1470.doSearch(String:C10(This:C1470.searchPicker.data.value))
		
	End if 
	
	//MARK:-
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function doDeleteFile($file : 4D:C1709.File; $e : cs:C1710.ui.evt)
	
	var $language : Object
	var $xliff : cs:C1710.Xliff
	
	CONFIRM:C162(Replace string:C233(Localized string:C991("DeleteFile"); "{filename}"; $file.name))
	
	If (OK=0)
		
		return 
		
	End if 
	
	$e:=$e || cs:C1710.ui.evt.new()
	
	$file.delete()
	
	For each ($language; This:C1470.current.languages)
		
		$xliff:=$language.xliff
		$file:=$xliff.file
		$xliff.close()
		$file.delete()
		
	End for each 
	
	// Update UI
	Form:C1466.files.remove(Form:C1466.files.indices("fullName = :1"; $file.fullName)[0])
	
	If (Form:C1466.files.length>0)
		
		This:C1470.fileList.doSafeSelect($e.row)
		
	Else 
		
		This:C1470.fileList.item:=Null:C1517
		
	End if 
	
	$e.code:=On Selection Change:K2:29
	This:C1470._fileListManager($e)
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Renames a file of the reference language and the same file in every other language (*.lproj), as localizedFile() pairs them
	// (same name, or the language suffix: CommonEN.xlf / CommonFR.xlf). Nothing is renamed if one target name is taken.
	// $newName given: no dialog (tests). Returns {success; renamed: [{from; to}]; errors: []}
Function doRenameFile($file : 4D:C1709.File; $newName : Text) : Object
	
	var $result : Object:={success: False:C215; renamed: []; errors: []; existing: []; message: ""}
	var $interactive : Boolean:=(Count parameters:C259<2)
	
	If ($file=Null:C1517) || (Not:C34($file.exists))
		
		return $result
		
	End if 
	
	If ($interactive)
		
		$newName:=Request:C163(Localized string:C991("FileName"); $file.name)
		
		If (OK=0)
			
			return $result
			
		End if 
	End if 
	
	$newName:=Replace string:C233(Replace string:C233($newName; ".xliff"; ""); This:C1470.Editor.FILE_EXTENSION; "")
	
	If (Length:C16($newName)=0) || (Position:C15("/"; $newName)>0) || (Position:C15(":"; $newName)>0) || (Position:C15("\\"; $newName)>0)
		
		$result.errors.push("invalidName")
		
		If ($interactive)
			
			ALERT:C41(Localized string:C991("theNameMustNotBeEmpty"))
			
		End if 
		
		return $result
		
	End if 
	
	If (Compare strings($newName; $file.name; sk char codes)=0)
		
		$result.success:=True:C214  // Same name: nothing to do
		return $result
		
	End if 
	
	// The plan: the reference file, then each localized file that exists
	var $master : Text:=This:C1470.main.language.lproj
	var $target : 4D:C1709.File:=$file.parent.file($newName+This:C1470.Editor.FILE_EXTENSION)
	var $plan : Collection:=[{from: $file; to: $target}]
	var $folder : 4D:C1709.Folder
	var $from; $to : 4D:C1709.File
	var $xliff : cs:C1710.Xliff:=cs:C1710.Xliff.new($file)  // only for localizedFile()
	
	For each ($folder; This:C1470.folders)
		
		If ($folder.name=$master)
			
			continue
			
		End if 
		
		$from:=$xliff.localizedFile($file; $master; $folder.name)
		
		If ($from.exists)
			
			$plan.push({from: $from; to: $xliff.localizedFile($target; $master; $folder.name)})
			
		End if 
	End for each 
	
	$xliff.close()
	
	// Collisions (B30), compared without the case: on APFS (case-insensitive) "test1.xlf" IS "Test1.xlf". The real name of
	// the existing file is reported. The file itself in another case is not a collision: a case-only rename (test2 -> Test2),
	// done through a temporary name (_renameFile)
	var $step : Object
	var $other : 4D:C1709.File
	For each ($step; $plan)
		
		For each ($other; $step.to.parent.files())
			
			If (Compare strings:C1756($other.fullName; $step.to.fullName; sk case insensitive)=0)\
				 && (Compare strings:C1756($other.fullName; $step.from.fullName; sk char codes)#0)
				
				$result.errors.push($other.path)
				$result.existing.push($other.parent.fullName+"/"+$other.fullName)
				
			End if 
		End for each 
	End for each 
	
	If ($result.errors.length>0)
		
		// Only an information: nothing is renamed and nothing can be replaced (the former text, "theFileAlreadyExists",
		// is the question of the "new file" dialog, "Do you want to replace it?", shown here with OK only)
		$result.message:=Replace string:C233(Replace string:C233(Localized string:C991("renameFileExists"); \
			"{name}"; $newName+This:C1470.Editor.FILE_EXTENSION); "{files}"; $result.existing.join(", "))
		
		If ($interactive)
			
			ALERT:C41($result.message)
			
		End if 
		
		return $result
		
	End if 
	
	// The parsed files are closed and removed from the cache (their File objects point to the old paths)
	var $cached : Object
	For each ($step; $plan)
		
		For each ($cached; This:C1470.cache.query("file.path = :1"; $step.from.path))
			
			Try($cached.close())
			This:C1470.cache.remove(This:C1470.cache.indexOf($cached))
			
		End for each 
	End for each 
	
	// Rename, and undo the renamed ones if one fails
	var $renamed : 4D:C1709.File
	For each ($step; $plan)
		
		$renamed:=This:C1470._renameFile($step.from; $step.to.fullName)
		
		If ($renamed=Null:C1517)
			
			$result.errors.push($step.from.path)
			break
			
		End if 
		
		$result.renamed.push({from: $step.from.path; to: $renamed.path})
		
	End for each 
	
	If ($result.errors.length>0)
		
		var $done : Object
		For each ($done; $result.renamed.reverse())
			
			This:C1470._renameFile(File:C1566($done.to); File:C1566($done.from).fullName)
			
		End for each 
		
		$result.renamed:=[]
		
		If ($interactive)
			
			ALERT:C41(Localized string:C991("renameFileFailed"))
			
		End if 
		
		return $result
		
	End if 
	
	$result.success:=True:C214
	
	// Update UI: the list of files, the renamed file selected and displayed again
	This:C1470.main.files:=This:C1470.getFiles()
	Form:C1466.files:=This:C1470.main.files
	This:C1470.fileList.select(This:C1470.main.files.indices("fullName = :1"; $target.fullName)[0]+1)
	This:C1470.stringList.item:=Null:C1517
	This:C1470._fileListManager({code: On Selection Change:K2:29})
	
	return $result
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Renames a file, also when only the case changes (APFS: the new name "exists", it is the file itself): through a
	// temporary name in this case. Returns Null if the file does not have exactly the new name afterwards (it gets
	// its first name back if the second step fails)
Function _renameFile($file : 4D:C1709.File; $fullName : Text) : 4D:C1709.File
	
	var $renamed; $temp : 4D:C1709.File
	
	If (Compare strings:C1756($file.fullName; $fullName; sk case insensitive)=0)
		
		$temp:=Try($file.rename($file.name+" ("+Generate UUID:C1066+")"+$file.extension))
		
		If ($temp=Null:C1517) || (Not:C34($temp.exists))
			
			return Null:C1517
			
		End if 
		
		$renamed:=Try($temp.rename($fullName))
		
		If ($renamed=Null:C1517) || (Not:C34($renamed.exists))
			
			Try($temp.rename($file.fullName))
			return Null:C1517
			
		End if 
		
	Else 
		
		$renamed:=Try($file.rename($fullName))
		
	End if 
	
	If ($renamed=Null:C1517) || (Not:C34($renamed.exists))
		
		return Null:C1517
		
	End if 
	
	return $renamed
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function doDeleteString($confirm : Boolean)
	
	var $row : Integer
	var $c : Collection
	var $language : Object
	var $group : cs:C1710.XliffGroup
	var $unit : cs:C1710.XliffUnit
	
	var $target : Object:=This:C1470.stringList.item
	
	If ($target=Null:C1517)
		
		return 
		
	End if 
	
	If (Count parameters:C259=0 ? True:C214 : $confirm)
		
		CONFIRM:C162(Replace string:C233(\
			Localized string:C991(OB Instance of:C1731($target; cs:C1710.XliffUnit) ? "DeleteItem" : "DeleteGroup"); \
			"{item}"; $target.resname))
		
		If (OK=0)
			
			return 
			
		End if 
	End if 
	
	var $xliff : cs:C1710.Xliff:=This:C1470.current
	
	If (This:C1470.isGroup($target))
		
		// Update files
		$xliff.remove($target.node)
		This:C1470.save($xliff)
		
		For each ($language; This:C1470.current.languages)
			
			$xliff:=$language.xliff
			$group:=$xliff.groups.query("xpath = :1"; $target.xpath).pop()
			$xliff.remove($group.node)
			This:C1470.save($xliff)
			
		End for each 
		
		// Update UI
		While ($row#-1)
			
			$row:=Find in array:C230(This:C1470.groupPtr->; $target.resname)
			
			If ($row#-1)
				
				DELETE FROM ARRAY:C228((This:C1470.groupPtr)->; $row)
				DELETE FROM ARRAY:C228((This:C1470.resnamePtr)->; $row)
				DELETE FROM ARRAY:C228((This:C1470.contentPtr)->; $row)
				
			End if 
		End while 
		
		This:C1470.stringList.unselect()
		
	Else 
		
		$group:=$xliff.deleteUnit($target)
		This:C1470.save($xliff)
		
		// Update localized files
		For each ($language; This:C1470.current.languages)
			
			$xliff:=$language.xliff
			$unit:=$xliff.groups.query("transunits[].id =:1"; $target.id).pop()\
				.transunits.query("id = :1"; $target.id).pop()
			$xliff.deleteUnit($unit)
			This:C1470.save($xliff)
			
		End for each 
		
		$group:=This:C1470.parentGroup($target)
		
		// Row of the deleted string (not the first row of its group: deleting another string of the group
		// removed the wrong row, the deleted string stayed in the list with a node no longer in the tree: error -9926 on a new Delete)
		$c:=[]
		ARRAY TO COLLECTION:C1563($c; This:C1470.contentPtr->)
		$row:=$c.indexOf($target)+1
		
		If ($row=0)
			
			return  // Not in the list
			
		End if 
		
		If ($group.transunits=Null:C1517) || ($group.transunits.length=0)
			
			// The group is now empty: its row shows the group (as in _LOAD_STRINGS)
			(This:C1470.resnamePtr)->{$row}:=""
			(This:C1470.contentPtr)->{$row}:=$group
			
			// Select the break line, collapse & select
			This:C1470.stringList.collapse($row; lk selection:K53:17)
			This:C1470.stringList.selectBreak($row)
			This:C1470.doSelectGroup($row)
			
		Else 
			
			DELETE FROM ARRAY:C228((This:C1470.groupPtr)->; $row)
			DELETE FROM ARRAY:C228((This:C1470.resnamePtr)->; $row)
			DELETE FROM ARRAY:C228((This:C1470.contentPtr)->; $row)
			
			// Select the next string of the group, or the previous one if the deleted string was the last one
			If ($row>Size of array:C274(This:C1470.groupPtr->)) || ((This:C1470.groupPtr)->{$row}#$group.resname)
				
				$row-=1
				
			End if 
			
			This:C1470.stringList.doSafeSelect($row)
			This:C1470.doSelectUnit($row)
			
		End if 
	End if 
	
	This:C1470._HIGHLIGHTING_DUPLICATES()
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function getItemCode($item : Object; $type : Text) : Text
	
	var $code; $format; $resname : Text
	var $b : Boolean
	var $o : Object
	var $file : 4D:C1709.File
	
	ARRAY LONGINT:C221($len; 0)
	ARRAY LONGINT:C221($pos; 0)
	
	// Is it an external code?
	$file:=File:C1566("/RESOURCES/4DPop xliff/"+$type+(This:C1470.isGroup($item) ? ".group" : ".unit"))
	
	If (Not:C34($file.exists))
		
		// Try host
		$file:=File:C1566("/RESOURCES/4DPop xliff/"+$type+(This:C1470.isGroup($item) ? ".group" : ".unit"); *)
		
	End if 
	
	If ($file.exists)
		
		$code:=$file.getText()
		PROCESS 4D TAGS:C816($code; $code; $item)
		return $code
		
	End if 
	
	If (This:C1470.isGroup($item))
		
		// Construct the code to load all strings into a collection
		$code:="var $c : Collection\r"
		$code+="$c:="+Command name:C538(1472)+"\r"
		
		// Check if the resnames are indexed, to reduce the code to a loop
		If ($item.transunits.every(Formula:C1597(Match regex:C1019("(?mi-s)_\\d+$"; $1.value.resname; 1))))
			
			$b:=Match regex:C1019("(?mi-s)_(\\d+)$"; $item.transunits[0].resname; 1; $pos; $len)
			$resname:=Substring:C12($item.transunits[0].resname; 1; $pos{0})
			
/*
⚠️ We assume that if the number of strings is >=10,
indexes < 10 are prefixed by 0.
*/
			$format:="0"*$len{1}
			
			$code+=Command name:C538(1)="Sum" ? "For" : "Boucle"
			$code+="($i;1;"+String:C10($item.transunits.length)+")\r"
			$code+="$c.push("+Command name:C538(991)+"(\""+$resname+"\"+"+Command name:C538(10)+"($i; \""+$format+"\")))\r"
			$code+=Command name:C538(1)="Sum" ? "End for" : "Fin de boucle"
			$code+="\r"
			
		Else 
			
			For each ($o; $item.transunits)
				
				$code+="$c.push("+This:C1470.getItemCode($o)+")\r"
				
			End for each 
		End if 
		
	Else 
		
		If (Match regex:C1019("(?mi-s)(\\{[^}]*\\})"; $item.source.value; 1; $pos; $len))
			
			// -> Replace string(Get localized string("resname");"{xxxx}";$VALUE)
			$code:=Command name:C538(233)+"("\
				+Command name:C538(991)+"(\""+$item.resname+"\");\""\
				+Substring:C12($item.source.value; $pos{1}; $len{1})\
				+"\";$VALUE)"
			
		Else 
			
			// -> Get localized string("resname")
			$code:=Command name:C538(991)+"(\""+$item.resname+"\")"
			
		End if 
	End if 
	
	return $code
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function doSearch($searchText : Text; $e : cs:C1710.ui.evt)
	
	$e:=$e || cs:C1710.ui.evt.new()
	
	var $data : Object:=This:C1470.searchPicker.data
	
	If ($data.value=Null:C1517)
		
		return 
		
	End if 
	
	$searchText:=$searchText || $data.value
	
	If (Length:C16($searchText)=0)
		
		$data.start:=0
		return 
		
	End if 
	
	// Perform a search by content
	$searchText:="@"+$searchText+"@"  // Contains
	
	// Manage the starts searching element number
	$data.start:=Num:C11($data.start)<=0 ? 0 : $data.start
	var $initialSearch : Boolean:=$data.start=0
	
	// Doing the search from the current position
	$data.start+=1
	$data.start:=Find in array:C230((This:C1470.resnamePtr)->; $searchText; $data.start)
	
	If ($data.start<0)
		
		// Start from scratch
		$data.start:=Find in array:C230((This:C1470.resnamePtr)->; $searchText)
		This:C1470._wrapTimer:=10
		This:C1470.wrap.show()
		
	End if 
	
	If ($data.start>0)
		
		If ($initialSearch)
			
			// Trick to force update (I'm not proud of it)
			var $coord : cs:C1710.ui.coordinates:=This:C1470.stringList.cellCoordinates(2; $data.start)
			POST CLICK:C466($coord.left+40; $coord.top+10)
			
		Else 
			
			// Select & scroll
			$e.column:=2
			$e.row:=$data.start
			
			This:C1470.setCurrentString($e)
			This:C1470.doSelectUnit($e.row)
			
		End if 
		
		This:C1470.form.callMeBack(Null:C1517; "_SELECT_STRING")
	Else 
		
		BEEP:C151
		
		$data.start:=0
		This:C1470._wrapTimer:=0
		This:C1470.wrap.hide()
		
		This:C1470.menuBar.disableItem("findNext")
		
	End if 
	
	This:C1470.detail.refresh()
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function uniqueResname($what : Text) : Text
	
	var $queryString; $resname; $t : Text
	var $indx : Integer
	
	$indx:=1
	$t:=Localized string:C991($what="group" ? "NewGroup" : "NewItem")
	$resname:=$t+" "+String:C10($indx)
	
	$queryString:=$what="group" ? "resname = :1" : "transunits[].resname = :1"
	
	While (This:C1470.current.groups.query($queryString; $resname).length>0)
		
		$indx+=1
		$resname:=$t+" "+String:C10($indx)
		
	End while 
	
	return $resname
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function setCurrentString($e : cs:C1710.ui.evt) : Object
	
	If (Bool:C1537(Form:C1466.TRACE))
		TRACE:C157
	End if 
	
	If ($e.row=0)
		
		This:C1470.stringList.item:=Null:C1517
		This:C1470.detail.refresh()
		
		return 
		
	End if 
	
	This:C1470.stringList.item:=This:C1470._populateString($e.column; $e.row)
	This:C1470.detail.refresh()
	
	return This:C1470.stringList.item
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _populateString($column : Integer; $row : Integer) : Object
	
	var $file : 4D:C1709.File
	var $xliff : cs:C1710.Xliff
	
	//%W-533.3
	var $o : Object:=(This:C1470.contentPtr)->{$row}
	//%W+533.3
	
	var $isGroup : Boolean:=($column=1) & (OB Instance of:C1731($o; cs:C1710.XliffUnit))
	var $string : Object:=$isGroup ? This:C1470.parentGroup($o) : $o
	
	If (Structure file:C489=Structure file:C489(*))
		
		ASSERT:C1129($string#Null:C1517)
		
	End if 
	
	If ($string.localizations=Null:C1517 ? True:C214 : ($string.localizations.length=0))
		
		// Open or create the target language
		$string.localizations:=[]
		
		var $language : cs:C1710.language
		
		For each ($language; This:C1470.languages)
			
			If ($language.xliff=Null:C1517)
				
				$file:=This:C1470.current.localizedFile(This:C1470.fileList.item; This:C1470.main.language.lproj; $language.lproj)
				
				$xliff:=This:C1470.cache.query("file.path = :1"; $file.path).first()
				
				If ($xliff=Null:C1517)
					
					$xliff:=This:C1470.parse($file)
					
				End if 
				
				$language.root:=$xliff.root
				
				If ($isGroup)
					
					$string.localizations.push({\
						language: $language; \
						xliff: $xliff\
						})
					
				Else 
					
					var $attributes : Object:=Null:C1517
					var $node : Text:=$xliff.findById($string.id)
					
					If ($xliff.isNotNull($node))
						
						$node:=$xliff.targetNode($node)
						
						If ($xliff.isNotNull($node))
							
							$attributes:=$xliff.getAttributes($node)
							
						End if 
					End if 
					
					$string.localizations.push({\
						language: $language; \
						xliff: $xliff; \
						properties: $attributes\
						})
					
				End if 
			End if 
		End for each 
	End if 
	
	return $string
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function doSelectFile($row : Integer; $e : cs:C1710.ui.evt)
	
	// Select the file
	This:C1470.fileList.select($row)
	
	// & call back the _fileListManager manager
	$e:=$e || cs:C1710.ui.evt.new()
	$e.column:=1
	$e.row:=$row
	$e.code:=On Selection Change:K2:29
	This:C1470._fileListManager($e)
	
	This:C1470.fileList.focus()
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function doSelectGroup($row : Integer; $e : cs:C1710.ui.evt; $keepFocus : Boolean)
	
	$row:=$row<=0 ? 1 : $row
	
	This:C1470.stringList.unselect()
	This:C1470.stringList.selectBreak($row)
	
	var $item : Object:=(This:C1470.stringList.columnPtr("content"))->{$row}
	This:C1470.stringList.item:=$item
	
	// Call back the stringList manager
	$e:=$e || cs:C1710.ui.evt.new()
	$e.column:=1
	$e.row:=$row
	$e.code:=On Selection Change:K2:29
	This:C1470._stringListManager($e; True:C214)
	
	If (Not:C34($keepFocus))
		
		This:C1470.stringList.focus()
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Name of the object that has the focus in the editor form
Function _focusedObject() : Text
	
	return OBJECT Get name:C1087(Object with focus)
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function doSelectUnit($row : Integer)
	
	If ($row<1)
		
		return  // Row not found
		
	End if 
	
/* A row just added with APPEND TO ARRAY is not yet in the Boolean array of the list box
	   (no immediate synchronization), and stringList.select() writes into that array: error 53
	   when the new row is beyond its size (new string sorted last)*/
	var $selection : Pointer:=OBJECT Get pointer:C1124(Object named:K67:5; This:C1470.stringList.name)
	
	If (Size of array:C274($selection->)<$row)
		
		INSERT IN ARRAY:C227($selection->; Size of array:C274($selection->)+1; $row-Size of array:C274($selection->))
		
	End if 
	
	// Expand group if any
	If (This:C1470.stringList.item#Null:C1517) && (This:C1470.isGroup(This:C1470.stringList.item))
		
		This:C1470.stringList.expand($row; lk break row:K53:18)
		
	End if 
	
	This:C1470.stringList.select($row)
	
	// The string itself, not only its row: a callback queued before (_UPDATE_RESNAME of a renamed group) can sort
	// the list again before _SELECT_STRING runs, the row then shows another string (B25)
	This:C1470.form.callMeBack({row: $row; item: (This:C1470.contentPtr)->{$row}}; "_SELECT_STRING")
	This:C1470.stringList.focus()
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// True if another group (for a group) or another string of the displayed file (for a string) has this name,
	// ignoring the case and the accents: XLIFF resnames are case sensitive, but the editor finds groups and rows with
	// queries and Find in array, which ignore the case ("debit" next to "Debit": a click on one selected the other).
	// Refusing such near-duplicates keeps the files unambiguous for both. Renaming an item to another case of its own
	// name stays possible (B26): the item itself is not compared.
	// A string is identified in the whole file, not in its group: Localized string(resname) has no group or file parameter.
	// Same resname with another d4:includeIf (mac/win variants) is allowed, as in XliffFolder (identity = resname + d4:includeIf)
Function isResnameTaken($string : Object; $xliff : cs:C1710.Xliff) : Boolean
	
	$xliff:=$xliff || This:C1470.current
	
	If ($string=Null:C1517) || ($xliff=Null:C1517)
		
		return False:C215
		
	End if 
	
	var $isGroup : Boolean:=OB Instance of:C1731($string; cs:C1710.XliffGroup)
	var $others : Collection:=$isGroup ? $xliff.groups : $xliff.allUnits
	var $other : Object
	
	For each ($other; $others)
		
		If ($other#$string)\
			 && (Compare strings(String:C10($other.resname); String:C10($string.resname); sk case insensitive+sk diacritic insensitive)=0)\
			 && ($isGroup || (String:C10($other.attributes["d4:includeIf"])=String:C10($string.attributes["d4:includeIf"])))
			
			return True:C214
			
		End if 
	End for each 
	
	return False:C215
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function parentGroup($unit : Object) : Object
	
	var $c : Collection
	
	$c:=Split string:C1554($unit.xpath; "/")
	$c.pop()
	
	return This:C1470.current.groups.query("xpath = :1"; $c.join("/")).pop()
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns a collection of all xliff files for a given language (main by default)
Function getFiles($language : Text) : Collection
	
	var $attributes : Object
	var $files : Collection
	var $file : 4D:C1709.File
	var $folder : 4D:C1709.Folder
	var $xliff : cs:C1710.Xliff
	
	$files:=[]
	
	$folder:=This:C1470.folders.query("name = :1"; $language || This:C1470.main.language.lproj).pop()
	
	If ($folder#Null:C1517)
		
		For each ($file; $folder.files().query("extension = :1"; This:C1470.Editor.FILE_EXTENSION))
			
			$xliff:=cs:C1710.Xliff.new($file)
			
			If (Not:C34($xliff.success))
				
				continue
				
			End if 
			
			$attributes:=$xliff.getAttributes($xliff.fileNode)
			$xliff.close()
			
			If (String:C10($attributes.datatype)="x-4DK#")
				
				// No management of constant files
				continue
				
			End if 
			
			$files.push($file)
			
		End for each 
	End if 
	
	return $files.length>0 ? $files.orderBy("name") : $files
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function parse($file : 4D:C1709.File) : cs:C1710.Xliff
	
	var $xliff : cs:C1710.Xliff:=cs:C1710.Xliff.new($file)
	
	If (Not:C34($xliff.success))
		
		return {\
			success: False:C215; \
			error: "Failed to open the file "+$file.path\
			}
		
	End if 
	
	This:C1470.cache.push($xliff)
	
	return $xliff.parse()
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function save($xliff : cs:C1710.Xliff; $force : Boolean)
	
	// Mark the file as modified
	$xliff.modified:=True:C214
	
	If (This:C1470.AUTOSAVE | $force)
		
		$xliff.save()
		
	Else 
		
		// TODO: Save it later after confirmation
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function deDuplicateIDs()
	
	var $language : Object
	var $after; $before : Collection
	var $parent; $xliff : cs:C1710.Xliff
	
	CONFIRM:C162(\
		Replace string:C233(Localized string:C991("makingTheIdsUniqueWillPreventTheOldCommand"); "{command}"; Command name:C538(506)); \
		Localized string:C991("iHaveUnderstoodWell"))
	
	If (Not:C34(Bool:C1537(OK)))
		
		return 
		
	End if 
	
	$xliff:=This:C1470.current
	
	$before:=$xliff.allUnits.copy()
	
	If ($xliff.deDuplicateIDs())
		
		$after:=$xliff.allUnits.copy()
		$parent:=$xliff
		
		For each ($language; $parent.languages)
			
			$xliff:=This:C1470.cache.query("root = :1"; $language.xliff.root).pop()
			$xliff.deDuplicateIDs($before; $after)
			
			If (Not:C34($xliff.success))
				
				break
				
			End if 
		End for each 
		
		If ($xliff.success)
			
			// Save & close All
			$xliff:=This:C1470.current
			This:C1470.save($xliff; True:C214)
			This:C1470.cache.remove(This:C1470.cache.indexOf($xliff))
			$xliff.close()
			
			For each ($language; $parent.languages)
				
				$xliff:=This:C1470.cache.query("root = :1"; $language.xliff.root).pop()
				This:C1470.save($xliff; True:C214)
				This:C1470.cache.remove(This:C1470.cache.indexOf($xliff))
				$xliff.close()
				
			End for each 
			
			// Reload
			This:C1470.stringList.item:=This:C1470._populateString(1; 1)
			This:C1470._fileListManager({code: On Selection Change:K2:29})
			
			This:C1470.form.refresh()
			
		Else 
			
			BEEP:C151
			ALERT:C41(Localized string:C991("uniqueIdsAssignmentFailure"))
			
		End if 
	End if 
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** 
Function _synchronizeAttributes($parent : Object; $string : Object; $attributes : Object)
	
	var $langue : Object
	
	For each ($langue; $parent.languages)
		
		// Update the XML tree of the localized file of THIS string ($langue.root is the one of the last string
		// loaded, possibly of another file: the attributes were written into the wrong file, as for B18)
		var $own : Object:=($string.localizations=Null:C1517) ? Null:C1517 : $string.localizations.query("language.lproj = :1"; $langue.lproj).first()
		var $xliff : cs:C1710.Xliff:=(($own#Null:C1517) && ($own.xliff#Null:C1517)) ? $own.xliff : $parent.cache.query("root = :1"; $langue.root).pop()
		
		If ($xliff=Null:C1517)
			
			continue
			
		End if 
		
		var $node : Text:=$xliff.findById($string.id)
		
		If ($xliff.success)
			
			$xliff.setAttributes($node; $attributes; True:C214)
			
			This:C1470.save($xliff)
			
		End if 
	End for each 
	
	//MARK:-[CALLBACKS]
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function _DISPLAY_FILE()
	
	// Take from cache if available
	var $xliff : cs:C1710.Xliff:=This:C1470.cache.query("file.path = :1"; This:C1470.fileList.item.path).first()
	
	var $language : cs:C1710.language
	var $file : 4D:C1709.File
	
	If ($xliff=Null:C1517)
		
		IDLE:C311
		
		$xliff:=This:C1470.parse(This:C1470.fileList.item)
		
		This:C1470.current:=$xliff
		
		If ($xliff.success)\
			 || ($xliff.error=Null:C1517)
			
			// Prepare the languages
			This:C1470.current.languages:=[]
			
			// We use one worker for each language.
			var $parallel:=[]
			For each ($language; This:C1470.languages)
				
				If ($language=Null:C1517)
					
					continue
					
				End if 
				
				var $signal:=New signal:C1641($language.lproj)
				
				Use ($signal)
					
					$signal.source:=This:C1470.main.language.lproj
					$signal.target:=$language.lproj  //OB Copy($language; ck shared; $signal)
					$signal.reference:=OB Copy:C1225($xliff; ck shared:K85:29; $signal)
					$signal.item:=OB Copy:C1225(This:C1470.fileList.item; ck shared:K85:29; $signal)
					
				End use 
				
				CALL WORKER:C1389("$4DPop XLIFF - "+$language.lproj; Formula:C1597(EDITOR_PARSE_LANGUAGE).source; $signal)
				$parallel.push($signal)
				
			End for each 
			
			Repeat 
				
				For each ($signal; $parallel.reverse())
					
					If ($signal.signaled)
						
						var $indx:=$parallel.indexOf($signal)
						var $cache : cs:C1710.Xliff:=OB Copy:C1225($signal.xliff)  // Make unshared
						
						This:C1470.current.languages.push({\
							language: $signal.language; \
							xliff: $cache})
						
						This:C1470.cache.push($cache)
						
						$parallel.remove($indx)
						
					End if 
				End for each 
				
				IDLE:C311
				
			Until ($parallel.length=0)
			
		Else 
			
			ALERT:C41($xliff.error)
			
		End if 
		
	Else 
		
		// Take it
		This:C1470.current:=$xliff
		
	End if 
	
	This:C1470.form.deferTimer(This:C1470.LOAD_STRINGS)
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function _SELECT_STRING($data : Object)
	
	var $e : cs:C1710.ui.evt:=cs:C1710.ui.evt.new()
	
	If ($data=Null:C1517)
		
		$data:=This:C1470.searchPicker.data
		
		$e.column:=2
		$e.row:=$data.start
		
		This:C1470.setCurrentString($e)
		This:C1470.doSelectUnit($e.row)
		
		This:C1470.detail.refresh()
		
	Else 
		
		If ($data.item#Null:C1517)
			
			// Its row now (the list may have been sorted again since doSelectUnit)
			var $c : Collection:=[]
			ARRAY TO COLLECTION:C1563($c; This:C1470.contentPtr->)
			var $row : Integer:=$c.indexOf($data.item)+1
			
			If ($row>0)
				
				$data.row:=$row
				
			End if 
		End if 
		
		This:C1470.stringList.select($data.row)
		
		// Call the stringList manager
		$e.column:=2
		$e.row:=$data.row
		$e.code:=On Selection Change:K2:29
		This:C1470._stringListManager($e; True:C214)
		
	End if 
	
	This:C1470.stringList.focus()
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function _LOAD_STRINGS()
	
	var $group : cs:C1710.XliffGroup
	var $unit : cs:C1710.XliffUnit
	
	ARRAY TEXT:C222($groupResnames; 0x0000)
	ARRAY TEXT:C222($stringResnames; 0x0000)
	ARRAY OBJECT:C1221($units; 0x0000)
	
	var $xliff : cs:C1710.Xliff:=This:C1470.current
	
	If ($xliff.groups.length>0)
		
		For each ($group; $xliff.groups)
			
			If ($group.transunits.length>0)
				
				For each ($unit; $group.transunits)
					
					APPEND TO ARRAY:C911($groupResnames; String:C10($group.resname))
					APPEND TO ARRAY:C911($stringResnames; String:C10($unit.resname))
					APPEND TO ARRAY:C911($units; $unit)
					
				End for each 
				
			Else 
				
				APPEND TO ARRAY:C911($groupResnames; String:C10($group.resname))
				APPEND TO ARRAY:C911($stringResnames; "")
				APPEND TO ARRAY:C911($units; $group)
				
			End if 
		End for each 
	End if 
	
	//%W-518.1
	COPY ARRAY:C226($groupResnames; This:C1470.groupPtr->)
	COPY ARRAY:C226($stringResnames; This:C1470.resnamePtr->)
	COPY ARRAY:C226($units; This:C1470.contentPtr->)
	//%W+518.1
	
	This:C1470.withFile.show()
	This:C1470.wrap.hide()
	
	This:C1470.stringList.collapseAll().unselect()
	
	// Reset resname color
	This:C1470.stringList.resetForegroundColor(2)
	
	This:C1470.spinner.stop(True:C214)
	
	// Always: the flags of a cached file may be stale
	This:C1470.form.callMeBack({expand: True:C214}; "_HIGHLIGHTING_DUPLICATES")
	
	This:C1470.locked.show($xliff.duplicateID)
	This:C1470.form.refresh()
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function _HIGHLIGHTING_DUPLICATES($data : Object)
	
	// Recomputed from scratch for the whole file, after loading, deleting, creating or renaming: the flags and the red
	// rows were only set (never cleared) when the file was loaded, so a string stayed red once its duplicate was deleted.
	// Same rule as isResnameTaken() (B28): another string of the file with the same resname, ignoring the case and the
	// accents, and the same d4:includeIf (a mac and a win variant are not duplicates)
	If (This:C1470.current=Null:C1517)
		
		return 
		
	End if 
	
	var $expand : Boolean:=($data#Null:C1517) && Bool:C1537($data.expand)
	var $current : Object:=This:C1470.stringList.item
	var $wasDuplicated : Boolean:=OB Instance of:C1731($current; cs:C1710.XliffUnit) && Bool:C1537($current.duplicateResname)
	var $unit; $other : Object
	var $buckets : Object:={}
	var $key : Text
	
	For each ($unit; This:C1470.current.allUnits)
		
		$unit.duplicateResname:=False:C215
		
		// Same length first (cheap), then Compare strings
		$key:=String:C10(Length:C16(String:C10($unit.resname)))
		
		If ($buckets[$key]=Null:C1517)
			
			$buckets[$key]:=[]
			
		End if 
		
		$buckets[$key].push($unit)
		
	End for each 
	
	var $bucket : Collection
	var $i; $j : Integer
	
	For each ($key; $buckets)
		
		$bucket:=$buckets[$key]
		
		For ($i; 0; $bucket.length-2)
			
			For ($j; $i+1; $bucket.length-1)
				
				$unit:=$bucket[$i]
				$other:=$bucket[$j]
				
				If (String:C10($unit.attributes["d4:includeIf"])=String:C10($other.attributes["d4:includeIf"]))\
					 && (Compare strings(String:C10($unit.resname); String:C10($other.resname); sk case insensitive+sk diacritic insensitive)=0)
					
					$unit.duplicateResname:=True:C214
					$other.duplicateResname:=True:C214
					
				End if 
			End for 
		End for 
	End for each 
	
	This:C1470.current.duplicateResname:=This:C1470.current.allUnits.query("duplicateResname = :1"; True:C214).length>0
	
	// UI: every row again (the colors are per row: after a deletion, an insertion or a sort they were on other strings)
	This:C1470.stringList.resetForegroundColor(2)
	
	var $row : Integer
	For ($row; 1; Size of array:C274(This:C1470.contentPtr->))
		
		$unit:=(This:C1470.contentPtr)->{$row}
		
		If (OB Instance of:C1731($unit; cs:C1710.XliffUnit)) && (Bool:C1537($unit.duplicateResname))
			
			This:C1470.stringList.setRowForegroundColor($row; "red"; 2)
			
			If ($expand)
				
				// Expand the group (when the file is loaded)
				This:C1470.stringList.expand(Find in array:C230(This:C1470.groupPtr->; (This:C1470.groupPtr)->{$row}); lk break row:K53:18)
				
			End if 
		End if 
	End for 
	
	// The resname field of the editor (red background, white text) follows the flag of the current string:
	// refreshed only when it changed (a refresh during a Tab to the languages would disturb the entry, B16/B17)
	If (OB Instance of:C1731($current; cs:C1710.XliffUnit)) && (Bool:C1537($current.duplicateResname)#$wasDuplicated)
		
		This:C1470.detail.refresh()
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function _UPDATE_SOURCE($context : Object)
	
	var $string : Object:=$context.string
	
	// Update the reference XML tree
	var $xliff : cs:C1710.Xliff:=$context.file
	var $unitNode : Text:=$xliff.findById($string.id)
	var $sourceNode : Text:=$xliff.sourceNode($unitNode; True:C214)
	var $targetNode : Text:=$xliff.targetNode($unitNode; True:C214)
	
	$xliff.setValue($sourceNode; $string.source.value)
	$xliff.setValue($targetNode; $string.source.value)
	
	This:C1470.save($xliff)
	
	var $localization : Object
	For each ($localization; $string.localizations)
		
		// Update the XML tree
		$xliff:=$localization.xliff
		$unitNode:=$xliff.findById($string.id)
		$sourceNode:=$xliff.sourceNode($unitNode; True:C214)
		$targetNode:=$xliff.targetNode($unitNode; True:C214)
		
		var $isNew : Boolean:=Length:C16(String:C10($xliff.getValue($sourceNode)))=0
		
		$xliff.setValue($sourceNode; $string.source.value)
		
		Case of 
				
				//______________________________________________________
			: ($isNew)
				
				$xliff.setValue($targetNode; $string.source.value)
				$xliff.setState($targetNode; $xliff.STATE_NEW)
				
				//______________________________________________________
			: (String:C10($xliff.getAttributes($targetNode).state)=$xliff.STATE_NEW)
				
				$xliff.setValue($targetNode; $string.source.value)
				
				//______________________________________________________
			Else 
				
				$xliff.setState($targetNode; $xliff.STATE_NEEDS_REVIEW)
				
				//______________________________________________________
		End case 
		
		This:C1470.save($xliff)
		
		// Updating of UI elements
		$localization.properties:=$localization.properties || {}
		$localization.properties.state:=$xliff.STATE_NEEDS_REVIEW
		
	End for each 
	
	This:C1470.detail.refresh()
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function _UPDATE_RESNAME($context : Object)
	
	var $ptr : Pointer
	var $row : Integer
	var $target : Object:=$context.string
	var $xliff : cs:C1710.Xliff:=$context.file
	var $parent : Object:=$context.parent
	
	// The target must belong to the file of the context (the string shown in the editor can be one of a file displayed before):
	// otherwise its node is in another tree and the UI rows are not its rows (error -10713)
	If ($target=Null:C1517) || ($xliff=Null:C1517)
		
		return 
		
	End if 
	
	var $in : Collection:=This:C1470.isGroup($target) ? $xliff.groups : $xliff.allUnits
	
	If ($in.indexOf($target)<0)
		
		return 
		
	End if 
	
	// The list shows this file (not another one displayed since the name was edited)
	// ... and the file list still shows it: after a click on another file, the callback can run before _DISPLAY_FILE
	// (This.current not replaced yet): doSelectGroup then made the group of the previous file current again
	var $isDisplayed : Boolean:=($xliff=This:C1470.current)\
		 && ((This:C1470.fileList.item=Null:C1517) || (String:C10(This:C1470.fileList.item.path)=$xliff.file.path))
	
	$xliff.setAttribute($target.node; "resname"; $target.resname)
	This:C1470.save($xliff)
	
	// MARK:-Group
	If (This:C1470.isGroup($target))
		
		var $group : cs:C1710.XliffGroup:=$xliff.groups.query("previous = :1"; $target.previous).first()
		$group.setResname($target.resname)
		This:C1470.save($xliff)
		
		var $item : Object
		For each ($item; $target.localizations)
			
			$xliff:=$item.xliff
			
			// Resnames are case sensitive (XLIFF, Localized string): "debit" -> "Debit" is a rename
			$group:=Null:C1517
			var $g : cs:C1710.XliffGroup
			For each ($g; $xliff.groups)
				
				If ($group=Null:C1517) && (Compare strings(String:C10($g.resname); $target.previous; sk char codes)=0)
					
					$group:=$g
					
				End if 
			End for each 
			
			If ($group#Null:C1517)
				
				$xliff.setAttribute($group.node; "resname"; $target.resname)
				This:C1470.save($xliff)
				
				$group.setResname($target.resname)
				
			End if 
		End for each 
		
		If (Not:C34($isDisplayed))
			
			OB REMOVE:C1226($target; "previous")
			return 
			
		End if 
		
		// UI
		var $selected : Object:=This:C1470.stringList.item  // A string of the group created before this callback ran ("+ String" without Tab)
		
		// The rows of the group: same name with the same case (Find in array ignores the case, "debit" -> "Debit" looped)
		var $i : Integer
		For ($i; 1; Size of array:C274(This:C1470.groupPtr->))
			
			If (Compare strings((This:C1470.groupPtr)->{$i}; $target.previous; sk char codes)=0)
				
				(This:C1470.groupPtr)->{$i}:=$target.resname
				
			End if 
		End for 
		
		This:C1470.stringList.sort(1)
		
		This:C1470._HIGHLIGHTING_DUPLICATES()  // rows moved by the sort
		
		If (OB Instance of:C1731($selected; cs:C1710.XliffUnit)) && ($target.transunits#Null:C1517) && ($target.transunits.query("id = :1"; String:C10($selected.id)).length>0)
			
			// Keep the string selected
			var $rows : Collection:=[]
			ARRAY TO COLLECTION:C1563($rows; This:C1470.contentPtr->)
			This:C1470.doSelectUnit($rows.indexOf($selected)+1)
			OB REMOVE:C1226($target; "previous")
			return 
			
		End if 
		
		// First row of the group (same case)
		$row:=-1
		For ($i; 1; Size of array:C274(This:C1470.groupPtr->))
			
			If ($row=-1) && (Compare strings((This:C1470.groupPtr)->{$i}; $target.resname; sk char codes)=0)
				
				$row:=$i
				
			End if 
		End for 
		
		// Without taking the focus: this callback runs after the resname field lost the focus (Tab, or a click elsewhere)
		This:C1470.doSelectGroup($row; Null:C1517; True:C214)
		
		If (This:C1470.stringList.item.transunits=Null:C1517)\
			 || (This:C1470.stringList.item.transunits.length=0)
			
			// No trans-unit, so no expansion
			This:C1470.stringList.collapse($row)
			
		End if 
		
		// A group has only its name in the editor: Tab leaves it for the next object of the EDITOR entry order
		// (standard order = layering of the objects, the file list comes after the editor). Stay with the group:
		// the string list, the group selected. Not after a click on another object or another file
		If (This:C1470._focusedObject()=This:C1470.fileList.name)\
			 && (This:C1470.fileList.item#Null:C1517)\
			 && (String:C10(This:C1470.fileList.item.path)=$context.file.file.path)
			
			This:C1470.stringList.focus()
			
		End if 
		
		OB REMOVE:C1226($target; "previous")
		
		return 
		
	End if 
	
	// MARK:-Unit: Synchronize attributes of other files
	This:C1470._synchronizeAttributes($context.parent; $target; $xliff.getAttributes($target.node))
	
	// MARK:-UI
	If (Not:C34($isDisplayed))
		
		return 
		
	End if 
	
	var $c:=[]
	ARRAY TO COLLECTION:C1563($c; This:C1470.stringList.columnPtr("content")->)
	$row:=$c.indexOf($target)+1  // Its row (by id, a string of another file with the same id could match)
	
	If ($row=0)
		
		return 
		
	End if 
	
	(This:C1470.stringList.columnPtr("unit"))->{$row}:=$target.resname
	This:C1470.stringList.sort(2)
	
	This:C1470._HIGHLIGHTING_DUPLICATES()  // the rename can create or remove a duplicate
	
	// No stringList.focus() here: this callback runs after the resname field lost the focus (Tab),
	// giving the focus back to the list took it away from the next field of the entry order (the languages)
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function _UPDATE_TRANSLATE($context : Object)
	
	var $attributes; $language : Object
	var $string : Object:=$context.string
	var $parent : Object:=$context.parent
	var $xliff : cs:C1710.Xliff:=$context.file
	var $unit : Text:=$xliff.findByXPath($string.xpath)
	
	If ($string.attributes["translate"]=Null:C1517)
		
		$xliff.removeAttribute($unit; "translate")
		$attributes:=$xliff.getAttributes($unit)
		
		var $value : Text:=$xliff.sourceValue($unit)
		
		// Create if any & set value
		var $target : Text:=$xliff.targetNode($unit; True:C214)
		$xliff.setValue($target; $value)
		This:C1470.save($xliff)
		
		$string.target.value:=$value
		
		For each ($language; $string.localizations)
			
			// Update the XML tree
			$xliff:=$language.xliff
			$unit:=$xliff.findByXPath($string.xpath)
			$target:=$xliff.targetNode($unit; True:C214)
			$xliff.setValue($target; $string.source.value)
			$xliff.setState($target; $xliff.STATE_NEEDS_TRANSLATION)
			This:C1470.save($xliff)
			
			// Updating of UI elements
			$language.properties:=$language.properties || {}
			$language.properties.state:=$xliff.STATE_NEEDS_TRANSLATION
			$language.value:=$string.source.value
			
		End for each 
		
		This:C1470.detail.refresh()
		
	Else 
		
		$xliff.setAttribute($unit; "translate"; "no")
		$attributes:=$xliff.getAttributes($unit)
		$xliff.remove($xliff.targetNode($unit))
		This:C1470.save($xliff)
		
		For each ($language; $string.localizations)
			
			// Update the XML tree
			$xliff:=$language.xliff
			$unit:=$xliff.findByXPath($string.xpath)
			$xliff.remove($xliff.targetNode($unit))
			This:C1470.save($xliff)
			
			// Updating of UI elements
			$language.properties:=$language.properties || {}
			OB REMOVE:C1226($language.properties; "state")
			
		End for each 
	End if 
	
	// Synchronize attributes of other files
	This:C1470._synchronizeAttributes($parent; $string; $attributes)
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function _UPDATE_PLATFORM($context : Object)
	
	var $unit : Text
	var $attributes; $parent; $string : Object
	var $xliff : cs:C1710.Xliff
	
	$string:=$context.string
	$parent:=$context.parent
	
	// Update the reference XML tree
	$xliff:=$context.file
	$unit:=$xliff.findByXPath($string.xpath)
	
	If ($string.attributes["d4:includeIf"]=Null:C1517)
		
		$xliff.removeAttribute($unit; "d4:includeIf")
		
	Else 
		
		$xliff.setAttribute($unit; "d4:includeIf"; $string.attributes["d4:includeIf"])
		
	End if 
	
	$attributes:=$xliff.getAttributes($unit)
	
	This:C1470.save($xliff)
	
	// Synchronize attributes of other files
	This:C1470._synchronizeAttributes($parent; $string; $attributes)
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function _UPDATE_NOTE($context : Object)
	
	var $note; $unit : Text
	var $language; $string : Object
	var $xliff : cs:C1710.Xliff
	
	$string:=$context.string
	
	// Update the reference XML tree
	$xliff:=$context.file
	$unit:=$xliff.findByXPath($string.xpath)
	$note:=$xliff.noteNode($unit)
	
	If (Length:C16(String:C10($string.note))=0)
		
		$xliff.remove($note)
		
	Else 
		
		$note:=(Length:C16($note)=0) ? $xliff.create($unit; "note") : $note
		$xliff.setValue($note; $string.note)
		
	End if 
	
	This:C1470.save($xliff)
	
	For each ($language; $string.localizations)
		
		// Update the XML tree
		$xliff:=$language.xliff
		$unit:=$xliff.findByXPath($string.xpath)
		$note:=$xliff.noteNode($unit)
		
		If (Length:C16(String:C10($string.note))=0)
			
			$xliff.remove($note)
			
		Else 
			
			$note:=(Length:C16($note)=0) ? $xliff.create($unit; "note") : $note
			$xliff.setValue($note; $string.note)
			
		End if 
		
		This:C1470.save($xliff)
		
	End for each 
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function _PROPAGATE_REFERENCE($context : Object)
	
	var $target; $unit : Text
	var $language; $string : Object
	var $xliff : cs:C1710.Xliff
	
	$string:=$context.string
	
	For each ($language; $string.localizations)
		
		// Update the XML tree
		$xliff:=$language.xliff
		$unit:=$xliff.findByXPath($string.xpath)
		$xliff.setValue($target; $string.source.value)
		$xliff.setState($target; $xliff.STATE_NEEDS_TRANSLATION)
		
		This:C1470.save($xliff)
		
		// Updating of UI elements
		$language.properties:=$language.properties || {}
		$language.properties.state:=$xliff.STATE_NEEDS_TRANSLATION
		$language.value:=$string.source.value
		
	End for each 
	
	This:C1470.detail.refresh()
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// The localisation given by _STRING_Controller.update() to the LANGUAGE subform of $language for $string (Null if its file is not loaded)
Function localisation($string : Object; $language : Object) : Object
	
	var $localisation : Object:=OB Copy:C1225($language)
	
	// The localized file of this string: $language.root is the one of the last string loaded the first time,
	// possibly in another file
	var $own : Object:=$string.localizations=Null:C1517 ? Null:C1517 : $string.localizations.query("language.lproj = :1"; $language.lproj).first()
	
	If ($own#Null:C1517)
		
		If ($own.xliff#Null:C1517)
			
			$localisation.root:=$own.xliff.root
			
		End if 
	End if 
	
	var $xliff : cs:C1710.Xliff:=This:C1470.cache.query("root = :1"; $localisation.root).first()
	
	If ($xliff=Null:C1517)
		
		return Null:C1517
		
	End if 
	
	// The ref string
	$localisation.string:=$string
	$localisation.editor:=This:C1470  // Lets the LANGUAGE subform save the text being typed when the window closes
	
	// Get localisation
	var $node : Text:=$xliff.findById($localisation.string.id)
	
	If ($xliff.success)
		
		$localisation.value:=$xliff.targetValue($node)
		$localisation.properties:=$xliff.targetAttributes($node)
		
	Else 
		
		$localisation.value:=""
		$localisation.properties:={}
		
	End if 
	
	return $localisation
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function _UPDATE_LOCALIZED_TARGET($context : Object) : Boolean
	
	var $xliff : cs:C1710.Xliff:=This:C1470.cache.query("root = :1"; $context.root).first()
	
	If ($xliff=Null:C1517)
		
		return False:C215  // File closed or reloaded: write nothing
		
	End if 
	
	var $targetNode : Text:=$xliff.findByXPath($context.string.target.xpath)
	
	If (Not:C34($xliff.success)) || (Not:C34($xliff.isReference($targetNode)))
		
		return False:C215  // This trans-unit is not in this file: never write elsewhere
		
	End if 
	
	$xliff.setValue($targetNode; $context.value)
	$xliff.removeState($targetNode)
	This:C1470.save($xliff)
	
	return True:C214
	
	//MARK:-[FILTERS]
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Filter the new strings
Function filterNew() : Collection
	
	//var $c; $filtered : Collection
	//var $group : cs.XliffGroup
	//var $xliff : cs.Xliff
	//$xliff:=This.current
	//$filtered:=[]
	//For each ($group; $xliff.groups.query("units[].target[@state=\"new\"]"))
	//$c:=$group.transunits.query("target[@state=\"new\"]")
	//If ($c.length>0)
	//$filtered.combine($c)
	//End if 
	//End for each 
	//return $filtered
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Filter the strings that needs translation
Function filterNeedstranslation() : Collection
	
	//var $c; $filtered : Collection
	//var $group : cs.XliffGroup
	//var $xliff : cs.Xliff
	//$xliff:=This.current
	//$filtered:=[]
	//For each ($group; $xliff.groups.query("units[].target[@state=\"needs-translation\"]"))
	//$c:=$group.transunits.query("target[@state=\"needs-translation\"]")
	//If ($c.length>0)
	//$filtered.combine($c)
	//End if 
	//End for each 
	//return $filtered
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Filter the strings to be processed (new or needs-translation)
Function todo() : Collection
	
	var $xliff : cs:C1710.Xliff
	$xliff:=This:C1470.current
	
	var $c : Collection
	$c:=$xliff.todoNodes()
	
	// Maintenant il faut remonter au trans-unit et récupérer le groupe parent
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function isGroup($target : Object) : Boolean
	
	return OB Instance of:C1731($target; cs:C1710.XliffGroup)
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function isTransUnit($target : Object) : Boolean
	
	return OB Instance of:C1731($target; cs:C1710.XliffUnit)
	
	