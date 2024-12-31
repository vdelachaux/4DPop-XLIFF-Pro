property lproj; intl; fr; localized; iso; legacy; flag; regional : Text

property xliff : cs:C1710.Xliff
property root : Text

Class constructor($in : Object)
	
	var $key : Text
	
	For each ($key; $in)
		
		This:C1470[$key]:=$in[$key]
		
	End for each 
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function menuItem($withoutFlag : Boolean) : Text
	
	var $label : Text
	
	If ($withoutFlag)
		
		$label:=This:C1470.localized
		
	Else 
		
		$label:=This:C1470.flag+" "+This:C1470.localized
		
	End if 
	
	If (Get database localization:C1009(User system localization:K5:23; *)="fr")\
		 || (Get database localization:C1009(Current localization:K5:22; *)="fr")
		
		If (This:C1470.localized#This:C1470.fr)
			
			$label+=" ("+This:C1470.fr+")"
			
		End if 
		
	Else 
		
		If (This:C1470.localized#This:C1470.intl)
			
			$label+=" ("+This:C1470.intl+")"
			
		End if 
	End if 
	
	return $label