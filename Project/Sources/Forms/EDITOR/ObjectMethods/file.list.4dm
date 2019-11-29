  // ----------------------------------------------------
  // Object method : EDITOR.file.list - (4DPop XLIFF Pro)
  // ID[181BCE5204164614A0BFD8392CCB4444]
  // Created #12-10-2015 by Vincent de Lachaux
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($Lon_column;$Lon_formEvent;$Lon_row)
C_TEXT:C284($Txt_me)

  // ----------------------------------------------------
  // Initialisations
$Lon_formEvent:=Form event code:C388
$Txt_me:=OBJECT Get name:C1087(Object current:K67:2)

  //ASSERT(4D_LOG ($Txt_me+" ["+String($Lon_formEvent)+"]"))

LISTBOX GET CELL POSITION:C971(*;$Txt_me;$Lon_column;$Lon_row)

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($Lon_formEvent=On Load:K2:1)
		
		  //
		
		  //______________________________________________________
	: ($Lon_formEvent=On Clicked:K2:4)
		
		If (Contextual click:C713)
			
			EDITOR_MENU ($Txt_me)
			
		End if 
		
		  //______________________________________________________
	: ($Lon_formEvent=On Selection Change:K2:29)
		
		If ($Lon_row>0)
			
			If ($Lon_column=1)
				
				  // Project break row
				EDITOR_CLEANUP 
				
			Else 
				
				  // File row
				If (Form:C1466.files[Form:C1466.files.extract("name").indexOf((Form:C1466.dynamic("file"))->{$Lon_row})].nativePath#Null:C1517)
					
					  // Open the file
					Form:C1466.parse($Lon_row)
					
				End if 
			End if 
			
		Else 
			
			  // No selection
			EDITOR_CLEANUP 
			
		End if 
		
		  // Update UI
		Form:C1466.refresh(Null:C1517)
		
		  //______________________________________________________
	: ($Lon_formEvent=On Collapse:K2:42)
		
		  // Clear selection
		Form:C1466.file:=Null:C1517
		
		EDITOR_CLEANUP 
		
		  // Update UI
		Form:C1466.refresh(Null:C1517)
		
		  //______________________________________________________
	: ($Lon_formEvent=On Expand:K2:41)
		
		If (Form:C1466.files[$Lon_row-1].nativePath=Null:C1517)
			
			  // No file -> Refuse expansion
			LISTBOX COLLAPSE:C1101(*;$Txt_me;lk break row:K53:18;$Lon_row;1)
			LISTBOX SELECT BREAK:C1117(*;$Txt_me;$Lon_row;1)
			
		End if 
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
		
		  //______________________________________________________
End case 