  // ----------------------------------------------------
  // Object method : Form1.unit.handle.button - (4DPop XLIFF Pro)
  // ID[64D257C0F7EE42858B063C04F9793BC9]
  // Created 27/12/2016 by Designer
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($Lon_;$Lon_bottom;$Lon_formEvent;$Lon_i;$Lon_left;$Lon_offset)
C_LONGINT:C283($Lon_right;$Lon_targetBottom;$Lon_targetTop;$Lon_top;$Lon_vOffset)
C_TEXT:C284($Txt_me)

  // ----------------------------------------------------
  // Initialisations
$Lon_formEvent:=Form event code:C388
$Txt_me:=OBJECT Get name:C1087(Object current:K67:2)

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($Lon_formEvent=On Clicked:K2:4)
		
		  // Determine the offset
		OBJECT GET COORDINATES:C663(*;$Txt_me;$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
		OBJECT GET COORDINATES:C663(*;"unit.source";$Lon_;$Lon_targetTop;$Lon_;$Lon_targetBottom)
		
		$Lon_vOffset:=$Lon_bottom-$Lon_targetBottom
		
		If ((($Lon_targetBottom+$Lon_vOffset)-$Lon_targetTop)>50)
			
			  // Resize target
			OBJECT MOVE:C664(*;"unit.source";0;0;0;$Lon_vOffset)
			
			  // Position the handle
			OBJECT SET COORDINATES:C1248(*;"unit.handle";$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
			
			  // Position the undermost elements {
			OBJECT MOVE:C664(*;"unit.notranslate";0;$Lon_vOffset)
			OBJECT MOVE:C664(*;"unit.note";0;$Lon_vOffset)
			OBJECT MOVE:C664(*;"unit.mac";0;$Lon_vOffset)
			OBJECT MOVE:C664(*;"unit.win";0;$Lon_vOffset)
			
			  // Move & resize the subforms
			ARRAY TEXT:C222($tTxt_objects;0x0000)
			FORM GET OBJECTS:C898($tTxt_objects;Form current page:K67:6)
			
			For ($Lon_i;1;Size of array:C274($tTxt_objects);1)
				
				If ($tTxt_objects{$Lon_i}="lang_@")\
					 | ($tTxt_objects{$Lon_i}="_template)")
					
					$Lon_offset:=$Lon_offset+$Lon_vOffset
					OBJECT MOVE:C664(*;$tTxt_objects{$Lon_i};0;$Lon_offset;0;$Lon_vOffset)
					
				End if 
			End for 
			  //}
			
		Else 
			
			  // Reset the handle position
			OBJECT SET COORDINATES:C1248(*;$Txt_me;$Lon_left;$Lon_targetBottom-9;$Lon_right;$Lon_targetBottom)
			OBJECT SET COORDINATES:C1248(*;"unit.handle";$Lon_left;$Lon_targetBottom-9;$Lon_right;$Lon_targetBottom)
			
		End if 
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Form event activated unnecessary ("+String:C10($Lon_formEvent)+")")
		
		  //______________________________________________________
End case 