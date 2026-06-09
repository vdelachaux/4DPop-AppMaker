//%attributes = {"invisible":true}
// ----------------------------------------------------
// Method :  param_SET_ARRAY
// Created 21/05/10 by Vincent de Lachaux
// ----------------------------------------------------
// Description
//
// ----------------------------------------------------
// Declarations
var $1 : Text
var $2 : Text
var $3 : Pointer

var $Lon_count; $Lon_i; $Lon_parameters : Integer
var $Ptr_values : Pointer
var $Dom_array; $Dom_item; $Dom_root; $Txt_XPATH : Text

ARRAY TEXT:C222($tDom_items; 0)

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

If (OK=0)
	
	$Dom_array:=DOM Create XML element:C865($Dom_root; $Txt_XPATH)
	
End if 

If (Asserted:C1132(OK=1))
	
	$Dom_item:=DOM Find XML element:C864($Dom_root; $Txt_XPATH+"/item"; $tDom_items)
	
	$Lon_count:=Size of array:C274($tDom_items)
	
	For ($Lon_i; 1; $Lon_count; 1)
		
		DOM REMOVE XML ELEMENT:C869($tDom_items{$Lon_i})
		
	End for 
	
	$Lon_count:=Size of array:C274($Ptr_values->)
	
	For ($Lon_i; 1; $Lon_count; 1)
		
		$Dom_item:=DOM Create XML element:C865($Dom_array; "item")
		DOM SET XML ELEMENT VALUE:C868($Dom_item; $Ptr_values->{$Lon_i})
		
	End for 
End if 