  // ----------------------------------------------------
  // Form method : FILE_INFOS - (4DPop XLIFF Pro)
  // ID[F3E08E79EE0B45D0B6922B58547107E8]
  // Created #15-5-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Declarations
C_BOOLEAN:C305($Boo_Invisible;$Boo_Locked)
C_DATE:C307($Dat_Created;$Dat_Modified)
C_LONGINT:C283($Lon_formEvent)
C_TIME:C306($Gmt_Created;$Gmt_Modified)
C_TEXT:C284($Txt_Buffer)

ARRAY TEXT:C222($tTxt_found;0)

  // ----------------------------------------------------
  // Initialisations
$Lon_formEvent:=Form event code:C388

  // ----------------------------------------------------

Case of 
		
		  //______________________________________________________
	: ($Lon_formEvent=On Load:K2:1)
		
		GET DOCUMENT PROPERTIES:C477(Form:C1466.nativePath;$Boo_Locked;$Boo_Invisible;$Dat_Created;$Gmt_Created;$Dat_Modified;$Gmt_Modified)
		Form:C1466.creation:=String:C10($Dat_Created)+" - "+String:C10($Gmt_Created)
		Form:C1466.modification:=String:C10($Dat_Modified)+" - "+String:C10($Gmt_Modified)
		Form:C1466.size:=doc_gTxt_BytesToString (Get document size:C479(Form:C1466.nativePath))
		
		If (Position:C15(Get localized string:C991("Bytes");Form:C1466.size)=0)
			
			Form:C1466.size:=Form:C1466.size+" ("+doc_gTxt_BytesToString (Get document size:C479(Form:C1466.nativePath);"O")+")"
			
		End if 
		
		$Txt_Buffer:=Document to text:C1236(Form:C1466.nativePath)
		
		Rgx_ExtractText ("(?m-si)(<file\\s)";$Txt_Buffer;"1";->$tTxt_found)
		Form:C1466.file:=Size of array:C274($tTxt_found)
		Rgx_ExtractText ("(?m-si)(<group\\s)";$Txt_Buffer;"1";->$tTxt_found)
		Form:C1466.group:=Size of array:C274($tTxt_found)
		Rgx_ExtractText ("(?m-si)(<trans-unit\\s)";$Txt_Buffer;"1";->$tTxt_found)
		Form:C1466.unit:=Size of array:C274($tTxt_found)
		
		SET TIMER:C645(-1)
		
		  //______________________________________________________
	: ($Lon_formEvent=On Unload:K2:2)
		
		  //______________________________________________________
	: ($Lon_formEvent=On Timer:K2:25)
		
		SET TIMER:C645(0)
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
		
		  //______________________________________________________
End case 