//%attributes = {}
// ----------------------------------------------------
// Project method : AppMaker_RunProject
// Database: 4DPop AppMaker
// ID[E1EE339B9F2E48E9883737FF55BEB7E2]
// Created #9-6-2014 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
var $1 : Text

var $Lon_parameters : Integer
var $Ptr_nil : Pointer
var $Txt_project : Text

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0; "Missing parameter"))
	
	//NO PARAMETERS REQUIRED
	
	//Optional parameters
	If ($Lon_parameters>=1)
		
		$Txt_project:=$1
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
//4DPopAppMakerRun($Ptr_nil; $Txt_project)

// ----------------------------------------------------
// Return
//<NONE>
// ----------------------------------------------------
// End