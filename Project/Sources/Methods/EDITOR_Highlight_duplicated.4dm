//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : EDITOR_Highlight_duplicated
  // Database: 4DPop XLIFF Pro
  // ID[1A43E34D6E42400ABC3DCECF9FDDC919]
  // Created #14-1-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_BOOLEAN:C305($0)
C_POINTER:C301($1)
C_POINTER:C301($2)

C_BOOLEAN:C305($Boo_duplicated;$Boo_findDuplicate)
C_LONGINT:C283($Lon_i;$Lon_parameters;$Lon_x)
C_POINTER:C301($Ptr_groups;$Ptr_resnames;$Ptr_units)

If (False:C215)
	C_BOOLEAN:C305(EDITOR_Highlight_duplicated ;$0)
	C_POINTER:C301(EDITOR_Highlight_duplicated ;$1)
	C_POINTER:C301(EDITOR_Highlight_duplicated ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=2;"Missing parameter"))
	
	  // Required parameters
	$Ptr_resnames:=$1
	$Ptr_units:=$2
	
	  // Optional parameters
	If ($Lon_parameters>=3)
		
		  // <NONE>
		
	End if 
	
	$Ptr_groups:=OBJECT Get pointer:C1124(Object named:K67:5;"group")
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
For ($Lon_i;1;Size of array:C274($Ptr_resnames->);1)
	
	$Boo_duplicated:=(Count in array:C907($Ptr_resnames->;$Ptr_resnames->{$Lon_i})>1)
	
	If ($Boo_duplicated)  // More than one value found
		
		If ($Ptr_resnames->{$Lon_i}="...")
			
			$Boo_duplicated:=False:C215
			
		Else 
			
			  // First occurence
			$Lon_x:=Find in array:C230($Ptr_resnames->;$Ptr_resnames->{$Lon_i})
			
			  // Case sensitive comparison with the current value
			$Boo_duplicated:=(Position:C15($Ptr_resnames->{$Lon_i};$Ptr_resnames->{$Lon_x};*)=1)
			
			If ($Boo_duplicated)  // Check platform restriction
				
				$Boo_duplicated:=($Ptr_units->{$Lon_x}["d4:includeIf"]=Null:C1517)\
					 | (Length:C16(String:C10($Ptr_units->{$Lon_x}["d4:includeIf"]))=0)
				
			End if 
			
			Repeat 
				
				  // Search the next value
				$Lon_x:=Find in array:C230($Ptr_resnames->;$Ptr_resnames->{$Lon_i};$Lon_x+1)
				
				If ($Lon_x>0)
					
					  // Case sensitive comparison with the current value
					$Boo_duplicated:=$Boo_duplicated\
						 & (Position:C15($Ptr_resnames->{$Lon_i};$Ptr_resnames->{$Lon_x};*)=1)
					
					If ($Boo_duplicated)  // Check platform restriction
						
						$Boo_duplicated:=($Ptr_units->{$Lon_x}["d4:includeIf"]=Null:C1517)\
							 | (Length:C16(String:C10($Ptr_units->{$Lon_x}["d4:includeIf"]))=0)
						
					End if 
				End if 
			Until ($Lon_x=-1)\
				 | ($Boo_duplicated)
			
		End if 
	End if 
	
	If ($Boo_duplicated)
		
		  // Mark as duplicated
		$Boo_findDuplicate:=True:C214
		$Ptr_units->{$Lon_i}.duplicateResname:=True:C214
		
		  // Set resname color
		LISTBOX SET ROW COLOR:C1270(*;"unit";$Lon_i;0x00FF7E79)
		
		  // Expand the group 
		$Lon_x:=Find in array:C230($Ptr_groups->;$Ptr_groups->{$Lon_i})
		LISTBOX EXPAND:C1100(*;Form:C1466.widgets.strings;False:C215;lk break row:K53:18;$Lon_x;1)
		
	Else 
		
		  // Reset color
		LISTBOX SET ROW COLOR:C1270(*;"unit";$Lon_i;lk inherited:K53:26)
		
		OB REMOVE:C1226($Ptr_units->{$Lon_i};"duplicateResname")
		
	End if 
End for 

  // ----------------------------------------------------
  // Return
$0:=$Boo_findDuplicate

  // ----------------------------------------------------
  // End