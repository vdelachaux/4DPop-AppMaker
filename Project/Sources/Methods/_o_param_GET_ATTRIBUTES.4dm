//%attributes = {"invisible":true}
// ----------------------------------------------------
// Method :  param_GET_ATTRIBUTES
// Created 21/05/10 by Vincent de Lachaux
// ----------------------------------------------------
// Description
//
// ----------------------------------------------------
// Declarations
C_TEXT:C284($0)
C_TEXT:C284($1)
C_TEXT:C284($2)
C_POINTER:C301($3)
C_POINTER:C301($4)

C_LONGINT:C283($Lon_count; $Lon_i; $Lon_parameters)
C_POINTER:C301($Ptr_arrayKeys; $Ptr_arrayValues)
C_TEXT:C284($Dom_element; $Dom_root; $Txt_XPATH)

If (False:C215)
	C_TEXT:C284(_o_param_GET_ATTRIBUTES; $0)
	C_TEXT:C284(_o_param_GET_ATTRIBUTES; $1)
	C_TEXT:C284(_o_param_GET_ATTRIBUTES; $2)
	C_POINTER:C301(_o_param_GET_ATTRIBUTES; $3)
	C_POINTER:C301(_o_param_GET_ATTRIBUTES; $4)
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=4))
	
	$Dom_root:=$1
	$Txt_XPATH:=$2
	$Ptr_arrayKeys:=$3
	$Ptr_arrayValues:=$4
	
End if 

If (Position:C15("appMaker"; $Txt_XPATH)#1)
	
	$Txt_XPATH:="appMaker/"+$Txt_XPATH
	
End if 

// ----------------------------------------------------
$Dom_element:=DOM Find XML element:C864($Dom_root; $Txt_XPATH)

If (OK=1)
	
	$Lon_count:=DOM Count XML attributes:C727($Dom_element)
	
	//%W-518.5
	ARRAY TEXT:C222($Ptr_arrayKeys->; $Lon_count)
	ARRAY TEXT:C222($Ptr_arrayValues->; $Lon_count)
	//%W+518.5
	
	ON ERR CALL:C155("noERROR")
	
	For ($Lon_i; 1; $Lon_count; 1)
		
		DOM GET XML ATTRIBUTE BY INDEX:C729($Dom_element; $Lon_i; $Ptr_arrayKeys->{$Lon_i}; $Ptr_arrayValues->{$Lon_i})
		
		If (OK=0)
			
			$Lon_count:=MAXLONG:K35:2-1
			
		End if 
		
	End for 
	
	ON ERR CALL:C155("")
	
End if 