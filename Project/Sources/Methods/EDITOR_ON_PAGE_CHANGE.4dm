//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : EDITOR_ON_PAGE_CHANGE
  // Database: 4DPop XLIFF Pro
  // ID[2F2EDE8D80DA404D8C4C54FEECA4C1D7]
  // Created #13-10-2015 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($1)

C_LONGINT:C283($Lon_column;$Lon_page;$Lon_parameters;$Lon_row)
C_TEXT:C284($Txt_file)

ARRAY TEXT:C222($tTxt_tabOrder;0)

If (False:C215)
	C_LONGINT:C283(EDITOR_ON_PAGE_CHANGE ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // NO PARAMETERS REQUIRED
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		$Lon_page:=$1
		
	Else 
		
		$Lon_page:=FORM Get current page:C276(*)
		
	End if 
	
	  //ASSERT(4D_LOG (Current method name))
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //……………………………………………………………………………………
	: ($Lon_page=1)  // File
		
		LISTBOX GET CELL POSITION:C971(*;Form:C1466.widgets.files;$Lon_column;$Lon_row)
		
		If ($Lon_row=0)
			
			$Txt_file:=EDITOR_Preferences (New object:C1471("key";"file")).value
			
			If (Length:C16($Txt_file)>0)
				
				$Lon_row:=Find in array:C230(Form:C1466.dynamic("file")->;$Txt_file)
				
			End if 
			
			If ($Lon_row>0)
				
				LISTBOX SELECT ROW:C912(*;Form:C1466.widgets.files;$Lon_row)
				
				Form:C1466.parse($Lon_row)
				
			Else 
				
				LISTBOX SELECT ROW:C912(*;Form:C1466.widgets.files;$Lon_row;lk remove from selection:K53:3)
				
			End if 
		End if 
		
		APPEND TO ARRAY:C911($tTxt_tabOrder;Form:C1466.widgets.files)
		APPEND TO ARRAY:C911($tTxt_tabOrder;Form:C1466.widgets.strings)
		APPEND TO ARRAY:C911($tTxt_tabOrder;Form:C1466.widgets.localizations)
		
		  //……………………………………………………………………………………
	: ($Lon_page=2)  // Welcome
		
		APPEND TO ARRAY:C911($tTxt_tabOrder;"welcome")
		
		(OBJECT Get pointer:C1124(Object named:K67:5;"welcome"))->:=Form:C1466
		
		  //……………………………………………………………………………………
End case 

  // Set tab order
If (Num:C11(Application version:C493)>=1630)
	
	FORM SET ENTRY ORDER:C1468($tTxt_tabOrder)
	
End if 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End 