//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : File_Name_suffixed
  // Database: 4DPop XLIFF Pro
  // ID[AB3B59E8741942BFBAA3B5E5E3B1D2C4]
  // Created #2-3-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($0)
C_TEXT:C284($1)
C_TEXT:C284($2)
C_TEXT:C284($3)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Txt_buffer;$Txt_fileName;$Txt_referenceLanguage;$Txt_targetLanguage)

If (False:C215)
	C_TEXT:C284(File_Name_suffixed ;$0)
	C_TEXT:C284(File_Name_suffixed ;$1)
	C_TEXT:C284(File_Name_suffixed ;$2)
	C_TEXT:C284(File_Name_suffixed ;$3)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=3;"Missing parameter"))
	
	  // Required parameters
	$Txt_fileName:=$1
	$Txt_referenceLanguage:=$2
	$Txt_targetLanguage:=$3
	
	  // Optional parameters
	If ($Lon_parameters>=4)
		
		  // <NONE>
		
	End if 
	
	$Txt_referenceLanguage:=Uppercase:C13($Txt_referenceLanguage)
	$Txt_targetLanguage:=Uppercase:C13($Txt_targetLanguage)
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
  // Remove extension
$Txt_buffer:=Substring:C12($Txt_fileName;1;Position:C15(".";$Txt_fileName)-1)

  // Search for the reference language at the end of the file name
If (Position:C15($Txt_referenceLanguage;$Txt_buffer;*)=(Length:C16($Txt_buffer)-1))
	
	  // Replace reference language by target language
	$Txt_fileName:=Replace string:C233($Txt_fileName;$Txt_referenceLanguage+".xlf";$Txt_targetLanguage+".xlf";*)
	
End if 

  // ----------------------------------------------------
  // Return
$0:=$Txt_fileName

  // ----------------------------------------------------
  // End 