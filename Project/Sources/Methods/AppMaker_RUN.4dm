//%attributes = {"invisible":true,"shared":true}
  // ----------------------------------------------------
  // Project method : AppMaker_RUN
  // ID[B150A0DC18B342C8A555BD1CD36B43F4]
  // Created 10/05/11 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_POINTER:C301($1)
C_TEXT:C284($2)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Txt_action)

If (False:C215)
	C_POINTER:C301(AppMaker_RUN ;$1)
	C_TEXT:C284(AppMaker_RUN ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	$Txt_action:="_run"
	
	If ($Lon_parameters>=2)
		
		$Txt_action:=$Txt_action+$2
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
BRING TO FRONT:C326(New process:C317("APP_MAKER_HANDLER";0;"$APP_MAKER_HANDLER";$Txt_action;*))

  // ----------------------------------------------------
  // End 