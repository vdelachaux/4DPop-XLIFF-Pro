//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : xlf_New_unit
  // Database: 4DPop XLIFF Pro
  // ID[AED1DFAB108840979576EA24F04551BE]
  // Created #13-12-2016 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Dom_source;$Dom_target;$Dom_unit)
C_OBJECT:C1216($Obj_param;$Obj_unit)

If (False:C215)
	C_OBJECT:C1216(xlf_New_unit ;$0)
	C_OBJECT:C1216(xlf_New_unit ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Obj_param:=$1
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		  // <NONE>
		
	End if 
	
	If (Asserted:C1132(OB Is defined:C1231($Obj_param)))
		
		  // Mandatory values
		ASSERT:C1129(Length:C16(String:C10($Obj_param.group))>0)
		ASSERT:C1129(Length:C16(String:C10($Obj_param.id))>0)
		ASSERT:C1129(Length:C16(String:C10($Obj_param.resname))>0)
		
	Else 
		
		TRACE:C157
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
  // Create the unit element
$Dom_unit:=DOM Create XML element:C865($Obj_param.group;"trans-unit";\
"id";$Obj_param.id;\
"resname";$Obj_param.resname)

  // Create the source…
$Dom_source:=DOM Create XML element:C865($Dom_unit;"source")
DOM SET XML ELEMENT VALUE:C868($Dom_source;String:C10($Obj_param.source))

If (Bool:C1537($Obj_param.noTranslate))
	
	DOM SET XML ATTRIBUTE:C866($Dom_unit;\
		"translate";"no")
	
Else 
	
	  //…& the target elements
	$Dom_target:=DOM Create XML element:C865($Dom_unit;"target")
	
	If (Length:C16(String:C10($Obj_param.target))>0)
		
		DOM SET XML ELEMENT VALUE:C868($Dom_target;$Obj_param.target)
		
	End if 
	
	If (Not:C34(Bool:C1537($Obj_param.master)))
		
		DOM SET XML ATTRIBUTE:C866($Dom_target;\
			"state";"needs-translation")
		
	End if 
End if 

$Obj_unit:=New object:C1471(\
"$dom";$Dom_unit;\
"id";$Obj_param.id;\
"noTranslate";Bool:C1537($Obj_param.noTranslate);\
"resname";$Obj_param.resname;\
"source";New object:C1471(\
"$dom";$Dom_source;\
"value";$Obj_param.source))

  // ----------------------------------------------------
  // Return
$0:=$Obj_unit

  // ----------------------------------------------------
  // End 