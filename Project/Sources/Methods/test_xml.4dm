//%attributes  = {}
  // unitTest

If (True:C214)  //xml_IsValidReference
	
	  //32 bits
	ASSERT:C1129(xml_IsValidReference ("3438F2C031902008"))
	ASSERT:C1129(Not:C34(xml_IsValidReference ("0000000000000000")))
	
	  // 64 bits
	ASSERT:C1129(xml_IsValidReference ("00007FC05759857000007FC052D97208"))
	ASSERT:C1129(Not:C34(xml_IsValidReference ("00000000000000000000000000000000")))
	
	  //invalid references
	ASSERT:C1129(Not:C34(xml_IsValidReference ("")))  //empty
	ASSERT:C1129(Not:C34(xml_IsValidReference ("3438F2C03190")))  //too short
	ASSERT:C1129(Not:C34(xml_IsValidReference ("00007FC05759857000007FC052D9720")))  //too short
	ASSERT:C1129(Not:C34(xml_IsValidReference ("3438F23438F2C031902008C031902008X")))  //too long
	ASSERT:C1129(Not:C34(xml_IsValidReference ("3438F2C031902008Z")))  //too long
	ASSERT:C1129(Not:C34(xml_IsValidReference ("00007FC05759857000007FC052D9720X")))  //bad character
	ASSERT:C1129(Not:C34(xml_IsValidReference ("3438F2C03190200Z")))  //bad character
	
End if 