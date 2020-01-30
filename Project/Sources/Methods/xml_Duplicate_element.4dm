//%attributes  = {"invisible":true}
  // ----------------------------------------------------
  // Method : xml_DUPLICATE_ELEMENT
  // Created 05/09/08 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description
  //
  // ----------------------------------------------------
C_TEXT:C284($0)
C_TEXT:C284($1)
C_TEXT:C284($2)

C_BLOB:C604($Blb_xml)
C_LONGINT:C283($Lon_i)
C_TEXT:C284($Dom_source;$Dom_sourceRef;$Dom_target;$Dom_targetRef;$Txt_name;$Txt_nameBuffer)
C_TEXT:C284($Txt_valueBuffer)

If (False:C215)
	C_TEXT:C284(xml_Duplicate_element ;$0)
	C_TEXT:C284(xml_Duplicate_element ;$1)
	C_TEXT:C284(xml_Duplicate_element ;$2)
End if 

$Dom_sourceRef:=$1
$Dom_targetRef:=$2

If (Asserted:C1132(xml_IsValidReference ($Dom_sourceRef) & xml_IsValidReference ($Dom_targetRef);Get localized string:C991("error_badReference")))
	
	DOM EXPORT TO VAR:C863($Dom_sourceRef;$Blb_xml)
	
	If (OK=1)
		
		$Dom_source:=DOM Parse XML variable:C720($Blb_xml;False:C215)
		
		If (OK=1)
			
			DOM GET XML ELEMENT NAME:C730($Dom_source;$Txt_name)
			
			If (OK=1)
				
				$Dom_target:=DOM Create XML element:C865($Dom_targetRef;$Txt_name)
				
				If (OK=1)
					
					For ($Lon_i;1;DOM Count XML attributes:C727($Dom_source);1)
						
						DOM GET XML ATTRIBUTE BY INDEX:C729($Dom_source;$Lon_i;$Txt_nameBuffer;$Txt_valueBuffer)
						
						If (OK=1)
							
							DOM SET XML ATTRIBUTE:C866($Dom_target;\
								$Txt_nameBuffer;$Txt_valueBuffer)
							
						Else 
							
							$Lon_i:=MAXLONG:K35:2-1  //Go out
							
						End if 
					End for 
				End if 
			End if 
		End if 
	End if 
	
	If (OK=1)
		
		$0:=$Dom_target
		
		xml_COPY_ELEMENT ($Dom_source;$Dom_target)
		
	End if 
End if 