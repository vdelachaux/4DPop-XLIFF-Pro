//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Method : xml_COPY_ELEMENT
  // Created 08/09/08 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description
  //
  // ----------------------------------------------------
C_TEXT:C284($1)
C_TEXT:C284($2)

C_BOOLEAN:C305($Boo_OK;$Boo_stop)
C_LONGINT:C283($Lon_i)
C_TEXT:C284($Dom_node;$Dom_sourceRef;$Dom_target;$Dom_targetRef;$Txt_name;$Txt_nameBuffer)
C_TEXT:C284($Txt_value;$Txt_valueBuffer)

If (False:C215)
	C_TEXT:C284(xml_COPY_ELEMENT ;$1)
	C_TEXT:C284(xml_COPY_ELEMENT ;$2)
End if 

$Dom_sourceRef:=$1
$Dom_targetRef:=$2

If (Asserted:C1132(xml_IsValidReference ($Dom_sourceRef) & xml_IsValidReference ($Dom_targetRef);"bad reference"))
	
	$Dom_node:=DOM Get first child XML element:C723($Dom_sourceRef;$Txt_name;$Txt_value)
	
	If (OK=1)
		
		Repeat 
			
			$Dom_target:=DOM Create XML element:C865($Dom_targetRef;$Txt_name)
			$Boo_OK:=(OK=1)
			
			If ($Boo_OK)
				
				If (Length:C16($Txt_value)>0)
					
					DOM SET XML ELEMENT VALUE:C868($Dom_target;$Txt_value)
					$Boo_OK:=(OK=1)
					
				End if 
				
				If ($Boo_OK)
					
					For ($Lon_i;1;DOM Count XML attributes:C727($Dom_node);1)
						
						DOM GET XML ATTRIBUTE BY INDEX:C729($Dom_node;$Lon_i;$Txt_nameBuffer;$Txt_valueBuffer)
						$Boo_OK:=(OK=1)
						
						If ($Boo_OK)
							
							DOM SET XML ATTRIBUTE:C866($Dom_target;\
								$Txt_nameBuffer;$Txt_valueBuffer)
							
						Else 
							
							$Lon_i:=MAXLONG:K35:2-1  //Go out
							
						End if 
					End for 
				End if 
			End if 
			
			If ($Boo_OK)
				
				xml_COPY_ELEMENT ($Dom_node;$Dom_target)
				
			End if 
			
			If ($Boo_OK)
				
				$Dom_node:=DOM Get next sibling XML element:C724($Dom_node;$Txt_name;$Txt_value)
				
				$Boo_stop:=(OK=0)
				
				OK:=1
				
			End if 
		Until (Not:C34($Boo_OK))\
			 | ($Boo_stop)
		
	End if 
End if 