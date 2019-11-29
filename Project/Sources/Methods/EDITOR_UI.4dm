//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : EDITOR_UI
  // Database: 4DPop XLIFF Pro
  // ID[418B8606CC904104B231BE9C7168FCC0]
  // Created #13-10-2015 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($1)

C_LONGINT:C283($Lon_column;$Lon_parameters;$Lon_row)
C_OBJECT:C1216($Obj_in)

ARRAY TEXT:C222($tTxt_items;0)
ARRAY TEXT:C222($tTxt_labels;0)
ARRAY TEXT:C222($tTxt_menus;0)

If (False:C215)
	C_OBJECT:C1216(EDITOR_UI ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // NO PARAMETERS REQUIRED
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		$Obj_in:=$1
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($Obj_in#Null:C1517)  // Specific calls
		
		Case of 
				
				  //……………………………………………………………………………………………………………………………
			: ($Obj_in.target="sort")
				
				ASSERT:C1129(False:C215)
				
				  //……………………………………………………………………………………………………………………………
			: ($Obj_in.target="break")
				
				Case of 
						
						  //……………………………………………………………………
					: ($Obj_in.action="new")  // New group added
						
						  // Collapse and select the group
						LISTBOX COLLAPSE:C1101(*;Form:C1466.widgets.strings;True:C214;lk break row:K53:18;$Obj_in.row;1)
						LISTBOX SELECT ROW:C912(*;Form:C1466.widgets.strings;$Obj_in.row;lk replace selection:K53:1)
						LISTBOX SELECT BREAK:C1117(*;Form:C1466.widgets.strings;$Obj_in.row;1;lk replace selection:K53:1)
						
						(Form:C1466.dynamic(Form:C1466.widgets.localizations))->:=Form:C1466
						
						  // Give the focus to resname
						GOTO OBJECT:C206(*;Form:C1466.widgets.localizations)
						
						  // Update UI
						Form:C1466.refresh(Null:C1517)
						
						  //……………………………………………………………………
					: ($Obj_in.action="collapse")
						
						LISTBOX COLLAPSE:C1101(*;Form:C1466.widgets.strings;True:C214;lk break row:K53:18;$Obj_in.row;$Obj_in.column)
						
						  //……………………………………………………………………
					Else 
						
						ASSERT:C1129(False:C215;"Unknown entry point: \""+$Obj_in.action+"\"")
						
						  //……………………………………………………………………
				End case 
				
				  //  LISTBOX SORT COLUMNS(*;"string.list";1;>)
				
				  //……………………………………………………………………………………………………………………………
			: ($Obj_in.target="row")
				
				Case of 
						
						  //……………………………………………………………………
					: ($Obj_in.action="new")
						
						LISTBOX SELECT ROW:C912(*;Form:C1466.widgets.strings;$Obj_in.row;lk replace selection:K53:1)
						OBJECT SET SCROLL POSITION:C906(*;Form:C1466.widgets.strings;$Obj_in.row)
						
						  // Sort
						LISTBOX SORT COLUMNS:C916(*;Form:C1466.widgets.strings;2;>)
						
						  //……………………………………………………………………
					: ($Obj_in.action="select")
						
						LISTBOX SELECT ROW:C912(*;Form:C1466.widgets.strings;$Obj_in.row;lk replace selection:K53:1)
						OBJECT SET SCROLL POSITION:C906(*;Form:C1466.widgets.strings;$Obj_in.row)
						
						  //……………………………………………………………………
					Else 
						
						ASSERT:C1129(False:C215;"Unknown entry point: \""+$Obj_in.action+"\"")
						
						  //……………………………………………………………………
				End case 
				
				  //……………………………………………………………………………………………………………………………
			Else 
				
				ASSERT:C1129(False:C215;"Unknown entry point: \""+$Obj_in.target+"\"")
				
				  //……………………………………………………………………………………………………………………………
		End case 
		
		  //______________________________________________________
	: (Form event code:C388#0)
		
		  // Called from an event cycle : Delayed
		Form:C1466.refresh(Null:C1517)
		
		  //______________________________________________________
	Else 
		
		  // Menus
		GET MENU ITEMS:C977(Get menu bar reference:C979;$tTxt_labels;$tTxt_menus)
		
		  // File menu items
		GET MENU ITEMS:C977($tTxt_menus{1};$tTxt_labels;$tTxt_items)
		
		OBJECT SET ENABLED:C1123(*;"b.project.setting";False:C215)
		OBJECT SET ENABLED:C1123(*;"b.file.infos";False:C215)
		
		  // Do it now
		LISTBOX GET CELL POSITION:C971(*;Form:C1466.widgets.files;$Lon_column;$Lon_row)
		
		If ($Lon_row>0)
			
			If ($Lon_column=1)  // Project
				
				OBJECT SET ENABLED:C1123(*;"b.project.setting";True:C214)
				
				OBJECT SET VISIBLE:C603(*;Form:C1466.widgets.strings+"@";False:C215)
				OBJECT SET VISIBLE:C603(*;Form:C1466.widgets.localizations;False:C215)
				
			Else 
				
				  // File
				FORM GOTO PAGE:C247(1)
				
				OBJECT SET ENABLED:C1123(*;"b.file.infos";True:C214)
				
				OBJECT SET VISIBLE:C603(*;Form:C1466.widgets.strings+"@";True:C214)
				
				LISTBOX GET CELL POSITION:C971(*;Form:C1466.widgets.strings;$Lon_column;$Lon_row)
				
				If ($Lon_row=0)\
					 & (OBJECT Get name:C1087(Object with focus:K67:3)=Form:C1466.widgets.strings)\
					 & (Bool:C1537(Form:C1466.$target))
					
					$Lon_row:=Num:C11(LISTBOX Get number of rows:C915(*;Form:C1466.widgets.strings)>0)
					
				End if 
				
				OBJECT SET VISIBLE:C603(*;Form:C1466.widgets.localizations;$Lon_row>0)
				
				  // Do not allow adding a group or unit for a constants file
				If (Form:C1466.isConstant())
					
					OBJECT SET ENABLED:C1123(*;"unit.@";False:C215)
					DISABLE MENU ITEM:C150($tTxt_items{1};2)  // New group
					
					OBJECT SET ENABLED:C1123(*;"unit.new.group";False:C215)
					DISABLE MENU ITEM:C150($tTxt_items{1};3)  // New unit
					
				Else 
					
					If ($Lon_row>0)
						
						OBJECT SET ENABLED:C1123(*;"unit.@";True:C214)
						ENABLE MENU ITEM:C149($tTxt_items{1};3)  // New unit
						
					Else 
						
						OBJECT SET ENABLED:C1123(*;"unit.@";False:C215)
						DISABLE MENU ITEM:C150($tTxt_items{1};3)  // New unit
						
					End if 
					
					OBJECT SET ENABLED:C1123(*;"unit.new.group";True:C214)
					ENABLE MENU ITEM:C149($tTxt_items{1};2)  // New group
					
				End if 
				
				OBJECT SET ENABLED:C1123(*;"unit.search";True:C214)
				
			End if 
			
		Else 
			
			  // No selection
			OBJECT SET VISIBLE:C603(*;Form:C1466.widgets.strings+"@";False:C215)
			OBJECT SET VISIBLE:C603(*;Form:C1466.widgets.localizations;False:C215)
			
			OBJECT SET ENABLED:C1123(*;"unit.@";False:C215)
			
			DISABLE MENU ITEM:C150($tTxt_items{1};2)  // New group
			DISABLE MENU ITEM:C150($tTxt_items{1};3)  // New unit
			
			EDITOR_Preferences (New object:C1471(\
				"set";True:C214;\
				"key";"file"))
			
		End if 
		
		SET TIMER:C645(5)
		
		  //______________________________________________________
End case 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End