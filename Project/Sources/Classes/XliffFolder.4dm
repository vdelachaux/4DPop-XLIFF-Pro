/*
Bulk maintenance operations on a whole Resources/<lang>.lproj/ tree (all
languages, all "families" -- the per-domain XLIFF file basename, e.g.
"Common" in CommonEN.xlf or "editor" in editor.xlf -- both naming
conventions are supported).

Ported from the standalone renumber_xliff_ids.py script (4D-Internal-Components/
preferences/tools/renumber_xliff_ids.py) so the same maintenance can be run
directly from 4DPop XLIFF Pro.

Each public function operates on the current project's /RESOURCES/ folder
(Folder("/RESOURCES/"; *) already resolves to the host database's resources
when called from a component, and to the project's own resources otherwise).
	cs.XliffFolder.new().renumberIds()

A .xlf file directly at the root of /RESOURCES/ (no <lang>.lproj/) is shared
by every language; if a language's <lang>.lproj/ folder has no file for a
given family, that root file is used as its content instead. Either way, such
a shared/fallback file is read and written only once per family, no matter
how many languages point to it.

The identity key for a trans-unit is (resname, d4:includeIf): a resname
legitimately repeats when platform-conditional variants exist
(d4:includeIf="mac" / "win"), each with distinct content. A TRUE duplicate is
the same (resname, d4:includeIf) appearing more than once in the same file.
*/

Class constructor()

// === === === === === === === === === === === === === === === === === === ===
// Returns duplicates found across the whole tree: [{family; languages; file;
// resname; includeIf; count}]. Nothing is written to disk.
Function detectDuplicates() : Collection

	var $resourcesFolder : 4D:C1709.Folder:=This:C1470._resourcesFolder()

	If (Not:C34($resourcesFolder.exists))

		return []

	End if

	var $langs : Collection:=This:C1470._discoverLangs($resourcesFolder)
	var $discovery : Object:=This:C1470._discoverFamilies($resourcesFolder; $langs)

	return This:C1470._scanDuplicates($discovery.families; $langs; $discovery.fileMap)

	// === === === === === === === === === === === === === === === === === === ===
	// Renumbers every trans-unit id to 1..N per family, in document order (using
	// "en" as the reference language when present, else the first language
	// alphabetically), synced across every language that has that family.
	// Aborts (writes nothing) if any true duplicate is found; returns
	// {ok; duplicates; families; error}.
