//%attributes  = {"invisible":true}
  // ----------------------------------------------------
  // Method : env_Boo_Is_a_Component
  // Created 27/10/06 by vdl
  // ----------------------------------------------------
  // Description
  // Return true if the method is executed in a component
  // ----------------------------------------------------
C_BOOLEAN:C305($0)

If (False:C215)
	C_BOOLEAN:C305(env_Component ;$0)
End if 

$0:=(Structure file:C489#Structure file:C489(*))