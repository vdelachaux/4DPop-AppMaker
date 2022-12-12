//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : buildApp_DELETE_RESOURCES
// Database: 4DPop AppMaker
// ID[9064BA637A7240208CC68E63BD96B5C0]
// Created #17-12-2013 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
C_TEXT:C284($1)
C_POINTER:C301($2)

C_LONGINT:C283($Lon_i; $Lon_ii; $Lon_parameters)
C_POINTER:C301($Ptr_path)
C_TEXT:C284($Dir_target)

ARRAY TEXT:C222($tTxt_items; 0)

If (False:C215)
	C_TEXT:C284(_o_buildApp_DELETE_RESOURCES; $1)
	C_POINTER:C301(_o_buildApp_DELETE_RESOURCES; $2)
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=2; "Missing parameter"))
	
	$Dir_target:=$1
	$Ptr_path:=$2
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
If (Test path name:C476($Dir_target)=Is a folder:K24:2)
	
	For ($Lon_i; 1; Size of array:C274($Ptr_path->); 1)
		
		Case of 
				
				//______________________________________________________
			: (Position:C15("{localized}"; $Ptr_path->{$Lon_i})>0)
				
				FOLDER LIST:C473($Dir_target+Substring:C12($Ptr_path->{$Lon_i}; 1; Position:C15("{localized}"; $Ptr_path->{$Lon_i})-1); $tTxt_items)
				
				For ($Lon_ii; 1; Size of array:C274($tTxt_items); 1)
					
					If ($tTxt_items{$Lon_ii}="@.lproj")
						
						_o_doc_DELETE($Dir_target+Replace string:C233($Ptr_path->{$Lon_i}; "{localized}"; $tTxt_items{$Lon_ii}))
						
					End if 
				End for 
				
				//______________________________________________________
			Else 
				
				_o_doc_DELETE($Dir_target+$Ptr_path->{$Lon_i})
				
				//______________________________________________________
		End case 
	End for 
End if 

// ----------------------------------------------------
// End