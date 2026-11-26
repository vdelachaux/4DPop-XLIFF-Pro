/*
Class: _STRING_Controller - (4DPop XLIFF Pro)
Created 20-2-2023 by Vincent de Lachaux
*/

// MARK: Default values ⚙️
property isSubform:=True:C214
property toBeInitialized:=False:C215

// MARK: Delegates 📦
property form : cs:C1710.ui.form

// MARK: Widgets 🧱
property flag; value : cs:C1710.ui.input

// MARK: Text being typed (Get edited text), not yet in the variable, and the trans-unit it belongs to,
// memorized when the typing starts (never the string displayed when saving)
property pending : Variant
property target : Object
property displayed : Text

Class constructor
	
	// MARK:Delegates 📦
	This:C1470.form:=cs:C1710.ui.form.new(This:C1470)
	
	This:C1470.form.init()
	
	// MARK:-[Standard Suite]
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function init()
	
	// MARK:Wigets
	This:C1470.flag:=This:C1470.form.Input("flag")
	This:C1470.value:=This:C1470.form.Input("value")
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function handleEvents($e : cs:C1710.ui.evt)
	
	$e:=$e || cs:C1710.ui.evt.new()
	
	// MARK:Form Method
	If ($e.objectName=Null:C1517)
		
		Case of 
				
				//______________________________________________________
			: ($e.load)
				
				This:C1470.form.onLoad()
				
				//______________________________________________________
			: ($e.activate)
				
				//Never seems to trigger
				
				//______________________________________________________
			: ($e.boundVariableChange)
				
				// Another string, file or language is displayed: save what was being typed, to its own trans-unit
				This:C1470._savePending()
				
				This:C1470.form.update()
				
				//______________________________________________________
			: ($e.unload)
				
				// Window closed without leaving the field: save now, a callback would never run
				This:C1470._savePending()
				
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
		: (This:C1470.value.catch($e))
			
			If ($e.gettingFocus)
				
				SPELL SET CURRENT DICTIONARY:C904(Form:C1466._container.lproj)
				
				This:C1470.value.backup().highlight()
				This:C1470.pending:=Null:C1517
				This:C1470.target:=This:C1470._target(Form:C1466._container)
				return 
				
			End if 
			
			If ($e.afterEdit)
				
				// getValue() returns Get edited text while the field has the focus
				This:C1470.target:=This:C1470.target || This:C1470._target(Form:C1466._container)
				This:C1470.pending:=This:C1470.value.getValue()
				return 
				
			End if 
			
			If ($e.losingFocus)
				
				If (This:C1470.pending=Null:C1517)\
					 && (This:C1470.target#Null:C1517)\
					 && (This:C1470.value.modified)
					
					This:C1470.pending:=This:C1470.value.getValue()  // Modified without On After Edit
					
				End if 
				
				If (This:C1470._savePending())
					
					This:C1470.value.setColors(Foreground color:K23:1; Background color:K23:2)
					
				End if 
			End if 
			
			//==============================================
		: (This:C1470.flag.catch($e))
			
			//TODO: Remove state "needs-review-translation"
			
			//Form._container.value:=This.value.getValue()
			//This.form.callMeBack("_UPDATE_LOCALIZED_TARGET"; Form._container)
			//This.value.setColors(Foreground color; Background color)
			
			//==============================================
	End case 
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// The trans-unit edited in the field: values copied from the displayed localisation when the typing starts
Function _target($context : Object) : Object
	
	If ($context=Null:C1517) || ($context.string=Null:C1517)
		
		return Null:C1517
		
	End if 
	
	If (Length:C16(String:C10($context.string.target.xpath))=0) || ($context.root=Null:C1517)
		
		return Null:C1517
		
	End if 
	
	return {\
		root: $context.root; \
		lproj: String:C10($context.lproj); \
		id: String:C10($context.string.id); \
		xpath: String:C10($context.string.target.xpath); \
		original: This:C1470.displayed; \
		editor: $context.editor}
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Saves the text typed in the field to the trans-unit memorized when the typing started, once:
	// on losing focus, when the window closes or when another string, file or language is displayed.
	// Direct call to the editor (set by _STRING_Controller.update()): a callback would never run if the window is closing
Function _savePending() : Boolean
	
	var $target : Object:=This:C1470.target
	var $text : Variant:=This:C1470.pending
	
	// Only once
	This:C1470.pending:=Null:C1517
	This:C1470.target:=Null:C1517
	
	If ($text=Null:C1517) || ($target=Null:C1517)
		
		return False:C215
		
	End if 
	
	If (String:C10($text)=$target.original)
		
		return False:C215  // Nothing changed
		
	End if 
	
	var $context : Object:={\
		root: $target.root; \
		lproj: $target.lproj; \
		string: {id: $target.id; target: {xpath: $target.xpath}}; \
		value: String:C10($text)}
	
	var $displayed : Object:=Form:C1466._container
	
	If ($displayed#Null:C1517)
		
		If ($displayed.string#Null:C1517)
			
			If ($displayed.root=$target.root)\
				 && (String:C10($displayed.string.id)=$target.id)
				
				$displayed.value:=$context.value  // Still displayed
				This:C1470.displayed:=$context.value  // Reference for the next typing in the field (update() is not called after a Tab)
				
			End if 
		End if 
	End if 
	
	If ($target.editor#Null:C1517)
		
		return $target.editor._UPDATE_LOCALIZED_TARGET($context)
		
	End if 
	
	This:C1470.form.callMeBack($context; "_UPDATE_LOCALIZED_TARGET")
	return True:C214
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function onLoad()
	
	This:C1470.flag.font:="emoji"
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function update()
	
	This:C1470.value.setColors(Foreground color:K23:1; Background color:K23:2)
	
	Form:C1466._container:=This:C1470.form.containerValue
	
	If (Form:C1466._container#Null:C1517)
		
		var $state : Text
		
		If (Form:C1466._container.properties#Null:C1517)
			
			$state:=String:C10(Form:C1466._container.properties.state)
			
		End if 
		
		If (Position:C15($state; "needs-translation|new"; *)>0)
			
			This:C1470.value.setValue("")
			This:C1470.displayed:=""
			This:C1470.value.setPlaceholder(Form:C1466._container.value)
			This:C1470.value.backgroundColor:=This:C1470.form.darkScheme ? "#3A3E5A" : 16775402
			
		Else 
			
			This:C1470.value.setValue(Form:C1466._container.value)
			This:C1470.displayed:=String:C10(Form:C1466._container.value)
			This:C1470.value.setPlaceholder("")
			
			If (Position:C15($state; "needs-review-translation"; *)>0)
				
				This:C1470.value.foregroundColor:=This:C1470.form.darkScheme ? "white" : Foreground color:K23:1
				This:C1470.value.backgroundColor:=This:C1470.form.darkScheme ? "#516D9F" : 16773064
				
			End if 
		End if 
	End if 
	
	// Adjust value width
	var $height; $width : Integer
	OBJECT GET SUBFORM CONTAINER SIZE:C1148($width; $height)
	
	var $coord : cs:C1710.ui.coordinates:=This:C1470.value.coordinates
	$coord.top:=5
	$coord.right:=$width-18
	$coord.bottom:=$height-9
	
	This:C1470.value.setCoordinates($coord)
	