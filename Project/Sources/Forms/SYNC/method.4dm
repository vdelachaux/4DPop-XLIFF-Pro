var $e : cs:C1710.evt

$e:=cs:C1710.evt.new()

Case of 
		
		//______________________________________________________
	: ($e.load)
		
		Form:C1466.local:=cs:C1710.listboxDelegate.new("local")
		
		ARRAY TEXT:C222($names; 0x0000)
		METHOD GET FOLDERS:C1206($names; *)
		Form:C1466.folders:=[]
		
		var $i : Integer
		
		For ($i; 1; Size of array:C274($names); 1)
			
			Form:C1466.folders.push({name: $names{$i}})
			
		End for 
		
		Form:C1466.sync:=cs:C1710._sync.new()
		
		var $source : Text
		$source:=String:C10(Form:C1466.sync.source)
		
		If (Length:C16($source)>0)
			
			var $list : cs:C1710.listboxDelegate
			$list:=Form:C1466.local
			
			var $indx : Integer
			$indx:=Find in array:C230($names; $source)
			$list.select($indx)
			
		End if 
		
		//______________________________________________________
End case 