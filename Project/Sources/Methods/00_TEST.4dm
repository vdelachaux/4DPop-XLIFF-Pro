//%attributes = {}
TRACE:C157

Case of 
		
		//______________________________________________________
	: (True:C214)
		
		var $folder : Object
		var $after; $before; $folders : Collection
		var $file : 4D:C1709.File
		var $xliff : cs:C1710.Xliff
		
		$file:=File:C1566("/Volumes/Passport 500/4D Components/Internal Components/preferences/Resources/en.lproj/MotorEN.xlf")
		
		$xliff:=cs:C1710.Xliff.new($file)
		$xliff.parse()
		
		$before:=$xliff.allUnits.copy()
		$xliff.deDuplicateIDs()
		$after:=$xliff.allUnits.copy()
		
		$xliff.close()
		
		$folders:=$file.parent.parent.folders().query("extension = :1 & name != :2"; ".lproj"; "_@")
		$folders.query("name != :1"; "en.lproj")
		
		For each ($folder; $folders)
			
			$file:=$xliff.localizedFile($folder.file("MotorEN.xlf"); "en"; $folder.name)
			$xliff:=cs:C1710.Xliff.new($file)
			$xliff.parse()
			$xliff.deDuplicateIDs($before; $after)
			$xliff.close()
			
			If (Not:C34($xliff.success))
				
				break
				
			End if 
		End for each 
		
		//______________________________________________________
End case 