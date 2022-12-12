//%attributes = {"invisible":true}
// ----------------------------------------------------
// Method : doc_getCommonPath
// Created 29/05/08 by vdl
// ----------------------------------------------------
// Description
//
// ----------------------------------------------------
C_TEXT:C284($0)
C_TEXT:C284($1)
C_TEXT:C284($2)

C_LONGINT:C283($Lon_end; $Lon_i; $Lon_j)
C_TEXT:C284($Txt_commonPath; $Txt_path1; $Txt_path2)

If (False:C215)
	C_TEXT:C284(_o_doc_getCommonPath; $0)
	C_TEXT:C284(_o_doc_getCommonPath; $1)
	C_TEXT:C284(_o_doc_getCommonPath; $2)
End if 

$Txt_path1:=$1
$Txt_path2:=$2

$Lon_i:=Length:C16($Txt_path1)
$Lon_j:=Length:C16($Txt_path2)

If ($Lon_i>0) & ($Lon_j>0)
	
	If ($Lon_i<$Lon_j)
		
		$Lon_j:=$Lon_i
		
	End if 
	
	For ($Lon_i; 1; $Lon_j; 1)
		
		If ($Txt_path1[[$Lon_i]]=Folder separator:K24:12)
			
			$Lon_end:=$Lon_i
			
		End if 
		
		If ($Txt_path1[[$Lon_i]]=$Txt_path2[[$Lon_i]])
			
			$Txt_commonPath:=$Txt_commonPath+$Txt_path1[[$Lon_i]]
			
		Else 
			
			$Lon_i:=$Lon_j+1
			
		End if 
		
	End for 
	
	$Txt_commonPath:=Substring:C12($Txt_commonPath; 1; $Lon_end)
	
End if 

$0:=$Txt_commonPath