/*
Class: _EDITOR_Controller - (4DPop XLIFF Pro)
Created 1-1-2023 by Vincent de Lachaux
*/

// MARK: Default values ⚙️
property isSubform:=False:C215
property toBeInitialized:=False:C215

// MARK: Delegates 📦
property form : cs:C1710.form
property Xliff : cs:C1710.Xliff
property menuBar : cs:C1710.menuBar
property Preferences : cs:C1710.Preferences
property str : cs:C1710.str:=cs:C1710.str.new()

// MARK: Widgets 🧱
property lock; lockMessage : cs:C1710.static
property wrap : cs:C1710.widget
property newFile; newGroup; newString; filterLanguage : cs:C1710.button
property stringSplitter; lockButton : cs:C1710.button
property detail; searchPicker : cs:C1710.subform
property fileList; stringList : cs:C1710.listbox
property strings; locked; withFile : cs:C1710.group
property spinner : cs:C1710.stepper

// MARK: Constants 🔐
property FILE_EXTENSION:=".xlf"
property FOLDER_EXTENSION:=".lproj"
property GENERATOR:=File:C1566(Structure file:C489; fk platform path:K87:2).name
property VERSION:="3.1"

// TODO:Could be a preference
property AUTOSAVE:=True:C214  // Flag for automatic saving

// MARK: Other 💾
property current : cs:C1710.Xliff
property folders; cache; languages : Collection
property default; main; resources : Object

property groupPtr; resnamePtr; contentPtr : Pointer

property stringListConstraints : cs:C1710.constraints

