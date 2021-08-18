//%attributes = {"invisible":true,"shared":true}
// ----------------------------------------------------
// Project method : popAppMakerRun
// ID[B150A0DC18B342C8A555BD1CD36B43F4]
// Created 10/05/11 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// 
// ----------------------------------------------------
// Declarations
#DECLARE($ptr : Pointer; $cmd : Text)

var $action : Text

// ----------------------------------------------------
// Initialisations
$action:="_run"

If (Count parameters:C259>=2)
	
	$action:=$action+$cmd
	
End if 

// ----------------------------------------------------
BRING TO FRONT:C326(New process:C317("APP_MAKER_HANDLER"; 0; "$APP_MAKER_HANDLER"; $action; *))