var $i : Integer
var $e : cs:C1710.evt

$e:=cs:C1710.evt.new()

Case of 
		//______________________________________________________
	: ($e.load)
		
		ARRAY TEXT:C222($names; 0x0000)
		METHOD GET FOLDERS:C1206($names; *)
		Form:C1466.folders:=[]
		
		For ($i; 1; Size of array:C274($names); 1)
			
			Form:C1466.folders.push({name: $names{$i}})
			
		End for 
		
		Form:C1466.delegate:=cs:C1710._sync.new()
		
		//______________________________________________________
	: (False:C215)
		
		//______________________________________________________
	Else 
		
		// A "Case of" statement should never omit "Else"
		
		//______________________________________________________
End case 