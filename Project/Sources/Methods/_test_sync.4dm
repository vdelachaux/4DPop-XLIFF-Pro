//%attributes = {}
var $path : Text
var $sync : cs:C1710._sync

//// Get the sync folder
//$pref:=cs.pref.new().session("4DPop brew.remote")
//If ($pref.exists)
//$folder:=Folder($pref.get("target"))
//Else
//$path:=Select folder("Select the synchronization folder")
//If (OK=0)
//return
//End if
//$folder:=Folder($path; fk platform path)
//$pref.set("target"; $folder.path)
//End if
//// Get the local folder
//$pref:=cs.pref.new().database("4DPop brew.local")
//If (Not($pref.exists))
//$pref.set("target"; "♻️ LIBRAIRIES")
//End if
//$sync:=cs._sync.new($pref.get("target"); $folder)
//If (Not($sync.success))
//TRACE
//End if
//If (True)
//$sync.push()
//Else
//$c:=$sync.fetch()
//$sync.pull()
//End if

$sync:=cs:C1710._sync.new()

//  $sync.Failure()

If ($sync.fail)
	
	If (Not:C34($sync.remoteValid))
		
		$path:=Select folder:C670("Select the synchronization folder")
		
		If (OK=0)
			
			return 
			
		End if 
		
		//SetRemoteFolder
		$sync.SetRemoteFolder(Folder:C1567($path; fk platform path:K87:2).path)
		
	End if 
	
	If (Not:C34($sync.localValid))
		
		$sync.SetLocalFolder("♻️ LIBRAIRIES")
		
	End if 
End if 

If ($sync.success)
	
	$sync.Push()
	
End if 