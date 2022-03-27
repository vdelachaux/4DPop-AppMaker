//%attributes = {"invisible":true}
// ----------------------------------------------------
// Method : BuildApp_SET_ELEMENT
// Created 02/06/08 by vdl
// ----------------------------------------------------
// Description
//
// ----------------------------------------------------
#DECLARE($value : Text)

If (False:C215)
	C_TEXT:C284(buildApp_SET_ELEMENT; $1)
End if 

var $node; $xpath : Text
var $mark : Picture

GET LIST ITEM PARAMETER:C985(Form:C1466.buildApp; *; "dom"; $node)

If (Length:C16($node)=0)
	
	GET LIST ITEM PARAMETER:C985(Form:C1466.buildApp; *; "xpath"; $xpath)
	$node:=DOM Create XML element:C865(Storage:C1525.environment.domBuildApp; $xpath)
	
	If (Bool:C1537(OK))
		
		SET LIST ITEM PARAMETER:C986(Form:C1466.buildApp; *; "dom"; $node)
		
	End if 
End if 

If (Asserted:C1132(Bool:C1537(OK)))
	
	DOM SET XML ELEMENT VALUE:C868($node; $value)
	
	Form:C1466.modified:=True:C214
	
	READ PICTURE FILE:C678(File:C1566("/RESOURCES/Images/xml_mark.png").platformPath; $mark)
	SET LIST ITEM ICON:C950(Form:C1466.buildApp; *; $mark)
	
End if 