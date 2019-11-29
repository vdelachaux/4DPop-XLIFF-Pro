  // ----------------------------------------------------
  // Object method : DISPLAY.resname.box - (4DPop XLIFF Pro)
  // ID[A3699B93D46D4757871810611D8231CC]
  // Created #2-11-2015 by Vincent de Lachaux
  // ----------------------------------------------------
  // Declarations
C_BOOLEAN:C305($Boo_OK)
C_LONGINT:C283($Lon_formEvent;$Lon_x)
C_POINTER:C301($Ptr_me)
C_TEXT:C284($Txt_me)
C_COLLECTION:C1488($Col_resname)

  // ----------------------------------------------------
  // Initialisations
$Lon_formEvent:=Form event code:C388
$Txt_me:=OBJECT Get name:C1087(Object current:K67:2)
$Ptr_me:=OBJECT Get pointer:C1124(Object current:K67:2)

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($Lon_formEvent=On Data Change:K2:15)
		
		  // Don't allow empty value
		$Boo_OK:=(Length:C16($Ptr_me->)>0)
		
		If ($Boo_OK)
			
			  // For a group, do not allow duplicate names
			If (Form:C1466.$target="group")
				
				$Col_resname:=Form:C1466.files[Form:C1466.files.extract("name").indexOf(Form:C1466.$currentFile)].groups.extract("resname")
				
				$Lon_x:=$Col_resname.indexOf($Ptr_me->)
				$Boo_OK:=($Lon_x=-1)
				
				If (Not:C34($Boo_OK))
					
					  //#TO_BE_DONE - except for me & diacritical
					
				End if 
				
				If (Not:C34($Boo_OK))
					
					ALERT:C41(Replace string:C233(Get localized string:C991("theNameIsAlreadyTaken");"{name}";$Ptr_me->))
					
					$Boo_OK:=Shift down:C543  //I know what I do ;-)
					
				End if 
			End if 
			
		Else 
			
			ALERT:C41(Get localized string:C991("theNameMustNotBeEmpty"))
			
		End if 
		
		If ($Boo_OK)
			
			Form:C1466.message(New object:C1471(\
				"target";"resname";\
				"value";$Ptr_me->))
			
		Else 
			
			  // Restore the old value
			Form:C1466.dynamic($Txt_me)->:=Form:C1466.$current.resname
			HIGHLIGHT TEXT:C210(*;$Txt_me;1;32000)
			GOTO OBJECT:C206(*;$Txt_me)
			
		End if 
		
		  //  CALL SUBFORM CONTAINER(-$Lon_formEvent)
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
		
		  //______________________________________________________
End case 