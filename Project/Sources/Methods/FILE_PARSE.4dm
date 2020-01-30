//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : FILE_PARSE
  // Database: 4DPop XLIFF Pro
  // ID[71E10F989F864DDA90A2B944F0C879AA]
  // Created #12-10-2015 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($1)

C_BOOLEAN:C305($Boo_constantThemes)
C_LONGINT:C283($Lon_group;$Lon_parameters;$Lon_row;$Lon_unit;$Lon_unitCount;$Lon_x)
C_TEXT:C284($Dom_file;$Dom_root;$Dom_source;$Txt_note;$Txt_source)
C_OBJECT:C1216($Obj_group;$Obj_groupAttributes;$Obj_language;$Obj_unit;$Obj_unitAttributes)
C_COLLECTION:C1488($Col_allUnits)

ARRAY TEXT:C222($tDom_group;0)

If (False:C215)
	C_LONGINT:C283(FILE_PARSE ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	$Lon_row:=$1
	
	  // Keep the current file
	Form:C1466.$currentFile:=(Form:C1466.dynamic("file"))->{$Lon_row}
	
	$Lon_x:=Form:C1466.files.extract("name").indexOf(Form:C1466.$currentFile)
	ASSERT:C1129($Lon_x#-1;"oups")
	
	Form:C1466.file:=Form:C1466.files[$Lon_x]
	
	  // Parse selected file if any {
	If (Form:C1466.file.$dom=Null:C1517)
		
		Form:C1466.file.$dom:=xlf_Open (Form:C1466.file.nativePath)
		
	End if 
	
	ASSERT:C1129(xml_IsValidReference (Form:C1466.file.$dom))
	  //}
	
	EDITOR_CLEANUP 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
ASSERT:C1129(Not:C34(Bool:C1537(Form:C1466.file.shared)))  //#IN_WORKS - must manage files at the root of the resources folder

$Dom_file:=DOM Find XML element:C864(Form:C1466.file.$dom;"xliff/file")

If (Asserted:C1132(Bool:C1537(OK)))
	
	  // Delete all strings
	LISTBOX DELETE ROWS:C914(*;Form:C1466.widgets.strings;1;LISTBOX Get number of rows:C915(*;Form:C1466.widgets.strings))
	
	  // [Reference file]
	If (Form:C1466.file.datatype=Null:C1517)
		
		  // Get & keep the datatype: x-STR# | x-4DK#
		Form:C1466.file.datatype:=String:C10(xml_attributes ($Dom_file).datatype)
		
	End if 
	
	$tDom_group{0}:=DOM Find XML element:C864($Dom_file;"file/body/group";$tDom_group)
	
	If (Bool:C1537(OK))
		
		Form:C1466.file.groups:=New collection:C1472
		
		  // Keep a collection of all units of the file
		$Col_allUnits:=New collection:C1472
		
		  // For each group
		For ($Lon_group;1;Size of array:C274($tDom_group);1)
			
			  // Get the group attributes
			$Obj_groupAttributes:=xml_attributes ($tDom_group{$Lon_group})
			
			$Obj_group:=New object:C1471(\
				"$dom";$tDom_group{$Lon_group};\
				"resname";$Obj_groupAttributes.resname;\
				"id";String:C10($Obj_groupAttributes.id);\
				"units";New collection:C1472)
			
			ARRAY TEXT:C222($tDom_unit;0x0000)
			$tDom_unit{0}:=DOM Find XML element:C864($tDom_group{$Lon_group};"group/trans-unit";$tDom_unit)
			
			$Lon_unitCount:=Size of array:C274($tDom_unit)
			
			$Boo_constantThemes:=Form:C1466.isConstant() & ($Lon_group=1)
			
			If ($Boo_constantThemes)
				
				ARRAY TEXT:C222($tTxt_themeResname;$Lon_unitCount)
				ARRAY TEXT:C222($tTxt_themeName;$Lon_unitCount)
				
			End if 
			
			If ($Lon_unitCount>0)
				
				  // For each trans-unit
				For ($Lon_unit;1;$Lon_unitCount;1)
					
					  // Get the source element
					$Dom_source:=DOM Find XML element:C864($tDom_unit{$Lon_unit};"trans-unit/source")
					
					If (OK=1)
						
						  // Get the unit attributes
						$Obj_unitAttributes:=xml_attributes ($tDom_unit{$Lon_unit})
						
						  // Get the reference string
						xml_GET_ELEMENT_VALUE ($Dom_source;->$Txt_source)
						
						If ($Boo_constantThemes)
							
							  // Keep the theme names
							$tTxt_themeResname{$Lon_unit}:=String:C10($Obj_unitAttributes.resname)
							$tTxt_themeName{$Lon_unit}:=$Txt_source
							
						End if 
						
						$Obj_unit:=New object:C1471(\
							"$dom";$tDom_unit{$Lon_unit};\
							"resname";String:C10($Obj_unitAttributes.resname);\
							"id";String:C10($Obj_unitAttributes.id);\
							"noTranslate";Bool:C1537(String:C10($Obj_unitAttributes.translate)="no");\
							"source";New object:C1471(\
							"$dom";$Dom_source;\
							"value";$Txt_source))
						
						If (Length:C16(String:C10($Obj_unitAttributes["d4:includeIf"]))>0)
							
							$Obj_unit["d4:includeIf"]:=$Obj_unitAttributes["d4:includeIf"]
							
						End if 
						
						  // Retrieve note if exists
						$Dom_source:=DOM Find XML element:C864($tDom_unit{$Lon_unit};"trans-unit/note")
						
						If (OK=1)
							
							xml_GET_ELEMENT_VALUE ($Dom_source;->$Txt_note)
							$Obj_unit.note:=$Txt_note
							
						End if 
						
						If (Form:C1466.isConstant())\
							 & Not:C34($Boo_constantThemes)
							
							  // Get the group name
							$Lon_x:=Find in array:C230($tTxt_themeResname;$Obj_groupAttributes["d4:groupName"])
							
							$Obj_unit.group:=Choose:C955(Asserted:C1132($Lon_x>0);New object:C1471(\
								"resname";$tTxt_themeName{$Lon_x});\
								New object:C1471(\
								"resname";""))
							
							$Obj_unit.resname:=$Txt_source
							
						Else 
							
							If ($Boo_constantThemes)
								
								$Obj_unit.resname:=$Txt_source
								
							End if 
							
							$Obj_unit.group:=Choose:C955(False:C215;New object:C1471(\
								"resname";$Obj_group.resname;\
								"$dom";$Obj_group.$dom);\
								$Obj_group)
							
						End if 
						
						$Obj_group.units.push($Obj_unit)
						$Col_allUnits.push($Obj_unit)
						
					End if 
				End for 
				
			Else 
				
				$Col_allUnits.push(New object:C1471(\
					"resname";"...";\
					"group";$Obj_group))
				
			End if 
			
			Form:C1466.file.groups.push($Obj_group)
			
		End for 
		
		  //%W-518.1
		  // Populate listbox [
		COLLECTION TO ARRAY:C1562($Col_allUnits;Form:C1466.dynamic("group")->;"group.resname")
		COLLECTION TO ARRAY:C1562($Col_allUnits;Form:C1466.dynamic("unit")->;"resname")
		COLLECTION TO ARRAY:C1562($Col_allUnits;Form:C1466.dynamic("content")->)
		  //%W+518.1
		
		  // Collapse
		LISTBOX COLLAPSE:C1101(*;Form:C1466.widgets.strings;True:C214;lk all:K53:16)
		
		  // Unselect all
		LISTBOX SELECT ROW:C912(*;Form:C1466.widgets.strings;0;lk remove from selection:K53:3)
		
		  // Sort
		LISTBOX SORT COLUMNS:C916(*;Form:C1466.widgets.strings;2;>)
		  //]
		
		  // Find duplicates resnames in the file
		Form:C1466.file.duplicateResname:=Not:C34($Col_allUnits.extract("resname").orderBy().equal($Col_allUnits.distinct("resname";ck diacritical:K85:3);ck diacritical:K85:3))
		
		If (Form:C1466.file.duplicateResname)
			
			  // Highlight duplicate rename
			Form:C1466.message(New object:C1471(\
				"target";"duplicateResname"))
			
		End if 
		
		  // Check if the ID attribute is unique
		Form:C1466.file.uniqueID:=$Col_allUnits.extract("id").orderBy().equal($Col_allUnits.distinct("id";ck diacritical:K85:3);ck diacritical:K85:3)
		
	Else 
		
		Form:C1466.file.uniqueID:=True:C214
		Form:C1466.file.duplicateResname:=False:C215
		
	End if 
	
	  // [Localizations] {
	If (Bool:C1537(Form:C1466.file.shared))  //#IN_WORKS - must manage files at the root of the resources folder
		
		  //
		
	Else 
		
		For each ($Obj_language;Form:C1466.languages)
			
			If ($Obj_language.language=Form:C1466.language)
				
				$Obj_language.file:=New object:C1471
				$Obj_language.file.fullName:=Form:C1466.file.fullName
				$Obj_language.file.parentPath:=Storage:C1525.editor.directory+$Obj_language.language+".lproj"+Folder separator:K24:12
				$Obj_language.file.nativePath:=$Obj_language.file.parentPath+$Obj_language.file.fullName
				$Obj_language.file.$dom:=$Dom_file
				
			Else 
				
				$Obj_language.file:=New object:C1471
				$Obj_language.file.fullName:=File_Name_suffixed (Form:C1466.file.fullName;Form:C1466.language;language_Code ($Obj_language.language))
				$Obj_language.file.parentPath:=Storage:C1525.editor.directory+$Obj_language.language+".lproj"+Folder separator:K24:12
				$Obj_language.file.nativePath:=$Obj_language.file.parentPath+$Obj_language.file.fullName
				
				If (Asserted:C1132(Test path name:C476($Obj_language.file.nativePath)=Is a document:K24:1))
					
					  // Open the file
					If ($Obj_language.file.$dom=Null:C1517)
						
						$Dom_root:=xlf_Open ($Obj_language.file.nativePath)
						
						If (Asserted:C1132(OK=1))
							
							  // Keep the tree root reference
							$Obj_language.file.$dom:=$Dom_root
							
						End if 
					End if 
				End if 
				
				  // Remove obsoletes
				OB REMOVE:C1226($Obj_language;"value")
				OB REMOVE:C1226($Obj_language;"state")
				
			End if 
		End for each 
	End if 
	  //}
	
	  // UI
	LISTBOX SELECT ROW:C912(*;Form:C1466.widgets.strings;0;lk remove from selection:K53:3)
	
	EDITOR_Preferences (New object:C1471(\
		"set";True:C214;\
		"key";"file";\
		"value";Form:C1466.$currentFile))
	
	  // ASSERT(debug_SAVE (Form))
	
End if 

SET TIMER:C645(-1)

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End 