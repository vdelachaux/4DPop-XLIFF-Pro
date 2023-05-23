Class extends _classCore

property local; remote : Object

Class constructor($folder : Text; $tgt : 4D:C1709.Folder)
	
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
	
	This:C1470.tgt:=$tgt
	
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
	
	$o:=This:C1470.brew()
	$o.src:={name: $folder}
	$o.src.content:=JSON Parse:C1218(File:C1566("/SOURCES/folders.json").getText())[This:C1470.src]
	This:C1470.brew($o)
	
	This:C1470.remote.Resources.create()
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function brew($value : Object) : Object
	
	var $file : 4D:C1709.File
	
	$file:=This:C1470.tgt.file("4DPop brew.json")
	
	If ($value=Null:C1517)
		
		return $file.exists ? JSON Parse:C1218($file.getText()) : {}
		
	Else 
		
		$file.setText(JSON Stringify:C1217($value; *))
		
	End if 
	
	// MARK:-
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Push, to the remote, the local files/folders that are modified
Function push()
	
	var $brew; $latest; $local; $stamps : Object
	
	$brew:=This:C1470.brew()
	$latest:=$brew.stamps || {}
	
	$stamps:={}
	
	For each ($local; This:C1470._src())
		
		//TODO:only src
		//This._push($src.type; $src.name; $latest; $stamps)
		
		This:C1470._push($local; $latest; $stamps)
		//This._pushDocumentation($o.type; $o.name; $latest; $stamps)
		
	End for each 
	
	$brew.stamps:=$stamps
	This:C1470.brew($brew)
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _push($local : Object; $latest : Object; $stamp : Object)
	
	var $digest; $name; $type : Text
	var $o; $src : Object
	var $dependencies; $documentation : 4D:C1709.File
	var $documentationAssets : 4D:C1709.Folder
	
	$name:=$local.name
	$type:=$local.type
	
	$o:=This:C1470._map($type; $name)
	
	$src:=$o.src
	$type:=$o.tgt
	
	$digest:=This:C1470.digest($src)
	
	$stamp[$type]:=$stamp[$type] || {}
	
	If ($latest[$type][$name]=Null:C1517)\
		 && ($latest[$type][$name]#$digest)
		
		This:C1470.remote[$type].create()
		
		$src.copyTo(This:C1470.remote[$type]; fk overwrite:K87:5)
		
	End if 
	
	$stamp[$type][$name]:=$digest
	
	// MARK:Documentation
	$documentation:=This:C1470.local.Documentation[$type].file($name+".md")
	
	If ($documentation.exists)
		
		This:C1470.remote.Documentation[$type].create()
		
		$stamp.Documentation:=$stamp.Documentation || {}
		$stamp.Documentation[$type]:=$stamp.Documentation[$type] || {}
		
		$digest:=This:C1470.digest($documentation)
		
		$documentationAssets:=This:C1470.local.Documentation[$type].folder($name)
		
		If ($documentationAssets.exists)
			
			$digest:=This:C1470.digest($digest+This:C1470.digest($documentationAssets))
			
		End if 
		
		If ($latest.Documentation[$type][$name]=Null:C1517)\
			 && ($latest.Documentation[$type][$name]#$digest)
			
			$documentation.copyTo(This:C1470.remote.Documentation[$type]; fk overwrite:K87:5)
			
			If ($documentationAssets.exists)
				
				$documentationAssets.copyTo(This:C1470.remote.Documentation[$type]; fk overwrite:K87:5)
				
			End if 
			
		End if 
		
		$stamp.Documentation[$type][$name]:=$digest
		
	End if 
	
	// TODO: Dependencies
	$dependencies:=This:C1470.local[$type].file($name+".manifest")
	
	If ($dependencies.exists)
		
		//$manifest:=JSON Parse($dependencies.getText())
		//$digest:=This.digest($digest+This.digest($manifest))
		
	End if 
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _pushDocumentation($tgt : Text; $name : Text; $latest : Object; $stamp : Object)
	
	var $digest : Text
	var $src : 4D:C1709.File
	
	$tgt:=This:C1470._map($tgt; $name).tgt
	
	// Documentation
	$src:=This:C1470.local.Documentation[$tgt].file($name+".md")
	
	If (Not:C34($src.exists))
		
		return 
		
	End if 
	
	$digest:=This:C1470.digest($src)
	
	var $documentationAssets : 4D:C1709.Folder
	$documentationAssets:=This:C1470.local.Documentation[$tgt].folder($name)
	
	If ($documentationAssets.exists)
		
		$digest:=This:C1470.digest($digest+This:C1470.digest($documentationAssets))
		
	End if 
	
	$stamp.Documentation:=$stamp.Documentation || {}
	$stamp.Documentation[$tgt]:=$stamp.Documentation[$tgt] || {}
	
	If ($latest.Documentation[$tgt][$name]#Null:C1517)\
		 && ($latest.Documentation[$tgt][$name]=$digest)
		
		$stamp.Documentation[$tgt][$name]:=$latest.Documentation[$tgt][$name]
		return 
		
	End if 
	
	This:C1470.remote.Documentation[$tgt].create()
	$src.copyTo(This:C1470.remote.Documentation[$tgt]; fk overwrite:K87:5)
	
	If ($documentationAssets.exists)
		
		$documentationAssets.copyTo(This:C1470.remote.Documentation[$tgt]; fk overwrite:K87:5)
		
	End if 
	
	$stamp.Documentation[$tgt][$name]:=$digest
	
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
	
	var $family; $name : Text
	var $latest; $src : Object
	var $file; $dependencies : 4D:C1709.File
	
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
			$dependencies:=This:C1470.local[$family].file($name+".manifest")
			
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
				"src"; This:C1470[$direction].Forms.folder($name); \
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