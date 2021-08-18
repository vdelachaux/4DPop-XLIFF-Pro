//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : EDITOR_ON_UNLOAD
// Database: 4DPop XLIFF Pro
// ID[681CD7EA00E242AF9DEC09FF6AF3B1FD]
// Created #16-10-2015 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
C_BLOB:C604($Blb_com)
C_LONGINT:C283($Lon_offset; $Lon_parameters)
C_TEXT:C284($Dir_cache; $Txt_buffer; $Txt_path)
C_OBJECT:C1216($Obj_file; $Obj_language; $Obj_preferences; $Obj_project)

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0; "Missing parameter"))
	
	// NO PARAMETERS REQUIRED
	
	// Optional parameters
	If ($Lon_parameters>=1)
		
		// <NONE>
		
	End if 
	
	$Obj_project:=Form:C1466
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
If (OB Is defined:C1231(Form:C1466))
	
	// Frees up the memory [
	For each ($Obj_file; Form:C1466.files)
		
		If (Length:C16(String:C10($Obj_file.$dom))>0)
			
			DOM CLOSE XML:C722($Obj_file.$dom)
			
		End if 
	End for each 
	
	For each ($Obj_file; Form:C1466.languages)
		
		If (Length:C16(String:C10($Obj_file.$dom))>0)
			
			DOM CLOSE XML:C722(DOM Get root XML element:C1053($Obj_file.$dom))
			
		End if 
	End for each 
	//]
	
	// Save project settings [
	$Obj_preferences:=EDITOR_Preferences
	
	// Reference language
	$Obj_preferences.reference:=Form:C1466.language
	
	// Managed languages
	$Obj_preferences.languages:=Form:C1466.languages.extract("language")
	
	// Files
	$Obj_preferences.files:=Form:C1466.files.extract("name")
	
	// Digest
	For each ($Obj_file; Form:C1466.files)
		
		If ($Obj_file.platformPath#Null:C1517)
			
			$Txt_buffer:=$Txt_buffer+Generate digest:C1147(Document to text:C1236($Obj_file.platformPath); MD5 digest:K66:1)
			
		End if 
	End for each 
	
	$Obj_preferences.digest:=Generate digest:C1147($Txt_buffer; MD5 digest:K66:1)
	
	EDITOR_Preferences(New object:C1471(\
		"set"; True:C214; \
		"value"; $Obj_preferences))
	//]
	
	If (Length:C16(String:C10(Form:C1466.localization))>0)
		
		// Restore default geometry
		EXECUTE METHOD IN SUBFORM:C1085(Form:C1466.widgets.localizations; "DISPLAY_INIT"; *; Form:C1466)
		
		OB REMOVE:C1226(Form:C1466; "localization")
		
	End if 
	
	If (Application type:C494=4D Remote mode:K5:5)  // Update server resources
		
		// Get the cache structure folder path
		$Dir_cache:=Get 4D folder:C485(4D Client database folder:K5:13; *)
		
		ARRAY TEXT:C222($tTxt_files; 0x0000)
		ARRAY BLOB:C1222($tBlb_files; 0x0000)
		
		For each ($Obj_file; Form:C1466.files)
			
			If (Bool:C1537($Obj_file.modified))
				
				For each ($Obj_language; Form:C1466.languages)
					
					$Txt_path:=$Obj_language.language+".lproj/"+File_Name_suffixed($Obj_file.fullName; Form:C1466.language; $Obj_language.language)
					APPEND TO ARRAY:C911($tTxt_files; $Txt_path)
					
					$Txt_path:=$Dir_cache+Convert path POSIX to system:C1107("Resources/"+$Txt_path)
					DOCUMENT TO BLOB:C525($Txt_path; $tBlb_files{0})
					APPEND TO ARRAY:C911($tBlb_files; $tBlb_files{0})
					SET BLOB SIZE:C606($tBlb_files{0}; 0)
					
				End for each 
			End if 
		End for each 
		
		If (Size of array:C274($tTxt_files)>0)
			
			VARIABLE TO BLOB:C532($tTxt_files; $Blb_com; $Lon_offset)
			VARIABLE TO BLOB:C532($tBlb_files; $Blb_com; $Lon_offset)
			
			CLEAR VARIABLE:C89($tTxt_files)
			CLEAR VARIABLE:C89($tBlb_files)
			
			COMPRESS BLOB:C534($Blb_com)
			
			env_UPDATE_RESOURCES($Blb_com)
			
			CLEAR VARIABLE:C89($Blb_com)
			
		End if 
	End if 
End if 

// Clean up and self-murder
If (Storage:C1525.editor#Null:C1517)
	
	Use (Storage:C1525)
		
		OB REMOVE:C1226(Storage:C1525.editor; "window")
		
	End use 
End if 

KILL WORKER:C1390("$4DPop XLIFF Pro")

// ----------------------------------------------------
// Return
// <NONE>
// ----------------------------------------------------
// End 