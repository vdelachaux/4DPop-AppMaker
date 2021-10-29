//%attributes = {"invisible":true}
// ----------------------------------------------------
// Method :  param_Get_array
// Created 21/05/10 by Vincent de Lachaux
// ----------------------------------------------------
// Description
//
// ----------------------------------------------------
// Declarations
C_TEXT:C284($1)
C_TEXT:C284($2)
C_POINTER:C301($3)

C_LONGINT:C283($Lon_count; $Lon_i; $Lon_parameters)
C_POINTER:C301($Ptr_values)
C_TEXT:C284($Dom_array; $Dom_item; $Dom_root; $Txt_XPATH)

If (False:C215)
	C_TEXT:C284(_o_param_GET_ARRAY; $1)
	C_TEXT:C284(_o_param_GET_ARRAY; $2)
	C_POINTER:C301(_o_param_GET_ARRAY; $3)
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=3))
	
	$Dom_root:=$1
	$Txt_XPATH:=$2
	$Ptr_values:=$3
	
End if 

If (Position:C15("appMaker"; $Txt_XPATH)#1)
	
	$Txt_XPATH:="appMaker/"+$Txt_XPATH
	
End if 

// ----------------------------------------------------
$Dom_array:=DOM Find XML element:C864($Dom_root; $Txt_XPATH)

If (OK=1)
	
	$Lon_count:=DOM Count XML elements:C726($Dom_array; "item")
	
	//%W-518.5
	ARRAY TEXT:C222($Ptr_values->; $Lon_count)
	//%W+518.5
	
	For ($Lon_i; 1; $Lon_count)
		
		$Dom_item:=DOM Get XML element:C725($Dom_array; "item"; $Lon_i; $Ptr_values->{$Lon_i})
		
	End for 
	
End if 