//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : AppMaker_SET_MESSAGE
  // ID[D4E694385484477B939F48D5089EEB3D]
  // Created 13/01/11 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($1)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Txt_message)

If (False:C215)
	C_TEXT:C284(_o_AppMaker_SET_MESSAGE ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	If ($Lon_parameters>=1)
		
		$Txt_message:=$1
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Use (Storage:C1525.progress)
	
	Storage:C1525.progress.title:=$Txt_message
	
End use 

  // ----------------------------------------------------
  // End 