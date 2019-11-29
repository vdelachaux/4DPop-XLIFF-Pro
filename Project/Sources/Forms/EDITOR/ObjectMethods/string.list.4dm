  // ----------------------------------------------------
  // Object method : EDITOR.string.list - (4DPop XLIFF Pro)
  // ID[A2FF750CD4C54034BCA6378BDE7AA42A]
  // Created #12-10-2015 by Vincent de Lachaux
  // ----------------------------------------------------
  // Declarations
C_BLOB:C604($Blb_)
C_LONGINT:C283($Lon_;$Lon_column;$Lon_formEvent;$Lon_row;$Lon_x;$Lon_y)
C_POINTER:C301($Ptr_me)
C_TEXT:C284($Mnu_main;$Txt_choice;$Txt_me)
C_OBJECT:C1216($Obj_)

  // ----------------------------------------------------
  // Initialisations
$Lon_formEvent:=Form event code:C388
$Txt_me:=OBJECT Get name:C1087(Object current:K67:2)
$Ptr_me:=OBJECT Get pointer:C1124(Object current:K67:2)

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($Lon_formEvent=On Double Clicked:K2:5)
		
		  //%W-533.3
		EDIT ITEM:C870($Ptr_me->{$Ptr_me->})
		  //%W+533.3
		
		  //______________________________________________________
	: ($Lon_formEvent=On Data Change:K2:15)
		
		  //%W-533.3
		Form:C1466.message(New object:C1471(\
			"target";"resname";\
			"value";$Ptr_me->{$Ptr_me->};\
			"fromList";True:C214))
		  //%W+533.3
		
		  //______________________________________________________
	: ($Lon_formEvent=On Selection Change:K2:29)
		
		LISTBOX GET CELL POSITION:C971(*;$Txt_me;$Lon_column;$Lon_row)
		
		If ($Lon_column=2)
			
			  // NOTHING MORE TO DO
			
		Else 
			
			If ($Lon_column=1)
				
				Form:C1466.$target:="group"
				
			Else 
				
				
			End if 
		End if 
		
		  //Form.showLocalization()
		EDITOR_DISPLAY 
		
		  //______________________________________________________
	: ($Lon_formEvent=On Clicked:K2:4)
		
		GET MOUSE:C468($Lon_x;$Lon_y;$Lon_)
		
		If (Form:C1466.$wait)
			
			  // Wait for the change to be saved…
			
			IDLE:C311
			
			Form:C1466.message(New object:C1471(\
				"target";"postClick";\
				"x";$Lon_x;\
				"y";$Lon_y))
			
		Else 
			
			EDITOR_DISPLAY 
			
			LISTBOX GET CELL POSITION:C971(*;$Txt_me;$Lon_column;$Lon_row)
			
			If (Contextual click:C713)
				
				$Mnu_main:=Create menu:C408
				
				If ($Lon_row#0)
					
					APPEND MENU ITEM:C411($Mnu_main;Get localized string:C991("CommonMenuItemCopy"))
					SET MENU ITEM PARAMETER:C1004($Mnu_main;-1;"copy")
					
				End if 
				
				$Txt_choice:=Dynamic pop up menu:C1006($Mnu_main)
				RELEASE MENU:C978($Mnu_main)
				
				Case of 
						
						  //………………………………………………………………………………………
					: (Length:C16($Txt_choice)=0)
						
						  // Nothing selected
						
						  //………………………………………………………………………………………
					: ($Txt_choice="copy")
						
						If (String:C10(Form:C1466.$target)="group")
							
							  // NOTHING MORE TO DO
							
						Else 
							
							SET TEXT TO PASTEBOARD:C523(":xliff:"+(OBJECT Get pointer:C1124(Object named:K67:5;"unit"))->{$Lon_row})
							
						End if 
						
						  // Put the current item as private data
						$Obj_:=OB Copy:C1225(Form:C1466.$current)
						OB REMOVE:C1226($Obj_;"group")
						
						TEXT TO BLOB:C554(JSON Stringify:C1217($Obj_;*);$Blb_;UTF8 text without length:K22:17)
						APPEND DATA TO PASTEBOARD:C403("xliff";$Blb_)
						
						  //………………………………………………………………………………………
					Else 
						
						ASSERT:C1129(False:C215;"Unknown menu action ("+$Txt_choice+")")
						
						  //………………………………………………………………………………………
				End case 
			End if 
		End if 
		
		  //______________________________________________________
	: ($Lon_formEvent=On Expand:K2:41)
		
		EDITOR_DISPLAY 
		
		LISTBOX GET CELL POSITION:C971(*;$Txt_me;$Lon_column;$Lon_row)
		
		  // Select the break line
		LISTBOX SELECT BREAK:C1117(*;$Txt_me;$Lon_row;1)
		
		  //______________________________________________________
	: ($Lon_formEvent=On Begin Drag Over:K2:44)
		
		EDITOR_DRAG 
		
		  //______________________________________________________
	: ($Lon_formEvent=On Delete Action:K2:56)
		
		  //#ACI0096170 turn around
		  // EDITOR_DELETE
		
		  //______________________________________________________
	: ($Lon_formEvent=On Getting Focus:K2:7)
		
		If (LISTBOX Get number of rows:C915(*;$Txt_me)>0)
			
			  // Enable the delete button
			OBJECT SET ENABLED:C1123(*;"unit.delete";True:C214)
			
		Else 
			
			  // Reject focus
			obj_GOTO_NEXT 
			
		End if 
		
		  //______________________________________________________
	: ($Lon_formEvent=On Losing Focus:K2:8)
		
		OBJECT SET ENABLED:C1123(*;"unit.delete";False:C215)
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
		
		  //______________________________________________________
End case 