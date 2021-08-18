//%attributes = {"invisible":true,"shared":true}
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
C_TEXT:C284($1)

C_LONGINT:C283($Lon_parameters)
C_POINTER:C301($Ptr_nil)
C_TEXT:C284($Txt_project)

If (False:C215)
	C_TEXT:C284(AppMaker_RunProject; $1)
End if 

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
popAppMakerRun($Ptr_nil; $Txt_project)

// ----------------------------------------------------
// Return
//<NONE>
// ----------------------------------------------------
// End  