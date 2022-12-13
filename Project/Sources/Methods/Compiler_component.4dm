//%attributes = {"invisible":true}
// ----------------------------------------------------
// Method :  Compiler_component
// Created 25/05/10 by Vincent de Lachaux
// ----------------------------------------------------
var AppMaker : cs:C1710.AppMaker

If (False:C215)  //Public
	
	C_POINTER:C301(popAppMakerRun; $1)
	C_TEXT:C284(popAppMakerRun; $2)
	
	C_POINTER:C301(popAppMakerParameters; $1)
	
	C_TEXT:C284(AppMaker_RunProject; $1)
	
End if 

If (False:C215)  //Private
	
	C_LONGINT:C283(onHostDatabaseEvent; $1)
	
	C_LONGINT:C283(APP_MAKER_Go_to_page; $1)
	C_LONGINT:C283(APP_MAKER_Go_to_page; $2)
	
	C_TEXT:C284(APP_MAKER_HANDLER; $1)
	
	C_LONGINT:C283(APP_MAKER_Load_page; $1)
	
	C_POINTER:C301(BuildApp_SET_ARRAY; $1)
	
	C_TEXT:C284(buildApp_SET_ELEMENT; $1)
	
End if 

