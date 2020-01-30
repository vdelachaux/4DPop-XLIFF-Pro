//%attributes  = {"invisible":true}
  // ----------------------------------------------------
  // Project method : xlf_Dom_group_from_resname
  // Database: 4DPop XLIFF Pro
  // ID[1ACCB255917A4F2D93C3EEEA8D280AEB]
  // Created #26-10-2015 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // In the XML tree referenced by $1, returns the reference of the "group" element
  // whose resname is $2
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($0)
C_TEXT:C284($1)
C_TEXT:C284($2)

C_LONGINT:C283($Lon_group;$Lon_parameters;$Lon_x)
C_TEXT:C284($Dom_ref;$Dom_root;$Txt_resname)

ARRAY TEXT:C222($tDom_group;0)
ARRAY TEXT:C222($tTxt_keys;0)
ARRAY TEXT:C222($tTxt_values;0)

If (False:C215)
	C_TEXT:C284(xlf_Dom_group_from_resname ;$0)
	C_TEXT:C284(xlf_Dom_group_from_resname ;$1)
	C_TEXT:C284(xlf_Dom_group_from_resname ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=2;"Missing parameter"))
	
	  //Required parameters
	$Dom_root:=$1
	$Txt_resname:=$2
	
	  //Optional parameters
	If ($Lon_parameters>=3)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
$tDom_group{0}:=DOM Find XML element:C864($Dom_root;"xliff/file/body/group";$tDom_group)

For ($Lon_group;1;Size of array:C274($tDom_group);1)
	
	xml_GET_ATTRIBUTE_ARRAYS ($tDom_group{$Lon_group};->$tTxt_keys;->$tTxt_values)
	
	$Lon_x:=Find in array:C230($tTxt_keys;"resname")
	
	If ($Lon_x>0)
		
		If ($tTxt_values{$Lon_x}=$Txt_resname)
			
			  //Go out
			$Dom_ref:=$tDom_group{$Lon_group}
			$Lon_group:=MAXLONG:K35:2-1
			
		End if 
	End if 
End for 

  // ----------------------------------------------------
  // Return
$0:=$Dom_ref

  // ----------------------------------------------------
  // End 