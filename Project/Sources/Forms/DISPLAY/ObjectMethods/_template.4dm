  // ----------------------------------------------------
  // Object method : LOCALIZATION._template - (4DPop XLIFF Pro)
  // ID[CD49DCB5582447BC9CA8AB7043B2CAD2]
  // Created #27-10-2015 by Vincent de Lachaux
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($Lon_formEvent;$Lon_i;$Lon_offset;$Lon_x)
C_POINTER:C301($Ptr_me)
C_TEXT:C284($Txt_me)

  // ----------------------------------------------------
  // Initialisations
$Lon_formEvent:=Form event code:C388
$Txt_me:=OBJECT Get name:C1087(Object current:K67:2)
$Ptr_me:=OBJECT Get pointer:C1124(Object current:K67:2)

  // ----------------------------------------------------
Case of 
		
		  //________________________________________
	: ($Lon_formEvent<0)  // Subform call
		
		$Lon_formEvent:=Abs:C99($Lon_formEvent)
		
		Case of 
				
				  //…………………………………………………………………………………………………
			: ($Lon_formEvent=On Data Change:K2:15)  // Update value
				
				  // Notify the container to place a "modification on hold" flag
				CALL SUBFORM CONTAINER:C1086(-$Lon_formEvent)
				
				Form:C1466.message(New object:C1471(\
					"target";"localization";\
					"value";$Ptr_me->value;\
					"language";Replace string:C233($Txt_me;"lang_";"")))
				
				  //…………………………………………………………………………………………………
			Else   // Resizing
				
				  // Get the offset
				$Lon_offset:=$Lon_formEvent
				
				  // Resize me
				OBJECT MOVE:C664(*;$Txt_me;0;0;0;$Lon_offset)
				
				  // Position the undermost elements {
				ARRAY TEXT:C222($tTxt_objects;0x0000)
				FORM GET OBJECTS:C898($tTxt_objects;Form current page:K67:6)
				
				$Lon_x:=Find in array:C230($tTxt_objects;$Txt_me)
				
				For ($Lon_i;$Lon_x+1;Size of array:C274($tTxt_objects);1)
					
					If ($tTxt_objects{$Lon_i}="lang_@")
						
						OBJECT MOVE:C664(*;$tTxt_objects{$Lon_i};0;$Lon_offset)
						
					End if 
				End for 
				  //}
				
				  // Resize the background
				OBJECT MOVE:C664(*;"_background";0;0;0;$Lon_offset)
				
				  //…………………………………………………………………………………………………
		End case 
		
		  //______________________________________________________
	Else 
		
		  //ASSERT(False;"Form event activated unnecessarily ("+String($Lon_formEvent)+")")
		
		  //______________________________________________________
End case 