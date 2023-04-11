//%attributes = {}

//$src:=File("/RESOURCES/en.lproj/_testEN.xlf"; *)
//$srcLanguage:="en"
//$tgtLanguage:="fr"


//ARRAY INTEGER($pos; 0)
//ARRAY INTEGER($len; 0)

//$path:=$src.path

//$srcLanguage:=Substring($srcLanguage; 1; 2)


//If (Match regex("(?m-si)(.*)"+Uppercase(Substring($srcLanguage; 1; 2))+"\\.xlf$"; $path; 1; $pos; $len))

//$path:=Substring($path; 1; $len{1})+Uppercase(Substring($tgtLanguage; 1; 2))+".xlf"

//End if 

//$path:=Replace string($path; $srcLanguage+".lproj"; $tgtLanguage+".lproj")

//$file:=File($path)


