//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Method :  AppMaker_DELETE_FOLDER
  // Created 21/05/10 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description
  //
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($0)
C_TEXT:C284($1)

C_LONGINT:C283($Lon_i;$Lon_parameters)
C_TEXT:C284($Txt_currentErrorMethod;$Txt_path)

ARRAY TEXT:C222($tTxt_files;0)
ARRAY TEXT:C222($tTxt_folders;0)

If (False:C215)
	C_LONGINT:C283(_o_AppMaker_DELETE_FOLDER ;$0)
	C_TEXT:C284(_o_AppMaker_DELETE_FOLDER ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1))
	
	$Txt_path:=$1
	
	If ($Txt_path[[Length:C16($Txt_path)]]#Folder separator:K24:12)
		
		$Txt_path:=$Txt_path+Folder separator:K24:12
		
	End if 
End if 
  // ----------------------------------------------------

If (Test path name:C476($Txt_path)=Is a folder:K24:2)
	
	DOCUMENT LIST:C474($Txt_path;$tTxt_files)
	
	For ($Lon_i;1;Size of array:C274($tTxt_files);1)
		
		DELETE DOCUMENT:C159($Txt_path+$tTxt_files{$Lon_i})
		
	End for 
	
	FOLDER LIST:C473($Txt_path;$tTxt_folders)
	
	For ($Lon_i;1;Size of array:C274($tTxt_folders);1)
		
		_o_AppMaker_DELETE_FOLDER ($Txt_path+$tTxt_folders{$Lon_i})  //<==== RECURSIVE
		
	End for 
	
	$Txt_currentErrorMethod:=Method called on error:C704
	ON ERR CALL:C155("noERROR")
	
	ERROR:=0
	DELETE FOLDER:C693($Txt_path)
	
	$0:=-Num:C11(ERROR#0)
	
	ON ERR CALL:C155($Txt_currentErrorMethod)
	
End if 