//%attributes = {}
C_TEXT:C284(<>Txt_value)

If (False:C215)
	
	C_TEXT:C284(_o_APP_MAKER_Get_target_path; $0)
	C_LONGINT:C283(_o_APP_MAKER_Get_target_path; $1)
	
	C_POINTER:C301(_o_APP_MAKER_GET_PROJECTS; $1)
	
	C_TEXT:C284(_o_param_SET_ARRAY; $1)
	C_TEXT:C284(_o_param_SET_ARRAY; $2)
	C_POINTER:C301(_o_param_SET_ARRAY; $3)
	
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
	
	C_TEXT:C284(_o_Obj_CENTER; $1)
	C_TEXT:C284(_o_Obj_CENTER; $2)
	C_LONGINT:C283(_o_Obj_CENTER; $3)
	
	C_OBJECT:C1216(_o_database; $0)
	C_TEXT:C284(_o_database; $1)
	C_OBJECT:C1216(_o_database; $2)
	
	C_OBJECT:C1216(_o_preferences; $0)
	C_TEXT:C284(_o_preferences; $1)
	C_OBJECT:C1216(_o_preferences; $2)
	
	C_OBJECT:C1216(_o_pList; $0)
	C_TEXT:C284(_o_pList; $1)
	C_OBJECT:C1216(_o_pList; $2)
	
End if 