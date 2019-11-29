  // ----------------------------------------------------
  // Form method : LANGUE - (4DPop XLIFF Pro)
  // ID[8A7569B5707841098DF14B9658A8A94E]
  // Created #13-10-2015 by Vincent de Lachaux
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($Lon_bottom;$Lon_formEvent;$Lon_height;$Lon_left;$Lon_right;$Lon_top)
C_LONGINT:C283($Lon_width)

  // ----------------------------------------------------
  // Initialisations
$Lon_formEvent:=Form event code:C388

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($Lon_formEvent=On Load:K2:1)
		
		ui_SET_EMOJI_FONT ("flag")
		
		SET TIMER:C645(-1)
		
		  //______________________________________________________
	: ($Lon_formEvent=On Unload:K2:2)
		
		  //______________________________________________________
	: ($Lon_formEvent=On Timer:K2:25)
		
		SET TIMER:C645(0)
		
		  //______________________________________________________
	: ($Lon_formEvent=On Activate:K2:9)
		
		If (OBJECT Get pointer:C1124(Object with focus:K67:3)=OBJECT Get pointer:C1124(Object subform container:K67:4))
			
			GOTO OBJECT:C206(*;"value")
			HIGHLIGHT TEXT:C210(*;"value";1;MAXLONG:K35:2)
			
		End if 
		
		SPELL SET CURRENT DICTIONARY:C904(OB Get:C1224(obj_Container ->;"language";Is text:K8:3))
		
		  //______________________________________________________
	: ($Lon_formEvent=On Bound Variable Change:K2:52)
		
		If (Form:C1466#Null:C1517)
			
			obj_Dynamic ("flag")->:=Form:C1466.regional
			obj_Dynamic ("lang")->:=Form:C1466.language
			
			If (Position:C15(String:C10(Form:C1466.state);"needs-translation|new";*)>0)
				
				obj_Dynamic ("value")->:=""
				OBJECT SET PLACEHOLDER:C1295(*;"value";Form:C1466.value)
				
				  //If (ui_darkMode )
				
				  //OBJECT SET RGB COLORS(*;"value";Foreground color;Background color none)
				
				  //Else 
				
				OBJECT SET RGB COLORS:C628(*;"value";Foreground color:K23:1;0x00FFF8EA)
				
				  //End if 
				
				
			Else 
				
				obj_Dynamic ("value")->:=String:C10(Form:C1466.value)
				OBJECT SET PLACEHOLDER:C1295(*;"value";"")
				
				If (Position:C15(String:C10(Form:C1466.state);"needs-review-translation";*)>0)
					
					  //If (ui_darkMode )
					
					  //OBJECT SET RGB COLORS(*;"value";Disable highlight item color;Dark shadow color)
					
					  //Else 
					
					OBJECT SET RGB COLORS:C628(*;"value";Foreground color:K23:1;0x00FFEFC8)
					
					  //End if 
					
				Else 
					
					OBJECT SET RGB COLORS:C628(*;"value";Foreground color:K23:1;Background color:K23:2)
					
				End if 
			End if 
		End if 
		
		  // Adjust value width
		OBJECT GET SUBFORM CONTAINER SIZE:C1148($Lon_width;$Lon_height)
		OBJECT GET COORDINATES:C663(*;"value";$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
		
		$Lon_top:=5
		$Lon_right:=$Lon_width-18
		$Lon_bottom:=$Lon_height-9
		
		OBJECT SET COORDINATES:C1248(*;"value";$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
		
		  //______________________________________________________
End case 