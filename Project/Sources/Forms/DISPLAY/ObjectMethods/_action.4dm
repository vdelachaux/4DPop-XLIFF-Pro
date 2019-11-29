  // ----------------------------------------------------
  // Object method : DISPLAY._action - (4DPop XLIFF Pro)
  // ID[C7974274E3D548F3BC984779B02AF39D]
  // Created #22-12-2016 by Vincent de Lachaux
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($Lon_formEvent)
C_POINTER:C301($Ptr_me)
C_TEXT:C284($Mnu_main;$Mnu_sub;$Txt_buffer;$Txt_choice;$Txt_me)

  // ----------------------------------------------------
  // Initialisations
$Lon_formEvent:=Form event code:C388
$Txt_me:=OBJECT Get name:C1087(Object current:K67:2)
$Ptr_me:=OBJECT Get pointer:C1124(Object current:K67:2)

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($Lon_formEvent=On Clicked:K2:4)
		
		$Mnu_main:=Create menu:C408
		
		APPEND MENU ITEM:C411($Mnu_main;"camelCase")
		SET MENU ITEM PARAMETER:C1004($Mnu_main;-1;"camelCase")
		
		If (Form:C1466.$target="unit")
			
			APPEND MENU ITEM:C411($Mnu_main;":xliff:prefixWithTheGroupName")
			SET MENU ITEM PARAMETER:C1004($Mnu_main;-1;"prefix")
			
			APPEND MENU ITEM:C411($Mnu_main;"-")
			
			If (OBJECT Get visible:C1075(*;"NOTE"))
				
				APPEND MENU ITEM:C411($Mnu_main;":xliff:closeComment")
				
			Else 
				
				If (Form:C1466.$current.note#Null:C1517)
					
					APPEND MENU ITEM:C411($Mnu_main;":xliff:editComment")
					
				Else 
					
					APPEND MENU ITEM:C411($Mnu_main;":xliff:addComment")
					
				End if 
				
				SET MENU ITEM PARAMETER:C1004($Mnu_main;-1;"comment")
				SET MENU ITEM SHORTCUT:C423($Mnu_main;-1;"N";(0 ?+ Option key bit:K16:8))
				
			End if 
			
			APPEND MENU ITEM:C411($Mnu_main;"-")
			
			$Mnu_sub:=Create menu:C408
			
			$Txt_buffer:=String:C10(Form:C1466.$current["d4:includeIf"])
			
			APPEND MENU ITEM:C411($Mnu_sub;":xliff:all")
			SET MENU ITEM PARAMETER:C1004($Mnu_sub;-1;"d4:includeIf_all")
			SET MENU ITEM MARK:C208($Mnu_sub;-1;Char:C90(18)*Num:C11(Length:C16($Txt_buffer)=0))
			
			APPEND MENU ITEM:C411($Mnu_sub;"-")
			
			APPEND MENU ITEM:C411($Mnu_sub;"macOS")
			SET MENU ITEM PARAMETER:C1004($Mnu_sub;-1;"d4:includeIf_mac")
			SET MENU ITEM MARK:C208($Mnu_sub;-1;Char:C90(18)*Num:C11($Txt_buffer="mac"))
			
			APPEND MENU ITEM:C411($Mnu_sub;"Windows")
			SET MENU ITEM PARAMETER:C1004($Mnu_sub;-1;"d4:includeIf_win")
			SET MENU ITEM MARK:C208($Mnu_sub;-1;Char:C90(18)*Num:C11($Txt_buffer="win"))
			
			APPEND MENU ITEM:C411($Mnu_main;":xliff:operatingSystems";$Mnu_sub)
			RELEASE MENU:C978($Mnu_sub)
			
			If (Not:C34(Bool:C1537(Form:C1466.$current.noTranslate)))
				
				APPEND MENU ITEM:C411($Mnu_main;"-")
				
				APPEND MENU ITEM:C411($Mnu_main;":xliff:setReferenceValueToAllLanguages")
				SET MENU ITEM PARAMETER:C1004($Mnu_main;-1;"propagate_reference")
				SET MENU ITEM SHORTCUT:C423($Mnu_main;-1;Shortcut with Down arrow:K75:30;Option key mask:K16:7)
				
			End if 
		End if 
		
		$Txt_choice:=Dynamic pop up menu:C1006($Mnu_main)
		RELEASE MENU:C978($Mnu_main)
		
		Case of 
				
				  //………………………………………………………………………………………
			: (Length:C16($Txt_choice)=0)
				
				  // nothing selected
				
				  //………………………………………………………………………………………
			: ($Txt_choice="camelCase")
				
				$Ptr_me:=OBJECT Get pointer:C1124(Object named:K67:5;"resname.box")
				$Ptr_me->:=convert_camelCase ($Ptr_me->)
				
				Form:C1466.message(New object:C1471(\
					"target";"resname";\
					"value";$Ptr_me->))
				
				  //………………………………………………………………………………………
			: ($Txt_choice="prefix")
				
				$Ptr_me:=OBJECT Get pointer:C1124(Object named:K67:5;"resname.box")
				$Ptr_me->:=Form:C1466.$current.group.resname+"_"+$Ptr_me->
				
				Form:C1466.message(New object:C1471(\
					"target";"resname";\
					"value";$Ptr_me->))
				
				  //………………………………………………………………………………………
			: ($Txt_choice="comment")
				
				POST EVENT:C467(Key down event:K17:4;Character code:C91("N");Tickcount:C458;0;0;(0 ?+ Option key bit:K16:8) ?+ Command key bit:K16:2)
				
				  //………………………………………………………………………………………
			: ($Txt_choice="propagate_reference")
				
				Form:C1466.message(New object:C1471(\
					"target";"propagate_reference";\
					"value";Form:C1466.$current.source))
				
				  //………………………………………………………………………………………
			: ($Txt_choice="d4:includeIf_@")
				
				$Txt_choice:=Delete string:C232($Txt_choice;1;13)
				
				  // Update project
				If ($Txt_choice="all")
					
					OB REMOVE:C1226(Form:C1466.$current;"d4:includeIf")
					
				Else 
					
					Form:C1466.$current["d4:includeIf"]:=$Txt_choice
					
				End if 
				
				  // Save modifications
				Form:C1466.message(New object:C1471(\
					"target";"d4:includeIf"))
				
				  //………………………………………………………………………………………
				
			Else 
				
				ASSERT:C1129(False:C215;"Unknown menu action ("+$Txt_choice+")")
				
				  //………………………………………………………………………………………
		End case 
		
		  //______________________________________________________
		
	Else 
		
		ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
		
		  //______________________________________________________
End case 