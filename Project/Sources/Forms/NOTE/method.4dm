// ----------------------------------------------------
// Form method : NOTE - (4DPop XLIFF Pro)
// ID[FA7DB5B98D2D4E8EADB6A101D8983968]
// Created #3-1-2017 by Vincent de Lachaux
// ----------------------------------------------------
var $e : cs:C1710.evt

$e:=FORM Event:C1606

Case of 
		
		//______________________________________________________
	: ($e.code=On Activate:K2:9)
		
		// Backup cuttent value
		Form:C1466.$note:=Form:C1466.note
		
		GOTO OBJECT:C206(*; "note")
		
		//______________________________________________________
	: ($e.code=On Getting Focus:K2:7)
		
		HIGHLIGHT TEXT:C210(*; "note"; Length:C16(String:C10(Form:C1466.note))+1; Length:C16(String:C10(Form:C1466.note))+1)
		
		//______________________________________________________
	: ($e.code=On Losing Focus:K2:8)
		
		If (Form:C1466.note#Form:C1466.$note)
			
			CALL SUBFORM CONTAINER:C1086(-On Data Change:K2:15)
			
		Else 
			
			CALL SUBFORM CONTAINER:C1086(-On Close Box:K2:21)
			
		End if 
		
		//______________________________________________________
	: (($e.code=On Clicked:K2:4)\
		 & ($e.objectName="close"))
		
		GOTO OBJECT:C206(*; "")
		
		//______________________________________________________
End case 