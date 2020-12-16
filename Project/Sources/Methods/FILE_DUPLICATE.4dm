//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : FILE_DUPLICATE
// Database: 4DPop XLIFF Pro
// ID[A8A6A94222FB443987D7570781813E3E]
// Created #3-11-2015 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
C_TEXT:C284($1)
C_TEXT:C284($2)
C_TEXT:C284($3)
C_BOOLEAN:C305($4)

C_BOOLEAN:C305($Boo_emptyTarget)
C_LONGINT:C283($Lon_group; $Lon_parameters; $Lon_unit)
C_TEXT:C284($Dom_body; $Dom_file; $Dom_root; $Dom_source; $Dom_target; $File_source)
C_TEXT:C284($File_target; $Txt_buffer; $Txt_targetLanguage)

ARRAY TEXT:C222($tDom_groups; 0)
ARRAY TEXT:C222($tDom_units; 0)

If (False:C215)
	C_TEXT:C284(FILE_DUPLICATE; $1)
	C_TEXT:C284(FILE_DUPLICATE; $2)
	C_TEXT:C284(FILE_DUPLICATE; $3)
	C_BOOLEAN:C305(FILE_DUPLICATE; $4)
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=3; "Missing parameter"))
	
	// Required parameters
	$File_source:=$1  // Template file
	$File_target:=$2  // File to create
	$Txt_targetLanguage:=$3
	
	// Default values
	$Boo_emptyTarget:=False:C215
	
	// Optional parameters
	If ($Lon_parameters>=4)
		
		$Boo_emptyTarget:=$4  // If omitted, the target value is initialized to the value of the master file
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
// Create target file
COPY DOCUMENT:C541($File_source; $File_target)

If (Asserted:C1132(OK=1))
	
	$Dom_root:=xlf_Open($File_target)
	
	If (Asserted:C1132(OK=1))
		
		// Set the target language
		$Dom_file:=DOM Find XML element:C864($Dom_root; "xliff/file")
		
		If (Asserted:C1132(OK=1))
			
			DOM SET XML ATTRIBUTE:C866($Dom_file; \
				"target-language"; $Txt_targetLanguage)
			
			If (Asserted:C1132(OK=1))
				
				$Dom_body:=DOM Find XML element:C864($Dom_root; "xliff/file/body")
				
				If (Asserted:C1132(OK=1))
					
					$tDom_groups{0}:=DOM Find XML element:C864($Dom_body; "body/group"; $tDom_groups)
					
					For ($Lon_group; 1; Size of array:C274($tDom_groups); 1)
						
						$tDom_units{0}:=DOM Find XML element:C864($tDom_groups{$Lon_group}; "group/trans-unit"; $tDom_units)
						
						For ($Lon_unit; 1; Size of array:C274($tDom_units); 1)
							
							If (xlf_To_translate($tDom_units{$Lon_unit}))
								
								$Dom_target:=DOM Find XML element:C864($tDom_units{$Lon_unit}; "trans-unit/target")
								
								If (OK=0)
									
									$Dom_target:=DOM Create XML element:C865($tDom_units{$Lon_unit}; "target")
									
									If (Asserted:C1132(OK=1))
										
										If (Not:C34($Boo_emptyTarget))
											
											$Dom_source:=DOM Find XML element:C864($tDom_units{$Lon_unit}; "trans-unit/source")
											
											If (Asserted:C1132(OK=1))
												
												DOM GET XML ELEMENT VALUE:C731($Dom_source; $Txt_buffer)
												DOM SET XML ELEMENT VALUE:C868($Dom_target; $Txt_buffer)
												
											End if 
										End if 
									End if 
									
								Else 
									
									If ($Boo_emptyTarget)
										
										DOM SET XML ELEMENT VALUE:C868($Dom_target; "")
										DOM SET XML ATTRIBUTE:C866($Dom_target; \
											"state"; "new")
										
									Else 
										
										$Dom_source:=DOM Find XML element:C864($tDom_units{$Lon_unit}; "trans-unit/source")
										
										DOM GET XML ELEMENT VALUE:C731($Dom_source; $Txt_buffer)
										DOM SET XML ELEMENT VALUE:C868($Dom_target; $Txt_buffer)
										
									End if 
								End if 
								
								DOM SET XML ATTRIBUTE:C866($Dom_target; \
									"state"; "new")
								
							End if 
						End for 
					End for 
					
					Form:C1466.save($Dom_root; $File_target)
					
					ASSERT:C1129(OK=1)
					
					DOM CLOSE XML:C722($Dom_root)
					
				End if 
			End if 
		End if 
	End if 
End if 

// ----------------------------------------------------
// Return
// <NONE>
// ----------------------------------------------------
// End 