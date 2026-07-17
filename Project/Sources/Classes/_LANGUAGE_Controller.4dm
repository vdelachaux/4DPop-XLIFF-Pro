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
		: (This:C1470.value.catch($e))
			
			If ($e.gettingFocus)
				
				SPELL SET CURRENT DICTIONARY:C904(Form:C1466._container.lproj)
				
				This:C1470.value.backup().highlight()
				return 
				
			End if 
			
			If ($e.losingFocus)\
				 && (This:C1470.value.modified)
				
				Form:C1466._container.value:=This:C1470.value.getValue()
				This:C1470.form.callMeBack(Form:C1466._container; "_UPDATE_LOCALIZED_TARGET")
				This:C1470.value.setColors(Foreground color:K23:1; Background color:K23:2)
				
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
			This:C1470.value.setPlaceholder(Form:C1466._container.value)
			This:C1470.value.backgroundColor:=This:C1470.form.darkScheme ? "#3A3E5A" : 16775402
			
		Else 
			
			This:C1470.value.setValue(Form:C1466._container.value)
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
	