//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : language_Reference
// Database: 4DPop XLIFF Pro
// ID[C0ABDA947229485C9B5E66ADEB1BC441]
// Created 21/04/2018 by Super_Utilisateur
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
C_TEXT:C284($0)
C_TEXT:C284($1)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Dir_resources; $Dom_file; $Dom_root; $Txt_folder; $Txt_reference; $Txt_source)
C_TEXT:C284($Txt_target)
C_OBJECT:C1216($Obj_attributes; $Obj_file)
C_COLLECTION:C1488($Col_references)

If (False:C215)
	C_TEXT:C284(language_Reference; $0)
	C_TEXT:C284(language_Reference; $1)
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0; "Missing parameter"))
	
	If ($Lon_parameters>=1)
		
		$Dir_resources:=$1
		
	Else 
		
		$Dir_resources:=Get 4D folder:C485(Current resources folder:K5:16; *)
		
	End if 
	
	// Default is the os language
	$Col_references:=New collection:C1472(Get system info:C1571.osLanguage)
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
// For each active language
For each ($Txt_folder; doc_Folder($Dir_resources).folders.query("extension = .lproj & name != _@").extract("name"))
	
	For each ($Obj_file; doc_Folder($Dir_resources+$Txt_folder+".lproj").files.query("extension = .xlf"))
		
		$Dom_root:=DOM Parse XML source:C719($Obj_file.platformPath)
		
		If (Bool:C1537(OK))
			
			$Dom_file:=DOM Find XML element:C864($Dom_root; "xliff/file")
			
			If (OK=1)
				
				$Obj_attributes:=xml_attributes($Dom_file)
				
			End if 
			
			DOM CLOSE XML:C722($Dom_root)
			
			$Txt_source:=String:C10($Obj_attributes["source-language"])
			
			If ($Txt_source#"x-none")  // "x-none" is for constant file
				
				If (Match regex:C1019("(?mi-s)^[a-zA-Z]{2}-[a-zA-Z]{2,}$"; $Txt_source; 1))  // Language-Regional Codes
					
					// Keep the Language code
					$Txt_source:=Substring:C12($Txt_source; 1; 2)
					
				End if 
				
				// Keep the source language
				$Col_references.push($Txt_source)
				
				$Txt_target:=String:C10($Obj_attributes["target-language"])
				
				Case of 
						
						//______________________________________________________
					: ($Txt_source=$Txt_target)
						
						$Txt_reference:=$Txt_source
						
						//______________________________________________________
					: (language_Code($Txt_target)=$Txt_source)  // en : en-us
						
						$Txt_reference:=$Txt_target
						
						//______________________________________________________
					Else 
						
						// ??
						
						//______________________________________________________
				End case 
			End if 
		End if 
	End for each 
End for each 

$Col_references:=$Col_references.distinct()

If ($Col_references.indexOf($Txt_reference)#-1)
	
	$Txt_reference:=language_Code($Txt_reference)
	
Else 
	
	If ($Col_references.length=1)
		
		$Txt_reference:=language_Code($Col_references[0])
		
	Else 
		
		If ($Col_references.indexOf($Col_references[0])#-1)
			
			// Remove the system language
			$Col_references.remove($Col_references.indexOf($Col_references[0]))
			
		End if 
		
		$Txt_reference:=$Col_references.join(",")
		
	End if 
End if 

// ----------------------------------------------------
// Return
$0:=$Txt_reference

// ----------------------------------------------------
// End 