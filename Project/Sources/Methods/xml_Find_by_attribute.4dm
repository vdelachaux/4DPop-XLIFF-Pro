//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : xml_Find_by_attribute
  // Database: 4DPop XLIFF Pro
  // ID[0C35E32A2EC349578EA6C5993358A97F]
  // Created #6-1-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($0)
C_TEXT:C284($1)
C_TEXT:C284($2)
C_TEXT:C284($3)
C_TEXT:C284($4)

C_LONGINT:C283($Lon_i;$Lon_j;$Lon_parameters;$Lon_x)
C_TEXT:C284($Dom_foundReference;$Dom_ref;$Txt_attributeName;$Txt_attributeValue;$Txt_soughtAttribute;$Txt_soughtValue)
C_TEXT:C284($Txt_xPath)

ARRAY LONGINT:C221($tLon_lengths;0)
ARRAY LONGINT:C221($tLon_positions;0)
ARRAY TEXT:C222($tTxt_keys;0)
ARRAY TEXT:C222($tTxt_values;0)

If (False:C215)
	C_TEXT:C284(xml_Find_by_attribute ;$0)
	C_TEXT:C284(xml_Find_by_attribute ;$1)
	C_TEXT:C284(xml_Find_by_attribute ;$2)
	C_TEXT:C284(xml_Find_by_attribute ;$3)
	C_TEXT:C284(xml_Find_by_attribute ;$4)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=2;"Missing parameter"))
	
	  //Required parameters
	$Dom_ref:=$1
	$Txt_xPath:=$2
	
	  //Optional parameters
	Case of 
			
			  //……………………………………………………………
		: ($Lon_parameters>=4)
			
			$Txt_soughtAttribute:=$3
			$Txt_soughtValue:=$4
			
			  //……………………………………………………………
		: ($Lon_parameters>2)
			
			$Txt_soughtValue:=$3
			
			  //……………………………………………………………
		Else 
			
			ASSERT:C1129(False:C215;"Missing parameter")
			
			  //……………………………………………………………
	End case 
	
	If (Match regex:C1019("(?mi-s)^(.*)/@(.*)$";$Txt_xPath;1;$tLon_positions;$tLon_lengths))
		
		$Txt_soughtAttribute:=Substring:C12($Txt_xPath;$tLon_positions{2};$tLon_lengths{2})
		$Txt_xPath:=Substring:C12($Txt_xPath;$tLon_positions{1};$tLon_lengths{1})
		
	Else 
		
		$Txt_soughtAttribute:=$Txt_xPath
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If (Asserted:C1132(Match regex:C1019("(?mi-s)^(?!^0*$)(?:[0-9A-F]{16}){1,2}$";$Dom_ref;1)))  //xml_IsValidReference
	
	ARRAY TEXT:C222($tDom_references;0x0000)
	$tDom_references{0}:=DOM Find XML element:C864($Dom_ref;$Txt_xPath;$tDom_references)
	
	If (OK=1)
		
		For ($Lon_i;1;Size of array:C274($tDom_references);1)
			
			For ($Lon_j;1;DOM Count XML attributes:C727($tDom_references{$Lon_i});1)
				
				DOM GET XML ATTRIBUTE BY INDEX:C729($tDom_references{$Lon_i};$Lon_j;$Txt_attributeName;$Txt_attributeValue)
				
				If (OK=1)
					
					If ($Txt_attributeName=$Txt_soughtAttribute)
						
						$Lon_j:=MAXLONG:K35:2-1  //Go out
						
					End if 
				End if 
			End for 
			
			If ($Lon_j=MAXLONG:K35:2) & ($Txt_attributeValue=$Txt_soughtValue)
				
				$Dom_foundReference:=$tDom_references{$Lon_i}
				$Lon_i:=MAXLONG:K35:2-1  //Go out
				
			End if 
		End for 
	End if 
End if 

  // ----------------------------------------------------
  // Return
$0:=$Dom_foundReference

  // ----------------------------------------------------
  // End