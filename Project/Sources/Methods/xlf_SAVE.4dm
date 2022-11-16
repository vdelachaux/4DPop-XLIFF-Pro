//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : xlf_SAVE
// Database: 4DPop XLIFF Pro
// ID[5BB70C5B158547FE82614AD7204B412D]
// Created #15-12-2016 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
C_TEXT:C284($1)
C_TEXT:C284($2)
C_BOOLEAN:C305($3)

C_BOOLEAN:C305($Boo_close)
C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Dom_ref; $Dom_root; $File_pathname)

ARRAY TEXT:C222($tDom_prop; 0)
ARRAY TEXT:C222($tDom_propGroup; 0)

If (False:C215)
	C_TEXT:C284(xlf_SAVE; $1)
	C_TEXT:C284(xlf_SAVE; $2)
	C_BOOLEAN:C305(xlf_SAVE; $3)
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=2; "Missing parameter"))
	
	// Required parameters
	$Dom_ref:=$1
	$File_pathname:=$2
	
	// Optional parameters
	If ($Lon_parameters>=3)
		
		$Boo_close:=$3
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
$Dom_root:=DOM Get root XML element:C1053($Dom_ref)

ASSERT:C1129(xml_IsValidReference($Dom_root))

// Add the namespace d4
DOM SET XML ATTRIBUTE:C866($Dom_root; \
"xmlns:d4"; "http://www.4d.com/d4-ns")

$Dom_root:=xml_cleanup($Dom_root)

// Update prop-group values
xlf_PROP_GROUP($Dom_root)

// Update copyright if any
$Dom_root:=xlf_Copyright($Dom_root)
DOM EXPORT TO FILE:C862($Dom_root; $File_pathname)

ASSERT:C1129(OK=1)
DOM CLOSE XML:C722($Dom_root)

If ($Boo_close)
	
	DOM CLOSE XML:C722($Dom_ref)
	
End if 

// ----------------------------------------------------
// Return
// <NONE>
// ----------------------------------------------------
// End 