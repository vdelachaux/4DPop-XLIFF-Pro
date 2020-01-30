//%attributes  = {"invisible":true}
  // ----------------------------------------------------
  // Project method : doc_Get_name
  // Database: 4D unitTest
  // ID[5933BC6DD39B45EAB274EC12689AA501]
  // Created #9-1-2014 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($0)
C_TEXT:C284($1)

C_LONGINT:C283($Lon_parameters;$Lon_x)
C_TEXT:C284($Txt_name;$Txt_path)

If (False:C215)
	C_TEXT:C284(doc_Get_name ;$0)
	C_TEXT:C284(doc_Get_name ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  //NO PARAMETERS REQUIRED
	
	$Txt_path:=$1
	
	If ($Txt_path[[Length:C16($Txt_path)]]=Folder separator:K24:12)
		
		$Txt_path:=Delete string:C232($Txt_path;Length:C16($Txt_path);1)
		
	End if 
	
	$Txt_name:=$Txt_path
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Repeat 
	
	$Lon_x:=Position:C15(Folder separator:K24:12;$Txt_name)
	
	If ($Lon_x>0)
		
		$Txt_name:=Substring:C12($Txt_name;$Lon_x+1)
		
	End if 
Until ($Lon_x=0)

  //Remove extension
$Lon_x:=Position:C15(".";$Txt_name)

If ($Lon_x>0)
	
	$Txt_name:=Substring:C12($Txt_name;1;$Lon_x-1)
	
End if 

$0:=$Txt_name

  // ----------------------------------------------------
  // End 