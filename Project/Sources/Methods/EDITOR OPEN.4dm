//%attributes = {"invisible":true}
#DECLARE($run : Boolean)

var $data : Object
var $database : cs:C1710.database

$database:=cs:C1710.database.new()

If (Not:C34($run))\
 && ($database.isProcessExists("$4DPop XLIFF Pro"; True:C214))
	
	return 
	
End if 

If ($run)
	
	// Allow assertions for the matrix database & me ;-)
	SET ASSERT ENABLED:C1131($database.isMatrix | $database.isDebug; *)
	
	If (Shift down:C543)  // Delete geometry
		
		$database.deleteGeometry()
		
	End if 
	
	$data:=New object:C1471(\
		"window"; Open form window:C675("EDITOR"; Plain form window:K39:10; Horizontally centered:K39:1; Vertically centered:K39:4; *))
	
	DIALOG:C40("EDITOR"; $data; *)
	
Else 
	
	CALL WORKER:C1389("$4DPop XLIFF Pro"; Current method name:C684; True:C214)
	
End if 