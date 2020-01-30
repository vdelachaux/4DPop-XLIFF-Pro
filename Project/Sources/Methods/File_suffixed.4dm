//%attributes  = {"invisible":true}
  // ----------------------------------------------------
  // Project method : File_suffixed
  // Database: 4DPop XLIFF Pro
  // ID[7AE65EA724B84B639AAADD496F3AE15F]
  // Created #2-3-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_BOOLEAN:C305($0)
C_TEXT:C284($1)
C_TEXT:C284($2)

C_BOOLEAN:C305($Boo_suffixed)
C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Txt_buffer;$Txt_fileName;$Txt_language)

If (False:C215)
	C_BOOLEAN:C305(File_suffixed ;$0)
	C_TEXT:C284(File_suffixed ;$1)
	C_TEXT:C284(File_suffixed ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=2;"Missing parameter"))
	
	  // Required parameters
	$Txt_fileName:=$1
	$Txt_language:=$2
	
	  // Optional parameters
	If ($Lon_parameters>=3)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
  // Remove extension
$Txt_buffer:=Substring:C12($Txt_fileName;1;Position:C15(".";$Txt_fileName)-1)

  // Search for the language at the end of the file name
$Boo_suffixed:=(Position:C15(Uppercase:C13($Txt_language);$Txt_buffer;*)=(Length:C16($Txt_buffer)-1))

  // ----------------------------------------------------
  // Return
$0:=$Boo_suffixed

  // ----------------------------------------------------
  // End 