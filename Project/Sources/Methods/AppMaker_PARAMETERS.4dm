//%attributes = {"invisible":true,"shared":true}
  // ----------------------------------------------------
  // Method : AppMaker_TOOL
  // Created 29/05/08 by vdl
  // ----------------------------------------------------
  // Description
  // Component Entry Point
  // ----------------------------------------------------
C_POINTER:C301($1)

If (False:C215)
	C_POINTER:C301(AppMaker_PARAMETERS ;$1)
End if 

APP_MAKER_HANDLER 