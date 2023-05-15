Class extends _classCore

Class constructor
	
	Super:C1705()
	
	This:C1470.Documentation:=Folder:C1567("/PACKAGE/Documentation"; *)
	This:C1470.Project:=Folder:C1567("/PROJECT/"; *)
	This:C1470.Sources:=Folder:C1567("/SOURCES/"; *)
	
	This:C1470.Classes:=This:C1470.Sources.folder("Classes")
	This:C1470.Forms:=This:C1470.Sources.folder("Forms")
	This:C1470.Methods:=This:C1470.Sources.folder("Methods")
	
	This:C1470.folders:=This:C1470.getFolders()
	
Function getFolders() : Object
	
	var $key; $name : Text
	var $folders; $o : Object
	var $c; $subfolder : Collection
	
	$folders:={}
	
	This:C1470._folders:=JSON Parse:C1218(This:C1470.Sources.file("folders.json").getText())
	
	$o:=This:C1470._folders
	
	$subfolder:=[]
	
	For each ($key; $o)
		
		If ($subfolder.indexOf($key)#-1) || ($key="trash")
			
			continue
			
		End if 
		
		$folders[$key]:=$folders[$key] || []
		
		For each ($name; $o[$key].forms || [])
			
			$folders[$key].push({name: $name; type: "form"})
			
		End for each 
		
		For each ($name; $o[$key].methods || [])
			
			$folders[$key].push({name: $name; type: "method"})
			
		End for each 
		
		For each ($name; $o[$key].classes || [])
			
			$folders[$key].push({name: $name; type: "class"})
			
		End for each 
		
		If ($o[$key].groups#Null:C1517)
			
			For each ($name; $o[$key].groups)
				
				$subfolder.push($name)
				
				If ($folders[$name]#Null:C1517)
					
					$c:=$folders[$name].copy()
					OB REMOVE:C1226($folders; $name)
					
				Else 
					
					$c:=This:C1470.getSubfolders($name)
					
				End if 
				
				$folders[$key].push({\
					name: $name; \
					type: "group"; \
					members: $c\
					})
				
			End for each 
		End if 
	End for each 
	
	return $folders
	
Function getSubfolders($name : Text) : Collection
	
	var $o : Object
	
	$o:=This:C1470._folders[$name]