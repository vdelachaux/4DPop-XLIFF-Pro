//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : doc_SET_WRITABLE
  // Database: 4D unitTest
  // ID[E67B3320E829415E93F9C9544B757391]
  // Created #25-6-2014 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($1)

C_BOOLEAN:C305($Boo_invisible;$Boo_locked)
C_DATE:C307($Dat_createdOn;$Dat_modifiedOn)
C_LONGINT:C283($Lon_parameters;$Lon_platform)
C_TIME:C306($Gmt_createdAt;$Gmt_modifiedAt)
C_TEXT:C284($Txt_cmd;$Txt_error;$Txt_in;$Txt_out;$Txt_path)

If (False:C215)
	C_TEXT:C284(doc_SET_WRITABLE ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  //Required parameters
	$Txt_path:=$1
	
	  //Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------

If (Test path name:C476($Txt_path)=Is a document:K24:1)
	
	GET DOCUMENT PROPERTIES:C477($Txt_path;$Boo_locked;$Boo_invisible;$Dat_createdOn;$Gmt_createdAt;$Dat_modifiedOn;$Gmt_modifiedAt)
	SET DOCUMENT PROPERTIES:C478($Txt_path;False:C215;$Boo_invisible;$Dat_createdOn;$Gmt_createdAt;$Dat_modifiedOn;$Gmt_modifiedAt)
	
Else 
	
	_O_PLATFORM PROPERTIES:C365($Lon_platform)
	
	SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_HIDE_CONSOLE";"true")
	SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_CURRENT_DIRECTORY";$Txt_path)
	
	If ($Lon_platform=Windows:K25:3)
		
		$Txt_cmd:="attrib.exe -R /S /D"
		LAUNCH EXTERNAL PROCESS:C811($Txt_cmd;$Txt_in;$Txt_out;$Txt_error)
		
	Else 
		
		$Txt_cmd:="chmod -R 777 "+Replace string:C233(Convert path system to POSIX:C1106($Txt_path);" ";"\\ ")
		LAUNCH EXTERNAL PROCESS:C811($Txt_cmd;$Txt_in;$Txt_out;$Txt_error)
		
	End if 
End if 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End 