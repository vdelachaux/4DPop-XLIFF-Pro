//%attributes  = {"invisible":true}
  // ----------------------------------------------------
  // Project method : DISPLAY_INIT
  // Database: 4DPop XLIFF Pro
  // ID[026D507241AA4F729306A2BC4B66B4EC]
  // Created #13-10-2015 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($1)

C_LONGINT:C283($Lon_;$Lon_bottom;$Lon_height;$Lon_i;$Lon_left;$Lon_parameters)
C_LONGINT:C283($Lon_right;$Lon_top)
C_POINTER:C301($Ptr_nil)
C_TEXT:C284($Txt_object)
C_OBJECT:C1216($Obj_in;$Obj_language)

ARRAY TEXT:C222($tTxt_objects;0)
ARRAY TEXT:C222($tTxt_tabOrder;0)

If (False:C215)
	C_OBJECT:C1216(DISPLAY_INIT ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Obj_in:=$1
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		  // <NONE>
		
	End if 
	
	  // Get the source line height…
	OBJECT GET COORDINATES:C663(*;"unit.source";$Lon_;$Lon_top;$Lon_right;$Lon_bottom)
	$Lon_height:=$Lon_bottom-$Lon_top+25
	$Lon_right:=$Lon_right+18
	
	  // …and the total source height
	OBJECT GET COORDINATES:C663(*;"unit.notranslate";$Lon_;$Lon_;$Lon_;$Lon_bottom)
	$Lon_top:=$Lon_bottom+2
	
	APPEND TO ARRAY:C911($tTxt_tabOrder;"resname.box")
	APPEND TO ARRAY:C911($tTxt_tabOrder;"unit.source")
	
	  // Mask all lines
	OBJECT SET VISIBLE:C603(*;"lang_@";False:C215)
	
	FORM GET OBJECTS:C898($tTxt_objects;Form current page:K67:6)
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
  // UI
obj_BEST_WIDTH (Align left:K42:2;"unit.notranslate")

  // For each languages
For each ($Obj_language;$Obj_in.languages)
	
	If ($Obj_language.language#$Obj_in.language)  // Not the reference language
		
		$Txt_object:="lang_"+$Obj_language.language
		
		If (Find in array:C230($tTxt_objects;$Txt_object)<0)
			
			  // Create line
			OBJECT DUPLICATE:C1111(*;"_template";$Txt_object;$Ptr_nil;"lang_"+String:C10($Lon_i-1);0;0)
			
		End if 
		
		OBJECT GET COORDINATES:C663(*;$Txt_object;$Lon_left;$Lon_;$Lon_;$Lon_)
		$Lon_bottom:=$Lon_top+$Lon_height
		OBJECT SET COORDINATES:C1248(*;$Txt_object;$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
		
		OBJECT SET VISIBLE:C603(*;$Txt_object;False:C215)
		
		  // Asign it the language object
		(OBJECT Get pointer:C1124(Object named:K67:5;$Txt_object))->:=$Obj_language
		
		APPEND TO ARRAY:C911($tTxt_tabOrder;$Txt_object)
		
		$Lon_i:=$Lon_i+1
		$Lon_top:=$Lon_bottom+5
		
	End if 
End for each 

FORM SET ENTRY ORDER:C1468($tTxt_tabOrder)

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End 