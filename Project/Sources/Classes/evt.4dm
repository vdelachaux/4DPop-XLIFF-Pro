Class constructor($e : cs:C1710.evt)
	
	// MARK:Common
	This:C1470.objectName:=Null:C1517
	This:C1470.code:=Null:C1517
	This:C1470.description:=Null:C1517
	
	// MARK:List boxes additional properties
	This:C1470.area:=Null:C1517
	This:C1470.areaName:=Null:C1517
	This:C1470.columnName:=Null:C1517
	This:C1470.footerName:=Null:C1517
	This:C1470.headerName:=Null:C1517
	
	This:C1470.column:=Null:C1517
	
	This:C1470.row:=Null:C1517
	This:C1470.isRowSelected:=Null:C1517
	
	This:C1470.horizontalScroll:=Null:C1517
	This:C1470.verticalScroll:=Null:C1517
	
	This:C1470.newPosition:=Null:C1517
	This:C1470.oldPosition:=Null:C1517
	
	This:C1470.newSize:=Null:C1517
	This:C1470.oldSize:=Null:C1517
	
	$e:=$e || FORM Event:C1606
	
	var $key : Text
	
	For each ($key; $e)
		
		This:C1470[$key]:=$e[$key]
		
	End for each 
	
	//MARK:-Form
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get load() : Boolean
	
	return This:C1470.code=On Load:K2:1
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get unload() : Boolean
	
	return This:C1470.code=On Unload:K2:2
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get activate() : Boolean
	
	return This:C1470.code=On Activate:K2:9
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get deactivate() : Boolean
	
	return This:C1470.code=On Deactivate:K2:10
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get resize() : Boolean
	
	return This:C1470.code=On Resize:K2:27
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get close() : Boolean
	
	return This:C1470.code=On Close Box:K2:21
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get validate() : Boolean
	
	return This:C1470.code=On Validate:K2:3
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get menuSelect() : Boolean
	
	return This:C1470.code=On Menu Selected:K2:14
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get outsideCall() : Boolean
	
	return This:C1470.code=On Outside Call:K2:11
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get pageChange() : Boolean
	
	return This:C1470.code=On Page Change:K2:54
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get onTimer() : Boolean
	
	return This:C1470.code=On Timer:K2:25
	
	//MARK:-Printing
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get header() : Boolean
	
	return This:C1470.code=On Header:K2:17
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get printingBreak() : Boolean
	
	return This:C1470.code=On Printing Break:K2:19
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get printingDetail() : Boolean
	
	return This:C1470.code=On Printing Detail:K2:18
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get printingFooter() : Boolean
	
	return This:C1470.code=On Printing Footer:K2:20
	
	//MARK:-Widgets
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get click() : Boolean
	
	return This:C1470.code=On Clicked:K2:4
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get doubleClick() : Boolean
	
	return This:C1470.code=On Double Clicked:K2:5
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get longClick() : Boolean
	
	return This:C1470.code=On Long Click:K2:37
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get alternateClick() : Boolean
	
	return This:C1470.code=On Alternative Click:K2:36
	
	//MARK:-
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get gettingFocus() : Boolean
	
	return This:C1470.code=On Getting Focus:K2:7
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get losingFocus() : Boolean
	
	return This:C1470.code=On Losing Focus:K2:8
	
	//MARK:-
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get beforeKeystroke() : Boolean
	
	return This:C1470.code=On Before Keystroke:K2:6
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get afterKeystroke() : Boolean
	
	return This:C1470.code=On After Keystroke:K2:26
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get beforeDataEntry() : Boolean
	
	return This:C1470.code=On Before Data Entry:K2:39
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get afterEdit() : Boolean
	
	return This:C1470.code=On After Edit:K2:43
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get dataChange() : Boolean
	
	return This:C1470.code=On Data Change:K2:15
	
	//MARK:-
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get beginDragOver() : Boolean
	
	return This:C1470.code=On Begin Drag Over:K2:44
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get dragOver() : Boolean
	
	return This:C1470.code=On Drag Over:K2:13
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get drop() : Boolean
	
	return This:C1470.code=On Drop:K2:12
	
	//MARK:-
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get mouseEnter() : Boolean
	
	return This:C1470.code=On Mouse Enter:K2:33
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get mouseMove() : Boolean
	
	return This:C1470.code=On Mouse Move:K2:35
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get mouseLeave() : Boolean
	
	return This:C1470.code=On Mouse Leave:K2:34
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get mouseUp() : Boolean
	
	return This:C1470.code=On Mouse Up:K2:58
	
	//MARK:-
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get boundVariableChange() : Boolean
	
	return This:C1470.code=On Bound Variable Change:K2:52
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get selectionChange() : Boolean
	
	return This:C1470.code=On Selection Change:K2:29
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get scroll() : Boolean
	
	return This:C1470.code=On Scroll:K2:57
	
	//MARK:-Listboxes
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get columnMoved() : Boolean
	
	return This:C1470.code=On Column Moved:K2:30
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get rowMoved() : Boolean
	
	return This:C1470.code=On Row Moved:K2:32
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get columnResize() : Boolean
	
	return This:C1470.code=On Column Resize:K2:31
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get rowResize() : Boolean
	
	return This:C1470.code=On Row Resize:K2:60
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get headerClick() : Boolean
	
	return This:C1470.code=On Header Click:K2:40
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get footerClick() : Boolean
	
	return This:C1470.code=On Footer Click:K2:55
	
	
	