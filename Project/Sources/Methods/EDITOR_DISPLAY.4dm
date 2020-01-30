//%attributes  = {"invisible":true}
  // ----------------------------------------------------
  // Project method : EDITOR_DISPLAY
  // Database: 4DPop XLIFF Pro
  // ID[66CB1E1BB6024134B0BFBD82C07CB3EF]
  // Created #23-6-2016 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($Lon_column;$Lon_parameters;$Lon_row)
C_OBJECT:C1216($Obj_content)

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // NO PARAMETERS REQUIRED
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
LISTBOX GET CELL POSITION:C971(*;Form:C1466.widgets.strings;$Lon_column;$Lon_row)

If ($Lon_row=0)
	
	  // No selection
	OBJECT SET VISIBLE:C603(*;Form:C1466.widgets.localizations;False:C215)
	
	OB REMOVE:C1226(Form:C1466;"$target")
	OB REMOVE:C1226(Form:C1466;"$current")
	
Else 
	
	OBJECT SET VISIBLE:C603(*;Form:C1466.widgets.localizations;True:C214)
	
	$Obj_content:=(Form:C1466.dynamic("content"))->{$Lon_row}
	
	If ($Lon_column=1)
		
		Form:C1466.$target:="group"
		
		If ($Obj_content.group#Null:C1517)\
			 & (Num:C11($Obj_content.group.units.length)=0)  // Empty group
			
			  // Get the unit group
			Form:C1466.$current:=$Obj_content.group
			
			LISTBOX COLLAPSE:C1101(*;Form:C1466.widgets.strings;True:C214;lk break row:K53:18;$Lon_row;1)
			LISTBOX SELECT ROW:C912(*;Form:C1466.widgets.strings;$Lon_row;lk replace selection:K53:1)
			LISTBOX SELECT BREAK:C1117(*;Form:C1466.widgets.strings;$Lon_row;1;lk replace selection:K53:1)
			
		Else 
			
			If ($Obj_content.group=Null:C1517)
				
				Form:C1466.$current:=$Obj_content
				
			Else 
				
				  // Get the unit group
				Form:C1466.$current:=$Obj_content.group
				
			End if 
		End if 
		
	Else 
		
		Form:C1466.$target:="unit"
		
		Form:C1466.$current:=$Obj_content
		
		If ($Obj_content.group=Null:C1517)  // Could occur after adding a group
			
			Form:C1466.$target:="group"
			
			LISTBOX COLLAPSE:C1101(*;Form:C1466.widgets.strings;True:C214;lk break row:K53:18;$Lon_row;1)
			LISTBOX SELECT ROW:C912(*;Form:C1466.widgets.strings;$Lon_row;lk replace selection:K53:1)
			LISTBOX SELECT BREAK:C1117(*;Form:C1466.widgets.strings;$Lon_row;1;lk replace selection:K53:1)
			
		End if 
	End if 
End if 

(Form:C1466.dynamic(Form:C1466.widgets.localizations))->:=Form:C1466

  // Update UI
Form:C1466.refresh(Null:C1517)

  //ASSERT(debug_SAVE (Form))

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End 