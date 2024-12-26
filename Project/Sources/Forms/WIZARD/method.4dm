var $e:=FORM Event:C1606

Case of 
		//______________________________________________________
	: ($e.code=On Load:K2:1)
		
		Form:C1466.editor:=cs:C1710._Editor.new()
		//Form.ref:=Form.editor.mainLanguage
		//Form.ref.flag:=Form.editor.getFlag(Form.ref)
		
		Form:C1466.language:=Form:C1466.editor.language()
		
		//______________________________________________________
	: (False:C215)
		
		
		
		//______________________________________________________
	Else 
		
		// A "Case of" statement should never omit "Else"
		
		//______________________________________________________
End case 