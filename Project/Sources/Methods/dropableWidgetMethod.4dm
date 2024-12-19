//%attributes = {"invisible":true,"shared":true}
#DECLARE() : Integer

var $manager : Text:="_"+OBJECT Get name:C1087+"Manager"
var $instance : 4D:C1709.Class:=formGetInstance

If (Asserted:C1132(OB Instance of:C1731($instance[$manager]; 4D:C1709.Function); "The function \""+$manager+"\" is missing in the class\""+$instance.__CLASS__.name+"\""))
	
	return $instance[$manager](FORM Event:C1606)
	
Else 
	
	return -1
	
End if 