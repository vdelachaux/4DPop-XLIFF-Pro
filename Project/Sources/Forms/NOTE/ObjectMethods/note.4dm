  // ----------------------------------------------------
  // Object method : NOTE.note - (4DPop XLIFF Pro)
  // ID[C39246E27CDA42AE95588BD9A642C0D6]
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
		
		  //______________________________________________________
	: ($Lon_formEvent=On Data Change:K2:15)
		
		  // Set the value
		(OBJECT Get pointer:C1124(Object subform container:K67:4))->:=$Ptr_me->
		
		  //______________________________________________________
	: ($Lon_formEvent=On Losing Focus:K2:8)
		
		  // Close me
		$Lon_formEvent:=On Close Box:K2:21
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
		
		  //______________________________________________________
End case 

  // Notify the container
CALL SUBFORM CONTAINER:C1086(-$Lon_formEvent)