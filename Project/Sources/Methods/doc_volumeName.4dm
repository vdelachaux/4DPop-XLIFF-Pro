//%attributes  = {"invisible":true}
  // ----------------------------------------------------
  // Project method : doc_volumeName
  // ID[2B6888351CBF4E87A0C1EA955B44C52E]
  // Created 30/11/10 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($0)
C_TEXT:C284($1)

C_LONGINT:C283($Lon_parameters;$Lon_x)
C_TEXT:C284($Txt_buffer;$Txt_path;$Txt_volume)

If (False:C215)
	C_TEXT:C284(doc_volumeName ;$0)
	C_TEXT:C284(doc_volumeName ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	$Txt_path:=$1
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If ($Txt_path#"")
	
	$Lon_x:=Position:C15(":";$Txt_path)  //marche sur Mac comme sur PC pour un volume LOCAL. Ex   C:\test\bonjour\   ou Mondisque:MonDossier:MonFichier
	
	If ($Lon_x>0)
		
		$Txt_volume:=Substring:C12($Txt_path;1;$Lon_x)  //renvoie "disque dur:"  ou C:
		
		If (Folder separator:K24:12="\\")  //on est sur Win
			
			$Txt_volume:=$Txt_volume+"\\"  //renvoie "C:\
				
		End if 
		
	Else 
		
		  //volume distant PC ? (vu d'un pc)
		  //exemple :     \\srv-4d\tempo\test\roland\    renverra    \\srv-4d\tempo$Lon_x:=Position("\\\\";$Txt_path)  //seulement deux \ \
			
		If ($Lon_x=1)
			
			  //c'est bien un volume distant PC
			$Txt_buffer:="••"+Substring:C12($Txt_path;3)  //remplace les deux premiers \ par "••"                   ••srv-4d\tempo\test$Lon_x:=Position("\\";$Txt_buffer)  //recherche le "\" suivant\
				
			
			If ($Lon_x>0)
				
				$Txt_buffer[[$Lon_x]]:="•"  //remplace le premier \ par une •                  ••srv-4d•tempo\test$Lon_x:=Position("\\";$Txt_buffer)  //recherche le "\" suivant\
					
				
				If ($Lon_x>0)
					
					$Txt_volume:=Substring:C12($Txt_path;1;$Lon_x)
					
				Else 
					
					  //???
					$Txt_volume:=""
					
				End if 
				
			Else 
				
				  //???
				$Txt_volume:=""
				
			End if 
			
		Else 
			
			If (Folder separator:K24:12="\\")  //on est sur Win
				
				$Txt_volume:=$Txt_path+":\\"  //directement la chaine passée +:\
					
			Else 
				
				$Txt_volume:=$Txt_path+":"  //directement la chaine passée +:
				
			End if 
		End if 
	End if 
End if 

$0:=$Txt_volume

  // ----------------------------------------------------
  // End 