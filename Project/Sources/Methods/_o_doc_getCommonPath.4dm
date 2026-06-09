//%attributes = {"invisible":true}
// ----------------------------------------------------
// Method : doc_getCommonPath
// Created 29/05/08 by vdl
// ----------------------------------------------------
// Description
//
// ----------------------------------------------------
var $0 : Text
var $1 : Text
var $2 : Text

var $Lon_end; $Lon_i; $Lon_j : Integer
var $Txt_commonPath; $Txt_path1; $Txt_path2 : Text

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