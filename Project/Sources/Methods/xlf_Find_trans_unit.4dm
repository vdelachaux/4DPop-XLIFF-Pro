//%attributes  = {"invisible":true}
  // ----------------------------------------------------
  // Project method : xlf_Find_trans_unit
  // Database: 4DPop XLIFF Pro
  // ID[30E2A479C56741DAA3A3B0FDF9E3E8CB]
  // Created #26-10-2015 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // In the XML tree referenced by $1, returns the reference of the "target" element
  // of the "trans-unit" whose resname is $2
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($0)
C_TEXT:C284($1)
C_TEXT:C284($2)
C_TEXT:C284($3)

C_BOOLEAN:C305($Boo_withID)
C_LONGINT:C283($Lon_attributes;$Lon_group;$Lon_i;$Lon_id;$Lon_parameters;$Lon_resname)
C_LONGINT:C283($Lon_unit)
C_TEXT:C284($Dom_ref;$Dom_root;$Txt_id;$Txt_resname)

ARRAY TEXT:C222($tDom_group;0)
ARRAY TEXT:C222($tDom_unit;0)

If (False:C215)
	C_TEXT:C284(xlf_Find_trans_unit ;$0)
	C_TEXT:C284(xlf_Find_trans_unit ;$1)
	C_TEXT:C284(xlf_Find_trans_unit ;$2)
	C_TEXT:C284(xlf_Find_trans_unit ;$3)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=2;"Missing parameter"))
	
	  // Required parameters
	$Dom_root:=$1
	$Txt_resname:=$2
	
	  // Optional parameters
	If ($Lon_parameters>=3)
		
		$Txt_id:=$3  // If omitted, search is made only with the resname
		
	End if 
	
	$Boo_withID:=($Lon_parameters>=3)
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
$tDom_group{0}:=DOM Find XML element:C864($Dom_root;"xliff/file/body/group";$tDom_group)

For ($Lon_group;1;Size of array:C274($tDom_group);1)
	
	$tDom_unit{0}:=DOM Find XML element:C864($tDom_group{$Lon_group};"group/trans-unit";$tDom_unit)
	
	For ($Lon_unit;1;Size of array:C274($tDom_unit);1)
		
		  // Get attributes {
		$Lon_attributes:=DOM Count XML attributes:C727($tDom_unit{$Lon_unit})
		ARRAY TEXT:C222($tTxt_keys;$Lon_attributes)
		ARRAY TEXT:C222($tTxt_values;$Lon_attributes)
		
		For ($Lon_i;1;$Lon_attributes;1)
			
			DOM GET XML ATTRIBUTE BY INDEX:C729($tDom_unit{$Lon_unit};$Lon_i;$tTxt_keys{$Lon_i};$tTxt_values{$Lon_i})
			
		End for 
		  //}
		
		$Lon_resname:=Find in array:C230($tTxt_keys;"resname")
		
		If ($Lon_resname>0)
			
			If ($Boo_withID)
				
				$Lon_id:=Find in array:C230($tTxt_keys;"id")
				
				If ($Lon_id>0)
					
					If ($tTxt_values{$Lon_resname}=$Txt_resname)\
						 & ($tTxt_values{$Lon_id}=$Txt_id)
						
						  // Go out
						$Dom_ref:=$tDom_unit{$Lon_unit}
						$Lon_unit:=MAXLONG:K35:2-1
						$Lon_group:=MAXLONG:K35:2-1
						
					End if 
				End if 
				
			Else 
				
				If ($tTxt_values{$Lon_resname}=$Txt_resname)
					
					  // Go out
					$Dom_ref:=$tDom_unit{$Lon_unit}
					$Lon_unit:=MAXLONG:K35:2-1
					$Lon_group:=MAXLONG:K35:2-1
					
				End if 
			End if 
		End if 
	End for 
End for 

  // ----------------------------------------------------
  // Return
$0:=$Dom_ref

  // ----------------------------------------------------
  // End 