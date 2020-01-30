//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : xml_cleanup
  // Database: 4DPop XLIFF Pro
  // ID[B9F6339DB1FB4BCA86ABF3CEC4C5A2DD]
  // Created #23-6-2016 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($0)
C_TEXT:C284($1)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Dom_cleanRoot;$Dom_root;$Txt_buffer)

If (False:C215)
	C_TEXT:C284(xml_cleanup ;$0)
	C_TEXT:C284(xml_cleanup ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  //Required parameters
	$Dom_root:=$1
	
	  //Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
DOM EXPORT TO VAR:C863($Dom_root;$Txt_buffer)

If (Asserted:C1132(OK=1))
	
	$Dom_root:=DOM Parse XML variable:C720($Txt_buffer)
	
	XML SET OPTIONS:C1090($Dom_root;XML indentation:K45:34;XML with indentation:K45:35)
	
	If (Asserted:C1132(OK=1))
		
		$Dom_cleanRoot:=$Dom_root
		
	End if 
End if 

  // ----------------------------------------------------
  // Return
$0:=$Dom_cleanRoot

  // ----------------------------------------------------
  // End 