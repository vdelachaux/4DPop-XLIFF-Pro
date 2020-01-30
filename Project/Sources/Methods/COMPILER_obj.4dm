//%attributes  = {"invisible":true}
C_OBJECT:C1216(Obj_buffer)
C_LONGINT:C283(Lon_buffer)

If (True:C214)  //language
	
	  //______________________________________
	C_TEXT:C284(obj_ASSIGNMENT ;$1)
	C_POINTER:C301(obj_ASSIGNMENT ;$2)
	
	  //______________________________________
	C_LONGINT:C283(obj_BOUND_WITH_LIST ;$1)
	C_TEXT:C284(obj_BOUND_WITH_LIST ;$2)
	
	  //______________________________________
	C_OBJECT:C1216(obj_BOUND_WITH_OBJECT ;$1)
	C_TEXT:C284(obj_BOUND_WITH_OBJECT ;$2)
	
	  //______________________________________
	C_POINTER:C301(obj_Container ;$0)
	
	  //______________________________________
	C_POINTER:C301(obj_Dynamic ;$0)
	C_TEXT:C284(obj_Dynamic ;$1)
	C_TEXT:C284(obj_Dynamic ;$2)
	
	  //______________________________________
	C_TEXT:C284(obj_TOUCH ;$1)
	C_TEXT:C284(obj_TOUCH ;${2})
	
	  //______________________________________
	
End if 

If (False:C215)  //UI
	
	  //______________________________________
	C_TEXT:C284(obj_ADAPT_SEPARATOR_LINE ;$1)
	C_TEXT:C284(obj_ADAPT_SEPARATOR_LINE ;${2})
	
	  //______________________________________
	C_LONGINT:C283(obj_ALIGN ;$1)
	C_LONGINT:C283(obj_ALIGN ;$2)
	C_TEXT:C284(obj_ALIGN ;$3)
	C_TEXT:C284(obj_ALIGN ;$4)
	C_TEXT:C284(obj_ALIGN ;${5})
	
	  //______________________________________
	C_LONGINT:C283(obj_BEST_WIDTH ;$1)
	C_TEXT:C284(obj_BEST_WIDTH ;$2)
	C_TEXT:C284(obj_BEST_WIDTH ;${3})
	
	  //______________________________________
	C_TEXT:C284(obj_CENTER ;$1)
	C_TEXT:C284(obj_CENTER ;$2)
	C_LONGINT:C283(obj_CENTER ;$3)
	
	  //______________________________________
	C_TEXT:C284(obj_GOTO_NEXT ;$1)
	
	  //______________________________________
	C_TEXT:C284(obj_OFF_SCREEN ;$1)
	C_TEXT:C284(obj_OFF_SCREEN ;${2})
	
	  //______________________________________
	C_BOOLEAN:C305(obj_SET_ENABLED ;$1)
	C_TEXT:C284(obj_SET_ENABLED ;$2)
	C_TEXT:C284(obj_SET_ENABLED ;${3})
	
	  //______________________________________
	C_LONGINT:C283(obj_ALIGN_ON_BEST_SIZE ;$1)
	C_TEXT:C284(obj_ALIGN_ON_BEST_SIZE ;$2)
	C_TEXT:C284(obj_ALIGN_ON_BEST_SIZE ;${3})
	
	  //______________________________________
End if 