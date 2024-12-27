// MARK: Default values ⚙️
property isSubform:=False:C215
property toBeInitialized:=False:C215

// MARK: Delegates 📦
property form : cs:C1710.form
property Editor : cs:C1710._Editor:=cs:C1710._Editor.new()

property source : cs:C1710.button
property targetAdd; targetRemove : cs:C1710.button
property targets : cs:C1710.listbox

Class constructor
	
	// MARK:Delegates 📦
	This:C1470.form:=cs:C1710.form.new(This:C1470)
	
	This:C1470.form.init()
	
	// MARK:-[STANDARD SUITE]
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function init()
	
	This:C1470.source:=This:C1470.form.Button("source")
	This:C1470.targets:=This:C1470.form.Listbox("List Box2")
	This:C1470.targetAdd:=This:C1470.form.Button("Button3")
	This:C1470.targetRemove:=This:C1470.form.Button("Button4")
	
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
	Case of 
			
			//==============================================
		: (This:C1470.source.catch($e))
			
			This:C1470.doSelectSourceLanguage()
			
			//==============================================
		: (This:C1470.targets.catch($e))
			
			This:C1470.form.update()
			
			//==============================================
		: (This:C1470.targetAdd.catch($e))
			
			This:C1470.doAddTargetLanguage()
			
			//==============================================
		: (This:C1470.targetRemove.catch($e))
			
			var $language : cs:C1710.language:=This:C1470.targets.item
			var $folder:=Folder:C1567("/RESOURCES/"+$language.lproj+This:C1470.Editor.FOLDER_EXTENSION; *)\
				 || Folder:C1567("/RESOURCES/"+$language.legacy+This:C1470.Editor.FOLDER_EXTENSION; *)
			
			OK:=Num:C11($folder.files(fk ignore invisible:K87:22).length=0)
			
			If (Not:C34(Bool:C1537(OK)))
				
				CONFIRM:C162("The content of this language folder will be deleted"; "Delete")
				
			End if 
			
			If (Bool:C1537(OK))
				
				$folder.delete(fk recursive:K87:7)
				Form:C1466.languages:=This:C1470.Editor.targetLanguages(Form:C1466.reference.lproj)
				This:C1470.targetRemove.disable()
				
			End if 
			
			//==============================================
	End case 
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function onLoad()
	
	Form:C1466.reference:=This:C1470.Editor.language()
	This:C1470.source.setTitle(Form:C1466.reference.localized)
	Form:C1466.languages:=This:C1470.Editor.targetLanguages()
	This:C1470.targetRemove.disable()
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function update()
	
	This:C1470.targetRemove.enable(This:C1470.targets.item#Null:C1517)
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function doSelectSourceLanguage()
	
	var $language : cs:C1710.language
	var $menu : cs:C1710.menu:=cs:C1710.menu.new()
	
	var $c : Collection:=Form:C1466.languages.copy().push(Form:C1466.reference).distinct()
	
	If ($c.length>0)
		
		If ($c.length>1)
			
			$menu.append("DETECTED LANGUAGES").disable()
			
		End if 
		
		For each ($language; $c.orderBy("lproj"))
			
			$menu.append($language.menuItem(); $language.lproj)\
				.mark($language.lproj=Form:C1466.reference.lproj)
			
		End for each 
		
		$menu.line()
		
	End if 
	
	$c:=$c.extract("lproj")
	
	For each ($language; This:C1470.Editor.LANGUAGES.orderBy("lproj"))
		
		If ($c.includes($language.lproj))
			
			continue
			
		End if 
		
		$menu.append($language.menuItem(); $language.lproj)\
			.mark($language.lproj=Form:C1466.reference.lproj)
		
	End for each 
	
	If ($menu.popup().selected)
		
		Form:C1466.reference:=This:C1470.Editor.language($menu.choice)
		This:C1470.source.setTitle(Form:C1466.reference.localized)  //.bestSize()
		Form:C1466.languages:=This:C1470.Editor.targetLanguages(Form:C1466.reference.lproj)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function doAddTargetLanguage()
	
	var $language : cs:C1710.language
	var $menu : cs:C1710.menu:=cs:C1710.menu.new()
	
	var $c : Collection:=Form:C1466.languages.copy().push(This:C1470.Editor.language()).distinct().extract("lproj")
	
	For each ($language; This:C1470.Editor.LANGUAGES.orderBy("lproj"))
		
		If ($c.includes($language.lproj))
			
			continue
			
		End if 
		
		$menu.append($language.menuItem(); $language.lproj)\
			.mark($language.lproj=Form:C1466.reference.lproj)
		
	End for each 
	
	If ($menu.popup().selected)
		
		Folder:C1567("/RESOURCES/"+$menu.choice+This:C1470.Editor.FOLDER_EXTENSION; *).create()
		Form:C1466.languages:=This:C1470.Editor.targetLanguages(Form:C1466.reference.lproj)
		
	End if 
	