C_TEXT:C284($Dir_localized;$File_localized)
C_OBJECT:C1216($Obj_file;$Obj_language)

EDITOR_CLEANUP (Form:C1466.backup.languages)

If (Form:C1466.language#Form:C1466.backup.language)
	
	Form:C1466.languages[0].language:=Form:C1466.language
	
	EDITOR_Preferences (New object:C1471(\
		"set";True:C214;\
		"key";"reference";\
		"value";Form:C1466.language))
	
Else 
	
	For each ($Obj_language;Form:C1466.languages)
		
		If ($Obj_language.language=Form:C1466.language)
			
			  //
			
		Else 
			
			$Dir_localized:=Object to path:C1548(New object:C1471(\
				"name";$Obj_language.language+".lproj";\
				"parentFolder";Storage:C1525.editor.directory;\
				"isFolder";True:C214))
			
			For each ($Obj_file;Form:C1466.files)
				
				$File_localized:=$Dir_localized+File_Name_suffixed ($Obj_file.fullName;Form:C1466.language;$Obj_language.language)
				
				If (Test path name:C476($File_localized)=Is a document:K24:1)
					
					  // Synchronize source and target files
					FILE_SYNCHRONIZE ($Obj_file.nativePath;$File_localized)
					
				Else 
					
					  // Create target file
					FILE_DUPLICATE ($Obj_file.nativePath;$File_localized;$Obj_language.language)
					
				End if 
			End for each 
		End if 
	End for each 
End if 

  // Apply the modifications
CALL SUBFORM CONTAINER:C1086(-On Validate:K2:3)