//%attributes  = {"invisible":true}
  //C_LONGINT($1;$charCode)
  //C_REAL($2;$fontSize)

  //C_PICTURE($0)

  //$params:=Count parameters

  //If ($params#0)

  //$charCode:=$1

  //If ($charCode>0xFFFF)
  //  //compute surrogate pair
  //$LEAD_OFFSET:=0xD800-(0x00010000 >> 10)
  //$lead:=$LEAD_OFFSET+($charCode >> 10)
  //$trail:=0xDC00+($charCode & 0x03FF)
  //$char:=Char($lead)+Char($trail)
  //Else 
  //$char:=Char($charCode)
  //End if 

  //$svg:=SVG_New 

  //If ($params>1)
  //$fontSize:=$2
  //$fontName:=Choose(Folder separator=":";"Lucida Grande";"Segoe UI Emoji")
  //$text:=SVG_New_text ($svg;$char;0;0;$fontName;$fontSize)
  //Else 
  //$text:=SVG_New_text ($svg;$char)
  //End if 

  //SVG EXPORT TO PICTURE($svg;$image)

  //SVG_CLEAR ($svg)

  //$0:=$image

  //End if 