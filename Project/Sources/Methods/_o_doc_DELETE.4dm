//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : doc_DELETE
// Database: 4DPop AppMaker
// ID[E7C37203B3F84FEF81E8C8CCA719EF40]
// Created #17-12-2013 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
C_TEXT:C284($1)

C_LONGINT:C283($Lon_i; $Lon_parameters)
C_TEXT:C284($Txt_path)

ARRAY TEXT:C222($tTxt_files; 0)
ARRAY TEXT:C222($tTxt_folders; 0)

If (False:C215)
	C_TEXT:C284(_o_doc_DELETE; $1)
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1; "Missing parameter"))
	
	$Txt_path:=$1
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------

Case of 
		
		//______________________________________________________
	: (Test path name:C476($Txt_path)=Is a document:K24:1)
		
		DELETE DOCUMENT:C159($Txt_path)
		
		//______________________________________________________
	: (Test path name:C476($Txt_path)=Is a folder:K24:2)
		
		DOCUMENT LIST:C474($Txt_path; $tTxt_files)
		
		For ($Lon_i; 1; Size of array:C274($tTxt_files); 1)
			
			DELETE DOCUMENT:C159($Txt_path+$tTxt_files{$Lon_i})
			
		End for 
		
		FOLDER LIST:C473($Txt_path; $tTxt_folders)
		
		For ($Lon_i; 1; Size of array:C274($tTxt_folders); 1)
			
			_o_doc_DELETE($Txt_path+$tTxt_folders{$Lon_i}+Folder separator:K24:12)  //<==== RECURSIVE
			
		End for 
		
		DELETE FOLDER:C693($Txt_path)
		
		//______________________________________________________
	Else 
		
		//ERROR
		
		//______________________________________________________
End case 

// ----------------------------------------------------
// End