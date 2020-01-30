//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : AppMaker_SET_BARBER
  // ID[AAA713BEB9E443C5B239351480AF14A7]
  // Created 13/01/11 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($1)

C_LONGINT:C283($Lon_parameters)

If (False:C215)
	C_LONGINT:C283(_o_AppMaker_SET_BARBER ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	Use (Storage:C1525.progress)
		
		Storage:C1525.progress.barber:=$1
		
	End use 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------

  // ----------------------------------------------------
  // End  