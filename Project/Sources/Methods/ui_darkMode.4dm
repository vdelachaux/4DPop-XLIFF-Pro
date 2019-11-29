//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : ui_darkMode
  // Database: 4DPop XLIFF Pro
  // ID[213EC1162AC740D6815DDDCA8EF2A6AC]
  // Created #30-11-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Return true if dark mode is on
  // ----------------------------------------------------
  // Declarations
C_BOOLEAN:C305($0)

C_TEXT:C284($Txt_error;$Txt_input;$Txt_output)

If (False:C215)
	C_BOOLEAN:C305(ui_darkMode ;$0)
End if 

  // ----------------------------------------------------
If (Is macOS:C1572)
	
	LAUNCH EXTERNAL PROCESS:C811("defaults read -g AppleInterfaceStyle";$Txt_input;$Txt_output;$Txt_error)
	$0:=($Txt_output="Dark\n")
	
Else 
	
	$0:=False:C215
	
End if 