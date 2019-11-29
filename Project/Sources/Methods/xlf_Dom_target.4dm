//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : xlf_Dom_target
  // Database: 4DPop XLIFF Pro
  // ID[ECD219761CA54FCBB4481C50F6C39F6A]
  // Created #23-6-2016 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // From a reference into the trans-unit, returns the reference of the "target" element
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($0)
C_TEXT:C284($1)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Dom_nodeRef;$Dom_targetRef;$Dom_unit;$Txt_name)

If (False:C215)
	C_TEXT:C284(xlf_Dom_target ;$0)
	C_TEXT:C284(xlf_Dom_target ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  //Required parameters
	$Dom_nodeRef:=$1
	
	  //Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
DOM GET XML ELEMENT NAME:C730($Dom_nodeRef;$Txt_name)

Case of 
		
		  //______________________________________________________
	: ($Txt_name="target")
		
		$Dom_targetRef:=$Dom_nodeRef
		
		  //______________________________________________________
	: ($Txt_name="trans-unit")
		
		$Dom_nodeRef:=DOM Find XML element:C864($Dom_nodeRef;"trans-unit/target")
		
		If (Asserted:C1132(OK=1))
			
			$Dom_targetRef:=$Dom_nodeRef
			
		End if 
		
		  //______________________________________________________
	: ($Txt_name="source")\
		 | ($Txt_name="note")
		
		$Dom_unit:=xml_Parent ($Dom_nodeRef;"trans-unit")
		
		If (Asserted:C1132(Length:C16($Dom_unit)>0))
			
			$Dom_nodeRef:=DOM Find XML element:C864($Dom_unit;"trans-unit/target")
			
			If (Asserted:C1132(OK=1))
				
				$Dom_targetRef:=$Dom_nodeRef
				
			End if 
		End if 
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Unknown entry point: \""+$Txt_name+"\"")
		
		  //______________________________________________________
End case 

  // ----------------------------------------------------
  // Return
$0:=$Dom_targetRef

  // ----------------------------------------------------
  // End