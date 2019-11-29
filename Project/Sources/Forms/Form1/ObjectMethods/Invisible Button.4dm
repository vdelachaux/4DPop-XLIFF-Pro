  // ----------------------------------------------------
  // Object method : Form1.Invisible Button - (4DPop XLIFF Pro)
  // ID[64D257C0F7EE42858B063C04F9793BC9]
  // Created 27/12/2016 by Designer
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($Lon_;$Lon_bottom;$Lon_formEvent;$Lon_left;$Lon_offset;$Lon_right)
C_LONGINT:C283($Lon_top;$Lon_x;$Lon_y)
C_TEXT:C284($Txt_me)

  // ----------------------------------------------------
  // Initialisations
$Lon_formEvent:=Form event code:C388

$Txt_me:=OBJECT Get name:C1087(Object current:K67:2)
  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($Lon_formEvent=On Clicked:K2:4)
		
		OBJECT GET COORDINATES:C663(*;$Txt_me;$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
		
		GET MOUSE:C468($Lon_x;$Lon_y;$Lon_)
		
		If ($Lon_y>370)  //max 
			
			$Lon_top:=370-9
			$Lon_bottom:=370
			
		End if 
		
		OBJECT GET COORDINATES:C663(*;"Variable";$Lon_;$Lon_;$Lon_;$Lon_offset)
		
		$Lon_offset:=$Lon_bottom-$Lon_offset
		
		  //Resize target
		OBJECT MOVE:C664(*;"Variable";0;0;0;$Lon_offset)
		
		  //Position the handle
		OBJECT SET COORDINATES:C1248(*;"handle";$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
		
		  //Position the undermost elements
		OBJECT MOVE:C664(*;"rectangle";0;$Lon_offset)
		
		  //______________________________________________________
	: ($Lon_formEvent=On Mouse Leave:K2:34)
		
		OBJECT GET COORDINATES:C663(*;"handle";$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
		
		OBJECT SET COORDINATES:C1248(*;$Txt_me;$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Form event activated unnecessary ("+String:C10($Lon_formEvent)+")")
		
		  //______________________________________________________
End case 