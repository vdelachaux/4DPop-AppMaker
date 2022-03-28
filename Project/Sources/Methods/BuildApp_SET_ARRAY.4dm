//%attributes = {"invisible":true}
// ----------------------------------------------------
// Method : BuildApp_SET_ARRAY
// Created 02/06/08 by vdl
// ----------------------------------------------------
// Description
//
// ----------------------------------------------------
#DECLARE($array : Pointer)

If (False:C215)
	C_POINTER:C301(BuildApp_SET_ARRAY; $1)
End if 

var $node; $root; $xpath : Text
var $count; $i : Integer

GET LIST ITEM PARAMETER:C985(Form:C1466.buildApp; *; "xpath"; $xpath)
GET LIST ITEM PARAMETER:C985(Form:C1466.buildApp; *; "dom"; $node)

$root:=Storage:C1525.environment.domBuildApp

If (Length:C16($node)=0)
	
	$node:=DOM Create XML element:C865($root; $xpath)
	
	If (Bool:C1537(OK))
		
		SET LIST ITEM PARAMETER:C986(Form:C1466.buildApp; *; "dom"; $node)
		$node:=DOM Create XML element:C865($root; $xpath+"/ItemsCount")
		
	End if 
End if 

If (Bool:C1537(OK))
	
	$node:=DOM Find XML element:C864($root; $xpath+"/ItemsCount")
	
	If (Bool:C1537(OK))
		
		// Delete the array
		DOM GET XML ELEMENT VALUE:C731($node; $count)
		
		For ($i; 1; $count; 1)
			
			DOM REMOVE XML ELEMENT:C869(DOM Find XML element:C864($root; $xpath+"/Item"+String:C10($i)))
			
		End for 
		
		// Construct the array
		$count:=Size of array:C274($array->)
		DOM SET XML ELEMENT VALUE:C868($node; $count)
		
		For ($i; 1; $count; 1)
			
			DOM SET XML ELEMENT VALUE:C868(DOM Create XML element:C865($root; $xpath+"/Item"+String:C10($i)); $array->{$i})
			
		End for 
		
		Form:C1466.modified:=True:C214
		
	End if 
End if 