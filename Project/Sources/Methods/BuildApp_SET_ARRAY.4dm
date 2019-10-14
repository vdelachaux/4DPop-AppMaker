//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Method : BuildApp_SET_ARRAY
  // Created 02/06/08 by vdl
  // ----------------------------------------------------
  // Description
  //
  // ----------------------------------------------------
C_POINTER:C301($1)

C_LONGINT:C283($Lon_i;$Lon_x)
C_TEXT:C284($Txt_Buffer;$Txt_Node;$Txt_UID)

If (False:C215)
	C_POINTER:C301(BuildApp_SET_ARRAY ;$1)
End if 

GET LIST ITEM PARAMETER:C985(Form:C1466.buildApp;*;"xpath";$Txt_Buffer)
GET LIST ITEM PARAMETER:C985(Form:C1466.buildApp;*;"UID";$Txt_UID)

If (Length:C16($Txt_UID)=0)
	
	$Txt_UID:=DOM Create XML element:C865(Storage:C1525.environment.domBuildApp;$Txt_Buffer)
	
	If (OK=1)
		
		SET LIST ITEM PARAMETER:C986(Form:C1466.buildApp;*;"UID";$Txt_UID)
		$Txt_Node:=DOM Create XML element:C865(Storage:C1525.environment.domBuildApp;$Txt_Buffer+"/ItemsCount")
		
	End if 
End if 

If (OK=1)
	
	$Txt_Node:=DOM Find XML element:C864(Storage:C1525.environment.domBuildApp;$Txt_Buffer+"/ItemsCount")
	
	If (OK=1)
		
		  // Delete the array
		DOM GET XML ELEMENT VALUE:C731($Txt_Node;$Lon_x)
		
		For ($Lon_i;1;$Lon_x;1)
			
			DOM REMOVE XML ELEMENT:C869(DOM Find XML element:C864(Storage:C1525.environment.domBuildApp;$Txt_Buffer+"/Item"+String:C10($Lon_i)))
			
		End for 
		
		  // Construct the array
		$Lon_x:=Size of array:C274($1->)
		DOM SET XML ELEMENT VALUE:C868($Txt_Node;$Lon_x)
		
		For ($Lon_i;1;$Lon_x;1)
			
			DOM SET XML ELEMENT VALUE:C868(DOM Create XML element:C865(Storage:C1525.environment.domBuildApp;$Txt_Buffer+"/Item"+String:C10($Lon_i));\
				$1->{$Lon_i})
			
		End for 
		
		Form:C1466.modified:=True:C214
		
	End if 
End if 