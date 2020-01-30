//%attributes  = {"invisible":true}
  // ----------------------------------------------------
  // Project method : debug_SAVE
  // Database: 4DPop XLIFF Pro
  // ID[399EB8FDD09C4ED491493503748975BE]
  // Created #27-10-2015 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_BOOLEAN:C305($0)
C_OBJECT:C1216($1)

C_LONGINT:C283($Lon_parameters)
C_OBJECT:C1216($Obj_in)

ARRAY TEXT:C222($tTxt_components;0)

If (False:C215)
	C_BOOLEAN:C305(debug_SAVE ;$0)
	C_OBJECT:C1216(debug_SAVE ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  //Required parameters
	$Obj_in:=$1
	
	  //Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: (Structure file:C489#Structure file:C489(*))
		
		  //NOTHING MORE TO DO
		
		  //______________________________________________________
	: (Is compiled mode:C492)\
		 & (Test path name:C476(Get 4D folder:C485(Active 4D Folder:K5:10)+"_vdl")=-43)
		
		  //NOTHING MORE TO DO
		
		  //______________________________________________________
	Else 
		
		TEXT TO DOCUMENT:C1237(Get 4D folder:C485(Current resources folder:K5:16)+"debug.json";JSON Stringify:C1217($Obj_in;*))
		
		  //______________________________________________________
End case 

  // ----------------------------------------------------
  // Return
$0:=True:C214  //for use with ASSERT

  // ----------------------------------------------------
  // End 