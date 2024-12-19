Class constructor
	
	//
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function getRunningUserProcesses() : Collection
	
	var $c : Collection:=Process activity:C1495(Processes only:K5:35).processes
	return $c.query("state >= :1 & type > 0"; Executing:K13:4)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function isProcessRunning($name : Text) : Boolean
	
	return This:C1470.getRunningUserProcesses().query("name = :1"; $name).pop()#Null:C1517
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function isProcessExists($name : Text; $bringToFront : Boolean) : Boolean
	
	var $process : Object:=This:C1470.getRunningUserProcesses().query("name = :1"; $name).first()
	
	If ($process#Null:C1517)
		
		If ($bringToFront)
			
			SHOW PROCESS:C325($process.number)
			BRING TO FRONT:C326($process.number)
			
		End if 
		
		return True:C214
		
	End if 