//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : FILE_NEW
  // Database: 4DPop XLIFF Pro
  // ID[C368E702A7C64EE1A850F5ADF6C683E3]
  // Created #22-2-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_BOOLEAN:C305($Boo_first;$Boo_newFile)
C_LONGINT:C283($Lon_i;$Lon_index;$Lon_parameters;$Lon_row)
C_POINTER:C301($Ptr_list;$Ptr_name;$Ptr_object;$Ptr_project)
C_TEXT:C284($Dir_target;$Dom_node;$Dom_root;$File_localized;$File_reference;$Txt_fileName)
C_TEXT:C284($Txt_targetLanguage)
C_OBJECT:C1216($Obj_file;$Obj_language)

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // NO PARAMETERS REQUIRED
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		  // <NONE>
		
	End if 
	
	$Boo_first:=(String:C10(Form:C1466.files[0].name)="")  // First file added for the project
	
	$Dir_target:=Form:C1466.referenceFolder()
	
	$Txt_fileName:=Select document:C905($Dir_target;".xlf";Get localized string:C991("FileName");File name entry:K24:17+Package open:K24:8+Use sheet window:K24:11)
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If (OK=1)
	
	  // Let's make sure that the extension is correct
	$Obj_file:=Path to object:C1547(DOCUMENT)
	$Obj_file.extension:=".xlf"
	$File_reference:=Object to path:C1548($Obj_file)
	$Txt_fileName:=$Obj_file.name+$Obj_file.extension
	
	$Dir_target:=$Obj_file.parentFolder
	
	  // Create the reference folder if any
	CREATE FOLDER:C475($File_reference;*)
	
	$Dom_root:=DOM Parse XML source:C719(Get 4D folder:C485(Current resources folder:K5:16)+"template.xlf")
	
	If (Asserted:C1132(OK=1))
		
		$Obj_file:=New object:C1471(\
			"name";$Txt_fileName;\
			"fullName";$Txt_fileName;\
			"parentPath";$Dir_target;\
			"nativePath";$File_reference;\
			"modified";True:C214)
		
		$Dom_node:=DOM Find XML element:C864($Dom_root;"xliff/file")
		
		If (Asserted:C1132(OK=1))
			
			For each ($Obj_language;Form:C1466.languages)
				
				If ($Obj_language.language=Form:C1466.language)
					
					  // Reference file {
					DOM SET XML ATTRIBUTE:C866($Dom_node;\
						"source-language";Form:C1466.language;\
						"target-language";Form:C1466.language)
					
					  // Save reference file
					Form:C1466.save($Dom_root;$File_reference)
					
					  // UI = update file list  [
					$Ptr_project:=Form:C1466.dynamic("project")
					$Ptr_name:=Form:C1466.dynamic("file")
					$Ptr_object:=Form:C1466.dynamic("file.object")
					
					  // WARNING: File could exist
					If ($Boo_first)
						
						$Lon_row:=1
						
					Else 
						
						$Lon_row:=Find in array:C230($Ptr_name->;$Txt_fileName)
						$Boo_newFile:=($Lon_row=-1)
						
						If ($Boo_newFile)
							
							$Lon_row:=LISTBOX Get number of rows:C915(*;Form:C1466.widgets.files)+1
							LISTBOX INSERT ROWS:C913(*;Form:C1466.widgets.files;$Lon_row)
							
						End if 
					End if 
					
					  // Populate
					$Ptr_project->{$Lon_row}:=$Ptr_project->{1}
					$Ptr_name->{$Lon_row}:=$Txt_fileName
					$Ptr_object->{$Lon_row}:=$Obj_file
					  //]
					
				Else 
					
					  // WARNING: The filename could be suffixed with language [
					$Txt_targetLanguage:=language_Code ($Obj_language.language)
					$File_localized:=Storage:C1525.editor.directory+$Obj_language.language+".lproj"+Folder separator:K24:12+File_Name_suffixed ($Txt_fileName;Form:C1466.language;$Txt_targetLanguage)
					  //]
					
					If (Test path name:C476($File_localized)=Is a document:K24:1)
						
						  // Synchronize source and target files
						FILE_SYNCHRONIZE ($File_reference;$File_localized)
						
					Else 
						
						  // Create target file
						FILE_DUPLICATE ($File_reference;$File_localized;$Txt_targetLanguage)
						
					End if 
				End if 
			End for each 
			  //}
			
		End if 
		
		  // Close reference file
		DOM CLOSE XML:C722($Dom_root)
		
		  // Update project {
		$Lon_index:=Form:C1466.files.extract("name").indexOf($Obj_file.fullName)
		
		Case of 
				
				  //______________________________________________________
			: ($Boo_first)
				
				Form:C1466.files[0]:=$Obj_file
				
				  //______________________________________________________
			: ($Lon_index#-1)
				
				Form:C1466.files[$Lon_index]:=$Obj_file
				$Lon_row:=$Lon_index+1
				
				  //______________________________________________________
			Else 
				
				Form:C1466.files.push($Obj_file)
				$Lon_row:=Form:C1466.files.length
				
				  //______________________________________________________
		End case 
		  //}
		
		  // Set as current edited file
		EDITOR_Preferences (New object:C1471(\
			"set";True:C214;\
			"key";"file";\
			"value";$Txt_fileName))
		
		  // Select & parse
		$Ptr_list:=Form:C1466.dynamic(Form:C1466.widgets.files)
		
		For ($Lon_i;1;Size of array:C274($Ptr_list->);1)
			
			$Ptr_list->{$Lon_i}:=($Lon_i=$Lon_row)
			
		End for 
		
		OBJECT SET SCROLL POSITION:C906(*;Form:C1466.widgets.files;$Lon_row)
		
		Form:C1466.parse($Lon_row)
		
	End if 
End if 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End 