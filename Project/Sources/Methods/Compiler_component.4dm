//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Method :  Compiler_component
  // Created 25/05/10 by Vincent de Lachaux
  // ----------------------------------------------------
C_TEXT:C284(<>Txt_value)


If (False:C215)  //Public
	
	C_TEXT:C284(_o_AppMaker_Get_target_name ;$0)
	
	C_LONGINT:C283(_o_AppMaker_DELETE_FOLDER ;$0)
	C_TEXT:C284(_o_AppMaker_DELETE_FOLDER ;$1)
	
	C_TEXT:C284(DELETE_MAC_CONTENT ;$1)
	
	  //C_LONGINT(AppMaker_DUPLICATE_FOLDER ;$0)
	  //C_TEXT(AppMaker_DUPLICATE_FOLDER ;$1)
	  //C_TEXT(AppMaker_DUPLICATE_FOLDER ;$2)
	
	C_TEXT:C284(_o_AppMaker_Get_infoPlistKey ;$0)
	C_TEXT:C284(_o_AppMaker_Get_infoPlistKey ;$1)
	C_TEXT:C284(_o_AppMaker_Get_infoPlistKey ;$2)
	
	C_POINTER:C301(_o_AppMaker_OPEN_TARGET_FOLDER ;$1)
	
	C_TEXT:C284(_o_APP_MAKER_Get_target_path ;$0)
	C_LONGINT:C283(_o_APP_MAKER_Get_target_path ;$1)
	
	C_POINTER:C301(_o_AppMaker_INIT ;$1)
	
	C_POINTER:C301(AppMaker_RUN ;$1)
	C_TEXT:C284(AppMaker_RUN ;$2)
	
	C_TEXT:C284(AppMaker_RunProject ;$1)
	
	C_LONGINT:C283(_o_AppMaker_SET_BARBER ;$1)
	
	C_TEXT:C284(_o_AppMaker_SET_infoPlistKey ;$1)
	C_TEXT:C284(_o_AppMaker_SET_infoPlistKey ;$2)
	C_TEXT:C284(_o_AppMaker_SET_infoPlistKey ;$3)
	
	C_TEXT:C284(_o_AppMaker_SET_MESSAGE ;$1)
	
	C_POINTER:C301(AppMaker_PARAMETERS ;$1)
	
End if 

If (False:C215)  //Private
	
	C_POINTER:C301(_o_APP_MAKER_GET_PROJECTS ;$1)
	
	C_LONGINT:C283(APP_MAKER_Go_to_page ;$1)
	C_LONGINT:C283(APP_MAKER_Go_to_page ;$2)
	
	C_TEXT:C284(APP_MAKER_HANDLER ;$1)
	
	C_LONGINT:C283(APP_MAKER_Load_page ;$1)
	
	C_TEXT:C284(COPY ;$1)
	C_COLLECTION:C1488(COPY ;$2)
	
	C_TEXT:C284(DELETE ;$1)
	C_COLLECTION:C1488(DELETE ;$2)
	C_TEXT:C284(DELETE ;$3)
	
	C_POINTER:C301(BuildApp_SET_ARRAY ;$1)
	
	C_TEXT:C284(buildApp_SET_ELEMENT ;$1)
	
	C_TEXT:C284(buildApp_DELETE_RESOURCES ;$1)
	C_POINTER:C301(buildApp_DELETE_RESOURCES ;$2)
	
	C_BOOLEAN:C305(key_mark ;$1)
	C_LONGINT:C283(key_mark ;$2)
	C_PICTURE:C286(key_mark ;$3)
	
	C_TEXT:C284(_o_param_GET_ARRAY ;$1)
	C_TEXT:C284(_o_param_GET_ARRAY ;$2)
	C_POINTER:C301(_o_param_GET_ARRAY ;$3)
	
	C_TEXT:C284(_o_param_GET_ATTRIBUTES ;$0)
	C_TEXT:C284(_o_param_GET_ATTRIBUTES ;$1)
	C_TEXT:C284(_o_param_GET_ATTRIBUTES ;$2)
	C_POINTER:C301(_o_param_GET_ATTRIBUTES ;$3)
	C_POINTER:C301(_o_param_GET_ATTRIBUTES ;$4)
	
	C_TEXT:C284(_o_param_Get_value ;$0)
	C_TEXT:C284(_o_param_Get_value ;$1)
	C_TEXT:C284(_o_param_Get_value ;$2)
	C_POINTER:C301(_o_param_Get_value ;$3)
	
	C_TEXT:C284(_o_preferencesOpen ;$0)
	
	C_TEXT:C284(_o_param_SET_ARRAY ;$1)
	C_TEXT:C284(_o_param_SET_ARRAY ;$2)
	C_POINTER:C301(_o_param_SET_ARRAY ;$3)
	
	C_TEXT:C284(_o_param_SET_ATTRIBUTES ;$0)
	C_TEXT:C284(_o_param_SET_ATTRIBUTES ;$1)
	C_TEXT:C284(_o_param_SET_ATTRIBUTES ;$2)
	C_POINTER:C301(_o_param_SET_ATTRIBUTES ;$3)
	C_POINTER:C301(_o_param_SET_ATTRIBUTES ;$4)
	
	C_TEXT:C284(_o_param_SET_VALUE ;$1)
	C_TEXT:C284(_o_param_SET_VALUE ;$2)
	C_POINTER:C301(_o_param_SET_VALUE ;$3)
	
End if 

