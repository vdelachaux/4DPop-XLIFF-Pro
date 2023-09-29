//%attributes = {}
var $id; $node : Text
var $folder : 4D:C1709.Folder
var $file : 4D:C1709.File
var $xml : cs:C1710.xml

For each ($folder; Folder:C1567("/RESOURCES/"; *).folders().query("extension=.lproj"))
	
	For each ($file; $folder.files().query("extension = .xlf"))
		
		$xml:=cs:C1710.xml.new($file)
		
		For each ($node; $xml.find("/xliff/file/body/group/trans-unit"))
			
			$id:=String:C10($xml.getAttribute($node; "id"))
			$xml.setAttribute($node; "id"; Split string:C1554($id; "/").join("_"))
			
		End for each 
		
		$xml.save()
		$xml.close()
		
	End for each 
End for each 