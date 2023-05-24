//%attributes = {}
var $path : Text
var $c : Collection
var $folder : 4D:C1709.Folder
var $sync : cs:C1710._sync
var $pref : cs:C1710.pref

// Get the sync folder
$pref:=cs:C1710.pref.new().session("4DPop brew.remote")

If ($pref.exists)
	
	$folder:=Folder:C1567($pref.get("target"))
	
Else 
	
	$path:=Select folder:C670("Select the synchronization folder")
	
	If (OK=0)
		
		return 
		
	End if 
	
	$folder:=Folder:C1567($path; fk platform path:K87:2)
	
	$pref.set("target"; $folder.path)
	
End if 

// Get the local folder
$pref:=cs:C1710.pref.new().database("4DPop brew.local")

If (Not:C34($pref.exists))
	
	$pref.set("target"; "♻️ LIBRAIRIES")
	
End if 

$sync:=cs:C1710._sync.new($pref.get("target"); $folder)

If (True:C214)
	
	$sync.push()
	
Else 
	
	$c:=$sync.fetch()
	
	$sync.pull()
	
End if 