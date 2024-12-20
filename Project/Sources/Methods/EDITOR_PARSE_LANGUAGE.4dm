//%attributes = {}
#DECLARE($signal : 4D:C1709.Signal)

var $xliff : cs:C1710.Xliff:=$signal.reference  // The file analyzed in the main language
var $language : Object:=$signal.language  // The language to parse

// Get the localized file
var $file : 4D:C1709.File:=$xliff.localizedFile($signal.item; $signal.main; $language.language)

// Ensure that content is synchronized
$xliff.synchronize($file; $language.language)

// Finally, parse the localized file
$xliff:=cs:C1710.Xliff.new($file)

Use ($signal)
	
	$signal.xliff:=OB Copy:C1225($xliff.parse(); ck shared:K85:29; $signal)
	
End use 

$signal.trigger()