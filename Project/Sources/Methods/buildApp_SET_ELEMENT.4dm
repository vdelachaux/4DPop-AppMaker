//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Method : BuildApp_SET_ELEMENT
  // Created 02/06/08 by vdl
  // ----------------------------------------------------
  // Description
  //
  // ----------------------------------------------------
C_TEXT:C284($1)

C_TEXT:C284($Txt_xpath;$Txt_UID)

If (False:C215)
	C_TEXT:C284(buildApp_SET_ELEMENT ;$1)
End if 

GET LIST ITEM PARAMETER:C985(Form:C1466.buildApp;*;"UID";$Txt_UID)

If (Length:C16($Txt_UID)=0)
	
	GET LIST ITEM PARAMETER:C985(Form:C1466.buildApp;*;"xpath";$Txt_xpath)
	$Txt_UID:=DOM Create XML element:C865(Storage:C1525.environment.domBuildApp;$Txt_xpath)
	
	If (OK=1)
		
		SET LIST ITEM PARAMETER:C986(Form:C1466.buildApp;*;"UID";$Txt_UID)
		
	End if 
End if 

If (Asserted:C1132(OK=1))
	
	DOM SET XML ELEMENT VALUE:C868($Txt_UID;$1)
	
	Form:C1466.modified:=True:C214
	
	key_mark (True:C214)
	
End if 