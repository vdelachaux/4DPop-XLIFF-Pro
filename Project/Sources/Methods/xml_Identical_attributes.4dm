//%attributes  = {"invisible":true}
  // ----------------------------------------------------
  // Project method : xml_Identical_attributes
  // Database: 4DPop XLIFF Pro
  // ID[25AD8765ED1A4DD98B47687AB6427591]
  // Created #4-1-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_BOOLEAN:C305($0)
C_TEXT:C284($1)
C_TEXT:C284($2)
C_TEXT:C284($3)
C_TEXT:C284(${4})

C_BOOLEAN:C305($Boo_identical)
C_LONGINT:C283($Lon_i;$Lon_parameters;$Lon_x;$Lon_y)
C_TEXT:C284($Dom_source;$Dom_target;$Txt_mandatory;$Txt_name;$Txt_value)

ARRAY TEXT:C222($tTxt_srcKeys;0)
ARRAY TEXT:C222($tTxt_srcValues;0)
ARRAY TEXT:C222($tTxt_tgtKeys;0)
ARRAY TEXT:C222($tTxt_tgtValues;0)

If (False:C215)
	C_BOOLEAN:C305(xml_Identical_attributes ;$0)
	C_TEXT:C284(xml_Identical_attributes ;$1)
	C_TEXT:C284(xml_Identical_attributes ;$2)
	C_TEXT:C284(xml_Identical_attributes ;$3)
	C_TEXT:C284(xml_Identical_attributes ;${4})
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=2;"Missing parameter"))
	
	  //Required parameters
	$Dom_source:=$1
	$Dom_target:=$2
	
	  //Optional parameters
	If ($Lon_parameters>=3)
		
		$Txt_mandatory:=$3
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
  //get source attributes
For ($Lon_i;1;DOM Count XML attributes:C727($Dom_source);1)
	
	DOM GET XML ATTRIBUTE BY INDEX:C729($Dom_source;$Lon_i;$Txt_name;$Txt_value)
	
	APPEND TO ARRAY:C911($tTxt_srcKeys;$Txt_name)
	APPEND TO ARRAY:C911($tTxt_srcValues;$Txt_value)
	
End for 

  //get target attributes
For ($Lon_i;1;DOM Count XML attributes:C727($Dom_target);1)
	
	DOM GET XML ATTRIBUTE BY INDEX:C729($Dom_target;$Lon_i;$Txt_name;$Txt_value)
	
	APPEND TO ARRAY:C911($tTxt_tgtKeys;$Txt_name)
	APPEND TO ARRAY:C911($tTxt_tgtValues;$Txt_value)
	
End for 

If (Size of array:C274($tTxt_tgtKeys)=Size of array:C274($tTxt_srcKeys))
	
	  //Compare attributes one by one
	$Boo_identical:=True:C214
	
	SORT ARRAY:C229($tTxt_srcKeys;$tTxt_srcValues)
	SORT ARRAY:C229($tTxt_tgtKeys;$tTxt_tgtValues)
	
	For ($Lon_i;1;Size of array:C274($tTxt_srcKeys);1)
		
		If ($tTxt_srcKeys{$Lon_i}#$tTxt_tgtKeys{$Lon_i})\
			 | ($tTxt_srcValues{$Lon_i}#$tTxt_tgtValues{$Lon_i})
			
			$Boo_identical:=False:C215
			$Lon_i:=MAXLONG:K35:2-1  //Go out
			
		End if 
	End for 
End if 

If (Not:C34($Boo_identical))\
 & ($Lon_parameters>=3)
	
	  //Find the minimum required
	$Boo_identical:=True:C214
	
	For ($Lon_i;3;$Lon_parameters;1)
		
		$Lon_x:=Find in array:C230($tTxt_srcKeys;${$Lon_i})
		
		If ($Lon_x>0)
			
			$Lon_y:=Find in array:C230($tTxt_tgtKeys;${$Lon_i})
			
			If ($Lon_y>0)
				
				$Boo_identical:=$Boo_identical & ($tTxt_srcValues{$Lon_x}=$tTxt_tgtValues{$Lon_y})
				
			End if 
		End if 
		
		If (Not:C34($Boo_identical))
			
			$Lon_i:=MAXLONG:K35:2-1  //Go out
			
		End if 
	End for 
End if 

  // ----------------------------------------------------
  // Return
$0:=$Boo_identical

  // ----------------------------------------------------
  // End 