Class extends _classCore

property Project; Sources; Documentation : 4D:C1709.Folder
property Classes; Forms; Methods : 4D:C1709.Folder

Class constructor
	
	Super:C1705()
	
	This:C1470.Project:=Folder:C1567("/PROJECT/"; *)
	This:C1470.Sources:=Folder:C1567("/SOURCES/"; *)
	This:C1470.Documentation:=Folder:C1567("/PACKAGE/Documentation"; *)
	
	This:C1470.Classes:=This:C1470.Sources.folder("Classes")
	This:C1470.Forms:=This:C1470.Sources.folder("Forms")
	This:C1470.Methods:=This:C1470.Sources.folder("Methods")
	
	This:C1470.getFolders()
	
Function getFolders()
	
	var $key; $name : Text
	var $folders; $o : Object
	var $c; $subfolder : Collection
	
	$o:=JSON Parse:C1218(This:C1470.Sources.file("folders.json").getText())
	$folders:={}
	$subfolder:=[]
	
	This:C1470.folders:=$folders
	
	For each ($key; $o)
		
		If ($subfolder.indexOf($key)#-1) || ($key="trash")
			
			continue
			
		End if 
		
		$folders[$key]:={name: $key; members: []}
		
		For each ($name; $o[$key].forms || [])
			
			$folders[$key].members.push({name: $name; type: "form"})
			
		End for each 
		
		For each ($name; $o[$key].methods || [])
			
			$folders[$key].members.push({name: $name; type: "method"})
			
		End for each 
		
		For each ($name; $o[$key].classes || [])
			
			$folders[$key].members.push({name: $name; type: "class"})
			
		End for each 
		
		If ($o[$key].groups#Null:C1517)
			
			For each ($name; $o[$key].groups)
				
				$subfolder.push($name)
				
				If ($folders[$name]#Null:C1517)
					
					$c:=$folders[$name].members.copy()
					OB REMOVE:C1226($folders; $name)
					
				Else 
					
					$c:=This:C1470.getSubfolders($o[$name])
					
				End if 
				
				$folders[$key].members.push({\
					name: $name; \
					type: "group"; \
					members: $c\
					})
				
			End for each 
		End if 
	End for each 
	
Function getSubfolders($o : Object; $subfolder : Collection) : Collection
	
	var $name : Text
	var $c; $members : Collection
	
	$members:=[]
	
	If ($o.forms#Null:C1517)
		
		For each ($name; $o.forms)
			
			$members.push({name: $name; type: "form"})
			
		End for each 
	End if 
	
	If ($o.methods#Null:C1517)
		
		For each ($name; $o.methods)
			
			$members.push({name: $name; type: "method"})
			
		End for each 
	End if 
	
	If ($o.classes#Null:C1517)
		
		For each ($name; $o.classes)
			
			$members.push({name: $name; type: "class"})
			
		End for each 
	End if 
	
	If ($o.groups#Null:C1517)
		
		For each ($name; $o.groups)
			
			$subfolder.push($name)
			
			If (This:C1470.folders[$name]#Null:C1517)
				
				$c:=This:C1470.folders[$name].copy()
				OB REMOVE:C1226(This:C1470.folders; $name)
				
			Else 
				
				$c:=This:C1470.getSubfolders($o[$name])
				
			End if 
			
			$members.push({\
				name: $name; \
				type: "group"; \
				members: $c\
				})
			
		End for each 
	End if 
	
	return $members