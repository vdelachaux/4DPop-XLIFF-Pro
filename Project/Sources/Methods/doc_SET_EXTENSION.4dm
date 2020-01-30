//%attributes  = {"invisible":true}
  // ----------------------------------------------------
  // Project method : doc_SET_EXTENSION
  // Database: 4D unitTest
  // ID[AAD1F4CB253B416881EC3A3E6914ADA4]
  // Created #8-1-2014 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($0)
C_TEXT:C284($1)
C_TEXT:C284($2)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Txt_extension;$Txt_file)

If (False:C215)
	C_TEXT:C284(doc_SET_EXTENSION ;$0)
	C_TEXT:C284(doc_SET_EXTENSION ;$1)
	C_TEXT:C284(doc_SET_EXTENSION ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=2;"Missing parameter"))
	
	$Txt_file:=$1
	$Txt_extension:=$2
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
$0:=Choose:C955(Match regex:C1019("\\."+$Txt_extension+"$";$Txt_file;1);$Txt_file;$Txt_file+"."+$Txt_extension)

  // ----------------------------------------------------
  // End 