Function renumberIds() : Object

	var $report : Object:={ok: True:C214; duplicates: []; families: []}

	var $resourcesFolder : 4D:C1709.Folder:=This:C1470._resourcesFolder()

	If (Not:C34($resourcesFolder.exists))

		$report.ok:=False:C215
		$report.error:="Resources folder not found: "+String:C10($resourcesFolder.path)
		return $report

	End if

	var $langs : Collection:=This:C1470._discoverLangs($resourcesFolder)

	If ($langs.length=0)

		$report.ok:=False:C215
		$report.error:="No <lang>.lproj folder found under "+String:C10($resourcesFolder.path)
		return $report

	End if

	var $discovery : Object:=This:C1470._discoverFamilies($resourcesFolder; $langs)
	var $fileMap : Object:=$discovery.fileMap
	var $families : Collection:=$discovery.families

	var $duplicates : Collection:=This:C1470._scanDuplicates($families; $langs; $fileMap)

	If ($duplicates.length>0)

		$report.ok:=False:C215
		$report.duplicates:=$duplicates
		return $report

	End if

	var $refLang : Text:=($langs.indexOf("en")>=0) ? "en" : $langs[0]

	var $family; $lang : Text
	var $node : Text
	var $attrs : Object

	For each ($family; $families)

		// Build the (resname, includeIf) -> id map from the reference language,
		// in document order, then extend it with keys found only in other languages.
		var $idMap : Object:={}
		var $nextId : Integer:=1

		// Reference language first, then every other language that has this family.
		var $orderedLangs : Collection:=[$refLang]

		For each ($lang; $langs)

			If ($lang#$refLang)

				$orderedLangs.push($lang)

			End if

		End for each

		// A file shared by several languages (root-level or fallback file) is
		// only read once, no matter how many languages map to it.
		var $readPaths : Object:={}

		For each ($lang; $orderedLangs)

			var $file : 4D:C1709.File:=$fileMap[$family][$lang]

			If ($file=Null:C1517)

				continue

			End if

			var $path : Text:=String:C10($file.platformPath)

			If ($readPaths[$path]#Null:C1517)

				continue

			End if

			$readPaths[$path]:=True:C214

			var $xliff : cs:C1710.Xliff:=cs:C1710.Xliff.new($file)

			For each ($node; $xliff.find($xliff.root; "//trans-unit"))

				$attrs:=This:C1470._unitKey($xliff.getAttributes($node))

				If ($attrs=Null:C1517)

					continue

				End if

				$idMap[$attrs.resname]:=$idMap[$attrs.resname] || {}

				If ($idMap[$attrs.resname][$attrs.includeIf]=Null:C1517)

					$idMap[$attrs.resname][$attrs.includeIf]:=$nextId
					$nextId+=1

				End if

			End for each

			$xliff.close()

		End for each

		// Apply the map to every language that has this family; a shared/fallback
		// file is only written once even if several languages point to it.
		var $totalUpdated : Integer:=0
		var $writtenPaths : Object:={}

		For each ($lang; $langs)

			var $wfile : 4D:C1709.File:=$fileMap[$family][$lang]

			If ($wfile=Null:C1517)

				continue

			End if

			var $wpath : Text:=String:C10($wfile.platformPath)

			If ($writtenPaths[$wpath]#Null:C1517)

				continue

			End if

			$writtenPaths[$wpath]:=True:C214

			var $wxliff : cs:C1710.Xliff:=cs:C1710.Xliff.new($wfile)
			var $changed : Integer:=0

			For each ($node; $wxliff.find($wxliff.root; "//trans-unit"))

				var $wattrs : Object:=$wxliff.getAttributes($node)
				var $key : Object:=This:C1470._unitKey($wattrs)

				If ($key=Null:C1517)\
					 || ($idMap[$key.resname]=Null:C1517)\
					 || ($idMap[$key.resname][$key.includeIf]=Null:C1517)

					continue

				End if

				var $newId : Text:=String:C10($idMap[$key.resname][$key.includeIf])

				If (String:C10($wattrs.id)#$newId)

					$wxliff.setAttribute($node; "id"; $newId)
					$changed+=1

				End if

			End for each

			$wxliff.save()  // Also closes the tree

			$totalUpdated+=$changed

		End for each

		$report.families.push({family: $family; keys: $nextId-1; updated: $totalUpdated})

	End for each

	return $report

	// === === === === === === === === === === === === === === === === === === ===
	// Removes the leftover id attribute from every <group> element in every .xlf
	// file found anywhere under the resources folder (groups are addressed by
	// resname, not id). Returns {filesChanged; tagsRemoved; details; error}.
Function stripGroupIds() : Object

	var $report : Object:={filesChanged: 0; tagsRemoved: 0; details: []}

	var $resourcesFolder : 4D:C1709.Folder:=This:C1470._resourcesFolder()

	If (Not:C34($resourcesFolder.exists))

		$report.error:="Resources folder not found: "+String:C10($resourcesFolder.path)
		return $report

	End if

	var $file : 4D:C1709.File

	For each ($file; $resourcesFolder.files(fk recursive:K87:7).query("extension = .xlf"))

		var $xliff : cs:C1710.Xliff:=cs:C1710.Xliff.new($file)
		var $node : Text
		var $count : Integer:=0

		For each ($node; $xliff.find($xliff.root; "//group[@id]"))

			$xliff.removeAttribute($node; "id")
			$count+=1

		End for each

		If ($count>0)

			$xliff.save()  // Also closes the tree

			$report.filesChanged+=1
			$report.tagsRemoved+=$count
			$report.details.push({file: String:C10($file.platformPath); removed: $count})

		Else

			$xliff.close()

		End if

	End for each

	return $report

	// === === === === === === === === === === === === === === === === === === ===
	// MARK: - Private helpers
	// === === === === === === === === === === === === === === === === === === ===

Function _resourcesFolder() : 4D:C1709.Folder

	return Folder:C1567("/RESOURCES/"; *)

	// === === === === === === === === === === === === === === === === === === ===
	// Sorted language codes from the <lang>.lproj folder names.
Function _discoverLangs($resourcesFolder : 4D:C1709.Folder) : Collection

	var $langs : Collection:=[]
	var $folder : 4D:C1709.Folder

	For each ($folder; $resourcesFolder.folders().query("extension=.lproj"))

		$langs.push($folder.name)

	End for each

	return $langs.sort()

	// === === === === === === === === === === === === === === === === === === ===
	// Strips a trailing uppercase language suffix from a file stem if present
	// (CommonEN -> Common), else returns the stem unchanged (editor -> editor).
Function _familyForFilename($stem : Text; $lang : Text) : Text

	var $suffix : Text:=Uppercase:C13($lang)

	If (Length:C16($stem)>Length:C16($suffix))\
		 && (Substring:C12($stem; Length:C16($stem)-Length:C16($suffix)+1)=$suffix)

		return Substring:C12($stem; 1; Length:C16($stem)-Length:C16($suffix))

	End if

	return $stem

	// === === === === === === === === === === === === === === === === === === ===
	// Returns {fileMap; families; partial}: families common to EVERY language
	// (fileMap[family][lang] = File), and families present in only some
	// languages (partial[family] = count of languages having it), left untouched.
	//
	// A .xlf file directly at the root of resourcesFolder (no <lang>.lproj/) is
	// shared by every language: if a language has no <lang>.lproj file for that
	// family, the root file is used as fileMap[family][lang] instead (multiple
	// languages can end up pointing to the very same File).
Function _discoverFamilies($resourcesFolder : 4D:C1709.Folder; $langs : Collection) : Object

	var $fileMap : Object:={}
	var $famCount : Object:={}

	var $lang : Text
	For each ($lang; $langs)

		var $langFolder : 4D:C1709.Folder:=$resourcesFolder.folder($lang+".lproj")
		var $file : 4D:C1709.File

		For each ($file; $langFolder.files().query("extension = .xlf"))

			var $fam : Text:=This:C1470._familyForFilename($file.name; $lang)

			$fileMap[$fam]:=$fileMap[$fam] || {}
			$fileMap[$fam][$lang]:=$file

			$famCount[$fam]:=($famCount[$fam] || 0)+1

		End for each

	End for each

	// Root-level files: shared by every language, and the fallback for any
	// language whose <lang>.lproj/ folder has no file for that family.
	var $rootFile : 4D:C1709.File

	For each ($rootFile; $resourcesFolder.files().query("extension = .xlf"))

		var $rootFam : Text:=$rootFile.name

		$fileMap[$rootFam]:=$fileMap[$rootFam] || {}
		$famCount[$rootFam]:=$famCount[$rootFam] || 0

		For each ($lang; $langs)

			If ($fileMap[$rootFam][$lang]=Null:C1517)

				$fileMap[$rootFam][$lang]:=$rootFile
				$famCount[$rootFam]+=1

			End if

		End for each

	End for each

	var $families : Collection:=[]
	var $partial : Object:={}

	var $family : Text
	For each ($family; $famCount)

		If ($famCount[$family]=$langs.length)

			$families.push($family)

		Else

			$partial[$family]:=$famCount[$family]

		End if

	End for each

	return {fileMap: $fileMap; families: $families.sort(); partial: $partial}

	// === === === === === === === === === === === === === === === === === === ===
	// Returns {resname; includeIf} for a trans-unit's attributes, or Null if it
	// has no resname (nothing to key/sync it by).
Function _unitKey($attrs : Object) : Object

	If ($attrs.resname=Null:C1517)

		return Null:C1517

	End if

	return {resname: String:C10($attrs.resname); includeIf: String:C10($attrs["d4:includeIf"])}

	// === === === === === === === === === === === === === === === === === === ===
	// True duplicates -- same (resname, d4:includeIf) appearing more than once
	// in the SAME file -- across every family/language combination. A file
	// shared by several languages (root-level or fallback file) is scanned only
	// once per family, and reported with the full list of languages using it.
Function _scanDuplicates($families : Collection; $langs : Collection; $fileMap : Object) : Collection

	var $result : Collection:=[]

	var $family; $lang; $path : Text
	For each ($family; $families)

		// Group languages by the physical file they actually use for this family.
		var $fileForPath : Object:={}
		var $langsForPath : Object:={}

		For each ($lang; $langs)

			var $file : 4D:C1709.File:=$fileMap[$family][$lang]

			If ($file=Null:C1517) || Not:C34($file.exists)

				continue

			End if

			$path:=String:C10($file.platformPath)

			$fileForPath[$path]:=$file
			$langsForPath[$path]:=$langsForPath[$path] || []
			$langsForPath[$path].push($lang)

		End for each

		For each ($path; $fileForPath)

			var $dupFile : 4D:C1709.File:=$fileForPath[$path]
			var $xliff : cs:C1710.Xliff:=cs:C1710.Xliff.new($dupFile)
			var $seen : Object:={}
			var $node : Text

			For each ($node; $xliff.find($xliff.root; "//trans-unit"))

				var $key : Object:=This:C1470._unitKey($xliff.getAttributes($node))

				If ($key=Null:C1517)

					continue

				End if

				$seen[$key.resname]:=$seen[$key.resname] || {}
				$seen[$key.resname][$key.includeIf]:=($seen[$key.resname][$key.includeIf] || 0)+1

			End for each

			$xliff.close()

			var $resname; $includeIf : Text
			For each ($resname; $seen)

				For each ($includeIf; $seen[$resname])

					If ($seen[$resname][$includeIf]>1)

						$result.push({\
							family: $family; \
							languages: $langsForPath[$path]; \
							file: $dupFile.name+$dupFile.extension; \
							resname: $resname; \
							includeIf: $includeIf; \
							count: $seen[$resname][$includeIf]})

					End if

				End for each

			End for each

		End for each

	End for each

	return $result
