//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : EDITOR_SEARCH
  // Database: 4DPop XLIFF Pro
  // ID[656C87371E854316870D3533E9976C5E]
  // Created 28/12/2016 by Designer
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
  //////////_o_C_STRING(0;$1)
C_TEXT:C284($1)
C_TEXT:C284($1)
C_TEXT:C284($1)

C_LONGINT:C283($Lon_begin;$Lon_end;$Lon_parameters;$Lon_row;$Lon_unit)
C_TEXT:C284($Txt_search)

If (False:C215)
	C_TEXT:C284(EDITOR_SEARCH ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

  // ASSERT(4D_LOG (Current method name))

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	If ($Lon_parameters>=1)
		
		$Txt_search:=$1
		
	Else 
		
		$Txt_search:=(Form:C1466.dynamic("unit.search"))->
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If (Length:C16($Txt_search)>0)
	
	  // Contains
	$Txt_search:="@"+$Txt_search+"@"
	
	  // Get the selected item
	$Lon_row:=(Form:C1466.dynamic(Form:C1466.widgets.strings))->
	$Lon_row:=Choose:C955($Lon_row<=0;1;$Lon_row+1)
	
	  // Doing the search from the current position
	$Lon_unit:=Find in array:C230((Form:C1466.dynamic("unit"))->;$Txt_search;$Lon_row)
	
	If ($Lon_unit<0)
		
		  // Start over again
		$Lon_unit:=Find in array:C230((Form:C1466.dynamic("unit"))->;$Txt_search)
		
		OBJECT SET VISIBLE:C603(*;"wrap";True:C214)
		
	End if 
	
	If ($Lon_unit>0)
		
		  // Select & scroll
		OBJECT SET SCROLL POSITION:C906(*;Form:C1466.widgets.strings;$Lon_unit)
		LISTBOX SELECT ROW:C912(*;Form:C1466.widgets.strings;$Lon_unit;lk replace selection:K53:1)
		
		  // Give the focus to the string list
		GOTO OBJECT:C206(*;Form:C1466.widgets.strings)
		
		  // Restore default colors
		OBJECT SET RGB COLORS:C628(*;"unit.search";Foreground color:K23:1;Background color:K23:2)
		
		Form:C1466.refresh(New object:C1471(\
			"target";"row";\
			"action";"select";\
			"row";$Lon_unit))
		
		Form:C1466.redraw()
		
	Else 
		
		BEEP:C151
		OBJECT SET VISIBLE:C603(*;"wrap";False:C215)
		
		  // Highlight with red color
		OBJECT SET RGB COLORS:C628(*;"unit.search";Foreground color:K23:1;0x00FFCCCC)
		
	End if 
	
	  //Form.showLocalization()
	EDITOR_DISPLAY 
	
Else 
	
	  // Restore default colors
	OBJECT SET RGB COLORS:C628(*;"unit.search";Foreground color:K23:1;Background color:K23:2)
	
	GET HIGHLIGHT:C209(*;OBJECT Get name:C1087(Object with focus:K67:3);$Lon_begin;$Lon_end)
	
	If ($Lon_end>$Lon_begin)
		
		$Txt_search:=Substring:C12((Form:C1466.focus())->;$Lon_begin;$Lon_end-$Lon_begin)
		(Form:C1466.dynamic("unit.search"))->:=$Txt_search
		
		EDITOR_SEARCH ($Txt_search)
		
	End if 
	
	GOTO OBJECT:C206(*;"unit.search")
	
End if 

  // ----------------------------------------------------
  // End