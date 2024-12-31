//%attributes = {}
#DECLARE($signal : 4D:C1709.Signal)

// The file analyzed as a source language
var $xliff : cs:C1710.Xliff:=$signal.reference  // Make unshared

// Get the localized file
var $file : 4D:C1709.File:=$xliff.localizedFile($signal.item; $signal.source; $signal.target)

// Ensure that content is synchronized
$xliff.synchronize($file; $signal.target)

// Finally, parse the localized file
$xliff:=cs:C1710.Xliff.new($file)

Use ($signal)
	
	$signal.xliff:=OB Copy:C1225($xliff.parse(); ck shared:K85:29; $signal)
	
End use 

$signal.trigger()