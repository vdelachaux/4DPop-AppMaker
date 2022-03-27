//%attributes = {"invisible":true}
// ----------------------------------------------------
// Method :  Compiler_tools
// Created 25/05/10 by Vincent de Lachaux
// ----------------------------------------------------

If (False:C215)
	
	// ----------------------------------------------------
	C_OBJECT:C1216(git; $0)
	C_OBJECT:C1216(git; $1)
	
	// ----------------------------------------------------
	C_OBJECT:C1216(EXPORT_PROJECT; $1)
	
	// ----------------------------------------------------
End if 

If (False:C215)
	
	// ----------------------------------------------------
	C_TEXT:C284(doc_EMPTY_FOLDER; $1)
	C_COLLECTION:C1488(doc_EMPTY_FOLDER; $2)
	
	// ----------------------------------------------------
	C_TEXT:C284(doc_DELETE; $1)
	
	// ----------------------------------------------------
	C_OBJECT:C1216(_o_doc_File; $0)
	C_TEXT:C284(_o_doc_File; $1)
	
	// ----------------------------------------------------
	C_OBJECT:C1216(_o_doc_Folder; $0)
	C_TEXT:C284(_o_doc_Folder; $1)
	
	// ----------------------------------------------------
	C_TEXT:C284(doc_getCommonPath; $0)
	C_TEXT:C284(doc_getCommonPath; $1)
	C_TEXT:C284(doc_getCommonPath; $2)
	
	// ----------------------------------------------------
	C_TEXT:C284(doc_getVolumeName; $0)
	C_TEXT:C284(doc_getVolumeName; $1)
	
	// ----------------------------------------------------
	C_BOOLEAN:C305(doc_Is_Relative_Path; $0)
	C_TEXT:C284(doc_Is_Relative_Path; $1)
	
	// ----------------------------------------------------
	C_TEXT:C284(doc_OBJET_LOCATION; $1)
	C_TEXT:C284(doc_OBJET_LOCATION; $2)
	C_LONGINT:C283(doc_OBJET_LOCATION; $3)
	C_LONGINT:C283(doc_OBJET_LOCATION; $4)
	
	// ----------------------------------------------------
End if 

If (False:C215)
	
	// ----------------------------------------------------
	C_TEXT:C284(_o_env_GET_infoPListPath; $0)
	C_TEXT:C284(_o_env_GET_infoPListPath; $1)
	C_BOOLEAN:C305(_o_env_GET_infoPListPath; $2)
	
	// ----------------------------------------------------
End if 

If (False:C215)
	
	// ----------------------------------------------------
	C_TEXT:C284(Obj_CENTER; $1)
	C_TEXT:C284(Obj_CENTER; $2)
	C_LONGINT:C283(Obj_CENTER; $3)
	
	// ----------------------------------------------------
End if 

If (False:C215)
	
	// ----------------------------------------------------
	C_TEXT:C284(PHP_zip_archive_to; $1)
	C_TEXT:C284(PHP_zip_archive_to; $2)
	C_BOOLEAN:C305(PHP_zip_archive_to; $0)
	
	// ----------------------------------------------------
End if 

If (False:C215)
	
	// ----------------------------------------------------
	C_BOOLEAN:C305(wait; $0)
	C_LONGINT:C283(wait; $1)
	C_LONGINT:C283(wait; $2)
	C_LONGINT:C283(wait; $3)
	C_LONGINT:C283(wait; $4)
	
	// ----------------------------------------------------
End if 

If (False:C215)
	
	// ----------------------------------------------------
	C_BOOLEAN:C305(xml_Clean_up; $0)
	C_TEXT:C284(xml_Clean_up; $1)
	C_TEXT:C284(xml_Clean_up; $2)
	
	// ----------------------------------------------------
	C_BOOLEAN:C305(xml_Reference; $0)
	C_TEXT:C284(xml_Reference; $1)
	
	// ----------------------------------------------------
	C_BOOLEAN:C305(xml_Save_file; $0)
	C_TEXT:C284(xml_Save_file; $1)
	C_TEXT:C284(xml_Save_file; $2)
	C_BOOLEAN:C305(xml_Save_file; $3)
	
	// ----------------------------------------------------
End if 