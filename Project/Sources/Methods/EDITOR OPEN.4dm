//%attributes = {"invisible":true}
#DECLARE($run : Boolean)

If (False:C215)
	C_BOOLEAN:C305(EDITOR OPEN; $1)
End if 

var $data : Object
var $database : cs:C1710.database

If ($run)
	
	$database:=cs:C1710.database.new()
	
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