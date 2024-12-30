//%attributes = {"invisible":true}
#DECLARE($run : Boolean)

var $me:="$4DPop XLIFF Pro"

If (Not:C34($run))\
 && (cs:C1710.process.new().isProcessExists($me; True:C214))
	
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
			$pref.set("currentProject"; $project.name)
			$pref.set("sourceLanguage"; $data.reference.lproj)
			$pref.set("targetLanguages"; $data.languages.extract("lproj"))
			
			CALL WORKER:C1389($me; Current method name:C684; True:C214)
			
		Else 
			
			CALL WORKER:C1389($me; Formula:C1597(KILL WORKER:C1390($me)))
			
		End if 
		
		return 
		
	End if 
	
	$data.window:=Open form window:C675("EDITOR"; Plain form window:K39:10; Horizontally centered:K39:1; Vertically centered:K39:4; *)
	DIALOG:C40("EDITOR"; $data; *)
	
Else 
	
	CALL WORKER:C1389($me; Current method name:C684; True:C214)
	
End if 