//%attributes = {"invisible":true}
#DECLARE($data : Object)

var $digest : Text
var $language : Object
var $file : 4D:C1709.File
var $xliff : cs:C1710.Xliff

var $dialog : Object:=$data.__DIALOG__

// MARK:-Update modified files & close XML trees
For each ($xliff; $dialog.cache)
	
	If ($xliff.modified)
		
		$xliff.updateHeader($dialog.GENERATOR; $dialog.VERSION)
		$xliff.updateCopyright()
		
	End if 
	
	$xliff.close()
	
End for each 

ASSERT:C1129($dialog.cache.extract("root").length=0; "Not all open XML trees have been closed")

// MARK:-Store session
$dialog.Preferences.set("reference"; $dialog.main.language)
$dialog.Preferences.set("project"; $data.project)

For each ($file; $dialog.main.files)
	
	$digest+=Generate digest:C1147($file.getText(); MD5 digest:K66:1)
	
End for each 

var $languages : Collection:=$dialog.current.languages

$dialog.Preferences.set($data.project; New object:C1471(\
"languages"; $languages.extract("language"); \
"files"; $data.files.extract("name"); \
"file"; $dialog.current.file.name; \
"digest"; Generate digest:C1147($digest; MD5 digest:K66:1)))

// MARK:-
// TODO: Update XLIFF files on server

// MARK:-Cleanup
var $c : Collection:=Process activity:C1495(Processes only:K5:35).processes
For each ($language; $languages)
	
	If ($c.query("name = :1"; "$4DPop XLIFF - "+$language.language).first()#Null:C1517)
		
		KILL WORKER:C1390("$4DPop XLIFF - "+$language.language)
		
	End if 
End for each 

KILL WORKER:C1390($dialog.form.process)