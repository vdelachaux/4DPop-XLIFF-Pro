Class extends widgetDelegate

// === === === === === === === === === === === === === === === === === === === === ===
Class constructor($name : Text)  //; $datasource : Variant)
	
	Super:C1705($name)
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function start()
	
	This:C1470.setValue(1)
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function stop()
	
	This:C1470.setValue(0)
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function isRunning() : Boolean
	
	return (This:C1470.getValue()#0)