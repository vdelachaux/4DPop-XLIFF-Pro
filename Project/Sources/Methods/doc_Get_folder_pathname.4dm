//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : doc_Get_folder_pathname
  // Database: 4D unitTest
  // ID[428E79ED9971429C9F04D08A63DE109E]
  // Created #7-1-2014 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Moves up into the hierarchy of $1's path  in accordance to parameter $2
  // $1 could be a file path or a folder path
  // $2 is compliant with the relative URL notation used in HTML.
  //   - "/" current folder
  //   - "./" parent folder
  //   - "././" grandparent folder
  // If $2 is ommitted the function return the parent path of a file or the current path of a folder
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($0)
C_TEXT:C284($1)
C_TEXT:C284($2)

C_BOOLEAN:C305($Boo_directory;$Boo_OK;$Boo_proceed)
C_LONGINT:C283($Lon_length;$Lon_parameters;$Lon_position)
C_TEXT:C284($Txt_path;$Txt_pathname;$Txt_pattern)

If (False:C215)
	C_TEXT:C284(doc_Get_folder_pathname ;$0)
	C_TEXT:C284(doc_Get_folder_pathname ;$1)
	C_TEXT:C284(doc_Get_folder_pathname ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  //NO PARAMETERS REQUIRED
	
	$Txt_pathname:=$1
	
	If ($Lon_parameters>=2)
		
		$Txt_path:=$2
		
	End if 
	
	$Boo_directory:=(Test path name:C476($Txt_pathname)=Is a folder:K24:2)
	$Txt_pattern:=Choose:C955(Folder separator:K24:12=":";":[^$:]*$";"\\\\[^$\\\\]*$")
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($Txt_path="current")
		
		If ($Boo_directory)
			
			  //Delete the final separator
			If ($Txt_pathname[[Length:C16($Txt_pathname)]]=Folder separator:K24:12)
				
				$Txt_pathname:=Delete string:C232($Txt_pathname;Length:C16($Txt_pathname);1)
				
			End if 
			
		Else 
			
			  //Up to the parent folder
			$Boo_OK:=Match regex:C1019($Txt_pattern;$Txt_pathname;1;$Lon_position;$Lon_length)
			
			If ($Boo_OK)
				
				$Txt_pathname:=Delete string:C232($Txt_pathname;$Lon_position;$Lon_length)
				
			End if 
		End if 
		
		  //______________________________________________________
	Else 
		
		If ($Boo_directory)
			
			  //Delete the final separator
			If ($Txt_pathname[[Length:C16($Txt_pathname)]]=Folder separator:K24:12)
				
				$Txt_pathname:=Delete string:C232($Txt_pathname;Length:C16($Txt_pathname);1)
				
			End if 
			
		Else 
			
			  //Up to the parent folder
			$Boo_OK:=Match regex:C1019($Txt_pattern;$Txt_pathname;1;$Lon_position;$Lon_length)
			
			If ($Boo_OK)
				
				$Txt_pathname:=Delete string:C232($Txt_pathname;$Lon_position;$Lon_length)
				
			End if 
		End if 
		
		Repeat 
			
			$Boo_proceed:=(Position:C15("./";$Txt_path)>0)
			
			If ($Boo_proceed)
				
				  //Get the last directory
				$Boo_OK:=Match regex:C1019($Txt_pattern;$Txt_pathname;1;$Lon_position;$Lon_length)
				ASSERT:C1129($Boo_OK;"oops, no parent directory")
				
				If ($Boo_OK)
					
					$Txt_pathname:=Delete string:C232($Txt_pathname;$Lon_position;$Lon_length)
					$Txt_path:=Substring:C12($Txt_path;3)
					
				Else 
					
					  //Error: No more parent
					$Txt_pathname:=""
					
				End if 
				
			Else 
				
				$Txt_pathname:=$Txt_pathname+Folder separator:K24:12
				
			End if 
		Until (Not:C34($Boo_proceed))\
			 | (Not:C34($Boo_OK))
		
		  //______________________________________________________
End case 

$0:=$Txt_pathname

  // ----------------------------------------------------
  // End