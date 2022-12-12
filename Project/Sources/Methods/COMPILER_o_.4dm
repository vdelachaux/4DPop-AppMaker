//%attributes = {}
C_TEXT:C284(<>Txt_value)

If (False:C215)
	
	C_TEXT:C284(_o_AppMaker_Get_target_name; $0)
	
	C_LONGINT:C283(_o_AppMaker_DELETE_FOLDER; $0)
	C_TEXT:C284(_o_AppMaker_DELETE_FOLDER; $1)
	
	C_TEXT:C284(_o_DELETE_MAC_CONTENT; $1)
	
	C_TEXT:C284(_o_AppMaker_Get_infoPlistKey; $0)
	C_TEXT:C284(_o_AppMaker_Get_infoPlistKey; $1)
	C_TEXT:C284(_o_AppMaker_Get_infoPlistKey; $2)
	
	C_POINTER:C301(_o_AppMaker_OPEN_TARGET_FOLDER; $1)
	
	C_TEXT:C284(_o_APP_MAKER_Get_target_path; $0)
	C_LONGINT:C283(_o_APP_MAKER_Get_target_path; $1)
	
	C_POINTER:C301(__o_AppMaker_INIT; $1)
	
	C_LONGINT:C283(_o_AppMaker_SET_BARBER; $1)
	
	C_TEXT:C284(_o_AppMaker_SET_infoPlistKey; $1)
	C_TEXT:C284(_o_AppMaker_SET_infoPlistKey; $2)
	C_TEXT:C284(_o_AppMaker_SET_infoPlistKey; $3)
	
	C_TEXT:C284(_o_AppMaker_SET_MESSAGE; $1)
	
	C_POINTER:C301(_o_APP_MAKER_GET_PROJECTS; $1)
	
	C_TEXT:C284(_o_COPY; $1)
	C_COLLECTION:C1488(_o_COPY; $2)
	
	C_TEXT:C284(_o_DELETE; $1)
	C_COLLECTION:C1488(_o_DELETE; $2)
	C_TEXT:C284(_o_DELETE; $3)
	
	C_TEXT:C284(_o_param_GET_ARRAY; $1)
	C_TEXT:C284(_o_param_GET_ARRAY; $2)
	C_POINTER:C301(_o_param_GET_ARRAY; $3)
	
	C_TEXT:C284(_o_param_GET_ATTRIBUTES; $0)
	C_TEXT:C284(_o_param_GET_ATTRIBUTES; $1)
	C_TEXT:C284(_o_param_GET_ATTRIBUTES; $2)
	C_POINTER:C301(_o_param_GET_ATTRIBUTES; $3)
	C_POINTER:C301(_o_param_GET_ATTRIBUTES; $4)
	
	C_TEXT:C284(_o_param_Get_value; $0)
	C_TEXT:C284(_o_param_Get_value; $1)
	C_TEXT:C284(_o_param_Get_value; $2)
	C_POINTER:C301(_o_param_Get_value; $3)
	
	C_TEXT:C284(_o_preferencesOpen; $0)
	
	C_TEXT:C284(_o_param_SET_ARRAY; $1)
	C_TEXT:C284(_o_param_SET_ARRAY; $2)
	C_POINTER:C301(_o_param_SET_ARRAY; $3)
	
	C_TEXT:C284(_o_param_SET_ATTRIBUTES; $0)
	C_TEXT:C284(_o_param_SET_ATTRIBUTES; $1)
	C_TEXT:C284(_o_param_SET_ATTRIBUTES; $2)
	C_POINTER:C301(_o_param_SET_ATTRIBUTES; $3)
	C_POINTER:C301(_o_param_SET_ATTRIBUTES; $4)
	
	C_TEXT:C284(_o_param_SET_VALUE; $1)
	C_TEXT:C284(_o_param_SET_VALUE; $2)
	C_POINTER:C301(_o_param_SET_VALUE; $3)
	
	C_TEXT:C284(_o_buildApp_DELETE_RESOURCES; $1)
	C_POINTER:C301(_o_buildApp_DELETE_RESOURCES; $2)
	
	C_OBJECT:C1216(_o_EXPORT_PROJECT; $1)
	
	C_TEXT:C284(_o_doc_EMPTY_FOLDER; $1)
	C_COLLECTION:C1488(_o_doc_EMPTY_FOLDER; $2)
	
	C_TEXT:C284(_o_doc_DELETE; $1)
	
	C_OBJECT:C1216(_o_doc_File; $0)
	C_TEXT:C284(_o_doc_File; $1)
	
	C_OBJECT:C1216(_o_doc_Folder; $0)
	C_TEXT:C284(_o_doc_Folder; $1)
	
	C_TEXT:C284(_o_doc_getCommonPath; $0)
	C_TEXT:C284(_o_doc_getCommonPath; $1)
	C_TEXT:C284(_o_doc_getCommonPath; $2)
	
	C_TEXT:C284(_o_doc_getVolumeName; $0)
	C_TEXT:C284(_o_doc_getVolumeName; $1)
	
	C_BOOLEAN:C305(_o_doc_Is_Relative_Path; $0)
	C_TEXT:C284(_o_doc_Is_Relative_Path; $1)
	
	C_TEXT:C284(_o_doc_OBJET_LOCATION; $1)
	C_TEXT:C284(_o_doc_OBJET_LOCATION; $2)
	C_LONGINT:C283(_o_doc_OBJET_LOCATION; $3)
	C_LONGINT:C283(_o_doc_OBJET_LOCATION; $4)
	
	C_TEXT:C284(_o_env_GET_infoPListPath; $0)
	C_TEXT:C284(_o_env_GET_infoPListPath; $1)
	C_BOOLEAN:C305(_o_env_GET_infoPListPath; $2)
	
	C_TEXT:C284(_o_Obj_CENTER; $1)
	C_TEXT:C284(_o_Obj_CENTER; $2)
	C_LONGINT:C283(_o_Obj_CENTER; $3)
	
	C_TEXT:C284(_o_PHP_zip_archive_to; $1)
	C_TEXT:C284(_o_PHP_zip_archive_to; $2)
	C_BOOLEAN:C305(_o_PHP_zip_archive_to; $0)
	
	C_BOOLEAN:C305(_o_wait; $0)
	C_LONGINT:C283(_o_wait; $1)
	C_LONGINT:C283(_o_wait; $2)
	C_LONGINT:C283(_o_wait; $3)
	C_LONGINT:C283(_o_wait; $4)
	
	C_BOOLEAN:C305(_o_xml_Clean_up; $0)
	C_TEXT:C284(_o_xml_Clean_up; $1)
	C_TEXT:C284(_o_xml_Clean_up; $2)
	
End if 