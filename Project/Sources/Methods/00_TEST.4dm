//%attributes = {}
var $Dom_node; $Dom_root; $File_source; $File_target; $t; $Txt_buffer; $Txt_xPath : Text
var $Lon_i : Integer
var $o; $Obj_; $Obj_child; $Obj_parent : Object
var $c : Collection
ARRAY TEXT:C222($tTxt_resources; 0)

//

Case of 
		
		//______________________________________________________
	: (True:C214)
		
		var $file : 4D:C1709.File
		//$file:=File("/RESOURCES/en.lproj/_test.xlf")
		$file:=File:C1566("/RESOURCES/en.lproj/4D Constant.xlf")
		
		$o:=cs:C1710.xliff.new($file)
		
		$o.close()
		
		//______________________________________________________
	: (True:C214)
		
		$o:=cs:C1710.language.new()
		$c:=$o.languages()
		$t:=$o.getReferenceLanguage()
		
		$o:=cs:C1710.EDITOR.new()
		
		
		//______________________________________________________
	: (True:C214)
		
		$c:=Folder:C1567(fk applications folder:K87:20).parent.files(fk recursive:K87:7)
		
		//______________________________________________________
	: (True:C214)
		
		$t:=Get 4D folder:C485(Current resources folder:K5:16; *)
		$t:=""
		$t:=Get 4D folder:C485(Current resources folder:K5:16; *)+"toto.png"
		$t:=Get 4D folder:C485(Current resources folder:K5:16; *)+"languages.json"
		
		$t:="Macintosh HD:Users:vdl:Desktop:TO BE TRASHED:"
		$o:=Path to object:C1547($t)
		//$Obj_folder:=Folder($Txt_path)
		
		//______________________________________________________
	: (True:C214)
		$t:=Get 4D folder:C485(Current resources folder:K5:16; *)
		$t:=""
		$t:=Get 4D folder:C485(Current resources folder:K5:16; *)+"toto.png"
		$t:=Get 4D folder:C485(Current resources folder:K5:16; *)+"languages.json"
		
		$o:=Path to object:C1547($t)
		//$Obj_file:=Folder($Txt_path)
		
		//______________________________________________________
	: (True:C214)
		
		$Txt_buffer:=EDITOR_Preferences(New object:C1471("key"; "reference")).value
		
		//______________________________________________________
	: (True:C214)
		
		$Txt_buffer:="I am new back on 4D after a long break and am interested in what methods are being used for Title Casing /Camel Casing of entered text."
		
		$Txt_buffer:=convert_titleCase($Txt_buffer)
		
		$Txt_buffer:=convert_camelCase($Txt_buffer)
		
		//______________________________________________________
	: (True:C214)
		
		ARRAY TEXT:C222($tTxt_languages; 0x0000)
		
		// Get language array from user language preferences, sorted by preferred language
		// (only one on Windows, one or more on Mac OS X)
		
		//_4D GET USER UI LANGUAGES($tTxt_languages)
		EXECUTE FORMULA:C63(":C1381"+"($tTxt_languages)")
		
		For ($Lon_i; 1; Size of array:C274($tTxt_languages); 1)
			
			$Txt_buffer:=$Txt_buffer+$tTxt_languages{$Lon_i}+"\r"
			
		End for 
		
		ALERT:C41($Txt_buffer)
		
		//______________________________________________________
	: (True:C214)
		
		$File_source:=Get 4D folder:C485(Current resources folder:K5:16)+"en.lproj"+Folder separator:K24:12+"_test.xlf"
		$File_target:=Get 4D folder:C485(Current resources folder:K5:16)+"_de.lproj"+Folder separator:K24:12+"_test.xlf"
		
		FILE_SYNCHRONIZE($File_source; $File_target)
		
		//______________________________________________________
	: (True:C214)
		
		$Dom_root:=DOM Create XML Ref:C861("root")
		
		$Dom_node:=DOM Create XML element:C865($Dom_root; "node"; "id"; "2")
		DOM SET XML ATTRIBUTE:C866($Dom_node; "xml:id"; "1")
		DOM SET XML ELEMENT VALUE:C868($Dom_node; "ID=2 XML:ID=1")
		
		$Dom_node:=DOM Create XML element:C865($Dom_root; "node"; "id"; "1")
		DOM SET XML ATTRIBUTE:C866($Dom_node; "xml:id"; "2")
		DOM SET XML ELEMENT VALUE:C868($Dom_node; "ID=1 XML:ID=2")
		
		If (False:C215)
			$Dom_node:=DOM Find XML element by ID:C1010($Dom_root; "2")
			DOM GET XML ELEMENT VALUE:C731($Dom_node; $Txt_buffer)  // -> ID=2 XML:ID=1
			
			$Dom_node:=DOM Find XML element by ID:C1010($Dom_root; "1")
			DOM GET XML ELEMENT VALUE:C731($Dom_node; $Txt_buffer)  // -> ID=2 XML:ID=1
			
			DOM EXPORT TO FILE:C862($Dom_root; System folder:C487(Desktop:K41:16)+"test.xml")
			DOM CLOSE XML:C722($Dom_root)
			
			$Dom_root:=DOM Parse XML source:C719(System folder:C487(Desktop:K41:16)+"test.xml")
			
			$Dom_node:=DOM Find XML element by ID:C1010($Dom_root; "2")
			DOM GET XML ELEMENT VALUE:C731($Dom_node; $Txt_buffer)  // -> ID=2 XML:ID=1
			
			$Dom_node:=DOM Find XML element by ID:C1010($Dom_root; "1")
			DOM GET XML ELEMENT VALUE:C731($Dom_node; $Txt_buffer)  // -> ID=1 XML:ID=2
			
			DOM EXPORT TO FILE:C862($Dom_root; System folder:C487(Desktop:K41:16)+"test_2.xml")
			
		Else 
			
			$Dom_node:=xml_Find_by_attribute($Dom_root; "/root/node/@xml:id"; "2")
			DOM GET XML ELEMENT VALUE:C731($Dom_node; $Txt_buffer)  // -> ID=1 XML:ID=2
			
			$Dom_node:=xml_Find_by_attribute($Dom_root; "/root/node/@xml:id"; "1")
			DOM GET XML ELEMENT VALUE:C731($Dom_node; $Txt_buffer)  // -> ID=2 XML:ID=1
		End if 
		
		DOM CLOSE XML:C722($Dom_root)
		
		//______________________________________________________
	: (True:C214)
		
		OB SET:C1220($Obj_; "value"; "test")
		OB SET:C1220($Obj_child; "child"; $Obj_)
		
		OB SET:C1220($Obj_parent; "parent"; $Obj_child)
		
		$Txt_xPath:="parent.child"
		
		//$Txt_value:=OB Get(ob_Get_by_path ($Obj_parent;$Txt_xPath);"value";Is text)
		//$Txt_value:=OB Get(ob_Get_by_path ($Obj_parent;$Txt_xPath);"value";Is text)
		
		//______________________________________________________
	: (True:C214)
		
		For ($Lon_i; 1; 1000000; 1)
			
			$Txt_buffer:=Delete string:C232(Generate digest:C1147(Generate UUID:C1066; 4D digest:K66:3); 23; 2)  // 22
			
		End for 
		
		$tTxt_resources{1}:=Get localized string:C991("New element")
		$tTxt_resources{2}:=Get localized string:C991("New element 2")
		
		For ($Lon_i; 1; 2; 1)
			
			$tTxt_resources{$Lon_i}:=Get localized string:C991("index_"+String:C10($Lon_i))
			
		End for 
		
		//$Txt_buffer:="Hello world! \rHello world! "
		//TEXT TO DOCUMENT(System folder(Desktop)+"DEV"+Folder separator+"export brut.txt";$Txt_buffer)
		//TEXT TO DOCUMENT(System folder(Desktop)+"DEV"+Folder separator+"export UTF8.txt";$Txt_buffer;"UTF-8")
		//TEXT TO BLOB($Txt_buffer;$Blb_buffer;UTF8 text without length)
		//BLOB TO DOCUMENT(System folder(Desktop)+"DEV"+Folder separator+"export UTF8 sans BOM.txt";$Blb_buffer)
		//$Txt_buffer:=language_Get ("italian")
		//$Txt_buffer:=doc_Get_name ("new document")
		//$Txt_buffer:=doc_Get_name ("new document.txt")
		//$Txt_buffer:=doc_Get_name ("Macintosh HD:new document")
		//OB SET($Obj_parent;"un";1)
		//OB SET($Obj_child;"deux";2)
		//OB SET($Obj_parent;"enfant";$Obj_child)
		//ob_GET_IN_VARIABLE ($Obj_parent;"enfant.deux";->$Lon_i)
		//$Obj_1:=New object("test";"toto")
		//$Obj_2:=New object("test";"toto")
		//$Txt_buffer:=JSON Stringify($Obj_1)
		//$Boo_isEqual:=(JSON Stringify($Obj_1)=JSON Stringify($Obj_2))
		//$Obj_1:=New object("test";"toto";"hello";"world")
		//ARRAY TEXT($tTxt_properties;0)
		//For ($Lon_i;1;maMethode ($Obj_1;->$tTxt_properties);1)
		//$Txt_buffer:=$tTxt_properties{$Lon_i}
		// End  for
		//  // MaMethode {
		//$Obj_:=$1
		//$Ptr_:=$2
		//OB GET PROPERTY NAMES($Obj_;$tTxt_p)
		//COPY ARRAY($tTxt_p;$Ptr_->)
		//$0:=Size of array($tTxt_p)
		
		//  //}  //______________________________________________________
End case 