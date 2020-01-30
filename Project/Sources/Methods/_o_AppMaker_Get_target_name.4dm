//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : AppMaker_Get_target_name
  // Database: 4DPop AppMaker
  // ID[F199225A477A42B0BC018E54D9EFB851]
  // Created #14-5-2014 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($0)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Dom_node;$Dom_root;$Txt_applicationName)

If (False:C215)
	C_TEXT:C284(_o_AppMaker_Get_target_name ;$0)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // NO PARAMETERS REQUIRED
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If (Test path name:C476(Storage:C1525.environment.buildApp)=Is a document:K24:1)
	
	$Dom_root:=DOM Parse XML source:C719(Storage:C1525.environment.buildApp)
	
	If (OK=1)
		
		$Dom_node:=DOM Find XML element:C864($Dom_root;"/Preferences4D/BuildApp/BuildApplicationName")
		
		If (OK=1)
			
			DOM GET XML ELEMENT VALUE:C731($Dom_node;$Txt_applicationName)
			
		End if 
	End if 
	
	DOM CLOSE XML:C722($Dom_root)
	
End if 

If (Length:C16($Txt_applicationName)=0)
	
	$Txt_applicationName:=Path to object:C1547(Structure file:C489(*)).name
	
End if 

  // ----------------------------------------------------
  // Return
$0:=$Txt_applicationName

  // ----------------------------------------------------
  // End  