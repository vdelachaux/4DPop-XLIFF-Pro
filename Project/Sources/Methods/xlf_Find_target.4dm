//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : xlf_Find_target
  // Database: 4DPop XLIFF Pro
  // ID[3D7AA5FE0C3343588F1FFE83F5BB3EE3]
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
C_LONGINT:C283($Lon_found;$Lon_group;$Lon_parameters;$Lon_unit)
C_TEXT:C284($Dom_root;$Dom_target;$Txt_id;$Txt_resname)
C_OBJECT:C1216($Obj_attributes)

ARRAY TEXT:C222($tDom_group;0)
ARRAY TEXT:C222($tDom_unit;0)

If (False:C215)
	C_TEXT:C284(xlf_Find_target ;$0)
	C_TEXT:C284(xlf_Find_target ;$1)
	C_TEXT:C284(xlf_Find_target ;$2)
	C_TEXT:C284(xlf_Find_target ;$3)
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
		
		  // Get attributes
		$Obj_attributes:=xml_attributes ($tDom_unit{$Lon_unit})
		
		If (Asserted:C1132($Obj_attributes.resname#Null:C1517;"No resname"))
			
			If ($Boo_withID)
				
				If (Length:C16(String:C10($Obj_attributes.id))>0)
					
					If ($Obj_attributes.resname=$Txt_resname)\
						 & ($Obj_attributes.id=$Txt_id)
						
						  // Go out
						$Lon_found:=$Lon_unit
						$Lon_unit:=MAXLONG:K35:2-1
						$Lon_group:=MAXLONG:K35:2-1
						
					End if 
				End if 
				
			Else 
				
				If ($Obj_attributes.resname=$Txt_resname)
					
					  // Go out
					$Lon_found:=$Lon_unit
					$Lon_unit:=MAXLONG:K35:2-1
					$Lon_group:=MAXLONG:K35:2-1
					
				End if 
			End if 
		End if 
	End for 
End for 

If ($Lon_found>0)
	
	$Dom_target:=DOM Find XML element:C864($tDom_unit{$Lon_found};"trans-unit/"\
		+Choose:C955(Bool:C1537(String:C10($Obj_attributes.translate)="no");"source";"target"))
	
	ASSERT:C1129(OK=1)
	
End if 

  // ----------------------------------------------------
  // Return
$0:=$Dom_target

  // ----------------------------------------------------
  // End