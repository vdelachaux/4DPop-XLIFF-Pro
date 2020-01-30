//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : FILE_SYNCHRONIZE
  // Database: 4DPop XLIFF Pro
  // ID[2D6C1919543C421D8FEFF8232A549EF6]
  // Created #4-1-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Synchonize (append missing nodes & atributes) two XLIFF files
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($1)
C_TEXT:C284($2)

C_BOOLEAN:C305($Boo_newGroup;$Boo_newUnit;$Boo_OK)
C_LONGINT:C283($Lon_group;$Lon_i;$Lon_parameters;$Lon_unit)
C_TEXT:C284($Dom_;$Dom_src;$Dom_srcGroup;$Dom_srcRoot;$Dom_srcUnit;$Dom_tgt)
C_TEXT:C284($Dom_tgtGroup;$Dom_tgtRoot;$Dom_tgtUnit;$File_source;$File_target;$Txt_attribute)
C_TEXT:C284($Txt_value)
C_OBJECT:C1216($Obj_srcGroupAttributes;$Obj_srcUnitAttributes;$Obj_tgtGroupAttributes;$Obj_tgtUnitAttributes)

ARRAY TEXT:C222($tDom_;0)
ARRAY TEXT:C222($tDom_srcGroups;0)
ARRAY TEXT:C222($tDom_srcUnits;0)
ARRAY TEXT:C222($tDom_tgtGroups;0)
ARRAY TEXT:C222($tDom_tgtUnits;0)

If (False:C215)
	C_TEXT:C284(FILE_SYNCHRONIZE ;$1)
	C_TEXT:C284(FILE_SYNCHRONIZE ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=2;"Missing parameter"))
	
	  // Required parameters
	$File_source:=$1  // Pathname
	$File_target:=$2  // Pathname
	
	  // Optional parameters
	If ($Lon_parameters>=3)
		
		  // <NONE>
		
	End if 
	
	$Boo_OK:=Asserted:C1132(Test path name:C476($File_source)=Is a document:K24:1)\
		 & Asserted:C1132(Test path name:C476($File_target)=Is a document:K24:1)
	
	If ($Boo_OK)
		
		$Dom_srcRoot:=DOM Parse XML source:C719($File_source)
		
		$Boo_OK:=Asserted:C1132(OK=1)
		
		If ($Boo_OK)
			
			$Dom_tgtRoot:=DOM Parse XML source:C719($File_target)
			
			$Boo_OK:=Asserted:C1132(OK=1)
			
		End if 
	End if 
	
	If (Not:C34(Asserted:C1132($Boo_OK)))
		
		ABORT:C156
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
  // Check groups
$Dom_srcGroup:=DOM Find XML element:C864($Dom_srcRoot;"/xliff/file/body/group";$tDom_srcGroups)
$Dom_tgtGroup:=DOM Find XML element:C864($Dom_tgtRoot;"/xliff/file/body/group";$tDom_tgtGroups)

