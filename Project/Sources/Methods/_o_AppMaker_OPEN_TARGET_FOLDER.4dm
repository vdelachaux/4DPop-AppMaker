//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : AppMaker_OPEN_TARGET_FOLDER
  // Database: 4DPop AppMaker
  // ID[3B9755FBAC194189ABB154DBCBB20648]
  // Created #17-12-2013 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_POINTER:C301($1)

C_LONGINT:C283($Lon_parameters)

If (False:C215)
	C_POINTER:C301(_o_AppMaker_OPEN_TARGET_FOLDER ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  //NO PARAMETERS REQUIRED
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
APP_MAKER_HANDLER ("_init")
SHOW ON DISK:C922(_o_APP_MAKER_Get_target_path (8);*)

  // ----------------------------------------------------
  // End 