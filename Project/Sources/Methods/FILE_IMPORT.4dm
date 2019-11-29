//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : FILE_IMPORT
  // Database: 4DPop XLIFF 2
  // ID[F8F2A295A0C64559865914AD58936707]
  // Created #18-5-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($1)

C_LONGINT:C283($Lon_i;$Lon_index;$Lon_parameters;$Lon_row)
C_POINTER:C301($Ptr_list;$Ptr_name;$Ptr_object;$Ptr_project)
C_TEXT:C284($Dir_root;$Dom_file;$Dom_root;$File_localized;$File_pathname;$File_reference)
C_TEXT:C284($Txt_fileName;$Txt_language;$Txt_source;$Txt_target)
C_OBJECT:C1216($Obj_attributes;$Obj_file)
C_COLLECTION:C1488($Col_languages)

ARRAY TEXT:C222($tFile_name;0)

If (False:C215)
	C_TEXT:C284(FILE_IMPORT ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$File_pathname:=$1
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
$Obj_file:=Path to object:C1547($File_pathname)

$Dir_root:=Path to object:C1547($Obj_file.parentFolder).parentFolder
$Txt_fileName:=$Obj_file.name+$Obj_file.extension

$Obj_file.fullName:=$Txt_fileName
$Obj_file.nativePath:=$File_pathname
$Obj_file.name:=$Txt_fileName
$Obj_file.modified:=True:C214

  // Get the source & target languages
$Dom_root:=DOM Parse XML source:C719($File_pathname)

If (OK=1)
	
	$Dom_file:=DOM Find XML element:C864($Dom_root;"xliff/file")
	
	If (OK=1)
		
		$Obj_attributes:=xml_attributes ($Dom_file)
		
	End if 
	
	DOM CLOSE XML:C722($Dom_root)
	
End if 

$Txt_source:=String:C10($Obj_attributes["source-language"])

If ($Txt_source#"x-none")  // "x-none" is for constant file
	
	If (Match regex:C1019("(?mi-s)^[a-zA-Z]{2}-[a-zA-Z]{2,}$";$Txt_source;1))  // Language-Regional Codes
		
		  // Keep the Language code
		$Txt_source:=Substring:C12($Txt_source;1;2)
		
	End if 
End if 

$Txt_target:=String:C10($Obj_attributes["target-language"])

  // Get other languages into the same directory
$Col_languages:=doc_Folder ($Dir_root).folders.query("extension = .lproj & name != _@").extract("name")

Case of 
		
		  //______________________________________________________
	: ($Txt_source=$Txt_target)\
		 & ($Txt_source=Form:C1466.languages[0].language)  // Source & target languages = reference language
		
		  // Copy file into the reference.lproj - WARNING: could exist in the target folder
		$File_reference:=Storage:C1525.editor.directory+$Txt_source+".lproj"+Folder separator:K24:12+$Txt_fileName
		COPY DOCUMENT:C541($File_pathname;Path to object:C1547($File_reference).parentFolder;*)
		
		For each ($Txt_language;$Col_languages)
			
			If ($Txt_language#Form:C1466.languages[0].language)  // Not for the reference
				
				DOCUMENT LIST:C474($Dir_root+$Txt_language+".lproj";$tFile_name;Ignore invisible:K24:16)
				
				$tFile_name{0}:=File_Name_suffixed ($Txt_fileName;Form:C1466.languages[0].language;$Txt_language)
				$File_localized:=Storage:C1525.editor.directory+$Txt_language+".lproj"+Folder separator:K24:12+$tFile_name{0}
				
				If (Find in array:C230($tFile_name;$tFile_name{0})>0)
					
					  // Copy document & synchronize
					COPY DOCUMENT:C541($Dir_root+$Txt_language+".lproj"+Folder separator:K24:12+$tFile_name{0};Path to object:C1547($File_localized).parentFolder;*)
					FILE_SYNCHRONIZE ($File_reference;$File_localized)
					
				Else 
					
					  // Duplicate reference file
					FILE_DUPLICATE ($File_reference;$File_localized;$Txt_language)
					
				End if 
			End if 
		End for each 
		
		  // UI = update file list  [
		$Ptr_project:=Form:C1466.dynamic("project")
		$Ptr_name:=Form:C1466.dynamic("file")
		$Ptr_object:=Form:C1466.dynamic("file.object")
		
		$Lon_row:=Find in array:C230($Ptr_name->;$Txt_fileName)
		
		If ($Lon_row=-1)
			
			$Lon_row:=LISTBOX Get number of rows:C915(*;Form:C1466.widgets.files)+1
			LISTBOX INSERT ROWS:C913(*;Form:C1466.widgets.files;$Lon_row)
			
		End if 
		
		  // Populate
		$Ptr_project->{$Lon_row}:=$Ptr_project->{1}
		$Ptr_name->{$Lon_row}:=$Txt_fileName
		$Ptr_object->{$Lon_row}:=$Obj_file
		  //]
		
		  // Update project [
		$Lon_index:=Form:C1466.files.extract("name").indexOf($Txt_fileName)
		
		If ($Lon_index#-1)
			
			Form:C1466.files[$Lon_index]:=$Obj_file
			
		Else 
			
			Form:C1466.files.push($Obj_file)
			
		End if 
		  //]
		
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
		
		  //______________________________________________________
	: (False:C215)
		
		  //______________________________________________________
	Else 
		
		  //______________________________________________________
End case 

  // If source = reference & target = one languages
  //    copy file into the language.lproj
  //   find translation into the same directory.
  //       If found copy & synchronize
  //       else duplicate

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End