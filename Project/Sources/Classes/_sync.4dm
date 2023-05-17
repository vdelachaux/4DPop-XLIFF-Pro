Class extends _classCore

property local; remote : Object

Class constructor($folder : Text)
	
	Super:C1705()
	
	This:C1470.local:={\
		Classes: Folder:C1567("/SOURCES/Classes"; *); \
		Forms: Folder:C1567("/SOURCES/Forms"; *); \
		Methods: Folder:C1567("/SOURCES/Methods"; *); \
		Resources: Folder:C1567("/PACKAGE/Resources"; *); \
		Documentation: {\
		Classes: Folder:C1567("/PACKAGE/Documentation/Classes"; *); \
		Methods: Folder:C1567("/PACKAGE/Documentation/Methods"; *)\
		}}
	
	This:C1470.src:=$folder
	This:C1470.tgt:=Folder:C1567(fk desktop folder:K87:19).folder("LIBRAIRIES")
	
	// FIXME:Use This.tgt when the bug is fixed
	var $o : Object
	$o:=This:C1470.tgt
	
	This:C1470.remote:={\
		Classes: $o.folder("Project/Sources/Classes"); \
		Forms: $o.folder("Project/Sources/Forms"); \
		Methods: $o.folder("Project/Sources/Methods"); \
		Resources: $o.folder("Resources"); \
		Documentation: {\
		Classes: $o.folder("Documentation/Classes"); \
		Methods: $o.folder("Documentation/Methods")\
		}}
	
	This:C1470.remote.Resources.create()
	
	// MARK:-
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Push, to the remote, the local files/folders that are modified
Function push()
	
	var $latest; $o; $stamp : Object
	var $file : 4D:C1709.File
	
	$stamp:={}
	
	$file:=This:C1470.tgt.file("4DPop brew.json")
	$latest:=$file.exists ? JSON Parse:C1218($file.getText()) : {}
	
	For each ($o; This:C1470._src())
		
		This:C1470._push($o.type; $o.name; $latest; $stamp)
		
	End for each 
	
	$file.setText(JSON Stringify:C1217($stamp; *))
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _push($tgt : Text; $name : Text; $latest : Object; $stamp : Object)
	
	var $digest : Text
	var $o; $src : Object
	var $manifest : 4D:C1709.File
	
	$o:=This:C1470._map($tgt; $name)
	$src:=$o.src
	$tgt:=$o.tgt
	
	$digest:=This:C1470.digest($src)
	
	$stamp[$tgt]:=$stamp[$tgt] || {}
	
	If ($latest[$tgt][$name]#Null:C1517)\
		 && ($latest[$tgt][$name]=$digest)
		
		$stamp[$tgt][$name]:=$latest[$tgt][$name]
		return 
		
	End if 
	
	This:C1470.remote[$tgt].create()
	
	$src.copyTo(This:C1470.remote[$tgt]; fk overwrite:K87:5)
	
	$stamp[$tgt][$name]:=$digest
	
	// TODO: Dependencies
	$manifest:=This:C1470.local[$tgt].file($name+".manifest")
	
	// Documentation
	$src:=This:C1470.local.Documentation[$tgt].file($name+".md")
	
	If (Not:C34($src.exists))
		
		return 
		
	End if 
	
	$digest:=This:C1470.digest($src)
	
	$stamp.Documentation:=$stamp.Documentation || {}
	$stamp.Documentation[$tgt]:=$stamp.Documentation[$tgt] || {}
	
	If ($latest.Documentation[$tgt][$name]#Null:C1517)\
		 && ($latest.Documentation[$tgt][$name]=$digest)
		
		$stamp.Documentation[$tgt][$name]:=$latest.Documentation[$tgt][$name]
		return 
		
	End if 
	
	This:C1470.remote.Documentation[$tgt].create()
	$src.copyTo(This:C1470.remote.Documentation[$tgt]; fk overwrite:K87:5)
	
	$stamp.Documentation[$tgt][$name]:=$digest
	
	// TODO: Documentation Assets
	
	// MARK:-
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Returns a collection of remote files/folders that are different from the local equivalent
Function fetch() : Collection
	
	var $latest; $o : Object
	var $c : Collection
	var $file : 4D:C1709.File
	
	$file:=This:C1470.tgt.file("4DPop brew.json")
	$latest:=$file.exists ? JSON Parse:C1218($file.getText()) : {}
	
	$c:=[]
	
	For each ($o; This:C1470._src())
		
		If (This:C1470._fetch($o.type; $o.name; $latest))
			
			$c.push($o)
			
		End if 
	End for each 
	
	return $c
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _fetch($tgt : Text; $name : Text; $latest : Object) : Boolean
	
	var $digest : Text
	var $o; $src : Object
	
	$o:=This:C1470._map($tgt; $name)
	$src:=$o.src
	$tgt:=$o.tgt
	
	$digest:=This:C1470.digest($src)
	
	If ($latest[$tgt][$name]=Null:C1517)\
		 || ($latest[$tgt][$name]#$digest)
		
		return True:C214
		
	End if 
	
	// MARK:-
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Get the remote files/folders that are modified
Function pull()
	
	var $family; $name; $manifest : Text
	var $latest; $src : Object
	var $file : 4D:C1709.File
	
	$file:=This:C1470.tgt.file("4DPop brew.json")
	$latest:=$file.exists ? JSON Parse:C1218($file.getText()) : {}
	
	var $folders : Object
	$folders:=JSON Parse:C1218(File:C1566("/SOURCES/folders.json").getText())
	
	For each ($family; $latest)
		
		This:C1470.local[$family].create()
		
		For each ($name; $latest[$family])
			
			If ($family="Classes") | ($family="Methods")
				
				$src:=This:C1470.remote[$family].file($name+".4dm")
				
			Else 
				
				$src:=This:C1470.remote[$family].folder($name)
				
			End if 
			
			$src.copyTo(This:C1470.local[$family]; fk overwrite:K87:5)
			
			// TODO: Dependencies
			$manifest:=This:C1470.local[$family].file($name+".manifest")
			
			// Documentation
			$src:=This:C1470.remote.Documentation[$family].file($name+".md")
			
			If (Not:C34($src.exists))
				
				return 
				
			End if 
			
			This:C1470.local.Documentation[$family].create()
			$src.copyTo(This:C1470.local.Documentation[$family]; fk overwrite:K87:5)
			
			// TODO: Documentation Assets
			
		End for each 
	End for each 
	
	RELOAD PROJECT:C1739
	
	// MARK:-
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _map($tgt : Text; $name : Text; $remote : Boolean) : Object
	
	var $direction : Text
	$direction:=$remote ? "remote" : "local"
	
	Case of 
			
			//______________________________________________________
		: ($tgt="method")
			
			return New object:C1471(\
				"src"; This:C1470[$direction].Methods.file($name+".4dm"); \
				"tgt"; "Methods")
			
			//______________________________________________________
		: ($tgt="class")
			
			return New object:C1471(\
				"src"; This:C1470[$direction].Classes.file($name+".4dm"); \
				"tgt"; "Classes")
			
			//______________________________________________________
		: ($tgt="form")
			
			return New object:C1471(\
				"src"; This:C1470[$direction].Forms.folder($name+".4dm"); \
				"tgt"; "Forms")
			
			//______________________________________________________
		Else 
			
			// TODO: Resources, CSS, …
			
			//______________________________________________________
	End case 
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _src($name : Text; $subfolders : Collection) : Collection
	
	var $src : Object
	var $members; $subfolder : Collection
	
	If (Count parameters:C259=0)
		
		$src:=JSON Parse:C1218(File:C1566("/SOURCES/folders.json").getText())[This:C1470.src]
		
	Else 
		
		$src:=JSON Parse:C1218(File:C1566("/SOURCES/folders.json").getText())[$name]
		
	End if 
	
	If ($src=Null:C1517)
		
		return 
		
	End if 
	
	$members:=[]
	
	$subfolder:=$subfolder || []
	
	If ($src.forms#Null:C1517)
		
		For each ($name; $src.forms)
			
			$members.push({name: $name; type: "form"})
			
		End for each 
	End if 
	
	If ($src.methods#Null:C1517)
		
		For each ($name; $src.methods)
			
			$members.push({name: $name; type: "method"})
			
		End for each 
	End if 
	
	If ($src.classes#Null:C1517)
		
		For each ($name; $src.classes)
			
			$members.push({name: $name; type: "class"})
			
		End for each 
	End if 
	
	If ($src.groups#Null:C1517)
		
		For each ($name; $src.groups)
			
			$members.combine(This:C1470._src($name; $subfolder))
			
		End for each 
	End if 
	
	return $members