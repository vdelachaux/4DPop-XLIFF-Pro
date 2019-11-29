//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : obj_Dynamic
  // Database: 4DPop XLIFF Pro
  // ID[18BF53C3C83347D68D2EDCA9743B1DDD]
  // Created #9-1-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Returns a pointer to a dynamic object from its name
  // ----------------------------------------------------
  // pointer := obj_Dynamic ( name {; subform})
  // -> name (Text) - object name
  // -> subform (Text) - optional - to reach an object into a subform
  // <- pointer (Pointer) - pointer to the object
  // ----------------------------------------------------
  // Declarations
C_POINTER:C301($0)
C_TEXT:C284($1)
C_TEXT:C284($2)

C_LONGINT:C283($Lon_parameters)
C_POINTER:C301($Ptr_pointer)
C_TEXT:C284($Txt_name;$Txt_subform)

If (False:C215)
	C_POINTER:C301(obj_Dynamic ;$0)
	C_TEXT:C284(obj_Dynamic ;$1)
	C_TEXT:C284(obj_Dynamic ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Txt_name:=$1  // Object name
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		$Txt_subform:=$2  // Optional - to reach an object into a subform
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If ($Lon_parameters>=2)
	
	  // In subform
	$Ptr_pointer:=OBJECT Get pointer:C1124(Object named:K67:5;$Txt_name;$Txt_subform)
	
Else 
	
	  // In main form
	$Ptr_pointer:=OBJECT Get pointer:C1124(Object named:K67:5;$Txt_name)
	
End if 

  // ----------------------------------------------------
  // Return
$0:=$Ptr_pointer  // Pointer to the object

  // ----------------------------------------------------
  // End