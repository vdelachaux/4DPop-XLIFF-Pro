//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : DISPLAY
  // Database: 4DPop XLIFF Pro
  // ID[75C1B22495924A5E8D9C9F5D6612BEB0]
  // Created #23-6-2016 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_BOOLEAN:C305($Boo_noTranslate)
C_LONGINT:C283($Lon_parameters)
C_POINTER:C301($Ptr_lang)
C_TEXT:C284($Dom_ref;$Dom_root;$Txt_buffer;$Txt_state;$Txt_value)
C_OBJECT:C1216($Obj_language)

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
If (Form:C1466#Null:C1517)
	
	If (Form:C1466.$current#Null:C1517)
		
		  // Populate resname
		(Form:C1466.dynamic("resname.box"))->:=String:C10(Form:C1466.$current.resname)
		
		If (Form:C1466.isUnit())
			
			If (Form:C1466.isConstant())
				
				  // Hide resname if any
				If (OBJECT Get visible:C1075(*;"resname.box"))
					
					OBJECT SET VISIBLE:C603(*;"resname.@";False:C215)
					
					OBJECT MOVE:C664(*;"unit@";0;-30)
					OBJECT MOVE:C664(*;"lang_@";0;-30)
					
				End if 
				
			Else 
				
				  // Show resname if any
				If (Not:C34(OBJECT Get visible:C1075(*;"resname.box")))
					
					OBJECT SET VISIBLE:C603(*;"resname.@";True:C214)
					OBJECT MOVE:C664(*;"unit@";0;30)
					OBJECT MOVE:C664(*;"lang_@";0;30)
					
				End if 
			End if 
			
			  // Translate property
			$Boo_noTranslate:=Bool:C1537(Form:C1466.$current.noTranslate)
			(Form:C1466.dynamic("unit.notranslate"))->:=Num:C11($Boo_noTranslate)
			
			  // Reference string
			(Form:C1466.dynamic("unit.source"))->:=String:C10(Form:C1466.$current.source.value)
			
			  // UI
			OBJECT SET VISIBLE:C603(*;"unit.@";True:C214)
			
			  // Close comment widget, if any
			OBJECT SET VISIBLE:C603(*;"NOTE";False:C215)
			
			  // Highlight duplicate resname
			OBJECT SET RGB COLORS:C628(*;"resname.box";Foreground color:K23:1;Choose:C955(Bool:C1537(Form:C1466.$current.duplicateResname);0x00FF7E79;Background color:K23:2))
			
			  // Set the note indicator
			OBJECT SET FORMAT:C236(*;"unit.note";";#Images/note_"+Choose:C955(Form:C1466.$current.note#Null:C1517;"on";"off")+".png")
			
			  // Set the platform indicator
			OBJECT SET VISIBLE:C603(*;"unit.mac";String:C10(Form:C1466.$current["d4:includeIf"])="mac")
			
			OBJECT SET VISIBLE:C603(*;"unit.win";String:C10(Form:C1466.$current["d4:includeIf"])="win")
			
			  // Show or hide translations in accordance with Translate property
			  // & localization filter
			If ($Boo_noTranslate)
				
				OBJECT SET VISIBLE:C603(*;"lang_@";False:C215)
				
			Else 
				
				If (Length:C16(String:C10(Form:C1466.localization))>0)
					
					OBJECT SET VISIBLE:C603(*;"lang_"+Form:C1466.localization;True:C214)
					
				Else 
					
					OBJECT SET VISIBLE:C603(*;"lang_@";False:C215)
					
					For each ($Obj_language;Form:C1466.languages)
						
						OBJECT SET VISIBLE:C603(*;"lang_"+$Obj_language.language;True:C214)
						
					End for each 
				End if 
				
			End if 
			
			  // Update all languages
			For each ($Obj_language;Form:C1466.languages)
				
				If ($Obj_language.language=Form:C1466.language)
					
					  // NOTHING MORE TO DO
					
				Else 
					
					ASSERT:C1129(xml_IsValidReference ($Obj_language.file.$dom))
					
					If (Form:C1466.isConstant())
						
						$Dom_ref:=DOM Find XML element by ID:C1010($Obj_language.file.$dom;Form:C1466.$current.id)
						
						If ($Boo_noTranslate)
							
							  // Get the source
							$Dom_ref:=Form:C1466.source($Dom_ref)
							
						Else 
							
							  // Get the target
							$Dom_ref:=Form:C1466.target($Dom_ref)
							
						End if 
						
					Else 
						
						  // Find the target
						$Dom_ref:=Form:C1466.findTarget($Obj_language.file.$dom;Form:C1466.$current.resname;Form:C1466.$current.id)
						
					End if 
					
					ASSERT:C1129(xml_IsValidReference ($Dom_ref))
					
					If (Not:C34($Boo_noTranslate))
						
						  // Get the localized value
						xml_GET_ELEMENT_VALUE ($Dom_ref;->$Txt_value)
						xml_GET_ATTRIBUTE ($Dom_ref;"state";->$Txt_state)
						
						Form:C1466.$current[$Obj_language.language]:=New object:C1471(\
							"$dom";$Dom_ref;\
							"value";$Txt_value)
						
						If (Length:C16($Txt_state)>0)
							
							Form:C1466.$current[$Obj_language.language].state:=$Txt_state
							
						End if 
					End if 
					
					  // UI = touch subform {
					$Ptr_lang:=Form:C1466.dynamic("lang_"+$Obj_language.language)
					
					If (Length:C16($Txt_state)>0)
						
						$Ptr_lang->state:=$Txt_state
						
					Else 
						
						OB REMOVE:C1226($Ptr_lang->;"state")
						
					End if 
					
					$Ptr_lang->value:=$Txt_value
					
					Form:C1466.touch("lang_"+$Obj_language.language)
					
				End if 
			End for each 
			
		Else   //<group>
			
			  // Restore default UI {
			OBJECT SET RGB COLORS:C628(*;"resname.box";Foreground color:K23:1;Background color:K23:2)
			
			If (Not:C34(OBJECT Get visible:C1075(*;"resname.box")))
				
				OBJECT SET VISIBLE:C603(*;"resname.@";True:C214)
				OBJECT MOVE:C664(*;"unit@";0;30)
				OBJECT MOVE:C664(*;"lang_@";0;30)
				
			End if 
			  //}
			
			If (Form:C1466.isConstant())
				
				  // Display the theme label
				$Dom_ref:=Form:C1466.$current.$dom
				
				If (Length:C16($Dom_ref)>0)
					
					xml_GET_ATTRIBUTE ($Dom_ref;"d4:groupName";->$Txt_buffer)
					
					$Dom_root:=DOM Get root XML element:C1053($Dom_ref)
					$Dom_ref:=xml_Find_by_attribute ($Dom_root;"/xliff/file/body/group/trans-unit/@resname";$Txt_buffer)
					
					If (xml_IsValidReference ($Dom_ref))
						
						$Dom_ref:=Form:C1466.target($Dom_ref)
						xml_GET_ELEMENT_VALUE ($Dom_ref;Form:C1466.dynamic("resname.box"))
						
					End if 
					
				Else 
					
					  // A "If" statement should never omit "Else" 
					
				End if 
				
				OBJECT SET ENABLED:C1123(*;"resname.@";False:C215)
				OBJECT SET VISIBLE:C603(*;"_action";False:C215)
				
			Else 
				
				OBJECT SET ENABLED:C1123(*;"resname.@";True:C214)
				OBJECT SET VISIBLE:C603(*;"_action";True:C214)
				
			End if 
			
			  // UI
			OBJECT SET VISIBLE:C603(*;"unit.@";False:C215)
			OBJECT SET VISIBLE:C603(*;"lang_@";False:C215)
			
		End if 
		
	Else 
		
		CLEAR VARIABLE:C89((Form:C1466.dynamic("resname.box"))->)
		
	End if 
End if 

  // ASSERT(debug_SAVE (Form))

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End