//%attributes = {}
var $language : Text
var $attributes : Object
var $files : Collection
var $file : 4D:C1709.File
var $folder : 4D:C1709.Folder
var $xliff : cs:C1710.Xliff

$language:="en"

$folder:=Folder:C1567(fk resources folder:K87:11; *).folders().query("extension = .lproj & name != :1"; "_@").query("name = :1"; $language).pop()

$files:=New collection:C1472

If ($folder#Null:C1517)
	
	For each ($file; $folder.files().query("extension = .xlf"))
		
		$xliff:=cs:C1710.Xliff.new($file)
		
		If (Not:C34($xliff.success))
			
			continue
			
		End if 
		
		$attributes:=$xliff.getAttributes($xliff.fileNode)
		
		$xliff.close()
		
		If (String:C10($attributes.datatype)="x-4DK#")
			
			// No management of constant files
			continue
			
		End if 
		
		$files.push($file)
		
	End for each 
End if 