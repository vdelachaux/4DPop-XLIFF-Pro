//%attributes = {"invisible":true}
#DECLARE($run : Boolean)

var $name : Text:="$4DPop XLIFF Pro"

If (Not:C34($run))\
 && (cs:C1710.process.new().isProcessExists($name; True:C214))
	
	return 
	
End if 

If ($run)
	
	var $database : cs:C1710.database:=cs:C1710.database.new()
	
	// Allow assertions for the matrix database & me ;-)
	SET ASSERT ENABLED:C1131($database.isMatrix | $database.isDebug; *)
	
	If (Shift down:C543)  // Delete geometry
		
		$database.deleteGeometry()
		
	End if 
	
	var $data : Object:={window: Open form window:C675("EDITOR"; Plain form window:K39:10; Horizontally centered:K39:1; Vertically centered:K39:4; *)}
	DIALOG:C40("EDITOR"; $data; *)
	
Else 
	
	CALL WORKER:C1389($name; Current method name:C684; True:C214)
	
End if 