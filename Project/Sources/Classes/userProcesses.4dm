shared singleton Class constructor
	
	//
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns a snapshot of running user processes in collection form 
Function getRunningUserProcesses() : Collection
	
	var $c : Collection:=Process activity:C1495(Processes only:K5:35).processes
	return $c.query("state >= :1 & type > 0"; Executing:K13:4)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns if the process whose number or name has been passed exists
Function isProcessRunning($name) : Boolean
	
	return This:C1470.processInfo($name)#Null:C1517
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns if the process whose number or name has been passed exists
	// It can be moved to the foreground if you pass True as the 2nd parameter.
Function isProcessExists($name; $bringToFront : Boolean) : Boolean
	
	var $process : Object:=This:C1470.processInfo($name)
	
	If ($process#Null:C1517)
		
		If ($bringToFront)
			
			SHOW PROCESS:C325($process.number)
			BRING TO FRONT:C326($process.number)
			
		End if 
		
		return True:C214
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns an object providing detailed information on the process whose number or name has been passed
Function processInfo($process) : Object
	
	Case of 
			
			//______________________________________________________
		: (Value type:C1509($process)=Is text:K8:3)
			
			return This:C1470.getRunningUserProcesses().query("name = :1"; $process).first()
			
			//______________________________________________________
		: (Value type:C1509($process)=Is longint:K8:6) || (Value type:C1509($process)=Is real:K8:4)
			
			return This:C1470.getRunningUserProcesses().query("ID = :1"; $process).first()
			
			//______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215; "process must be a text or numeric value")
			
			//______________________________________________________
	End case 
	