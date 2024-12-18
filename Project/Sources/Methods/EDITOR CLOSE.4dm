//%attributes = {"invisible":true}
#DECLARE($data : Object)

var $digest : Text
var $dialog : Object
var $file : 4D:C1709.File
var $xliff : cs:C1710.Xliff

$dialog:=$data.__DIALOG__

For each ($xliff; $dialog.opened)
	
	If ($xliff.modified)
		
		$xliff.updateHeader($dialog.GENERATOR; $dialog.VERSION)
		$xliff.updateCopyright()
		
	End if 
	
	$xliff.close()
	
End for each 

ASSERT:C1129($dialog.opened.extract("root").length=0; "Not all open XML trees have been closed")

// Store session
$dialog.Preferences.set("reference"; $dialog.main.language)
$dialog.Preferences.set("project"; $data.project)

For each ($file; $dialog.main.files)
	
	$digest+=Generate digest:C1147($file.getText(); MD5 digest:K66:1)
	
End for each 

$dialog.Preferences.set($data.project; New object:C1471(\
"languages"; $dialog.current.languages.extract("language"); \
"files"; $data.files.extract("name"); \
"file"; $dialog.current.file.name; \
"digest"; Generate digest:C1147($digest; MD5 digest:K66:1)))

// TODO: Update XLIFF files on server

KILL WORKER:C1390("$4DPop XLIFF Pro")