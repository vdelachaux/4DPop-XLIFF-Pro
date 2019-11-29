  // ----------------------------------------------------
  // Object method : PROJECT_SETTINGS.action - (4DPop XLIFF Pro)
  // ID[808A0BB219304163837BF501B1778DA6]
  // Created #15-5-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Declarations
C_BOOLEAN:C305($Boo_update)
C_LONGINT:C283($Lon_column;$Lon_formEvent;$Lon_row)
C_TEXT:C284($Dir_source;$Txt_choice;$Txt_me)
C_OBJECT:C1216($Obj_lproj)

  // ----------------------------------------------------
  // Initialisations
$Lon_formEvent:=Form event code:C388
$Txt_me:=OBJECT Get name:C1087(Object current:K67:2)

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($Lon_formEvent=On Clicked:K2:4)
		
		LISTBOX GET CELL POSITION:C971(*;$Txt_me;$Lon_column;$Lon_row)
		
		Case of 
				
				  //______________________________________________________
			: ($Lon_row=0)
				
				  // NOTHING MORE TO DO
				
				  //______________________________________________________
			: ($Lon_row=1)  // Change the reference language
				
				  //If (Picture size((OBJECT Get pointer(Object named;"action"))->{$Lon_row})>0)
				If (String:C10(Form:C1466.files[0].fullName)="")  // Allow reference language change for a project without localization
					
					$Txt_choice:=language_Menu (New object:C1471(\
						"selected";Form:C1466.languages.extract("language")[0]))
					
					If (Length:C16($Txt_choice)>0)\
						 & ($Txt_choice#Form:C1466.languages[0].language)
						
						  //#TO_BE_DONE - Change the reference language
						
						$Dir_source:=Form:C1466.referenceFolder()
						DELETE FOLDER:C693($Dir_source)
						
						Form:C1466.language:=$Txt_choice
						
						$Dir_source:=Form:C1466.referenceFolder()
						CREATE FOLDER:C475(($Dir_source))
						
						$Boo_update:=True:C214
						
					End if 
				End if 
				
				  //______________________________________________________
			: ($Lon_row=LISTBOX Get number of rows:C915(*;$Txt_me))  // Add a localization
				
				$Txt_choice:=language_Menu (New object:C1471(\
					"inactivated";Form:C1466.languages.extract("language")))
				
				If (Length:C16($Txt_choice)>0)
					
					$Obj_lproj:=New object:C1471(\
						"name";"_"+$Txt_choice+".lproj";\
						"parentFolder";Storage:C1525.editor.directory;\
						"isFolder";True:C214)
					
					$Dir_source:=Object to path:C1548($Obj_lproj)
					
					If (Test path name:C476($Dir_source)=Is a folder:K24:2)
						
						  // Rename the deactivated language
						COPY DOCUMENT:C541($Dir_source;Storage:C1525.editor.directory;$Txt_choice+".lproj";*)
						DELETE FOLDER:C693($Dir_source;Delete with contents:K24:24)
						
					Else 
						
						$Obj_lproj.name:=$Txt_choice+".lproj"
						CREATE FOLDER:C475(Object to path:C1548($Obj_lproj))
						
					End if 
					
					$Boo_update:=True:C214
					
				End if 
				
				  //______________________________________________________
			Else   // Delete (inactivate) a localization (#INACTIVATED)
				
				  //$Obj_lproj:=New object(\
					"name";Form.languages[$Lon_row-1].language+".lproj";\
					"parentFolder";Storage.editor.directory;\
					"isFolder";True)
				  //$Dir_source:=Object to path($Obj_lproj)
				  //COPY DOCUMENT($Dir_source;Storage.editor.directory;"_"+$Obj_lproj.name;*)
				  //DELETE FOLDER($Dir_source;Delete with contents)
				  //$Boo_update:=True
				
				  //______________________________________________________
		End case 
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
		
		  //______________________________________________________
End case 

If ($Boo_update)
	
	OBJECT SET ENABLED:C1123(*;"validate";True:C214)
	
	Form:C1466.languages:=language_Find 
	
	SET TIMER:C645(-1)
	
End if 