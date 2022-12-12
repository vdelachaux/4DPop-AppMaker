//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : AppMaker_INIT
// Database: 4DPop AppMaker
// ID[D2DAB151B9C84BF79929ECB4D9A720EB]
// Created #6-6-2014 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// This method is called at the time of initialization of the 4DPop's palet
// ----------------------------------------------------
// Declarations
C_POINTER:C301($1)

C_LONGINT:C283($Lon_i; $Lon_parameters)
C_POINTER:C301($Ptr_button)
C_TEXT:C284($Dom_node; $Dom_root; $Path_root)
C_OBJECT:C1216($Obj_message)

ARRAY TEXT:C222($tTxt_Components; 0)
ARRAY TEXT:C222($tTxt_files; 0)
ARRAY TEXT:C222($tTxt_items; 0)
ARRAY TEXT:C222($tTxt_methods; 0)

If (False:C215)
	C_POINTER:C301(__o_AppMaker_INIT; $1)
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0; "Missing parameter"))
	
	//NO PARAMETERS REQUIRED
	
	//Optional parameters
	If ($Lon_parameters>=1)
		
		$Ptr_button:=$1
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
// #10-6-2014 - multi-project management
If (Num:C11(Application version:C493)>=1440)  //14R4 and more
	
	COMPONENT LIST:C1001($tTxt_Components)
	
	If (Find in array:C230($tTxt_Components; "4DPop")>0)  //need 4DPop
		
		_o_APP_MAKER_GET_PROJECTS(->$tTxt_files)
		
		If ($tTxt_files=0)  //only one default project
			
			//NOTHING MORE TO DO
			
		Else 
			
			OB SET:C1220($Obj_message; "action"; "menu.add")
			
			APPEND TO ARRAY:C911($tTxt_items; "-")
			APPEND TO ARRAY:C911($tTxt_methods; "")
			
			If (Length:C16($tTxt_files{0})>0)
				
				APPEND TO ARRAY:C911($tTxt_items; "BuildApp.xml")
				APPEND TO ARRAY:C911($tTxt_methods; "AppMaker_RunProject()")
				
			End if 
			
			For ($Lon_i; 1; $tTxt_files; 1)
				
				APPEND TO ARRAY:C911($tTxt_items; $tTxt_files{$Lon_i})
				APPEND TO ARRAY:C911($tTxt_methods; "AppMaker_RunProject(\""+$tTxt_files{$Lon_i}+"\")")
				
			End for 
			
			OB SET ARRAY:C1227($Obj_message; "items"; $tTxt_items)
			OB SET ARRAY:C1227($Obj_message; "methods"; $tTxt_methods)
			
			//4DPop_UPDATE_TOOL (id;object)
			EXECUTE METHOD:C1007("4DPop_UPDATE_TOOL"; *; "AppMaker"; $Obj_message)
			CLEAR VARIABLE:C89($Obj_message)
			
		End if 
	End if 
End if 

// ----------------------------------------------------
// Return
//>NONE>
// ----------------------------------------------------
// End  