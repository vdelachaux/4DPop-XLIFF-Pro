//%attributes = {}
var $sourceLanguage; $targetLanguage : Text
var $file : 4D:C1709.File
var $xliff : cs:C1710.Xliff

$xliff:=cs:C1710.Xliff.new(File:C1566("/RESOURCES/en.lproj/_0_test.xlf"; *))
$xliff.parse()

$sourceLanguage:="en"
$targetLanguage:="fr"

$file:=File:C1566(Replace string:C233($xliff.file.path; $sourceLanguage+".lproj"; $targetLanguage+".lproj"))

$xliff.synchronize($file; $targetLanguage)

$xliff.close()