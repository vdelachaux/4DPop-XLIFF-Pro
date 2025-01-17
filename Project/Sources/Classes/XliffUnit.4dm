/*
The <trans-unit> elements contains a <source>, <target> and 
associated elements.

The required id attribute is used to uniquely identify the <trans-unit> within 
all <trans-unit> and <bin-unit> elements within the same <file>. The optional 
approved attribute indicates whether the translation has been approved by a 
reviewer. The optional translate attribute indicates whether the <trans-unit> is 
to be translated. The optional reformat attribute specifies whether and which 
attributes can be modified for the <target> element of the <trans-unit> . The 
optional xml:space attribute is used to specify how white-spaces are to be 
treated within the <trans-unit>. The optional datatype attribute specifies the 
data type of the content of the <trans-unit>; e.g. "winres" for Windows 
resources. The optional ts attribute was DEPRECATED in XLIFF 1.1. The optional 
phase-name attribute references the phase that the <trans-unit> is in. The 
optional restype, resname, extradata, help-id, menu, menu-option, menu-name , 
coord, font, css-style, style, exstyle, and extype attributes describe the 
resource contained within the <trans-unit>. The optional maxbytes and minbytes 
attributes specify the required maximum and minimum number of bytes for the text 
inside the <source> and <target> elements of the <trans-unit>. The optional size-
unit attribute determines the unit for the optional maxheight, minheight, 
maxwidth, and minwidth attributes, which limit the size of the resource 
described by the <trans-unit>. The optional charclass attribute restricts all 
<source> and <target> text in the scope of the <trans-unit> to a subset of 
characters. Lists of values for the datatype, restype, and size-unit attributes 
are provided by this specification. During translation the content of the 
<source> element may be duplicated into a <seg-source> element, in which 
additional segmentation related markup is introduced. See the Segmentation 
section for more information.

Required attributes:

<id>

Optional attributes:

approved, translate, reformat, xml:space , datatype, ts, phase-name , <restype>, 
<resname>, extradata , help-id, menu, menu-option , menu-name, coord, font, css-
style, style, exstyle, extype, maxbytes, minbytes , size-unit, maxheight, 
minheight, maxwidth, minwidth , charclass, non-XLIFF attributes

Contents:

One <source> element, followed by
Zero or one <seg-source> element, followed by
Zero or one <target> element, followed by
Zero, one or more <context-group>, <count-group>, <prop-group>, <note>, <alt-
trans> elements, in any order, followed by
Zero, one or more non-XLIFF elements.

All child elements of <trans-unit> pertain to their sibling <source> element.
While for backward compatibility reasons no order is enforced for the elements 
before the non-XLIFF elements, the recommended order is the one in which they 
are listed here.
*/
property source : Object:={value: ""; xpath: ""}
property target : Object:={value: ""; xpath: ""}
property note:=""

property node; resname; xpath; id : Text
property attributes : Object
property noTranslate : Boolean

property isUnit:=True:C214
property isGroup:=False:C215

Class constructor($node : Text; $attributes : Object)
	
	This:C1470.node:=$node
	This:C1470.attributes:=$attributes || {}
	This:C1470.resname:=String:C10(This:C1470.attributes.resname)
	This:C1470.xpath:=String:C10($attributes.xpath)
	This:C1470.id:=String:C10(This:C1470.attributes.id)
	This:C1470.noTranslate:=Bool:C1537(This:C1470.attributes.translate="no")
	