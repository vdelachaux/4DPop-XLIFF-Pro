/*
Class: _SEARCH_PICKER_Controller - (4DPop XLIFF Pro)
Created 10-05-2023 by Vincent de Lachaux
*/

property form : cs:C1710.formDelegate
property callback : 4D:C1709.Function
property box : cs:C1710.inputDelegate
property glass : cs:C1710.buttonDelegate
property ring : cs:C1710.staticDelegate

Class constructor()
	
	This:C1470.__CLASS__:=OB Class:C1730(This:C1470)
	
	This:C1470.isSubform:=True:C214
	
	// MARK:-Delegates 📦
	This:C1470.form:=cs:C1710.formDelegate.new(This:C1470)
	
	This:C1470.borderColor:=0x00E5E5E5
	This:C1470.expanded:=False:C215
	
	This:C1470.form.init()
	
	// MARK:-[Standard Suite]
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function init()
	
	This:C1470.box:=This:C1470.form.input.new("searchBox")
	This:C1470.ring:=This:C1470.form.static.new("searchBorder")
	This:C1470.glass:=This:C1470.form.button.new("searchGlass")
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function handleEvents($e : cs:C1710.evt)
	
	$e:=$e || FORM Event:C1606
	
	// MARK:Form Method
	If ($e.objectName=Null:C1517)
		
		Case of 
				
				//______________________________________________________
			: ($e.code=On Load:K2:1)
				
				SET TIMER:C645(-1)
				
				//______________________________________________________
			: ($e.code=On Timer:K2:25)
				
				SET TIMER:C645(0)
				
				This:C1470.reset()
				
				//______________________________________________________
			: ($e.code=On Unload:K2:2)
				
				This:C1470.reset()
				
				//______________________________________________________
		End case 
		
		return 
		
	End if 
	
	// MARK: Widget Methods
	Case of 
			
			//==============================================
		: ($e.code=On Activate:K2:9)
			
			//⚠️ $e.name = the name of the container
			This:C1470.box.focus()
			
			//==============================================
		: ($e.code=On Getting Focus:K2:7)
			
			This:C1470.expand()
			
			//==============================================
		: (This:C1470.box.catch($e))
			
			var $searchText : Text
			$searchText:=This:C1470.box.getValue()
			
			Case of 
					
					//______________________________________________________
				: ($e.code=On Losing Focus:K2:8)
					
					If (Length:C16($searchText)=0)
						
						This:C1470.reset()
						
					End if 
					
					//______________________________________________________
				: ($e.code=On After Edit:K2:43)
					
					// Restore default colors
					This:C1470.box.setColors(Foreground color:K23:1; Background color none:K23:10)
					This:C1470.ring.setColors(Highlight text background color:K23:5; Background color none:K23:10)
					
					//______________________________________________________
				: ($e.code=On Data Change:K2:15)
					
					This:C1470.form.containerInstance.data.value:=$searchText
					
					// Inform the host
					This:C1470.form.setValue(This:C1470)
					
					If (Length:C16($searchText)#0)
						
						// Stay in the widget
						This:C1470.box.focus()
						
					End if 
					
					//______________________________________________________
			End case 
			
			//==============================================
	End case 
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function expand()
	
	If (Not:C34(This:C1470.expanded))
		
		This:C1470.glass.moveHorizontally(-67)
		This:C1470.box.moveAndResizeHorizontally(-67)
		This:C1470.ring.setColors(Highlight text background color:K23:5; Background color none:K23:10)
		
		This:C1470.expanded:=True:C214
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function collapse()
	
	This:C1470.glass.setCoordinates(70; 3; 83; 18).show()
	This:C1470.box.setCoordinates(85; 2; 190; 19).show()
	
	This:C1470.expanded:=False:C215
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function reset()
	
	This:C1470.collapse()
	
	This:C1470.box.setColors(Foreground color:K23:1; Background color none:K23:10)
	This:C1470.ring.setColors(This:C1470.containerInstance.data.borderColor || This:C1470.borderColor; Background color none:K23:10).show()
	