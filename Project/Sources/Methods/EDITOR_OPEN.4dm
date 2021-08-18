//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method: EDITOR_OPEN
// Database: 4DPop XLIFF Pro
// ID[99D2098F1A1C4BE4B27439E00751EB1B]
// Created #13-10-2015 by Vincent de Lachaux
// ----------------------------------------------------
// Description
//
// ----------------------------------------------------
// Declarations
C_TEXT:C284($1)

C_BOOLEAN:C305($Boo_resetGeometry)
C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Txt_entryPoint; $Txt_methodName; $Txt_referenceLanguage)
C_OBJECT:C1216($Obj_editor; $Obj_settings)

If (False:C215)
	C_TEXT:C284(_EDITOR_OPEN; $1)
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If ($Lon_parameters>=1)
	
	$Txt_entryPoint:=$1
	
End if 

// ----------------------------------------------------
Case of 
		
		//___________________________________________________________
	: (Length:C16($Txt_entryPoint)=0)
		
		$Txt_methodName:=Current method name:C684
		
		Case of 
				
				//……………………………………………………………………
			: (Method called on error:C704=$Txt_methodName)
				
				// Error handling manager
				
				//……………………………………………………………………
			Else 
				
				CALL WORKER:C1389("$4DPop XLIFF Pro"; $Txt_methodName; "_run")
				
				//……………………………………………………………………
		End case 
		
		//___________________________________________________________
	: ($Txt_entryPoint="_run")
		
		// First launch of this method executed in a new process
		EDITOR_OPEN("_declarations")
		EDITOR_OPEN("_init")
		
		$Obj_editor:=Storage:C1525.editor
		
		If ($Obj_editor.window=Null:C1517)
			
			// Display the editor
			Use ($Obj_editor)
				
				$Obj_editor.window:=Open form window:C675("EDITOR"; Plain form window:K39:10; Horizontally centered:K39:1; Vertically centered:K39:4; *)
				DIALOG:C40("EDITOR"; *)
				
			End use 
			
		Else 
			
			// Bring to front
			BRING TO FRONT:C326(Window process:C446($Obj_editor.window))
			
		End if 
		
		EDITOR_OPEN("_deinit")
		
		//___________________________________________________________
	: ($Txt_entryPoint="_declarations")
		
		COMPILER_EDITOR
		
		If (Storage:C1525.editor=Null:C1517)
			
			Use (Storage:C1525)
				
				Storage:C1525.editor:=New shared object:C1526
				
			End use 
		End if 
		
		// Allow assertions for the matrix database | me
		SET ASSERT ENABLED:C1131((Structure file:C489=Structure file:C489(*))\
			 | (Test path name:C476(Get 4D folder:C485(Active 4D Folder:K5:10)+"_vdl")#-43); *)
		
		//___________________________________________________________
	: ($Txt_entryPoint="_init")
		
		$Obj_editor:=Storage:C1525.editor
		
		Use ($Obj_editor)
			
			If (env_Component)
				
				// Component execution
				$Obj_editor.mode:="editor"
				
			Else 
				
				If (Is compiled mode:C492)
					
					// Standalone editeur
					$Obj_editor.mode:="editor"
					
				Else 
					
					// Matrix database
					If (Macintosh option down:C545)
						
						// Test project mode
						$Obj_editor.mode:="editor"
						
					Else 
						
						// Matrix database
						$Obj_editor.mode:="component"
						
					End if 
				End if 
			End if 
			
			$Obj_editor.directory:=_o_EDITOR_Project_folder
			
		End use 
		
		EDITOR_MENU("install")
		
		If ($Obj_editor.mode="component")
			
			$Obj_settings:=EDITOR_Preferences
			
			// Get reference language
			$Txt_referenceLanguage:=$Obj_settings.reference
			
			If (Length:C16($Txt_referenceLanguage)=0)
				
				// Determine the probable reference language
				$Txt_referenceLanguage:=language_Reference($Obj_editor.directory)
				
				//#WARNING May not be unique
				//#TO_BE_DONE - Retrieve the first found lproj
				
				EDITOR_Preferences(New object:C1471(\
					"set"; True:C214; \
					"key"; "reference"; \
					"value"; $Txt_referenceLanguage))
				
				// & Create the folder if any
				CREATE FOLDER:C475(Object to path:C1548(New object:C1471(\
					"parentFolder"; $Obj_editor.directory; \
					"name"; $Txt_referenceLanguage; \
					"extension"; "lproj"; \
					"isFolder"; True:C214)); *)
				
			Else 
				
				// Detect a project modification (adding or deleting a language)
				// since the last editor use
				If ($Obj_settings.languages#Null:C1517)
					
					// Compare to last use
					$Boo_resetGeometry:=Not:C34(doc_Folder($Obj_editor.directory).folders.query("extension = .lproj & name != _@").extract("name").orderBy().equal($Obj_settings.languages.orderBy()))
					
					If ($Boo_resetGeometry & (Structure file:C489#Structure file:C489(*)))\
						 | Shift down:C543
						
						// Reinit geometry
						env_DELETE_GEOMETRY(Choose:C955(Structure file:C489=Structure file:C489(*); ""; Path to object:C1547(Structure file:C489).name+"/")+"[projectForm]/EDITOR.json")
						
					End if 
				End if 
			End if 
			
		Else 
			
			//Use ($Obj_editor)
			//If (Test path name($File_project)=Is a document)
			//$Obj_editor.project:=System folder(Documents folder)+"4DPop XLIFF Pro.project"
			// End  if
			// End  use
			
		End if 
		
		//___________________________________________________________
	: ($Txt_entryPoint="_deinit")
		
		//RELEASE MENU(Get menu bar reference)
		
		//___________________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Unknown entry point ("+$Txt_entryPoint+")")
		
		//___________________________________________________________
End case 