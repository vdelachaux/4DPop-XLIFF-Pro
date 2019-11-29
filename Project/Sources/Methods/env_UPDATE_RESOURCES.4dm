//%attributes = {"invisible":true,"executedOnServer":true}
  // ----------------------------------------------------
  // Project method : env_UPDATE_RESOURCES
  // ID[66F9B69A2C5A4B19ACA6EE8306FCF19E]
  // Created 28/05/08 by vdl
  // ----------------------------------------------------
  // Modified #24-5-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Update files into the server resources folder
  // ----------------------------------------------------
  // NOTE:
  // This method is executed on server
  // ----------------------------------------------------
  // Declarations
C_BLOB:C604($1)

C_LONGINT:C283($Lon_i;$Lon_mode;$Lon_offset;$Lon_parameters)
C_TEXT:C284($Dir_resources;$File_pathname)

ARRAY BLOB:C1222($tBlb_files;0)
ARRAY TEXT:C222($tTxt_files;0)

If (False:C215)
	C_BLOB:C604(env_UPDATE_RESOURCES ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	BLOB PROPERTIES:C536($1;$Lon_mode)
	
	If ($Lon_mode#Is not compressed:K22:11)
		
		EXPAND BLOB:C535($1)
		
	End if 
	
	BLOB TO VARIABLE:C533($1;$tTxt_files;$Lon_offset)
	BLOB TO VARIABLE:C533($1;$tBlb_files;$Lon_offset)
	
	SET BLOB SIZE:C606($1;0)
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
	$Dir_resources:=Get 4D folder:C485(Current resources folder:K5:16;*)
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
For ($Lon_i;1;Size of array:C274($tTxt_files);1)
	
	$File_pathname:=$Dir_resources+Convert path POSIX to system:C1107($tTxt_files{$Lon_i})
	
	If (BLOB size:C605($tBlb_files{$Lon_i})>0)
		
		If (Test path name:C476($File_pathname)=Is a document:K24:1)
			
			  // Update
			DELETE DOCUMENT:C159($File_pathname)
			
		Else 
			
			  // Add
			CREATE FOLDER:C475($File_pathname;*)
			
		End if 
		
		BLOB TO DOCUMENT:C526($File_pathname;$tBlb_files{$Lon_i})
		
	Else 
		
		If (Test path name:C476($File_pathname)=Is a document:K24:1)
			
			  // Delete
			DELETE DOCUMENT:C159($File_pathname)
			
		End if 
	End if 
End for 

NOTIFY RESOURCES FOLDER MODIFICATION:C1052

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End