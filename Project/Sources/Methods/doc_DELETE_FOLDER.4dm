//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : doc_DELETE_FOLDER
  // Database: 4D unitTest
  // ID[5D3005B1B5614C19927B2D29FCF533AB]
  // Created #31-10-2013 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($1)
C_BOOLEAN:C305($2)

C_BOOLEAN:C305($Boo_makeWritable)
C_LONGINT:C283($Lon_i;$Lon_parameters)
C_TEXT:C284($Path_target)

ARRAY TEXT:C222($tTxt_files;0)

If (False:C215)
	C_TEXT:C284(doc_DELETE_FOLDER ;$1)
	C_BOOLEAN:C305(doc_DELETE_FOLDER ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	$Path_target:=$1
	
	If ($Path_target[[Length:C16($Path_target)]]#Folder separator:K24:12)
		
		$Path_target:=$Path_target+Folder separator:K24:12
		
	End if 
	
	If ($Lon_parameters>=2)
		
		$Boo_makeWritable:=$2
		
	End if 
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
  // #25-6-2014
If ($Boo_makeWritable)
	
	  // we ensure that all files of the current directory are writable {
	doc_SET_WRITABLE ($Path_target)
	
End if 

DOCUMENT LIST:C474($Path_target;$tTxt_files)

For ($Lon_i;1;Size of array:C274($tTxt_files);1)
	
	DELETE DOCUMENT:C159($Path_target+$tTxt_files{$Lon_i})
	
End for 

FOLDER LIST:C473($Path_target;$tTxt_files)

For ($Lon_i;1;Size of array:C274($tTxt_files);1)
	
	doc_DELETE_FOLDER ($Path_target+$tTxt_files{$Lon_i}+Folder separator:K24:12)  //<==== RECURSIVE
	
End for 

DELETE FOLDER:C693($Path_target)

  // ----------------------------------------------------
  // End