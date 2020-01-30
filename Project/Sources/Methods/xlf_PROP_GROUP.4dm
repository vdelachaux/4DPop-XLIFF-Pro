//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : xlf_PROP_GROUP
  // Database: 4DPop XLIFF Pro
  // ID[5FBFF15185094F70B316D2F5002ABDEA]
  // Created #15-12-2016 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($1)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Dom_editor;$Dom_root;$Dom_version;$kTxt_editor)

If (False:C215)
	C_TEXT:C284(xlf_PROP_GROUP ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Dom_root:=$1
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
	$kTxt_editor:="Xliff-Editor.4dbase"
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
$Dom_editor:=xml_Find_by_attribute ($Dom_root;"xliff/file/header/prop-group/@name";$kTxt_editor)

If (Not:C34(xml_IsValidReference ($Dom_editor)))
	
	  // Create
	$Dom_editor:=DOM Create XML element:C865($Dom_root;"xliff/file/header/prop-group";\
		"name";$kTxt_editor)
	
End if 

If (OK=1)
	
	$Dom_version:=xml_Find_by_attribute ($Dom_editor;"prop-group/prop/@prop-type";"version")
	
	If (Not:C34(xml_IsValidReference ($Dom_version)))
		
		  // Create
		$Dom_version:=DOM Create XML element:C865($Dom_editor;"prop";\
			"prop-type";"version")
		
	End if 
End if 

If (xml_IsValidReference ($Dom_version))
	
	DOM SET XML ELEMENT VALUE:C868($Dom_version;"2.0")
	
End if 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End 