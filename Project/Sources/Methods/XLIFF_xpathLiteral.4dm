//%attributes = {"invisible":true}
// XLIFF_xpathLiteral ( value ) -> XPath string literal for value, usable even if value contains " or '
// abc -> "abc" ; Say "hi" -> 'Say "hi"' ; both quotes -> concat("…",'"',"…")
// Note: the XPath of 4D 21 R4 does not evaluate concat(): a value that contains both " and ' is still not found
#DECLARE($value : Text) : Text

Case of 
		
		//______________________________________________________
	: (Position:C15("\""; $value)=0)
		
		return "\""+$value+"\""
		
		//______________________________________________________
	: (Position:C15("'"; $value)=0)
		
		return "'"+$value+"'"
		
		//______________________________________________________
	Else 
		
		return "concat(\""+Replace string:C233($value; "\""; "\",'\"',\"")+"\")"
		
		//______________________________________________________
End case 
