//%attributes = {"invisible":true}
#DECLARE($data : Object)

var $dialog : Object:=$data.__DIALOG__

// MARK:-Update modified files & close XML trees
var $xliff : cs:C1710.Xliff

For each ($xliff; $dialog.cache)
	
	If ($xliff.modified)
		
		$xliff.updateHeader($dialog.GENERATOR; $dialog.VERSION)
		$xliff.updateCopyright()
		
	End if 
	
	$xliff.close()
	
End for each 

ASSERT:C1129($dialog.cache.extract("root").length=0; "Not all open XML trees have been closed")

// MARK:-Store session
var $pref : cs:C1710.Preferences:=$dialog.Preferences
$pref.set("sourceLanguage"; $dialog.main.language.lproj)
$pref.set("targetLanguages"; $dialog.languages.extract("lproj"))

var $digest : Text
var $file : 4D:C1709.File

For each ($file; $dialog.main.files)
	
	$digest+=Generate digest:C1147($file.getText(); MD5 digest:K66:1)
	
End for each 

$pref.set("files"; $data.files.extract("name"))
$pref.set("currentFile"; $dialog.current.file.name)
$pref.set("digest"; Generate digest:C1147($digest; MD5 digest:K66:1))

// MARK:-
// TODO: Update XLIFF files on server

// MARK:-Cleanup
var $c : Collection:=Process activity:C1495(Processes only:K5:35).processes
var $o : Object

Try
	
	For each ($o; $dialog.current.languages)
		
		If ($c.query("name = :1"; "$4DPop XLIFF - "+$o.language.lproj).first()#Null:C1517)
			
			KILL WORKER:C1390("$4DPop XLIFF - "+$o.language.lproj)
			
		End if 
	End for each 
End try

KILL WORKER:C1390($dialog.form.process)