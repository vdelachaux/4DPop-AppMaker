//%attributes = {"invisible":true}
C_OBJECT:C1216(database; $0)
C_TEXT:C284(database; $1)
C_OBJECT:C1216(database; $2)

C_OBJECT:C1216(preferences; $0)
C_TEXT:C284(preferences; $1)
C_OBJECT:C1216(preferences; $2)

C_OBJECT:C1216(pList; $0)
C_TEXT:C284(pList; $1)
C_OBJECT:C1216(pList; $2)

C_TEXT:C284(BARBER; $1)

C_OBJECT:C1216(application; $0)
C_TEXT:C284(application; $1)

C_OBJECT:C1216(component; $0)
C_TEXT:C284(component; $1)

If (False:C215)
	C_OBJECT:C1216(pref; $0)
	C_TEXT:C284(pref; $1)
	C_OBJECT:C1216(pref; $2)
End if 

C_OBJECT:C1216(ob_createPath; $0)
C_OBJECT:C1216(ob_createPath; $1)
C_TEXT:C284(ob_createPath; $2)
C_LONGINT:C283(ob_createPath; $3)

If (False:C215)
	C_OBJECT:C1216(ob_getByPath; $0)
	C_OBJECT:C1216(ob_getByPath; $1)
	C_TEXT:C284(ob_getByPath; $2)
End if 

If (False:C215)
	C_BOOLEAN:C305(ob_testPath; $0)
	C_OBJECT:C1216(ob_testPath; $1)
	C_TEXT:C284(ob_testPath; $2)
	C_TEXT:C284(ob_testPath; ${3})
End if 

C_TEXT:C284(escape_param; $0)
C_TEXT:C284(escape_param; $1)