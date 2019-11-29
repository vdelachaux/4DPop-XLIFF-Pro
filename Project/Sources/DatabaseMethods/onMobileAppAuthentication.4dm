C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_BOOLEAN:C305($Boo_simulator)
C_TEXT:C284($Txt_appID;$Txt_appName;$Txt_appVersion;$Txt_device;$Txt_deviceID;$Txt_email)
C_TEXT:C284($Txt_IP;$Txt_languageCode;$Txt_languageId;$Txt_languageRegion;$Txt_osVersion;$Txt_sessionId)
C_TEXT:C284($Txt_teamID)
C_OBJECT:C1216($Obj_request;$Obj_response)

$Obj_request:=$1  // Informations provided by mobile application and 4D server

$Obj_response:=New object:C1471  // Informations returned by 4D developer

  // Get user email (Not mandatory)
$Txt_email:=String:C10($Obj_request.email)

If (Length:C16($Txt_email)=0)
	
	  // Guest mode - allow connection
	$Obj_response.success:=True:C214
	
	  // Optional welcome message to display on mobile App.
	$Obj_response.statusText:="Welcome to my application"
	
Else 
	
	  // Authenticated mode -  Allow or not the connection
	If (Is compiled mode:C492)  // Deployment
		
		  // Allow, for example, all emails in the domain 4D.com
		$Obj_response.success:=($Obj_request.email=("@"+Char:C90(At sign:K15:46)+"4d.com"))
		
	Else   // Development
		
		  // Allow all addresses for tests
		$Obj_response.success:=True:C214
		
	End if 
	
	If ($Obj_response.success)
		
		  // Optional welcome message to display on mobile App.
		$Obj_response.statusText:="You are successfully authenticated"
		
	Else 
		
		$Obj_response.statusText:=$Obj_request.email+" is not an authorized email address."
		
	End if 
End if 

  // Get the App informations (C_OBJECT)
If ($Obj_request.application#Null:C1517)
	
	  // App Id
	$Txt_appID:=$Obj_request.application.id
	
	  // App Name
	$Txt_appName:=$Obj_request.application.name
	
	  // App Version
	$Txt_appVersion:=$Obj_request.application.version
	
End if 

  // Get the Device informations (C_OBJECT)
If ($Obj_request.device#Null:C1517)
	
	  // Device Description
	$Txt_device:=$Obj_request.device.description
	
	  // Device Id
	$Txt_deviceID:=$Obj_request.device.id
	
	  // System Version
	$Txt_osVersion:=$Obj_request.device.version
	
	  // True if the Device is a Simulator
	$Boo_simulator:=$Obj_request.device.simulator
	
End if 

  // Get the Team informations (C_OBJECT)
If ($Obj_request.team#Null:C1517)
	
	  // Team Id
	$Txt_teamID:=$Obj_request.team.id
	
End if 

  // Get the User Language informations (C_OBJECT)
If ($Obj_request.language#Null:C1517)
	
	  // User current language, ex: en
	$Txt_languageCode:=$Obj_request.language.Code
	
	  // User current language id, ex: en_US
	$Txt_languageId:=$Obj_request.language.id
	
	  // User current region, ex: US
	$Txt_languageRegion:=$Obj_request.language.Region
	
End if 

  // Get the Session informations (C_OBJECT)
If ($Obj_request.session#Null:C1517)
	
	  // Could be stored for future use.
	
	  // Session UUID created for this authentication.
	$Txt_sessionId:=$Obj_request.session.id
	
	  // Session IP address.
	$Txt_IP:=$Obj_request.session.ip
	
End if 

  // Get the App parameters (C_OBJECT)
If ($Obj_request.parameters#Null:C1517)
	
	  // Any additional information that could be added by mobile app for custom use (C_OBJECT)
	
End if 

$0:=$Obj_response