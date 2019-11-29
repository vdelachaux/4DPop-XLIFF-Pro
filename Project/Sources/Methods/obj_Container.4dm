//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : obj_Container
  // Database: 4DPop XLIFF Pro
  // ID[A245B0AFFEBF4972A902EA85B3E1DD68]
  // Created #13-1-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Returns a pointer to the container object
  // ----------------------------------------------------
  // container := obj_Container
  // <- container (Pointer)
  // ----------------------------------------------------
  // Declarations
C_POINTER:C301($0)

C_LONGINT:C283($Lon_parameters)
C_POINTER:C301($Ptr_container)

If (False:C215)
	C_POINTER:C301(obj_Container ;$0)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  //NO PARAMETERS REQUIRED
	
	  //Optional parameters
	If ($Lon_parameters>=1)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------

$Ptr_container:=OBJECT Get pointer:C1124(Object subform container:K67:4)

  // ----------------------------------------------------
  // Return
$0:=$Ptr_container

  // ----------------------------------------------------
  // End