For ($Lon_group;1;Size of array:C274($tDom_srcGroups);1)
	
	$Dom_srcGroup:=$tDom_srcGroups{$Lon_group}
	
	  // Get source group attributes
	$Obj_srcGroupAttributes:=xml_attributes ($Dom_srcGroup)
	
	  // Find the same <group> by resname in the target.
	For ($Lon_i;1;Size of array:C274($tDom_tgtGroups);1)
		
		  // Get target group attributes
		$Obj_tgtGroupAttributes:=xml_attributes ($tDom_tgtGroups{$Lon_i})
		
		If (String:C10($Obj_srcGroupAttributes.resname)=String:C10($Obj_tgtGroupAttributes.resname))
			
			  // Keep the reference of the group
			$Dom_tgtGroup:=$tDom_tgtGroups{$Lon_i}
			
			  // Remove found group from the target array (optimization for the next searches)
			DELETE FROM ARRAY:C228($tDom_tgtGroups;$Lon_i;1)
			
			  // Go out
			$Lon_i:=MAXLONG:K35:2-1
			
		End if 
	End for 
	
	$Boo_newGroup:=($Lon_i#MAXLONG:K35:2)
	
	If ($Boo_newGroup)
		
		  // Create
		$Dom_:=DOM Find XML element:C864($Dom_tgtRoot;"/xliff/file/body")
		
		If (OK=1)
			
			  // Copy the source <group>
			$Dom_tgtGroup:=DOM Append XML element:C1082($Dom_;$Dom_srcGroup)
			
			  // Set status for all <target>
			$tDom_{0}:=DOM Find XML element:C864($Dom_tgtGroup;"/group/trans-unit";$tDom_)
			
			For ($Lon_i;1;Size of array:C274($tDom_);1)
				
				$Dom_:=DOM Find XML element:C864($tDom_{$Lon_i};"/trans-unit/target")
				
				If (OK=1)
					
					DOM SET XML ATTRIBUTE:C866($Dom_;\
						"state";"needs-translation")
					
				End if 
			End for 
			
			CLEAR VARIABLE:C89($tDom_)
			
		End if 
		
	Else 
		
		  // Synchonize attributes
		For each ($Txt_attribute;$Obj_srcGroupAttributes)
			
			DOM SET XML ATTRIBUTE:C866($Dom_tgtGroup;\
				$Txt_attribute;$Obj_srcGroupAttributes[$Txt_attribute])
			
		End for each 
		
		  // Check trans-units
		  // Warning if no trans-unit (empty group) the arrays are NOT cleared
		CLEAR VARIABLE:C89($tDom_srcUnits)
		CLEAR VARIABLE:C89($tDom_tgtUnits)
		
		$Dom_srcUnit:=DOM Find XML element:C864($Dom_srcGroup;"/group/trans-unit";$tDom_srcUnits)
		$Dom_tgtUnit:=DOM Find XML element:C864($Dom_tgtGroup;"/group/trans-unit";$tDom_tgtUnits)
		
		For ($Lon_unit;1;Size of array:C274($tDom_srcUnits);1)
			
			$Dom_srcUnit:=$tDom_srcUnits{$Lon_unit}
			
			$Obj_srcUnitAttributes:=xml_attributes ($Dom_srcUnit)
			
			  // Find the same <trans-unit> in the target.
			For ($Lon_i;1;Size of array:C274($tDom_tgtUnits);1)
				
				$Obj_tgtUnitAttributes:=xml_attributes ($tDom_tgtUnits{$Lon_i})
				
				If (String:C10($Obj_srcUnitAttributes.resname)=String:C10($Obj_tgtUnitAttributes.resname))\
					 & (String:C10($Obj_srcUnitAttributes.id)=String:C10($Obj_tgtUnitAttributes.id))
					
					  // Keep the reference of the trans-unit
					$Dom_tgtUnit:=$tDom_tgtUnits{$Lon_i}
					
					  // Remove found unit from the target array (optimization for the next searches)
					DELETE FROM ARRAY:C228($tDom_tgtUnits;$Lon_i;1)
					
					  // Go out
					$Lon_i:=MAXLONG:K35:2-1
					
				End if 
			End for 
			
			$Boo_newUnit:=($Lon_i#MAXLONG:K35:2)
			
			If ($Boo_newUnit)
				
				  // Copy the source
				$Dom_tgtUnit:=DOM Append XML element:C1082($Dom_tgtGroup;$Dom_srcUnit)
				
				If (Asserted:C1132(OK=1))
					
					  // Set the status for the <target>
					$Dom_tgt:=DOM Find XML element:C864($Dom_tgtUnit;"/trans-unit/target")
					
					If (OK=1)  // Could be 0 if no translation
						
						DOM SET XML ATTRIBUTE:C866($Dom_tgt;\
							"state";"needs-translation")
						
					End if 
				End if 
				
			Else 
				
				  // Synchonize attributes
				For each ($Txt_attribute;$Obj_srcUnitAttributes)
					
					DOM SET XML ATTRIBUTE:C866($Dom_tgtUnit;\
						$Txt_attribute;$Obj_srcUnitAttributes[$Txt_attribute])
					
				End for each 
				
				  // One <source> element, followed by…
				$Dom_src:=DOM Find XML element:C864($Dom_srcUnit;"/trans-unit/source")
				
				If (Asserted:C1132(OK=1))
					
					DOM GET XML ELEMENT VALUE:C731($Dom_src;$Txt_value)
					
					$Dom_tgt:=DOM Find XML element:C864($Dom_tgtUnit;"/trans-unit/source")
					
					If (OK=0)
						
						$Dom_tgt:=DOM Create XML element:C865($Dom_tgtUnit;"source")
						
					End if 
					
					If (Asserted:C1132(OK=1))
						
						  // Synchronize <source> values
						DOM SET XML ELEMENT VALUE:C868($Dom_tgt;$Txt_value)
						
					End if 
					
					  //…Zero or one <target> element, followed by…
					$Dom_src:=DOM Find XML element:C864($Dom_srcUnit;"/trans-unit/target")
					
					If (OK=1)
						
						$Dom_tgt:=DOM Find XML element:C864($Dom_tgtUnit;"/trans-unit/target")
						
						If (OK=0)
							
							$Dom_tgt:=DOM Create XML element:C865($Dom_tgtUnit;"target")
							
							If (Asserted:C1132(OK=1))
								
								  // Set <target> with the reference value
								DOM SET XML ELEMENT VALUE:C868($Dom_tgt;$Txt_value)
								
								  // Set the status for the <target>
								DOM SET XML ATTRIBUTE:C866($Dom_tgt;\
									"state";"needs-translation")
								
							End if 
						End if 
					End if 
					
					  //…Zero or one <note> element
					$Dom_src:=DOM Find XML element:C864($Dom_srcUnit;"/trans-unit/note")
					
					If (OK=1)  // Could be 0 if no note
						
						DOM GET XML ELEMENT VALUE:C731($Dom_src;$Txt_value)
						
						$Dom_tgt:=DOM Find XML element:C864($Dom_tgtUnit;"/trans-unit/note")
						
						If (OK=0)
							
							$Dom_tgt:=DOM Create XML element:C865($Dom_tgtUnit;"note")
							
						End if 
						
						If (Asserted:C1132(OK=1))
							
							  // Synchonize <note> values
							DOM SET XML ELEMENT VALUE:C868($Dom_tgt;$Txt_value)
							
						End if 
					End if 
				End if 
			End if 
			  //}
			
		End for 
	End if 
	  //}
	
End for 

xml_CLOSE ($Dom_srcRoot)

Form:C1466.save($Dom_tgtRoot;$File_target)
xml_CLOSE ($Dom_tgtRoot)

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End 