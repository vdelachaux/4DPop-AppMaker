//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : APP_MAKER_GET_PROJECTS
// Database: 4DPop AppMaker
// ID[17FB13BFAD0B412BB9893AD57BD47A84]
// Created #10-6-2014 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// Populate an array with the project files found into
// the folder /Preferences/BuildAPP/ of the host database
// ----------------------------------------------------
// Declarations
C_POINTER:C301($1)
C_LONGINT:C283($Lon_i; $Lon_parameters)
C_POINTER:C301($Ptr_array)
C_TEXT:C284($Dom_node; $Dom_root; $Path_root)
ARRAY TEXT:C222($tTxt_files; 0)

If (False:C215)
	C_POINTER:C301(_o_APP_MAKER_GET_PROJECTS; $1)
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1; "Missing parameter"))
	
	// Required parameters
	$Ptr_array:=$1  // Array to populate
	
	// Optional parameters
	If ($Lon_parameters>=2)
		
		// None
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
// Get the projects files
$Path_root:=Get 4D folder:C485(Database folder:K5:14; *)+"Preferences"+Folder separator:K24:12+"BuildApp"+Folder separator:K24:12

If (Test path name:C476($Path_root)=Is a folder:K24:2)
	
	DOCUMENT LIST:C474($Path_root; $tTxt_files; Ignore invisible:K24:16)
	
	For ($Lon_i; 1; Size of array:C274($tTxt_files); 1)
		
		If ($tTxt_files{$Lon_i}="BuildApp.xml")
			
			$tTxt_files{0}:=$tTxt_files{$Lon_i}
			
		Else 
			
			If ($tTxt_files{$Lon_i}="@.xml")
				
				$Dom_root:=DOM Parse XML source:C719($Path_root+$tTxt_files{$Lon_i})
				
				If (OK=1)
					
					$Dom_node:=DOM Find XML element:C864($Dom_root; "/Preferences4D/BuildApp")
					
					If (OK=1)
						
						$tTxt_files:=$tTxt_files+1
						$tTxt_files{$tTxt_files}:=$tTxt_files{$Lon_i}
						
					End if 
					
					DOM CLOSE XML:C722($Dom_root)
					
				End if 
			End if 
		End if 
	End for 
	
	ARRAY TEXT:C222($tTxt_files; $tTxt_files)
	//%W-518.1
	COPY ARRAY:C226($tTxt_files; $Ptr_array->)
	//%W+518.1
	
End if 

// ----------------------------------------------------
// Return
// ----------------------------------------------------
// End  