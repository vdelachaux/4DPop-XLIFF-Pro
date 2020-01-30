//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : doc_Get_extension
  // Database: 4D unitTest
  // ID[82655366425845CC8B1E2E0857157614]
  // Created #8-1-2014 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($0)
C_TEXT:C284($1)

C_LONGINT:C283($Lon_length;$Lon_parameters;$Lon_position)
C_TEXT:C284($Txt_file;$Txt_pattern)

If (False:C215)
	C_TEXT:C284(doc_Get_extension ;$0)
	C_TEXT:C284(doc_Get_extension ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	If (Asserted:C1132(Length:C16($1)>0;"Missing parameter"))
		
		$Txt_file:=$1
		
		$Txt_pattern:="\\.([^.]*)$"
		
	Else 
		
		ABORT:C156
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If (Match regex:C1019($Txt_pattern;$Txt_file;1;$Lon_position;$Lon_length))
	
	$0:=Substring:C12($Txt_file;$Lon_position+1;$Lon_length-1)
	
End if 

  // ----------------------------------------------------
  // End 