  // ----------------------------------------------------
  // Form method : PROJECT_SETTINGS - (4DPop XLIFF Pro)
  // ID[341E434CC56849799103096435C51879]
  // Created #11-5-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($Lon_bottom;$Lon_count;$Lon_formEvent;$Lon_height;$Lon_i;$Lon_left)
C_LONGINT:C283($Lon_right;$Lon_top;$Lon_vOffset)

  // ----------------------------------------------------
  // Initialisations
$Lon_formEvent:=Form event code:C388

  // ----------------------------------------------------

Case of 
		
		  //______________________________________________________
	: ($Lon_formEvent=On Load:K2:1)
		
		ui_SET_EMOJI_FONT ("source.flag";"target.flags")
		
		OBJECT SET ENABLED:C1123(*;"validate";False:C215)
		
		If (Is nil pointer:C315(OBJECT Get pointer:C1124(Object subform container:K67:4)))  // Test UI
			
			Form:C1466.languages:=New collection:C1472
			Form:C1466.languages.push(New object:C1471(\
				"regional";"🇺🇸";\
				"language";"en"))
			
			  // Form.languages.push(New object("regional";"🇫🇷";"language";"fr"))
			  // Form.languages.push(New object("regional";"🇯🇵";"language";"ja"))
			  // Form.languages.push(New object("regional";"🇩🇪";"language";"de"))
			Form:C1466.backup:=New object:C1471(\
				"language";Form:C1466.language;\
				"languages";Form:C1466.languages.copy())
			
			SET TIMER:C645(-1)
			
		End if 
		
		  //______________________________________________________
	: ($Lon_formEvent=On Unload:K2:2)
		
		OB REMOVE:C1226(Form:C1466;"backup")
		
		  //________________________________________
	: ($Lon_formEvent=On Bound Variable Change:K2:52)
		
		Form:C1466.backup:=New object:C1471(\
			"language";Form:C1466.language;\
			"languages";Form:C1466.languages.copy())
		
		SET TIMER:C645(-1)
		
		  //______________________________________________________
	: ($Lon_formEvent=On Timer:K2:25)
		
		SET TIMER:C645(0)
		
		  // Set the path
		(OBJECT Get pointer:C1124(Object named:K67:5;"path"))->:=Storage:C1525.editor.directory
		
		  // Set the type, message & placeholder
		PathPicker SET TYPE ("path";Is a document:K24:1)
		PathPicker SET OPTIONS ("path";False:C215;1)
		
		COLLECTION TO ARRAY:C1562(Form:C1466.languages.extract("language");(OBJECT Get pointer:C1124(Object named:K67:5;"target.language"))->)
		COLLECTION TO ARRAY:C1562(Form:C1466.languages.extract("regional");(OBJECT Get pointer:C1124(Object named:K67:5;"target.flags"))->)
		
		  // Create action icons column
		$Lon_count:=Form:C1466.languages.length
		ARRAY PICTURE:C279($tPic_actions;$Lon_count)
		
		READ PICTURE FILE:C678(Get 4D folder:C485(Current resources folder:K5:16)+"Images"+Folder separator:K24:12+"edit.png";$tPic_actions{1})
		
		If (String:C10(Form:C1466.files[0].fullName)="")  // Allow reference language change for a project without localization
			
			TRANSFORM PICTURE:C988($tPic_actions{1};Crop:K61:7;10;10;27;27)  // Activated
			
		Else 
			
			TRANSFORM PICTURE:C988($tPic_actions{1};Crop:K61:7;10;155;27;27)  // Inactivated
			
		End if 
		
		TRANSFORM PICTURE:C988($tPic_actions{1};Scale:K61:2;0.6;0.6)
		TRANSFORM PICTURE:C988($tPic_actions{1};Translate:K61:3;0;8)
		
		READ PICTURE FILE:C678(Get 4D folder:C485(Current resources folder:K5:16)+"Images"+Folder separator:K24:12+"delete.png";$tPic_actions{0})
		TRANSFORM PICTURE:C988($tPic_actions{0};Crop:K61:7;10;155;27;27)  // Inactivated
		TRANSFORM PICTURE:C988($tPic_actions{0};Scale:K61:2;0.6;0.6)
		TRANSFORM PICTURE:C988($tPic_actions{0};Translate:K61:3;0;8)
		
		For ($Lon_i;2;$Lon_count;1)
			
			$tPic_actions{$Lon_i}:=$tPic_actions{0}
			
		End for 
		
		  //%W-518.1
		COPY ARRAY:C226($tPic_actions;(OBJECT Get pointer:C1124(Object named:K67:5;"action"))->)
		  //%W+518.1
		
		READ PICTURE FILE:C678(Get 4D folder:C485(Current resources folder:K5:16)+"Images"+Folder separator:K24:12+"add.png";$tPic_actions{0})
		TRANSFORM PICTURE:C988($tPic_actions{0};Crop:K61:7;10;10;27;27)
		TRANSFORM PICTURE:C988($tPic_actions{0};Scale:K61:2;0.6;0.6)
		TRANSFORM PICTURE:C988($tPic_actions{0};Translate:K61:3;0;8)
		
		LISTBOX INSERT ROWS:C913(*;"localizations";MAXLONG:K35:2)
		(OBJECT Get pointer:C1124(Object named:K67:5;"action"))->{$Lon_i}:=$tPic_actions{0}
		
		  // Resize listbox
		OBJECT GET COORDINATES:C663(*;"localizations";$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
		$Lon_height:=LISTBOX Get rows height:C836(*;"localizations")*(Form:C1466.languages.length+1)
		
		$Lon_vOffset:=($Lon_bottom-$Lon_top)-$Lon_height
		$Lon_bottom:=$Lon_top+$Lon_height
		OBJECT SET COORDINATES:C1248(*;"localizations";$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
		
		  //______________________________________________________
End case 