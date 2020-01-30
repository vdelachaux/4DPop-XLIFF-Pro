//%attributes  = {"invisible":true}
  // ----------------------------------------------------
  // Project method : debug_VIEW_IN_JSON_LAB
  // Database: 4DPop XLIFF Pro
  // ID[9B3DBDE0B1E945FCB3A8A5D539653B7B]
  // Created #27-10-2015 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_BOOLEAN:C305($0)
C_OBJECT:C1216($1)

C_LONGINT:C283($Lon_bottom;$Lon_left;$Lon_parameters;$Lon_right;$Lon_top;$Win_main)
C_OBJECT:C1216($Obj_buffer)

ARRAY TEXT:C222($tTxt_components;0)

If (False:C215)
	C_BOOLEAN:C305(debug_VIEW_IN_JSON_LAB ;$0)
	C_OBJECT:C1216(debug_VIEW_IN_JSON_LAB ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  //Required parameters
	$Obj_buffer:=$1
	
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
		
		COMPONENT LIST:C1001($tTxt_components)
		
		If (Find in array:C230($tTxt_components;"4DPop JsonLab")>0)
			
			$Win_main:=Current form window:C827
			
			  //4DPop_JSON_LAB_VIEW ($Obj_buffer)
			EXECUTE METHOD:C1007("4DPop_JSON_LAB_VIEW";*;$Obj_buffer)
			
			  //restore focus to the current window
			GET WINDOW RECT:C443($Lon_left;$Lon_top;$Lon_right;$Lon_bottom;$Win_main)
			SET WINDOW RECT:C444($Lon_left;$Lon_top;$Lon_right;$Lon_bottom;$Win_main)
			
		End if 
		
		  //______________________________________________________
End case 

  // ----------------------------------------------------
  // Return
$0:=True:C214  //for use with ASSERT

  // ----------------------------------------------------
  // End 