Class extends _classCore

property folders; local; remote : Object
property destination : 4D:C1709.Folder
property brew; localPrefs; remotePrefs : cs:C1710.pref

Class constructor
	
	Super:C1705()
	
	This:C1470.localValid:=False:C215
	This:C1470.remoteValid:=False:C215
	
	// Get preferences
	This:C1470.localPrefs:=cs:C1710.pref.new().database("4DPop brew.local")
	This:C1470.remotePrefs:=cs:C1710.pref.new().session("4DPop brew.remote")
	
	This:C1470.SetLocalFolder(This:C1470.localPrefs.get("target"); True:C214)
	This:C1470.SetRemoteFolder(This:C1470.remotePrefs.get("target"); True:C214)
	
	This:C1470.Succeed(This:C1470.localValid & This:C1470.remoteValid)
	
	// Get the 4D folder tree
	This:C1470.folders:=JSON Parse:C1218(File:C1566("/SOURCES/folders.json").getText())
	
	This:C1470.local:={\
		Classes: Folder:C1567("/SOURCES/Classes"; *); \
		Forms: Folder:C1567("/SOURCES/Forms"; *); \
		Methods: Folder:C1567("/SOURCES/Methods"; *); \
		Resources: Folder:C1567("/PACKAGE/Resources"; *); \
		Documentation: {\
		Classes: Folder:C1567("/PACKAGE/Documentation/Classes"; *); \
		Methods: Folder:C1567("/PACKAGE/Documentation/Methods"; *)\
		}}
	
	// FIXME:Use This.destination when the bug is fixed
	var $o : Object
	$o:=This:C1470.destination
	
	This:C1470.remote:={\
		Classes: $o.folder("Project/Sources/Classes"); \
		Forms: $o.folder("Project/Sources/Forms"); \
		Methods: $o.folder("Project/Sources/Methods"); \
		Resources: $o.folder("Resources"); \
		Documentation: {\
		Classes: $o.folder("Documentation/Classes"); \
		Methods: $o.folder("Documentation/Methods")\
		}}
	
	If (This:C1470.success)
		
		// Update the local tree structure
		This:C1470.brew:=cs:C1710.pref.new(This:C1470.destination.file("4DPop brew.json"))
		
		var $brew : Object
		$brew:=This:C1470.brew.get()
		$brew.local:={}
		$brew.local[This:C1470.source]:=This:C1470.folders[This:C1470.source]
		This:C1470._groups($brew.local[This:C1470.source]; $brew.local)
		This:C1470.brew.set($brew)
		
		// This.remote.Resources.create()
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Sets the name of the local folder to be synchronized
Function SetLocalFolder($name : Text; $validate : Boolean)
	
	This:C1470.source:=$name
	
	If (Not:C34($validate))
		
		This:C1470.localPrefs.set("target"; $name)
		
	End if 
	
	ARRAY TEXT:C222($names; 0x0000)
	METHOD GET FOLDERS:C1206($names; *)
	
	This:C1470.localValid:=Find in array:C230($names; This:C1470.source)>0 ? True:C214 : False:C215
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Defines the path of the synchronization folder
Function SetRemoteFolder($path : Text; $validate : Boolean)
	
	If (Length:C16($path)>0)
		
		This:C1470.destination:=Folder:C1567($path)
		This:C1470.destination.create()
		
		If (Not:C34($validate))
			
			This:C1470.remotePrefs.set("target"; $path)
			
		End if 
		
		This:C1470.remoteValid:=This:C1470.destination.exists
		
	Else 
		
		This:C1470.destination:=Null:C1517
		This:C1470.remoteValid:=False:C215
		
	End if 
	
	// MARK:-
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Push, to the remote, the local files/folders that are modified
Function Push()
	
	var $brew; $latest; $local; $digests : Object
	
	$brew:=This:C1470.brew.get()
	$latest:=$brew.stamps || {}
	
	$digests:={}
	
	For each ($local; This:C1470._src())
		
		This:C1470._push($local; $latest; $digests)
		
	End for each 
	
	$brew.stamps:=$digests
	This:C1470.brew.set($brew)
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _push($local : Object; $latest : Object; $digests : Object)
	
	var $digest; $key; $name; $tgt; $type : Text
	var $source : Object
	var $documentation; $manifest : 4D:C1709.File
	var $assets : 4D:C1709.Folder
	
	$name:=$local.name
	
	$source:=This:C1470._source($local.type; $name)
	$type:=$source.type
	
	// MARK:Source
	$digest:=This:C1470.Digest($source.file)
	
	$digests[$type]:=$digests[$type] || {}
	
	If ($latest[$type][$name]=Null:C1517)\
		 || ($latest[$type][$name]#$digest)
		
		This:C1470.remote[$type].create()
		$source.file.copyTo(This:C1470.remote[$type]; fk overwrite:K87:5)
		
	End if 
	
	$digests[$type][$name]:=$digest
	
	// MARK:Documentation
	$documentation:=This:C1470.local.Documentation[$type].file($name+".md")
	
	If ($documentation.exists)
		
		This:C1470.remote.Documentation[$type].create()
		
		$digests.Documentation:=$digests.Documentation || {}
		$digests.Documentation[$type]:=$digests.Documentation[$type] || {}
		
		$digest:=This:C1470.Digest($documentation)
		
		// The documentation media must be in a folder with the same name as the method/class
		$assets:=This:C1470.local.Documentation[$type].folder($name)
		
		If ($assets.exists)
			
			$digest:=This:C1470.Digest($digest+This:C1470.Digest($assets))
			
		End if 
		
		If ($latest.Documentation[$type][$name]=Null:C1517)\
			 || ($latest.Documentation[$type][$name]#$digest)
			
			$documentation.copyTo(This:C1470.remote.Documentation[$type]; fk overwrite:K87:5)
			
			If ($assets.exists)
				
				$assets.copyTo(This:C1470.remote.Documentation[$type]; fk overwrite:K87:5)
				
			End if 
			
		End if 
		
		$digests.Documentation[$type][$name]:=$digest
		
	End if 
	
	// TODO: Dependencies
	$manifest:=This:C1470.local[$type].file($name+".manifest")
	
	If ($manifest.exists)
		
		For each ($key; JSON Parse:C1218($manifest.getText()))
			
			Case of 
					
					//______________________________________________________
				: ($key="[class]/@")
					
					// Path of class definition
					$tgt:="Classes"
					
					//______________________________________________________
				: ($key="[projectForm]/@")
					
					// Path of project form methods and all their object methods
					$tgt:="Forms"
					
					//______________________________________________________
				: ($key="[resources]/@")
					
					// Path of a resource (file or folder)
					$tgt:="Resources"
					
					//______________________________________________________
				: ($key="[image]/@")
					
					// Path of a media into the Resources/Images folder
					$tgt:="Resources/Images/"
					
					//______________________________________________________
				: ($key="[localized]/@")
					
					// Path of a localized file (in all .lproj folders)
					$tgt:="Resources/"
					
					//______________________________________________________
				Else   // Name of method
					
					$tgt:="Methods"
					
					//______________________________________________________
			End case 
			
		End for each 
		
		//$digest:=This.Digest($digest+This.Digest($manifest))
		
	End if 
	
	// MARK:-
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Returns a collection of remote files/folders that are different from the local equivalent
Function Fetch() : Collection
	
	var $latest; $o : Object
	var $c : Collection
	var $file : 4D:C1709.File
	
	$file:=This:C1470.destination.file("4DPop brew.json")
	$latest:=$file.exists ? JSON Parse:C1218($file.getText()) : {}
	
	$c:=[]
	
	For each ($o; This:C1470._src())
		
		If (This:C1470._fetch($o.type; $o.name; $latest))
			
			$c.push($o)
			
		End if 
	End for each 
	
	return $c
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _fetch($type : Text; $name : Text; $latest : Object) : Boolean
	
	var $digest : Text
	var $source : Object
	
	$source:=This:C1470._source($type; $name)
	$type:=$source.type
	
	$digest:=This:C1470.Digest($source.file)
	
	If ($latest[$type][$name]=Null:C1517)\
		 || ($latest[$type][$name]#$digest)
		
		return True:C214
		
	End if 
	
	// MARK:-
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Get the remote files/folders that are modified
Function Pull()
	
	var $family; $name : Text
	var $latest; $src : Object
	var $file; $dependencies : 4D:C1709.File
	
	$file:=This:C1470.destination.file("4DPop brew.json")
	$latest:=$file.exists ? JSON Parse:C1218($file.getText()) : {}
	
	var $folders : Object
	$folders:=This:C1470.folders
	
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
Function _groups($folder : Object; $container : Object)
	
	var $key : Text
	
	If ($folder.groups#Null:C1517)
		
		For each ($key; $folder.groups)
			
			$container[$key]:=This:C1470.folders[$key]
			This:C1470._groups($container[$key]; $container)
			
		End for each 
	End if 
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _source($type : Text; $name : Text; $remote : Boolean) : Object
	
	var $direction : Text
	$direction:=$remote ? "remote" : "local"
	
	Case of 
			
			//______________________________________________________
		: ($type="method")
			
			return New object:C1471(\
				"file"; This:C1470[$direction].Methods.file($name+".4dm"); \
				"type"; "Methods")
			
			//______________________________________________________
		: ($type="class")
			
			return New object:C1471(\
				"file"; This:C1470[$direction].Classes.file($name+".4dm"); \
				"type"; "Classes")
			
			//______________________________________________________
		: ($type="form")
			
			return New object:C1471(\
				"file"; This:C1470[$direction].Forms.folder($name); \
				"type"; "Forms")
			
			//______________________________________________________
		Else 
			
			// TODO: Resources, CSS, … ?
			
			//______________________________________________________
	End case 
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _src($name : Text) : Collection
	
	var $src : Object
	var $members : Collection
	
	If (Count parameters:C259=0)
		
		$src:=This:C1470.folders[This:C1470.source]
		
	Else 
		
		$src:=This:C1470.folders[$name]
		
	End if 
	
	If ($src=Null:C1517)
		
		return 
		
	End if 
	
	$members:=[]
	
	
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
			
			$members.combine(This:C1470._src($name))
			
		End for each 
	End if 
	
	return $members.orderBy("type,name")