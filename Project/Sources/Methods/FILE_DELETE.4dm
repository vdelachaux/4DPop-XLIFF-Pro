//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : FILE_DELETE
  // Database: 4DPop XLIFF 2
  // ID[3FC18B78150646EA945D6A6CD544E18B]
  // Created #18-5-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($1)

C_LONGINT:C283($Lon_i;$Lon_index;$Lon_parameters;$Lon_row;$Lon_x)
C_POINTER:C301($Ptr_list;$Ptr_name;$Ptr_object;$Ptr_project)
C_TEXT:C284($File_localized;$Txt_fileName;$Txt_language)
C_OBJECT:C1216($Obj_language)

ARRAY TEXT:C222($tFile_name;0)

If (False:C215)
	C_TEXT:C284(FILE_DELETE ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // NO PARAMETERS REQUIRED
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		$Txt_fileName:=$1
		
	Else 
		
		$Lon_x:=Find in array:C230(Form:C1466.dynamic(Form:C1466.widgets.files)->;True:C214)
		
		If ($Lon_x>0)
			
			$Txt_fileName:=(Form:C1466.dynamic("file"))->{$Lon_x}
			
		End if 
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If (Length:C16($Txt_fileName)>0)
	
	CONFIRM:C162(Replace string:C233(Get localized string:C991("DeleteFile");"{filename}";$Txt_fileName))
	
	If (OK=1)
		
		EDITOR_CLEANUP 
		
		$Lon_x:=Form:C1466.files.extract("name").indexOf($Txt_fileName)
		
		If (Asserted:C1132($Lon_x#-1))
			
			For each ($Obj_language;Form:C1466.languages)
				
				$Txt_language:=$Obj_language.language
				
				If ($Txt_language=Form:C1466.language)
					
					DELETE DOCUMENT:C159(Form:C1466.files[$Lon_x].nativePath)
					
				Else 
					
					DOCUMENT LIST:C474(Storage:C1525.editor.directory+$Txt_language+".lproj";$tFile_name;Ignore invisible:K24:16)
					
					$tFile_name{0}:=File_Name_suffixed ($Txt_fileName;Form:C1466.language;$Txt_language)
					$File_localized:=Storage:C1525.editor.directory+$Txt_language+".lproj"+Folder separator:K24:12+$tFile_name{0}
					
					If (Find in array:C230($tFile_name;$tFile_name{0})>0)
						
						DELETE DOCUMENT:C159($File_localized)
						
					End if 
				End if 
			End for each 
		End if 
		
		  // UI = update file list  [
		$Ptr_project:=Form:C1466.dynamic("project")
		$Ptr_name:=Form:C1466.dynamic("file")
		$Ptr_object:=Form:C1466.dynamic("file.object")
		
		$Lon_row:=Find in array:C230($Ptr_name->;$Txt_fileName)
		
		If ($Lon_row>0)
			
			LISTBOX DELETE ROWS:C914(*;Form:C1466.widgets.files;$Lon_row)
			
		End if 
		  //]
		
		  // Update project {
		$Lon_index:=Form:C1466.files.extract("name").indexOf($Txt_fileName)
		
		If ($Lon_index#-1)
			
			Form:C1466.files.remove($Lon_index)
			
		End if 
		
		$Lon_x:=LISTBOX Get number of rows:C915(*;Form:C1466.widgets.files)
		
		If ($Lon_row>$Lon_x)
			
			$Lon_row:=$Lon_row-1
			
			If ($Lon_row=0)\
				 & ($Lon_x>0)
				
				$Lon_row:=1
				
			End if 
		End if 
		
		If ($Lon_row>0)
			
			  // Set as current edited file
			EDITOR_Preferences (New object:C1471(\
				"set";True:C214;\
				"key";"file";\
				"value";$Ptr_name->{$Lon_row}))
			
			  // Select & parse
			$Ptr_list:=Form:C1466.dynamic(Form:C1466.widgets.files)
			
			For ($Lon_i;1;Size of array:C274($Ptr_list->);1)
				
				$Ptr_list->{$Lon_i}:=($Lon_i=$Lon_row)
				
			End for 
			
			OBJECT SET SCROLL POSITION:C906(*;Form:C1466.widgets.files;$Lon_row)
			
			Form:C1466.parse($Lon_row)
			
		Else 
			
			  // Remove current edited file
			EDITOR_Preferences (New object:C1471(\
				"set";True:C214;\
				"key";"file"))
			
			  // Select & parse
			$Ptr_list:=Form:C1466.dynamic(Form:C1466.widgets.files)
			
			For ($Lon_i;1;Size of array:C274($Ptr_list->);1)
				
				$Ptr_list->{$Lon_i}:=False:C215
				
			End for 
		End if 
		
		  //ASSERT(debug_SAVE (Form))
		
	End if 
End if 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End