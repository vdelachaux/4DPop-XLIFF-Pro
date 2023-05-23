//%attributes = {}
//var $o : Object
//$o:=$o || {}

var $sync : cs:C1710._sync

var $folder : 4D:C1709.Folder
$folder:=Folder:C1567(Select folder:C670; fk platform path:K87:2)

If (OK=0)
	
	return 
	
End if 

$sync:=cs:C1710._sync.new("♻️ LIBRAIRIES"; $folder)

If (True:C214)
	
	$sync.push()
	
Else 
	
	
	var $c : Collection
	$c:=$sync.fetch()
	
	$sync.pull()
	
End if 



