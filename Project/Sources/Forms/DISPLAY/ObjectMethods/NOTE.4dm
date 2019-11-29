  // ----------------------------------------------------
  // Object method : DISPLAY.NOTE - (4DPop XLIFF Pro)
  // ID[25FFEFD263614BD0AB6464DB304C5FE3]
  // Created #3-1-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($Lon_formEvent)
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
			: ($Lon_formEvent=On Data Change:K2:15)
				
				  // Save modifications
				Form:C1466.message(New object:C1471(\
					"target";"note";\
					"value";$Ptr_me->))
				
				  //…………………………………………………………………………………………………
			: ($Lon_formEvent=On Close Box:K2:21)
				
				  // Hide me
				OBJECT SET VISIBLE:C603(*;"NOTE";False:C215)
				
				  //…………………………………………………………………………………………………
			Else 
				
				ASSERT:C1129(False:C215;"Unknown call from subform ("+String:C10(-$Lon_formEvent)+")")
				
				  //…………………………………………………………………………………………………
		End case 
		
		  // UI
		If (Length:C16($Ptr_me->)#0)
			
			OBJECT SET FORMAT:C236(*;"unit.note";";#Images/note_on.png")
			
		Else 
			
			OBJECT SET FORMAT:C236(*;"unit.note";";#Images/note_off.png")
			
		End if 
		
		  //______________________________________________________
	: ($Lon_formEvent=On Data Change:K2:15)
		
		  // NOTHING MORE TO DO
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
		
		  //______________________________________________________
End case 