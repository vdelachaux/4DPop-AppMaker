//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Method :  param_SET_ATTRIBUTES
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

C_LONGINT:C283($Lon_count;$Lon_i;$Lon_parameters)
C_POINTER:C301($Ptr_arrayKeys;$Ptr_arrayValues)
C_TEXT:C284($Dom_element;$Dom_root;$Txt_buffer;$Txt_name;$Txt_XPATH)

If (False:C215)
	C_TEXT:C284(_o_param_SET_ATTRIBUTES ;$0)
	C_TEXT:C284(_o_param_SET_ATTRIBUTES ;$1)
	C_TEXT:C284(_o_param_SET_ATTRIBUTES ;$2)
	C_POINTER:C301(_o_param_SET_ATTRIBUTES ;$3)
	C_POINTER:C301(_o_param_SET_ATTRIBUTES ;$4)
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

If (Position:C15("appMaker";$Txt_XPATH)#1)
	
	$Txt_XPATH:="appMaker/"+$Txt_XPATH
	
End if 

  // ----------------------------------------------------
$Dom_element:=DOM Find XML element:C864($Dom_root;$Txt_XPATH)

If (OK=0)
	
	$Dom_element:=DOM Create XML element:C865($Dom_root;$Txt_XPATH)
	
End if 

If (Asserted:C1132(OK=1))
	
	  // Delete existing attributes {
	$Lon_count:=DOM Count XML attributes:C727($Dom_element)
	
	ON ERR CALL:C155("noERROR")
	
	For ($Lon_i;1;$Lon_count;1)
		
		DOM GET XML ATTRIBUTE BY INDEX:C729($Dom_element;$Lon_i;$Txt_name;$Txt_buffer)
		DOM REMOVE XML ATTRIBUTE:C1084($Dom_element;$Txt_name)
		
	End for 
	
	ON ERR CALL:C155("")
	  //}
	
	  // Set new attributes {
	$Lon_count:=Size of array:C274($Ptr_arrayKeys->)
	
	For ($Lon_i;1;$Lon_count;1)
		
		If (Length:C16($Ptr_arrayKeys->{$Lon_i})>0)
			
			DOM SET XML ATTRIBUTE:C866($Dom_element;$Ptr_arrayKeys->{$Lon_i};$Ptr_arrayValues->{$Lon_i})
			
		End if 
	End for 
	  //}
	
End if 