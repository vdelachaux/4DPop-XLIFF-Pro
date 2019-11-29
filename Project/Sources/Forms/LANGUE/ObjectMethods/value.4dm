  // ----------------------------------------------------
  // Object method : LANGUE.value - (4DPop XLIFF Pro)
  // ID[2CEF6E8A545E48BBAAAF82595C76B9DD]
  // Created #3-11-2015 by Vincent de Lachaux
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
		
		  //______________________________________________________
	: ($Lon_formEvent=On Data Change:K2:15)
		
		Form:C1466.value:=$Ptr_me->
		
		OB REMOVE:C1226(Form:C1466;"state")
		
		OBJECT SET RGB COLORS:C628(*;$Txt_me;Foreground color:K23:1;Background color:K23:2)
		
		CALL SUBFORM CONTAINER:C1086(-$Lon_formEvent)
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
		
		  //______________________________________________________
End case 