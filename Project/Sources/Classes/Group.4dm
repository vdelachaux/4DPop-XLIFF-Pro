Class constructor($node : Text; $attributes : Object)
	
/*
The <group> element specifies a set of elements that should be processed 
together. For example: all the items of a menu, etc. Note that a <group> element 
can contain other <group> elements. The <group> element can be used to describe 
the hierarchy of the file.
	
The optional id attribute is used to uniquely identify the <group> within the same <file>. 
	
The optional datatype attribute specifies the data type of the 
content of the <group>; e.g. "winres" for Windows resources. The optional 
xml:space attribute is used to specify how white-spaces are to be treated within 
the <group>.
	
The optional restype, resname, extradata, help-id, menu , menu-option, 
menu-name, coord, font, css-style, style, exstyle, and extype attributes 
describe the resources contained within the <group>.
	
The optional translate attribute provides a default value for all <trans-unit>
elements contained within the <group>.
	
The optional reformat attribute specifies whether and which 
attributes can be modified for the <target> elements of the <group>. 
	
The optional maxbytes and minbytes attributes specify the required maximum and 
minimum number of bytes for the translation units within the <group>. The 
optional size-unit attribute determines the unit for the optional maxheight, 
minheight, maxwidth, and minwidth attributes, which limit the size of the 
resource described by the <group>. 
	
The optional charclass attribute restricts all translation units in the scope 
of the <group> to a subset of characters. 
	
The optional merged-trans attribute indicates if the group element contains merged 
<trans-unit> elements. 
	
The optional ts attribute was DEPRECATED in XLIFF 1.1. 
	
Lists of values for the datatype, restype, and size-unit attributes are provided 
by this specification.
	
Required attributes:
	
None.
	
Optional attributes:
	
id, datatype, xml:space, ts, <restype>, <resname>, extradata, help-id, menu, menu-
option , menu-name, coord, font, css-style, style, exstyle, extype, translate, 
reformat , maxbytes, minbytes, size-unit, maxheight, minheight, maxwidth , 
minwidth, charclass, merged-trans, non-XLIFF attributes
	
Contents:
	
Zero, one or more <context-group> elements, followed by
Zero, one or more <count-group> elements, followed by
Zero, one or more <prop-group> elements, followed by
Zero, one or more <note> elements, followed by
Zero, one or more non-XLIFF elements, followed by
Zero, one or more <group>, <trans-unit>, <bin-unit> elements, in any order.
	
All <context-group>, <count-group>, <prop-group>, <note> and non-XLIFF elements 
pertain to the subsequent elements in the tree but can be overridden within a 
child element.
*/
	
	This:C1470.node:=$node
	This:C1470.attributes:=$attributes || New object:C1471
	This:C1470.resname:=String:C10(This:C1470.attributes.resname)
	This:C1470.XPATH:=String:C10($attributes.XPATH)
	This:C1470.isconstant:=String:C10(This:C1470.attributes.restype)="x-4DK#"
	
	This:C1470.transunits:=[]
	
	This:C1470._xpathPattern:="(?mi-s)(?<=group\\[@resname=\")([^\"]*)"
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function setResname($resname : Text)
	
	var $len; $pos : Integer
	
	This:C1470.resname:=$resname
	This:C1470.attributes.resname:=$resname
	
	If (Match regex:C1019(This:C1470._xpathPattern; This:C1470.XPATH; 1; $pos; $len))
		
		This:C1470.XPATH:=Substring:C12(This:C1470.XPATH; 1; $pos-1)+$resname+Substring:C12(This:C1470.XPATH; $pos+$len)
		
	End if 
	
	This:C1470.updateTransunits()
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function updateTransunits()
	
	var $len; $pos : Integer
	var $unit : cs:C1710.Transunit
	
	For each ($unit; This:C1470.transunits)
		
		If (Match regex:C1019(This:C1470._xpathPattern; $unit.XPATH; 1; $pos; $len))
			
			$unit.XPATH:=Substring:C12($unit.XPATH; 1; $pos-1)+This:C1470.resname+Substring:C12($unit.XPATH; $pos+$len)
			
		End if 
		
		If (Match regex:C1019(This:C1470._xpathPattern; $unit.source.XPATH; 1; $pos; $len))
			
			$unit.source.XPATH:=Substring:C12($unit.source.XPATH; 1; $pos-1)+This:C1470.resname+Substring:C12($unit.source.XPATH; $pos+$len)
			
		End if 
		
		If ($unit.target#Null:C1517)
			
			If (Match regex:C1019(This:C1470._xpathPattern; $unit.target.XPATH; 1; $pos; $len))
				
				$unit.target.XPATH:=Substring:C12($unit.target.XPATH; 1; $pos-1)+This:C1470.resname+Substring:C12($unit.target.XPATH; $pos+$len)
				
			End if 
		End if 
	End for each 
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function setAttributes($attributes : Object)
	
	var $len; $pos : Integer
	var $unit : cs:C1710.Transunit
	
	This:C1470.attributes:=$attributes
	This:C1470.resname:=String:C10(This:C1470.attributes.resname)
	This:C1470.XPATH:=String:C10($attributes.XPATH)
	
	For each ($unit; This:C1470.transunits)
		
		If (Match regex:C1019(This:C1470._xpathPattern; $unit.XPATH; 1; $pos; $len))
			
			$unit.XPATH:=Substring:C12($unit.XPATH; 1; $pos-1)+This:C1470.resname+Substring:C12($unit.XPATH; $pos+$len)
			
		End if 
		
		If (Match regex:C1019(This:C1470._xpathPattern; $unit.source.XPATH; 1; $pos; $len))
			
			$unit.source.XPATH:=Substring:C12($unit.source.XPATH; 1; $pos-1)+This:C1470.resname+Substring:C12($unit.source.XPATH; $pos+$len)
			
		End if 
		
		If ($unit.target#Null:C1517)
			
			If (Match regex:C1019(This:C1470._xpathPattern; $unit.target.XPATH; 1; $pos; $len))
				
				$unit.target.XPATH:=Substring:C12($unit.target.XPATH; 1; $pos-1)+This:C1470.resname+Substring:C12($unit.target.XPATH; $pos+$len)
				
			End if 
		End if 
	End for each 