Class constructor($mainLanguage : Text)
	
	// MARK:Delegates 📦
	This:C1470.form:=cs:C1710.form.new(This:C1470)
	This:C1470.Preferences:=cs:C1710.Preferences.new(This:C1470.VERSION)
	This:C1470.Xliff:=cs:C1710.Xliff
	
	// MARK:Retrieving active lproj folders
	This:C1470.folders:=Folder:C1567(fk resources folder:K87:11; *).folders().query("extension = :1 & name != :2"; This:C1470.FOLDER_EXTENSION; "_@")
	
	// MARK: Define the main language
	This:C1470.main:={}
	This:C1470.main.language:=$mainLanguage || This:C1470._mainLanguage()
	This:C1470.main.files:=This:C1470.getFiles()
	This:C1470.main.regional:=This:C1470.getFlag(This:C1470.main.language)
	
	// MARK: default
	This:C1470.default:={\
		language: This:C1470.main.language\
		}
	
	// TODO:Retrieve component version
	This:C1470.default.version:="3.0"
	
	This:C1470.languages:=[]
	
	var $folder : 4D:C1709.Folder
	For each ($folder; This:C1470.folders.query("name != :1"; This:C1470.main.language).orderBy("name"))
		
		// TODO: Change languages.language to languages.code
		This:C1470.languages.push({\
			language: $folder.name; \
			regional: This:C1470.getFlag($folder.name)\
			})
		
	End for each 
	
	// MARK: Memorize open XML trees to be able to close them when unloading
	This:C1470.cache:=[]
	
	This:C1470.form.init()
	
	// MARK:-[STANDARD SUITE]
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function init()
	
	// MARK: Menu bar
	var $menuHandle : Text:=Formula:C1597(formMenuHandle).source
	
	var $menuFile : cs:C1710.menu:=cs:C1710.menu.new()
	$menuFile.file()  // Get a standard file menu
	
	// Insert custom items at the beginning
	$menuFile.append(":xliff:newFile"; "newFile"; 0).method($menuHandle)\
		.append(":xliff:newGroup"; "newGroup"; 1).method($menuHandle).shortcut("N"; Option key mask:K16:7)\
		.append(":xliff:newString"; "newString"; 2).method($menuHandle).shortcut("N")\
		.line(3)\
		.append(":xliff:close"; "close"; 4).method($menuHandle).shortcut("W")\
		.line(5)
	
	var $menuEdit : cs:C1710.menu:=cs:C1710.menu.new().method($menuHandle)
	$menuEdit.edit()  // Get a standard edit menu
	
	// Modify the copy item (5) to be able to manage it ourselves
	$menuEdit.parameter("copy"; 5).method($menuHandle; 5).action(ak none:K76:35; 5)
	
	// Insert custom copy items
	$menuEdit.append(Localized string:C991("CommonMenuItemCopy")+" "+Localized string:C991("copyResname"); "copyResname"; 5).method($menuHandle).shortcut("C"; Shift key mask:K16:3)
	$menuEdit.append(Localized string:C991("CommonMenuItemCopy")+" "+Localized string:C991("copyTheCode"); "copyCode"; 6).method($menuHandle).shortcut("C"; Option key mask:K16:7)
	
	// Insert custom items before the last
	$menuEdit.line()\
		.append(":xliff:find"; "find"; -1).method($menuHandle).shortcut("F")\
		.append(":xliff:findNext"; "findNext"; -1).method($menuHandle).shortcut("G")\
		.line(-1)
	
	This:C1470.menuBar:=cs:C1710.menuBar.new([\
		":xliff:CommonMenuFile"; $menuFile; \
		":xliff:CommonMenuEdit"; $menuEdit]).set()
	
	// MARK: Callback
	This:C1470.form.callback:=Formula:C1597(EDITOR CALLBACK).source
	
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
Function handleEvents($e : cs:C1710.evt)
	
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
				
				This:C1470.strings.center(True:C214)
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
	
	If ($e.objectName="stringSplitter")
		
		This:C1470.stringListConstraints.apply()
		
		return 
		
	End if 
	
	// MARK: Widget Methods
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
	
	Form:C1466.files:=This:C1470.main.files
	Form:C1466.project:=File:C1566(Structure file:C489(*); fk platform path:K87:2).name
	
	OBJECT SET TITLE:C194(*; "project"; Form:C1466.project)
	
	// Avoid the offset created if the vertical bar is not displayed
	This:C1470.fileList.setVerticalScrollbar(2)
	This:C1470.stringList.setVerticalScrollbar(2)
	
	// Pointers to the dynamics
	This:C1470.groupPtr:=OBJECT Get pointer:C1124(Object named:K67:5; "group")
	This:C1470.resnamePtr:=OBJECT Get pointer:C1124(Object named:K67:5; "unit")
	This:C1470.contentPtr:=OBJECT Get pointer:C1124(Object named:K67:5; "content")
	
	// Distribute the "String" buttons of the toolbar
	This:C1470.withFile.distributeLeftToRight().disable()
	
	This:C1470.filterLanguage.bestSize()
	This:C1470.lockButton.bestSize()
	
	This:C1470.form.appendEvents(On Delete Action:K2:56)
	This:C1470.form.appendEvents(On Expand:K2:41)
	
	This:C1470.form.focus(This:C1470.fileList.name)
	
	This:C1470.form.setEntryOrder([This:C1470.fileList; This:C1470.stringList; This:C1470.detail])
	
	// Initialize the search widget
	This:C1470.searchPicker.data:={\
		value: Null:C1517; \
		start: 0; \
		borderColor: 0x00C0C0C0\
		}
	
	This:C1470.stringListConstraints.apply()
	
	This:C1470.spinner.start(True:C214)
	
	This:C1470.form.refresh()
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function update()
	
	If (This:C1470.fileList.item=Null:C1517)\
		 && (This:C1470.fileList.rowsNumber>0)
		
		// Select last used file
		var $o : Object:=This:C1470.Preferences.get(Form:C1466.project)
		
		If ($o#Null:C1517)\
			 && (Length:C16(String:C10($o.file))>0)
			
			var $c : Collection:=Form:C1466.files.indices("name = :1"; $o.file)
			
		End if 
		
		This:C1470.doSelectFile($c.length>0 ? $c[0]+1 : 1)
		
	End if 
	
	var $isWritable:=Not:C34(Bool:C1537(This:C1470.current.duplicateID))
	
	This:C1470.strings.show(This:C1470.current.error=Null:C1517)
	This:C1470.newString.enable((This:C1470.stringList.item#Null:C1517) & $isWritable)
	This:C1470.newGroup.enable($isWritable)
	
	This:C1470.updateMenus($isWritable)
	
	If (Num:C11(This:C1470.wrap.timer)=0)
		
		This:C1470.wrap.hide()
		
	Else 
		
		This:C1470.form.refresh(This:C1470.wrap.timer)
		This:C1470.wrap.timer:=0
		
	End if 
	
	This:C1470.detail.show((This:C1470.stringList.item#Null:C1517) & ($isWritable))
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function updateMenus($isWritable : Boolean)
	
	$isWritable:=Count parameters:C259=1 ? $isWritable : Not:C34(Bool:C1537(This:C1470.current.duplicateID))
	
	This:C1470.menuBar.enableItem("newGroup"; $isWritable)
	This:C1470.menuBar.enableItem("newString"; $isWritable & (This:C1470.stringList.item#Null:C1517))
	
	If (This:C1470.form.focused=This:C1470.stringList.name)
		
		This:C1470.menuBar.enableItem("copy"; (This:C1470.stringList.item#Null:C1517) && (This:C1470.stringList.item.id#Null:C1517))
		This:C1470.menuBar.enableItem("copyResname"; This:C1470.stringList.item#Null:C1517)
		This:C1470.menuBar.enableItem("copyCode"; This:C1470.stringList.item#Null:C1517)
		
	Else 
		
		This:C1470.menuBar.enableItem("copy"; Length:C16(Get edited text:C655)>0)
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
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function handleMenus($what : Text)
	
	$what:=$what || Get selected menu item parameter:C1005
	
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
		: ($what="copy")
			
			If (This:C1470.form.focused=This:C1470.stringList.name)
				
				SET TEXT TO PASTEBOARD:C523(":xliff:"+This:C1470.stringList.item.resname)  // XLIFF reference
				
			Else 
				
				var $text : Text
				$text:=Get edited text:C655
				
				If (Length:C16($text)>0)
					
					var $start; $stop : Integer
					GET HIGHLIGHT:C209(*; This:C1470.form.focused; $start; $stop)
					
					If ($start#$stop)
						
						SET TEXT TO PASTEBOARD:C523(Substring:C12($text; $start; $stop))
						
					End if 
				End if 
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
Function _fileListManager($e : cs:C1710.evt)
	
	var $file : 4D:C1709.File
	
	$file:=This:C1470.current.file
	
	Case of 
			
			//______________________________________________________
		: ($e.code=On Selection Change:K2:29)
			
			This:C1470.spinner.start(True:C214)
			
			This:C1470.stringList.unselect()
			This:C1470.stringList.item:=Null:C1517
			
			// Reset the search
			This:C1470.searchPicker.data.start:=0
			
			This:C1470.withFile.disable()
			This:C1470.strings.hide()
			This:C1470.stringList.hide()
			
			If (This:C1470.fileList.item=Null:C1517)
				
				return 
				
			End if 
			
			This:C1470.form.callMeBack("_DISPLAY_FILE")
			
			//______________________________________________________
		: ($e.code=On Clicked:K2:4)
			
			If (Contextual click:C713)
				
				var $menu : cs:C1710.menu:=cs:C1710.menu.new()
				
				$menu.append(":xliff:projectSettings"; "projectSettings").disable()
				
				If ($e.row#Null:C1517)
					
					$menu.line().append(":xliff:fileInformations"; "fileInformations").disable()\
						.append(":xliff:showOnDisk"; "showOnDisk")\
						.append(":xliff:delete"; "delete")
					
				End if 
				
				If (This:C1470.current.duplicateID)
					
					$menu.line()\
						.append(":xliff:makeIdsUnique"; "uid")
					
				End if 
				
				$menu.line()\
					.append(":xliff:import"; "import").disable()
				
				$menu.popup()
				
				Case of 
						//_____________________________________
					: (Not:C34($menu.selected))
						
						//
						
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
Function _stringListManager($e : cs:C1710.evt)
	
	If (Not:C34(Bool:C1537($e.force)))
		
		This:C1470.stringList.cellPosition($e)
		
	End if 
	
	var $item : Object:=This:C1470.setCurrentString($e)
	
	Case of 
			
			//______________________________________________________
		: ($e.code=On Selection Change:K2:29)
			
			This:C1470.form.refresh()
			
			//______________________________________________________
		: ($e.code=On Clicked:K2:4)
			
			If (Contextual click:C713)
				
				var $isWritable : Boolean:=Not:C34(Bool:C1537(This:C1470.current.duplicateID))
				var $menu : cs:C1710.menu:=cs:C1710.menu.new()
				
				If ($item#Null:C1517)
					
					var $copy : cs:C1710.menu:=cs:C1710.menu.new()
					$copy.append(":xliff:copyAsXliffReference"; "copy").shortcut("C").enable(OB Instance of:C1731($item; cs:C1710.XliffUnit))\
						.append(":xliff:copyResname"; "copyResname").shortcut("C"; Shift key mask:K16:3)\
						.append(":xliff:copyTheCode"; "copyCode").shortcut("C"; Option key mask:K16:7)
					
					var $files : Collection:=Folder:C1567("/RESOURCES/4DPop xliff").files()
					
					If (Structure file:C489#Structure file:C489(*))
						
						// Append host files
						$files.combine(Folder:C1567("/RESOURCES/4DPop xliff"; *).files())
						
					End if 
					
					$files:=$files.query("extension = :1"; OB Instance of:C1731($item; cs:C1710.XliffGroup) ? ".group" : ".unit").orderBy("name")
					
					If ($files.length>0)
						
						$copy.line()
						
						var $file : 4D:C1709.File
						For each ($file; $files)
							
							$copy.append(Localized string:C991("codeFor")+$file.name; $file.name)  //.setStyle(Italic)
							
						End for each 
					End if 
					
					// TODO: Allow to copy/cut an item to paste it in another group/file
					
					$menu.append(":xliff:CommonMenuItemCopy"; $copy)
					$menu.line()
					
				End if 
				
				$menu.append(":xliff:newGroup"; "newGroup").shortcut("N"; Option key mask:K16:7).enable($isWritable)
				
				If ($item#Null:C1517)
					
					$menu.append(":xliff:newString"; "newString").shortcut("N").enable($isWritable)\
						.line()\
						.append(":xliff:duplicate"; "duplicate").shortcut("D").enable($isWritable)\
						.line()\
						.append(":xliff:delete"; "delete").shortcut("[Del]").enable($isWritable)
					
				End if 
				
				If ($menu.popup().selected)
					
					This:C1470.handleMenus($menu.choice)
					
				End if 
			End if 
			
			This:C1470.form.refresh()
			
			//______________________________________________________
		: ($e.code=On Expand:K2:41)
			
			// Select the break line
			This:C1470.stringList.selectBreak($e.row)
			
			If (This:C1470.stringList.item.transunits=Null:C1517) || (This:C1470.stringList.item.transunits.length=0)
				
				// No trans-unit, so no expansion
				This:C1470.stringList.collapse($e.row; lk selection:K53:17)
				
			End if 
			
			This:C1470.form.refresh()
			
			//______________________________________________________
		: ($e.code=On Getting Focus:K2:7)
			
			//If ($item=Null) && (This.stringList.rowsNumber>0)
			//// Select the first group
			//This.doSelectGroup(1; $e)
			//This.form.refresh()
			//End if 
			
			//______________________________________________________
		: ($e.code=On Begin Drag Over:K2:44)
			
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
		: ($e.code=On Delete Action:K2:56)
			
			This:C1470.doDeleteString($e)
			
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
	$name+=This:C1470.FILE_EXTENSION
	
	If (This:C1470.main.files.query("fullName= :1"; $name).pop()#Null:C1517)
		
		CONFIRM:C162(Replace string:C233(Localized string:C991("theFileAlreadyExists"); "{name}"; $name))
		
		If (Not:C34(Bool:C1537(OK)))
			
			return 
			
		End if 
	End if 
	
	//
	If (This:C1470.folders.length=0)
		
		var $folder : 4D:C1709.Folder
		$folder:=Folder:C1567(fk resources folder:K87:11; *).folder(This:C1470.main.language+This:C1470.FOLDER_EXTENSION)
		$folder.create()
		This:C1470.folders.push($folder)
		
	End if 
	
	$file:=File:C1566("/RESOURCES/template.xlf").copyTo(This:C1470.folders.query("name = :1"; This:C1470.main.language).pop(); $name; fk overwrite:K87:5)
	
	$t:=$file.getText()
	PROCESS 4D TAGS:C816($t; $t; This:C1470.default)
	$file.setText($t)
	
	This:C1470.main.files:=This:C1470.getFiles()
	
	// Update UI
	Form:C1466.files:=This:C1470.main.files
	$indx:=This:C1470.main.files.indices("fullName = :1"; $name)[0]
	This:C1470.fileList.select($indx+1)
	This:C1470.stringList.item:=Null:C1517
	This:C1470._fileListManager({code: On Selection Change:K2:29})
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function doNewGroup()
	
	var $resname : Text
	var $row : Integer
	var $language : Object
	var $group : cs:C1710.XliffGroup
	var $unit : cs:C1710.XliffUnit
	var $xliff : cs:C1710.Xliff
	
	// Trigger string update
	This:C1470.form.removeFocus()
	
	$resname:=This:C1470.uniqueResname("group")
	$group:=This:C1470.current.createGroup($resname)
	This:C1470.save(This:C1470.current)
	
	// Update localized files
	For each ($language; This:C1470.current.languages)
		
		$xliff:=$language.xliff
		$xliff.createGroup($resname)
		This:C1470.save($xliff)
		
	End for each 
	
	// Update UI
	//FIXME:Turn around
	This:C1470._LOAD_STRINGS()
	
	This:C1470.stringList.sort(1)
	
	$row:=Find in array:C230((This:C1470.groupPtr)->; $resname)
	This:C1470.stringList.unselect()
	This:C1470.stringList.select($row-1)
	This:C1470.stringList.selectBreak($row).collapse($row).focus()
	This:C1470.doSelectGroup($row)
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function doNewString()
	
	var $resname : Text
	var $row : Integer
	var $language; $target : Object
	var $group : cs:C1710.XliffGroup
	var $unit : cs:C1710.XliffUnit
	var $xliff : cs:C1710.Xliff
	
	// Trigger string update
	This:C1470.form.removeFocus()
	
	$target:=This:C1470.stringList.item
	
	If (OB Instance of:C1731($target; cs:C1710.XliffUnit))
		
		// Get parent group
		$target:=This:C1470.parentGroup($target)
		
	End if 
	
	$resname:=This:C1470.uniqueResname("trans-unit")
	$unit:=This:C1470.current.createUnit($target; $resname)
	This:C1470.save(This:C1470.current)
	
	// Update localized files
	For each ($language; This:C1470.current.languages)
		
		$xliff:=$language.xliff
		$group:=$xliff.groups.query("resname = :1"; $target.resname).pop()
		$xliff.createUnit($group; $resname; $unit.id)
		This:C1470.save($xliff)
		
	End for each 
	
	// Update UI
	If ($target.transunits.length=1)
		
		$row:=Find in array:C230(This:C1470.groupPtr->; $target.resname)
		This:C1470.resnamePtr->{$row}:=$resname
		This:C1470.contentPtr->{$row}:=$unit
		
	Else 
		
		APPEND TO ARRAY:C911((This:C1470.groupPtr)->; $target.resname)
		APPEND TO ARRAY:C911((This:C1470.resnamePtr)->; $resname)
		APPEND TO ARRAY:C911((This:C1470.contentPtr)->; $unit)
		
	End if 
	
	This:C1470.stringList.sort(2)
	This:C1470.doSelectUnit(Find in array:C230((This:C1470.resnamePtr)->; $resname))
	
	// FIXME: Update the duplicates
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function _searchPickerManager($e : cs:C1710.evt)
	
	$e:=$e || FORM Event:C1606
	
	If ($e.code=On Data Change:K2:15)
		
		// Perform the search
		This:C1470.doSearch(String:C10(This:C1470.searchPicker.data.value))
		
	End if 
	
	//MARK:-
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function doDeleteFile($file : 4D:C1709.File; $e : cs:C1710.evt)
	
	var $language : Object
	var $xliff : cs:C1710.Xliff
	
	CONFIRM:C162(Replace string:C233(Localized string:C991("DeleteFile"); "{filename}"; $file.name))
	
	If (OK=0)
		
		return 
		
	End if 
	
	$e:=$e || FORM Event:C1606
	
	$file.delete()
	
	For each ($language; This:C1470.current.languages)
		
		$xliff:=$language.xliff
		$file:=$xliff.file
		$xliff.close()
		$file.delete()
		
	End for each 
	
	// Update UI
	Form:C1466.files.remove(Form:C1466.files.indices("fullName = :1"; $file.fullName)[0])
	This:C1470.fileList.doSafeSelect($e.row)
	$e.code:=On Selection Change:K2:29
	This:C1470._fileListManager($e)
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function doDeleteString($e : cs:C1710.evt)
	
	var $row : Integer
	var $language; $target : Object
	var $group : cs:C1710.XliffGroup
	var $unit : cs:C1710.XliffUnit
	var $xliff : cs:C1710.Xliff
	
	$target:=This:C1470.stringList.item
	
	If ($target=Null:C1517)
		
		return 
		
	End if 
	
	CONFIRM:C162(Replace string:C233(\
		Localized string:C991(OB Instance of:C1731($target; cs:C1710.XliffUnit) ? "DeleteItem" : "DeleteGroup"); \
		"{item}"; $target.resname))
	
	If (OK=0)
		
		return 
		
	End if 
	
	$xliff:=This:C1470.current
	
	If (OB Instance of:C1731($target; cs:C1710.XliffGroup))
		
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
		$row:=Find in array:C230(This:C1470.groupPtr->; $group.resname; 1)
		
		If ($group.transunits=Null:C1517) || ($group.transunits.length=0)
			
			// Select the break line, collapse & select
			This:C1470.stringList.collapse($row; lk selection:K53:17)
			This:C1470.stringList.selectBreak($row)
			This:C1470.doSelectGroup($row)
			
		Else 
			
			DELETE FROM ARRAY:C228((This:C1470.groupPtr)->; $row)
			DELETE FROM ARRAY:C228((This:C1470.resnamePtr)->; $row)
			DELETE FROM ARRAY:C228((This:C1470.contentPtr)->; $row)
			
			// Select
			This:C1470.stringList.doSafeSelect($row)
			This:C1470.doSelectUnit($row)
			
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function getItemCode($item : Object; $type : Text) : Text
	
	var $code; $format; $resname : Text
	var $b : Boolean
	var $o : Object
	var $file : 4D:C1709.File
	
	ARRAY LONGINT:C221($len; 0)
	ARRAY LONGINT:C221($pos; 0)
	
	// Is it an external code?
	$file:=File:C1566("/RESOURCES/4DPop xliff/"+$type+(OB Instance of:C1731($item; cs:C1710.XliffGroup) ? ".group" : ".unit"))
	
	If (Not:C34($file.exists))
		
		// Try host
		$file:=File:C1566("/RESOURCES/4DPop xliff/"+$type+(OB Instance of:C1731($item; cs:C1710.XliffGroup) ? ".group" : ".unit"); *)
		
	End if 
	
	If ($file.exists)
		
		$code:=$file.getText()
		PROCESS 4D TAGS:C816($code; $code; $item)
		return $code
		
	End if 
	
	If (OB Instance of:C1731($item; cs:C1710.XliffGroup))
		
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
Function doSearch($searchText : Text; $e : cs:C1710.evt)
	
	$e:=$e || cs:C1710.evt.new()
	
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
		This:C1470.wrap.timer:=10
		This:C1470.wrap.show()
		
	End if 
	
	If ($data.start>0)
		
		If ($initialSearch)
			
			// Trick to force update (I'm not proud of it)
			var $coord : cs:C1710.coord:=This:C1470.stringList.cellCoordinates(2; $data.start)
			This:C1470.stringList.click($coord.left+40; $coord.top+10)
			
		Else 
			
			// Select & scroll
			$e.column:=2
			$e.row:=$data.start
			
			This:C1470.setCurrentString($e)
			This:C1470.doSelectUnit($e.row)
			
		End if 
		
		This:C1470.form.callMeBack("_SELECT_STRING")
		
	Else 
		
		BEEP:C151
		
		$data.start:=0
		This:C1470.wrap.timer:=0
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
Function setCurrentString($e : cs:C1710.evt) : Object
	
	If ($e.row=0)
		
		This:C1470.stringList.item:=Null:C1517
		This:C1470.detail.refresh()
		
		return 
		
	End if 
	
	This:C1470.stringList.item:=This:C1470._populateString($e.column; $e.row)
	This:C1470.detail.refresh()
	
	return This:C1470.stringList.item
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function _populateString($column : Integer; $row : Integer) : Object
	
	var $language; $o; $string : Object
	var $file : 4D:C1709.File
	var $xliff : cs:C1710.Xliff
	
	//%W-533.3
	$o:=(This:C1470.contentPtr)->{$row}
	//%W+533.3
	
	$string:=($column=1) & (OB Instance of:C1731($o; cs:C1710.XliffUnit)) ? This:C1470.parentGroup($o) : $o
	
	If (Structure file:C489=Structure file:C489(*))
		ASSERT:C1129($string#Null:C1517)
	End if 
	
	If ($string.localizations=Null:C1517 ? True:C214 : ($string.localizations.length=0))
		
		// Open or create the target language
		$string.localizations:=[]
		
		For each ($language; This:C1470.languages)
			
			If ($language.xliff=Null:C1517)
				
				$file:=This:C1470.current.localizedFile(This:C1470.fileList.item; This:C1470.main.language; $language.language)
				
				$xliff:=This:C1470.cache.query("file.path = :1"; $file.path).pop()
				
				If ($xliff=Null:C1517)
					
					$xliff:=This:C1470.parse($file)
					
				End if 
				
				$language.root:=$xliff.root
				
				$string.localizations.push(New object:C1471(\
					"language"; $language.language; \
					"regional"; This:C1470.getFlag($language.language); \
					"xliff"; $xliff))
				
			End if 
		End for each 
	End if 
	
	return $string
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function doSelectFile($row : Integer; $e : cs:C1710.evt)
	
	// Select the file
	This:C1470.fileList.select($row)
	
	// & call back the _fileListManager manager
	$e:=$e || cs:C1710.evt.new()
	$e.column:=1
	$e.row:=$row
	$e.code:=On Selection Change:K2:29
	$e.force:=True:C214
	This:C1470._fileListManager($e)
	
	This:C1470.fileList.focus()
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function doSelectGroup($row : Integer; $e : cs:C1710.evt)
	
	This:C1470.stringList.unselect()
	
	// Select the group
	This:C1470.stringList.selectBreak($row)
	
	// & call back the stringList manager
	$e:=$e || cs:C1710.evt.new()
	$e.column:=1
	$e.row:=$row
	$e.code:=On Selection Change:K2:29
	$e.force:=True:C214
	This:C1470._stringListManager($e)
	
	This:C1470.stringList.focus()
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function doSelectUnit($row : Integer)
	
	// Expand group if any
	If (This:C1470.stringList.item#Null:C1517) && (OB Instance of:C1731(This:C1470.stringList.item; cs:C1710.XliffGroup))
		
		This:C1470.stringList.expand($row; lk break row:K53:18)
		
	End if 
	
	This:C1470.stringList.select($row)
	
	This:C1470.form.callMeBack("_SELECT_STRING"; {row: $row})
	
	This:C1470.stringList.focus()
	
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
	
	$folder:=This:C1470.folders.query("name = :1"; $language || This:C1470.main.language).pop()
	
	If ($folder#Null:C1517)
		
		For each ($file; $folder.files().query("extension = :1"; This:C1470.FILE_EXTENSION))
			
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
Function getFlag($code : Text) : Text
	
	var $source : Text
	var $index : Integer
	var $first; $last : Object
	var $c : Collection
	
	This:C1470.resources:=This:C1470.resources || JSON Parse:C1218(File:C1566("/RESOURCES/languages.json").getText())
	
	Case of 
			
			//______________________________________________________
		: (Match regex:C1019("(?mi-s)^[a-zA-Z]{2}-[a-zA-Z]{2,}$"; $code; 1))
			
			$source:="lproj"  // Language-Regional Codes
			
			//______________________________________________________
		: (Match regex:C1019("(?mi-s)^[a-zA-Z]{2}$"; $code; 1))
			
			$source:="ISO639-1"
			
			//______________________________________________________
		Else 
			
			$source:="legacy"
			
			//______________________________________________________
	End case 
	
	$code:=Split string:C1554($code; "-")[0]  // Keep only the first 2 characters of a sub-language
	$index:=This:C1470.resources[$source].indexOf($code)
	
	If ($index#-1)
		
		return This:C1470.resources.flag[$index]  // Emoji
		
	Else 
		
		return "❔"
		
	End if 
	
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
	
	var $unit : Text
	var $language : Object
	var $xliff : cs:C1710.Xliff
	
	For each ($language; $parent.languages)
		
		// Update the XML tree
		$xliff:=$parent.cache.query("root = :1"; $language.root).pop()
		$unit:=$xliff.findByXPath($string.xpath)
		
		If ($xliff.success)
			
			$xliff.setAttributes($unit; $attributes; True:C214)
			
			This:C1470.save($xliff)
			
		End if 
	End for each 
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _mainLanguage() : Text
	
	var $langue : Text
	var $folder : 4D:C1709.Folder
	
	$langue:=Get database localization:C1009(User system localization:K5:23; *)
	$folder:=This:C1470.folders.query("name = :1 OR name = :2"; $langue; $langue+"@").pop()
	
	If ($folder#Null:C1517)
		
		return $folder.name
		
	End if 
	
	$langue:=Get database localization:C1009(Current localization:K5:22; *)
	$folder:=This:C1470.folders.query("name = :1 OR name = :2"; $langue; $langue+"@").pop()
	
	If ($folder#Null:C1517)
		
		return $folder.name
		
	End if 
	
	$folder:=This:C1470.folders.query("name = :1 OR name = :2 OR name = :3"; "en"; "en@"; "English").pop()
	
	If ($folder#Null:C1517)
		
		return $folder.name
		
	End if 
	
	return This:C1470.folders.length>0\
		 ? This:C1470.folders[0].name\
		 : Get database localization:C1009(User system localization:K5:23; *)
	
	//MARK:-[CALLBACKS]
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function _DISPLAY_FILE()
	
	// Take from cache if available
	var $xliff : cs:C1710.Xliff:=This:C1470.cache.query("file.path = :1"; This:C1470.fileList.item.path).first()
	
	var $language : Object
	var $file : 4D:C1709.File
	
	If ($xliff=Null:C1517)
		
		$xliff:=This:C1470.parse(This:C1470.fileList.item)
		
		This:C1470.current:=$xliff
		
		If ($xliff.success)\
			 || ($xliff.error=Null:C1517)
			
			// Prepare the languages
			This:C1470.current.languages:=[]
			
			// We use one worker for each language.
			var $parallel:=[]
			For each ($language; This:C1470.languages)
				
				var $signal:=New signal:C1641($language.language)
				
				Use ($signal)
					
					$signal.main:=This:C1470.main.language
					$signal.reference:=OB Copy:C1225($xliff; ck shared:K85:29; $signal)
					$signal.item:=OB Copy:C1225(This:C1470.fileList.item; ck shared:K85:29; $signal)
					$signal.language:=OB Copy:C1225($language; ck shared:K85:29; $signal)
					
				End use 
				
				CALL WORKER:C1389("$4DPop XLIFF - "+$language.language; Formula:C1597(EDITOR_PARSE_LANGUAGE).source; $signal)
				$parallel.push($signal)
				
			End for each 
			
			Repeat 
				
				For each ($signal; $parallel.reverse())
					
					If ($signal.signaled)
						
						var $indx:=$parallel.indexOf($signal)
						
						This:C1470.current.languages.push({\
							language: $signal.language.language; \
							regional: $signal.language.regional; \
							xliff: $signal.xliff})
						
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
	
	This:C1470.form.callMeBack("_LOAD_STRINGS")
	
	If ($xliff.duplicateResname)
		
		This:C1470.form.callMeBack("_HIGHLIGHTING_DUPLICATES")
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function _SELECT_STRING($data : Object)
	
	var $e : cs:C1710.evt:=cs:C1710.evt.new()
	
	If ($data=Null:C1517)
		
		$data:=This:C1470.searchPicker.data
		
		$e.column:=2
		$e.row:=$data.start
		
		This:C1470.setCurrentString($e)
		This:C1470.doSelectUnit($e.row)
		
		This:C1470.detail.refresh()
		
	Else 
		
		This:C1470.stringList.select($data.row)
		
		// Call the stringList manager
		$e.column:=2
		$e.row:=$data.row
		$e.code:=On Selection Change:K2:29
		$e.force:=True:C214
		This:C1470._stringListManager($e)
		
	End if 
	
	This:C1470.stringList.focus()
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function _LOAD_STRINGS()
	
	var $main : cs:C1710.Xliff
	var $group : cs:C1710.XliffGroup
	var $unit : cs:C1710.XliffUnit
	
	//FIXME:Optimize
	ARRAY TEXT:C222($groupResnames; 0x0000)
	ARRAY TEXT:C222($stringResnames; 0x0000)
	ARRAY OBJECT:C1221($units; 0x0000)
	
	$main:=This:C1470.current
	
	If ($main.groups.length>0)
		
		For each ($group; $main.groups)
			
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
	
	This:C1470.locked.show($main.duplicateID)
	This:C1470.form.refresh()
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function _HIGHLIGHTING_DUPLICATES()
	
	var $column; $t : Text
	var $isDuplicated : Boolean
	var $i; $row : Integer
	var $o : Object
	
	// TODO:Working with the collections
	$column:=This:C1470.stringList.getColumnName(2)
	
	For ($i; 1; Size of array:C274(This:C1470.resnamePtr->); 1)
		
		$t:=(This:C1470.resnamePtr)->{$i}
		
		$isDuplicated:=($t#"...")\
			 & (Count in array:C907(This:C1470.resnamePtr->; $t)>1)
		
		If ($isDuplicated)  // More than one value found
			
			// First occurence
			$row:=Find in array:C230(This:C1470.resnamePtr->; $t)
			
			// Case sensitive comparison with the current value
			$isDuplicated:=(Position:C15($t; (This:C1470.resnamePtr)->{$row}; *)=1)
			
			If ($isDuplicated)  // Check platform restriction
				
				$o:=(This:C1470.contentPtr)->{$row}
				
				$isDuplicated:=($o.attributes["d4:includeIf"]=Null:C1517)\
					 | (Length:C16(String:C10($o.attributes["d4:includeIf"]))=0)
				
			End if 
			
			Repeat 
				
				// Search the next value
				$row:=Find in array:C230(This:C1470.resnamePtr->; $t; $row+1)
				
				If ($row>0)
					
					// Case sensitive comparison with the current value
					$isDuplicated:=$isDuplicated\
						 & (Position:C15($t; (This:C1470.resnamePtr)->{$row}; *)=1)
					
					If ($isDuplicated)  // Check platform restriction
						
						$o:=(This:C1470.contentPtr)->{$row}
						$isDuplicated:=($o.attributes["d4:includeIf"]=Null:C1517)\
							 | (Length:C16(String:C10($o.attributes["d4:includeIf"]))=0)
						
					End if 
				End if 
			Until ($row=-1)\
				 | ($isDuplicated)
			
		End if 
		
		If ($isDuplicated)
			
			// Flag as containing duplicates
			(This:C1470.contentPtr)->{$i}.duplicateResname:=True:C214
			
			// Set resname color
			This:C1470.stringList.setRowForegroundColor($i; "red"; 2)
			
			// Expand the group
			$row:=Find in array:C230(This:C1470.groupPtr->; (This:C1470.groupPtr)->{$i})
			This:C1470.stringList.expand($row; lk break row:K53:18)
			
		End if 
	End for 
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function _UPDATE_SOURCE($context : Object)
	
	var $source; $target; $unit : Text
	var $isNew : Boolean
	var $language; $string : Object
	var $xliff : cs:C1710.Xliff
	
	$string:=$context.string
	
	// Update the reference XML tree
	$xliff:=$context.file
	$unit:=$xliff.findByXPath($string.xpath)
	$source:=$xliff.sourceNode($unit; True:C214)
	$target:=$xliff.targetNode($unit; True:C214)
	
	$xliff.setValue($source; $string.source.value)
	$xliff.setValue($target; $string.source.value)
	
	This:C1470.save($xliff)
	
	For each ($language; $string.localizations)
		
		// Update the XML tree
		$xliff:=$language.xliff
		$unit:=$xliff.findByXPath($string.xpath)
		$source:=$xliff.sourceNode($unit; True:C214)
		$target:=$xliff.targetNode($unit; True:C214)
		
		$isNew:=Length:C16($xliff.getValue($source))=0
		
		$xliff.setValue($source; $string.source.value)
		
		Case of 
				
				//______________________________________________________
			: ($isNew)
				
				$xliff.setValue($target; $string.source.value)
				$xliff.setState($target; $xliff.NEW)
				
				//______________________________________________________
			: (String:C10($xliff.getAttributes($target).state)=$xliff.NEW)
				
				$xliff.setValue($target; $string.source.value)
				
				//______________________________________________________
			Else 
				
				$xliff.setState($target; $xliff.NEEDS_REVIEW)
				
				//______________________________________________________
		End case 
		
		This:C1470.save($xliff)
		
		// Updating of UI elements
		$language.properties:=$language.properties || {}
		$language.properties.state:=$xliff.NEEDS_REVIEW
		
	End for each 
	
	This:C1470.detail.refresh()
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function _UPDATE_RESNAME($context : Object)
	
	var $itemPosition; $len; $pos; $row : Integer
	var $ptr : Pointer
	var $langue; $target : Object
	var $group : cs:C1710.XliffGroup
	var $xliff : cs:C1710.Xliff
	
	$target:=$context.string
	
	// Update the reference XML tree
	$xliff:=$context.file
	$xliff.setAttribute($xliff.findByXPath($target.xpath); "resname"; $target.resname)
	This:C1470.save($xliff)
	
	$ptr:=This:C1470.stringList.pointer
	$itemPosition:=Find in array:C230($ptr->; True:C214)
	
	If (OB Instance of:C1731($target; cs:C1710.XliffGroup))
		
		$group:=$xliff.groups.query("previous = :1"; $target.previous).pop()
		$group.setResname($target.resname)
		
		For each ($langue; $target.localizations)
			
			$xliff:=$langue.xliff
			$group:=$xliff.groups.query("resname = :1"; $target.previous).pop()
			
			If ($group#Null:C1517)
				
				$xliff.setAttribute($group.node; "resname"; $target.resname)
				This:C1470.save($xliff)
				
				$group.setResname($target.resname)
				
			End if 
		End for each 
		
		// Updating of UI elements
		$ptr:=This:C1470.stringList.columnPtr("group")
		
		Repeat 
			
			$row:=Find in array:C230($ptr->; $target.previous; $row+1)
			
			If ($row>0)
				
				$ptr->{$row}:=$target.resname
				
			End if 
		Until ($row=-1)
		
		OB REMOVE:C1226($target; "previous")
		This:C1470.stringList.sort(1)
		
		$itemPosition:=Find in array:C230($ptr->; $target.resname)
		
		This:C1470.stringList.select($itemPosition)
		This:C1470.stringList.selectBreak($itemPosition)
		
	Else 
		
		// Synchronize attributes of other files
		This:C1470._synchronizeAttributes($context.parent; $target; $xliff.getAttributes($target.node))
		
		If (Match regex:C1019("(?mi-s)(?<=trans-unit\\[@resname=\")([^\"]*)"; $target.xpath; 1; $pos; $len))
			
			$target.xpath:=Substring:C12($target.xpath; 1; $pos-1)+$target.resname+Substring:C12($target.xpath; $pos+$len)
			
		End if 
		
		// Updating of UI elements
		$ptr:=This:C1470.stringList.columnPtr("unit")
		$ptr->{$itemPosition}:=$target.resname
		This:C1470.stringList.sort(2)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function _UPDATE_TRANSLATE($context : Object)
	
	var $target; $unit; $value : Text
	var $attributes; $language; $parent; $string : Object
	var $xliff : cs:C1710.Xliff
	
	$string:=$context.string
	$parent:=$context.parent
	
	// Update the reference XML tree
	$xliff:=$context.file
	$unit:=$xliff.findByXPath($string.xpath)
	
	If ($string.attributes["translate"]=Null:C1517)
		
		$xliff.removeAttribute($unit; "translate")
		$attributes:=$xliff.getAttributes($unit)
		
		$value:=$xliff.sourceValue($unit)
		
		// Create if any & set value
		$target:=$xliff.targetNode($unit; True:C214)
		$xliff.setValue($target; $value)
		
		This:C1470.save($xliff)
		
		$string.target.value:=$value
		
		For each ($language; $string.localizations)
			
			// Update the XML tree
			$xliff:=$language.xliff
			$unit:=$xliff.findByXPath($string.xpath)
			
			$target:=$xliff.targetNode($unit; True:C214)
			$xliff.setValue($target; $string.source.value)
			$xliff.setState($target; $xliff.NEEDS_TRANSLATION)
			
			This:C1470.save($xliff)
			
			// Updating of UI elements
			$language.properties:=$language.properties || {}
			$language.properties.state:=$xliff.NEEDS_TRANSLATION
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
		$xliff.setState($target; $xliff.NEEDS_TRANSLATION)
		
		This:C1470.save($xliff)
		
		// Updating of UI elements
		$language.properties:=$language.properties || {}
		$language.properties.state:=$xliff.NEEDS_TRANSLATION
		$language.value:=$string.source.value
		
	End for each 
	
	This:C1470.detail.refresh()
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function _UPDATE_LOCALIZED_TARGET($context : Object)
	
	var $target : Text
	var $xliff : cs:C1710.Xliff
	
	// Get xliff
	$xliff:=This:C1470.cache.query("root=:1"; $context.root).pop()
	
	// Get target & set value
	$target:=$xliff.findByXPath($context.string.target.xpath)
	$xliff.setValue($target; $context.value)
	
	// Remove state attribute
	$xliff.removeState($target)
	
	// Save
	This:C1470.save($xliff)
	
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
	