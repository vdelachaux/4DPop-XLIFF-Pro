//%attributes  = {"invisible":true}
  // ----------------------------------------------------
  // Project method : env_DELETE_GEOMETRY
  // Database: 4DPop XLIFF Pro
  // ID[F7C3ACB33BA54F9DBBC41E6C9676639F]
  // Created #5-1-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Deletion of dialog geometry files
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($1)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Dir_root;$Txt_path)

If (False:C215)
	C_TEXT:C284(env_DELETE_GEOMETRY ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  //NO PARAMETERS REQUIRED
	
	  //Optional parameters
	If ($Lon_parameters>=1)
		
		$Txt_path:=$1  //if omitted, all geometry files for the current database for the current 4D version will be deleted
		
	End if 
	
	  //Initialize the pathname for the current 4D version
	$Dir_root:=Get 4D folder:C485\
		+Replace string:C233(Replace string:C233(Structure file:C489(*);Get 4D folder:C485(Database folder:K5:14);"");".4db";"")\
		+Folder separator:K24:12\
		+"4D Window Bounds v"+Delete string:C232(Application version:C493;3;2)\
		+Folder separator:K24:12
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If (Test path name:C476($Dir_root)=Is a folder:K24:2)
	
	If (Length:C16($Txt_path)=0)
		
		  //Delete all geometry files for the current database and for the current version
		DELETE FOLDER:C693($Dir_root;Delete with contents:K24:24)
		
	Else 
		
		$Txt_path:=$Dir_root+Replace string:C233($Txt_path;"/";Folder separator:K24:12)
		
		Case of 
				
				  //______________________________________________________
			: (Test path name:C476($Txt_path)=Is a document:K24:1)
				
				  //Delete the geometry file
				DELETE DOCUMENT:C159($Txt_path)
				
				  //______________________________________________________
			: (Test path name:C476($Txt_path)=Is a folder:K24:2)
				
				  //Delete the geometry folder
				DELETE FOLDER:C693($Dir_root;Delete with contents:K24:24)
				
				  //______________________________________________________
			Else 
				
				  //File or folder not found
				
				  //______________________________________________________
		End case 
	End if 
End if 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End 