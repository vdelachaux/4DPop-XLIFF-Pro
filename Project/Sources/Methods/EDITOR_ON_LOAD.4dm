//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : EDITOR_ON_LOAD
  // Database: 4DPop XLIFF Pro
  // ID[CFCA83093FDA43DBB8BD89E69ABA02AC]
  // Created #12-10-2015 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Initialization of the dialog
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($Lon_page;$Lon_parameters)

ARRAY TEXT:C222($tTxt_tabOrder;0)

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  //NO PARAMETERS REQUIRED
	
	  //Optional parameters
	If ($Lon_parameters>=1)
		
		  // <NONE>
		
	End if 
	
	  //ASSERT(4D_LOG (Current method name))
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
$Lon_page:=FORM Get current page:C276(*)

  //Set tab order

Case of 
		  //______________________________________________________
	: ($Lon_page=1)
		
		APPEND TO ARRAY:C911($tTxt_tabOrder;Form:C1466.widgets.files)
		APPEND TO ARRAY:C911($tTxt_tabOrder;Form:C1466.widgets.strings)
		APPEND TO ARRAY:C911($tTxt_tabOrder;Form:C1466.widgets.localizations)
		
		  //______________________________________________________
	: ($Lon_page=2)
		
		APPEND TO ARRAY:C911($tTxt_tabOrder;"welcome")
		
		  //______________________________________________________
	Else 
		
		  //______________________________________________________
End case 

FORM SET ENTRY ORDER:C1468($tTxt_tabOrder)

If (Is Windows:C1573)
	
	OBJECT SET SHORTCUT:C1185(*;"_close";Shortcut with F4:K75:4;Option key mask:K16:7)
	
End if 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End 