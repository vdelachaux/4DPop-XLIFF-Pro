//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : xlf_Open
// Database: 4DPop XLIFF Pro
// ID[C085B9E7277E44ED931C1A90F9A6B64A]
// Created #15-12-2016 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
C_TEXT:C284($0)
C_TEXT:C284($1)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Dom_root; $File_path; $Txt_)

If (False:C215)
	C_TEXT:C284(xlf_Open; $0)
	C_TEXT:C284(xlf_Open; $1)
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1; "Missing parameter"))
	
	// Required parameters
	$File_path:=$1
	
	// Optional parameters
	If ($Lon_parameters>=2)
		
		// <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
If (Asserted:C1132(Test path name:C476($File_path)=Is a document:K24:1))
	
	// Cleanup
	$Txt_:=Document to text:C1236($File_path; "UTF-8")
	
	If (0=Rgx_SubstituteText("(?m-si)>\\s*<"; "><"; ->$Txt_))
		
		$Dom_root:=DOM Parse XML variable:C720($Txt_)
		
	Else 
		
		// Keep the source
		$Dom_root:=DOM Parse XML source:C719($File_path)
		
	End if 
	
	If (OK=1)
		
		XML SET OPTIONS:C1090($Dom_root; XML indentation:K45:34; XML no indentation:K45:36)
		
	End if 
End if 

// ----------------------------------------------------
// Return
$0:=$Dom_root

// ----------------------------------------------------
// End 