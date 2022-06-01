// ----------------------------------------------------
// Object method : PROJECT_SETTINGS.action - (4DPop XLIFF Pro)
// ID[808A0BB219304163837BF501B1778DA6]
// Created #15-5-2018 by Vincent de Lachaux
// ----------------------------------------------------
// Declarations
var $languageCode; $me; $pathname : Text
var $update : Boolean
var $column; $row : Integer
var $e; $o : Object

// ----------------------------------------------------
// Initialisations
$e:=FORM Event:C1606
$me:=OBJECT Get name:C1087(Object current:K67:2)

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: ($e.code=On Clicked:K2:4)
		
		LISTBOX GET CELL POSITION:C971(*; $me; $column; $row)
		
		Case of 
				
				//______________________________________________________
			: ($row=0)
				
				// NOTHING MORE TO DO
				
				// MARK:Change the reference language
				//______________________________________________________
			: ($row=1)
				
				If (String:C10(Form:C1466.files[0].fullName)="")  // Allow reference language change for a project without localization
					
					$languageCode:=language_Menu(New object:C1471(\
						"selected"; Form:C1466.languages.extract("language")[0]))
					
					If (Length:C16($languageCode)>0)\
						 & ($languageCode#Form:C1466.languages[0].language)
						
						//TODO:Change the reference language
						
						$pathname:=Form:C1466.referenceFolder()
						DELETE FOLDER:C693($pathname)
						
						Form:C1466.language:=$languageCode
						
						$pathname:=Form:C1466.referenceFolder()
						CREATE FOLDER:C475(($pathname))
						
						$update:=True:C214
						
					End if 
				End if 
				
				// MARK:Add a localization
				//______________________________________________________
			: ($row=LISTBOX Get number of rows:C915(*; $me))
				
				$languageCode:=language_Menu(New object:C1471(\
					"inactivated"; Form:C1466.languages.extract("language")))
				
				If (Length:C16($languageCode)>0)
					
					$o:=New object:C1471(\
						"name"; "_"+$languageCode+".lproj"; \
						"parentFolder"; Storage:C1525.editor.directory; \
						"isFolder"; True:C214)
					
					$pathname:=Object to path:C1548($o)
					
					If (Test path name:C476($pathname)=Is a folder:K24:2)
						
						// Rename the deactivated language
						COPY DOCUMENT:C541($pathname; Storage:C1525.editor.directory; $languageCode+".lproj"; *)
						DELETE FOLDER:C693($pathname; Delete with contents:K24:24)
						
					Else 
						
						$o.name:=$languageCode+".lproj"
						CREATE FOLDER:C475(Object to path:C1548($o))
						
					End if 
					
					$update:=True:C214
					
				End if 
				
				// MARK:Delete (inactivate) a localization (#INACTIVATED)
				//______________________________________________________
			Else   // Delete (inactivate) a localization (#INACTIVATED)
				
				//$Obj_lproj:=New object(\
					"name";Form.languages[$row-1].language+".lproj";\
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
		
		ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+$e.description+")")
		
		//______________________________________________________
End case 

If ($update)
	
	OBJECT SET ENABLED:C1123(*; "validate"; True:C214)
	
	Form:C1466.languages:=language_Find
	
	SET TIMER:C645(-1)
	
End if 