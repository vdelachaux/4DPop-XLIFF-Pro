//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : doc_Path_add_folders
  // Database: 4D unitTest
  // ID[4567382CACDE4A8287628A28E78509E7]
  // Created #7-1-2014 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($0)
C_TEXT:C284(${1})

C_LONGINT:C283($Lon_i;$Lon_parameters)
C_TEXT:C284($Txt_path)

If (False:C215)
	C_TEXT:C284(doc_Path_add_folders ;$0)
	C_TEXT:C284(doc_Path_add_folders ;${1})
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
For ($Lon_i;1;$Lon_parameters;1)
	
	$Txt_path:=$Txt_path+${$Lon_i}+Folder separator:K24:12
	
End for 

$0:=$Txt_path

  // ----------------------------------------------------
  // End 