//%attributes = {}
#DECLARE($action : Text; $data)

Case of 
		//______________________________________________________
	: (Length:C16($action)=0)
		
		var winRef:=Open form window:C675("EDITOR_DEBUG"; Palette form window:K39:9; On the right:K39:3; At the bottom:K39:6; *)
		DIALOG:C40("EDITOR_DEBUG"; *)
		
		//______________________________________________________
	: ($action="update")
		
		CALL FORM:C1391(winRef; Formula:C1597(OBJECT SET VALUE:C1742("Input"; $data)))
		
		//______________________________________________________
	: ($action="close")
		
		CALL FORM:C1391(winRef; Formula:C1597(CANCEL:C270))
		
		//______________________________________________________
	Else 
		
		// A "Case of" statement should never omit "Else"
		
		//______________________________________________________
End case 