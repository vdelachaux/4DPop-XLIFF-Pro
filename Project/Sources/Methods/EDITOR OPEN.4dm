//%attributes = {"invisible":true}
#DECLARE($run : Boolean)

var $name:="$4DPop XLIFF Pro"

If (Not:C34($run))\
 && (cs:C1710.process.new().isProcessExists($name; True:C214))
	
	return 
	
End if 

If ($run)
	
	var $project:=cs:C1710.database.new()
	
	// Allow assertions for the matrix database & me ;-)
	SET ASSERT ENABLED:C1131($project.isMatrix | $project.isDebug; *)
	
	If (Shift down:C543)  // Delete geometry
		
		$project.deleteGeometry()
		
	End if 
	
	var $data:={}
	
	var $pref:=cs:C1710.Preferences.new()
	
	If (Not:C34($pref.exists))
		
		// First launch
		$data.window:=Open form window:C675("WIZARD"; Movable form dialog box:K39:8; Horizontally centered:K39:1; Vertically centered:K39:4)
		DIALOG:C40("WIZARD"; $data)
		CLOSE WINDOW:C154()
		
		If (Bool:C1537(OK))
			
			// Save preferences
			$pref.set("project"; $project.name)
			$pref.set("reference"; $data.reference.lproj)
			$pref.set("languages"; $data.languages.extract("lproj"))
			
		Else 
			
			CALL WORKER:C1389($name; Formula:C1597(KILL WORKER:C1390($name)))
			return 
			
		End if 
	End if 
	
	If ($project.isMatrix)
		
		$data.window:=Open form window:C675("EDITOR"; Plain form window:K39:10; Horizontally centered:K39:1; Vertically centered:K39:4; *)
		DIALOG:C40("EDITOR"; $data; *)
		
	End if 
	
Else 
	
	CALL WORKER:C1389($name; Current method name:C684; True:C214)
	
End if 