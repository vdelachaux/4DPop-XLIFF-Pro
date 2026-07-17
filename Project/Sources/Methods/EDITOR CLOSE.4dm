//%attributes = {"invisible":true}
#DECLARE($data : Object)

var $dialog : Object:=$data.__DIALOG__

// MARK:-Update modified files and close XML trees
var $xliff : cs:C1710.Xliff

For each ($xliff; $dialog.cache)
	
	If ($xliff.modified)
		
		$xliff.updateHeader($dialog.GENERATOR; $dialog.VERSION)
		$xliff.updateCopyright()
		
	End if 
	
	$xliff.close()
	
End for each 

// MARK:-Store session
var $pref : cs:C1710.Preferences:=$dialog.Preferences
$pref.set("sourceLanguage"; $dialog.main.language.lproj)
$pref.set("targetLanguages"; $dialog.languages.extract("lproj"))

// Compute a digest of files in the source folder
var $digest : Text
var $file : 4D:C1709.File
For each ($file; $dialog.main.files)
	
	$digest+=Generate digest:C1147($file.getText(); MD5 digest:K66:1)
	
End for each 

$digest:=Generate digest:C1147($digest; MD5 digest:K66:1)

$pref.set("files"; $data.files.extract("name"))
$pref.set("currentFile"; $dialog.current.file.name)
$pref.set("digest"; $digest)

// MARK:-
// TODO: Update XLIFF files on server

// MARK:-Cleanup
var $o : Object
For each ($o; Process activity:C1495(Processes only:K5:35).processes.query("name = :1"; "$4DPop XLIFF - @"))
	
	KILL WORKER:C1390($o.name)
	
End for each 

/* EDITOR CLOSE runs inside the "$4DPop XLIFF Pro" worker (dispatched via
   CALL WORKER), which is the process where the editor form was instantiated.
   Current process is therefore the worker to kill (the old local form class
   stored this in form.process, which the component form class no longer has). */
KILL WORKER:C1390(Current process:C322)