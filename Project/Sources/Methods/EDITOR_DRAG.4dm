//%attributes  = {"invisible":true}
  // ----------------------------------------------------
  // Project method : EDITOR_DRAG
  // Database: 4DPop XLIFF Pro
  // ID[4F610F3935B74B3FB31FE775CF032B34]
  // Created #14-2-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_BOOLEAN:C305($Boo_formEditor;$Boo_intl;$Boo_modifier)
C_LONGINT:C283($Lon_i;$Lon_number;$Lon_parameters;$Lon_x;$Lon_y;$Win_hdl)
C_TEXT:C284($Txt_buffer;$Txt_container)
C_OBJECT:C1216($Obj_unit)

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // NO PARAMETERS REQUIRED
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		  // <NONE>
		
	End if 
	
	  // Get the window kind (method or form editor) to determine what to put in the drag container
	$Win_hdl:=Current form window:C827
	
	$Win_hdl:=Choose:C955(Window kind:C445($Win_hdl)=Floating window:K27:4;\
		Frontmost window:C447;\
		Next window:C448($Win_hdl))
	
	$Txt_buffer:=Get window title:C450($Win_hdl)
	
	If (Position:C15("-";$Txt_buffer)>0)  // Compatibility with 4DPop Windows, if any
		
		$Txt_buffer:=Delete string:C232($Txt_buffer;1;Position:C15("-";$Txt_buffer)+1)
		
	End if 
	
	  //#TO_BE_DONE - localize
	$Boo_formEditor:=(Position:C15("Form";$Txt_buffer)=1)
	
	  // Check modifier to invert the logic
	$Boo_modifier:=(Macintosh option down:C545 | Windows Alt down:C563)
	
	If ($Boo_modifier)
		
		$Boo_formEditor:=Choose:C955($Boo_formEditor;\
			($Boo_formEditor & (Not:C34($Boo_modifier)));\
			$Boo_modifier)
		
	End if 
	
	CLEAR PASTEBOARD:C402
	
Else 
	
	ABORT:C156
	
End if 

  //  LISTBOX GET CELL POSITION(*;"string.ist";$Lon_column;$Lon_row)

EDITOR_DISPLAY 

  // ----------------------------------------------------
If (Form:C1466.$current#Null:C1517)
	
	If (Form:C1466.$target="unit")
		
		If ($Boo_formEditor)
			
			  // Paste as reference
			$Txt_container:=":xliff:"+Form:C1466.$current.resname
			
		Else 
			
			If (Length:C16(String:C10(Form:C1466.$current.source.value))>0)
				
				If (Shift down:C543)
					
					  // Paste as comment
					$Txt_container:="//"+Replace string:C233(Form:C1466.$current.source.value;"\n";" ")
					
				Else 
					
					  // Paste code
					$Lon_x:=Position:C15("{";Form:C1466.$current.source.value)
					
					If ($Lon_x>0)
						
						  // -> Replace string(Get localized string("Resname");"{xxxx}";VALUE)
						$Lon_y:=Position:C15("}";Form:C1466.$current.source.value;$Lon_x+1)
						$Txt_container:=Command name:C538(233)+"("\
							+Command name:C538(991)+"(\""+Form:C1466.$current.resname+"\");\""\
							+Substring:C12(Form:C1466.$current.source.value;$Lon_x;$Lon_y-$Lon_x+1)\
							+"\";VALUE)"
						
					Else 
						
						  // -> Get localized string("Resname")
						$Txt_container:=Command name:C538(991)+"(\""+Form:C1466.$current.resname+"\")"
						
					End if 
				End if 
			End if 
		End if 
		
	Else 
		
		If (Not:C34($Boo_formEditor))
			
			  // Construct the code to load all strings into a text array
			$Lon_number:=Form:C1466.$current.units.length
			
			If ($Lon_number>0)
				
				  // Get the programming language
				$Boo_intl:=(Command name:C538(1)="Sum")
				
				  // -> ARRAY TEXT($tTxt_resources;size)
				$Txt_container:=":C222($tTxt_resources;"+String:C10($Lon_number)+")\r"
				
				  // Get the first resname to detect if it's indexed
				If (Form:C1466.$current.units[0].resname=(Form:C1466.$current.resname+"_1"))
					
					  // The first resname is indexed. We assume that all the others are also.
					  // We can therefore minimize the code into a loop
					$Txt_container:=$Txt_container\
						+Choose:C955($Boo_intl;"For";"Boucle")+"($Lon_i;1;"+String:C10($Lon_number)+";1)\r\r"\
						+"$tTxt_resources{$Lon_i}:=:C991(\""+Form:C1466.$current.resname+"_\"+:C10($Lon_i)"+")\r\r"\
						+Choose:C955($Boo_intl;"End for";"Fin de boucle")+"\r"
					
				Else 
					
					For each ($Obj_unit;Form:C1466.$current.units)
						
						$Lon_i:=$Lon_i+1
						
						$Txt_container:=$Txt_container\
							+"$tTxt_resources{"+String:C10($Lon_i)+"}:=:C991(\""+$Obj_unit.resname+"\")\r"
						
					End for each 
					
					  // Force the tokenization of the last line
					$Txt_container:=$Txt_container+"\r"
					
				End if 
			End if 
		End if 
	End if 
End if 

SET TEXT TO PASTEBOARD:C523($Txt_container)

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End 