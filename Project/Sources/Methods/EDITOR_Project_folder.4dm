//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : EDITOR_Project_folder
  // Database: 4DPop XLIFF Pro
  // ID[D37BDBC0CDE24FFE85F90F57AC251F22]
  // Created #22-2-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($0)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Dir_pathname)

If (False:C215)
	C_TEXT:C284(EDITOR_Project_folder ;$0)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // NO PARAMETERS REQUIRED
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		  // <NONE>
		
	End if 
	
	  // ASSERT(4D_LOG (Current method name))
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If (env_Component )
	
	  // Component execution
	If (Application type:C494=4D Remote mode:K5:5)
		
		  // Open the local cached folder
		$Dir_pathname:=Get 4D folder:C485(4D Client database folder:K5:13;*)+"Resources"+Folder separator:K24:12
		
	Else 
		
		  // Open host database resources
		$Dir_pathname:=Get 4D folder:C485(Current resources folder:K5:16;*)
		
	End if 
	
Else 
	
	If (Is compiled mode:C492)  //& ($Txt_databaseName#"4DPop XLIFF Pro")  //  #TEMPORARY
		
		  //#TO_BE_DONE - must manage more than one project
		$Dir_pathname:=Get 4D folder:C485(Current resources folder:K5:16)
		
	Else 
		
		  // Matrix database
		If (Shift down:C543)
			
			  // Test project mode
			
		Else 
			
			$Dir_pathname:=Get 4D folder:C485(Current resources folder:K5:16)
			
		End if 
	End if 
End if 

  // ----------------------------------------------------
  // Return
$0:=$Dir_pathname

  // ----------------------------------------------------
  // End 