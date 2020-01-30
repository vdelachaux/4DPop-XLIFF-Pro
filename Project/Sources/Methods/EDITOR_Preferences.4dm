//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : EDITOR_Preferences
  // Database: 4DPop XLIFF Pro
  // ID[9E3894AB70404057BB9905641BE42148]
  // Created #8-3-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($File_setting;$Txt_key)
C_OBJECT:C1216($Obj_default;$Obj_in;$Obj_out;$Obj_settings)

If (False:C215)
	C_OBJECT:C1216(EDITOR_Preferences ;$0)
	C_OBJECT:C1216(EDITOR_Preferences ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // Required parameters
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		$Obj_in:=$1
		
	End if 
	
	$File_setting:=Get 4D folder:C485(Database folder:K5:14;*)+"Preferences"+Folder separator:K24:12+"4DPop XLIFF.settings"
	
	If (Test path name:C476($File_setting)=Is a document:K24:1)
		
		  // Get
		$Obj_settings:=JSON Parse:C1218(Document to text:C1236($File_setting))
		
	Else 
		
		  // Create
		$Obj_settings:=New object:C1471(\
			"reference";Get database localization:C1009(Default localization:K5:21);\
			"file";"")
		
		  // Create folder if not exist
		CREATE FOLDER:C475($File_setting;*)
		
	End if 
	
	  // Default values
	$Obj_default:=New object:C1471(\
		"reference";"en";\
		"file";"")
	
	  // Update if any
	For each ($Txt_key;$Obj_default)
		
		If ($Obj_settings[$Txt_key]=Null:C1517)
			
			$Obj_settings[$Txt_key]:=$Obj_default[$Txt_key]
			
		End if 
	End for each 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If (Bool:C1537($Obj_in.set))
	
	If ($Obj_in.key=Null:C1517)
		
		If (Asserted:C1132($Obj_in.value#Null:C1517;"missing value"))
			
			  // Save the passed preferences
			$Obj_settings:=$Obj_in.value
			
		End if 
		
	Else 
		
		If ($Obj_in.value=Null:C1517)\
			 | (Length:C16(String:C10($Obj_in.value))=0)
			
			  // Remove the key
			OB REMOVE:C1226($Obj_settings;$Obj_in.key)
			
		Else 
			
			If (Asserted:C1132($Obj_in.value#Null:C1517;"missing value"))
				
				  // Set the value
				$Obj_settings[$Obj_in.key]:=$Obj_in.value
				
			End if 
		End if 
	End if 
	
	TEXT TO DOCUMENT:C1237($File_setting;JSON Stringify:C1217($Obj_settings;*))
	
Else 
	
	Case of 
			
			  //______________________________________________________
		: ($Obj_in.key=Null:C1517)
			
			$Obj_out:=$Obj_settings
			
			  //______________________________________________________
		: ($Obj_settings[$Obj_in.key]#Null:C1517)
			
			$Obj_out:=New object:C1471(\
				"value";$Obj_settings[$Obj_in.key])
			
			  //______________________________________________________
		Else 
			
			  //ASSERT(False;"Unknown entry point: \""+String($Obj_in.key)+"\"")
			
			  //______________________________________________________
	End case 
End if 

  // ----------------------------------------------------
  // Return
$0:=$Obj_out

  // ----------------------------------------------------
  // End 