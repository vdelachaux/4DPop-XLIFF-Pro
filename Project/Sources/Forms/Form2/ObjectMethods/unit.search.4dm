  // ----------------------------------------------------
  // Object method : EDITOR.unit.search - (4DPop XLIFF Pro)
  // ID[84EFEA5E739C463E987FEEF40E3D73F6]
  // Created #28-12-2016 by Vincent de Lachaux
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($Lon_bottom;$Lon_formEvent;$Lon_left;$Lon_right;$Lon_top)
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
	: ($Lon_formEvent=On Load:K2:1)\
		 | ($Lon_formEvent=On Unload:K2:2)
		
		  // Restore default properties & positions
		OBJECT SET RGB COLORS:C628(*;"search.border";0x00E5E5E5;Background color:K23:2)
		
		OBJECT GET COORDINATES:C663(*;"search.border";$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
		OBJECT SET COORDINATES:C1248(*;"search.glass";$Lon_left+70;$Lon_top+3;$Lon_left+70+14;$Lon_top+3+14)
		OBJECT SET COORDINATES:C1248(*;"unit.search";$Lon_left+70+17;$Lon_top+2;$Lon_right-3;$Lon_bottom-2)
		
		  //______________________________________________________
	: ($Lon_formEvent=On Getting Focus:K2:7)
		
		  // Expand
		OBJECT GET COORDINATES:C663(*;"search.border";$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
		OBJECT SET COORDINATES:C1248(*;"search.glass";$Lon_left+3;$Lon_top+3;$Lon_left+3+14;$Lon_top+3+14)
		OBJECT SET COORDINATES:C1248(*;"unit.search";$Lon_left+3+17;$Lon_top+2;$Lon_right-3;$Lon_bottom-2)
		
		OBJECT SET RGB COLORS:C628(*;"search.border";Highlight text background color:K23:5;Background color:K23:2)
		
		  //______________________________________________________
	: ($Lon_formEvent=On Losing Focus:K2:8)
		
		If (Length:C16(Get edited text:C655)=0)
			
			  // Collapse
			OBJECT GET COORDINATES:C663(*;"search.border";$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
			OBJECT SET COORDINATES:C1248(*;"search.glass";$Lon_left+70;$Lon_top+3;$Lon_left+70+14;$Lon_top+3+14)
			OBJECT SET COORDINATES:C1248(*;"unit.search";$Lon_left+70+17;$Lon_top+2;$Lon_right-3;$Lon_bottom-2)
			
		End if 
		
		OBJECT SET RGB COLORS:C628(*;"search.border";0x00E5E5E5;Background color:K23:2)
		
		  //______________________________________________________
	: ($Lon_formEvent=On After Edit:K2:43)
		
		  // Restore default colors
		OBJECT SET RGB COLORS:C628(*;"unit.search";Foreground color:K23:1;Background color:K23:2)
		
		  //______________________________________________________
	: ($Lon_formEvent=On Data Change:K2:15)
		
		If (Length:C16($Ptr_me->)#0)
			
			  // Doing the search
			EDITOR_SEARCH ($Ptr_me->)
			
			  // Stay on the current object
			GOTO OBJECT:C206(*;$Txt_me)
			
		End if 
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Form event activated unnecessary ("+String:C10($Lon_formEvent)+")")
		
		  //______________________________________________________
End case 