//%attributes = {"invisible":true}
// Manage pList file a s object
C_OBJECT:C1216($0)
C_TEXT:C284($1)
C_OBJECT:C1216($2)

C_LONGINT:C283($i)
C_TEXT:C284($Dom_key; $Dom_root; $Dom_value; $t; $Txt_element; $Txt_key)
C_OBJECT:C1216($o)

If (False:C215)
	C_OBJECT:C1216(_o_pList; $0)
	C_TEXT:C284(_o_pList; $1)
	C_OBJECT:C1216(_o_pList; $2)
End if 

If (This:C1470=Null:C1517)
	
	$o:=New shared object:C1526("file"; File:C1566($1; fk platform path:K87:2); \
		"content"; Null:C1517; \
		"get"; Formula:C1597(_o_pList("get"; Choose:C955(Value type:C1509($1)=Is object:K8:27; $1; New object:C1471("key"; $1)))); \
		"set"; Formula:C1597(_o_pList("set"; $1)); \
		"save"; Formula:C1597(_o_pList("save")))
	
	If ($o.file.exists)
		
		Use ($o)
			
			$t:=$o.file.getText()
			$Dom_root:=DOM Parse XML variable:C720($t)
			
			If (Bool:C1537(OK))
				
				ARRAY TEXT:C222($tDom_dicts; 0x0000)
				$tDom_dicts{0}:=DOM Find XML element:C864($Dom_root; "/plist/dict/key"; $tDom_dicts)
				
				If (Bool:C1537(OK))
					
					$o.content:=New shared object:C1526
					
					Use ($o.content)
						
						For ($i; 1; Size of array:C274($tDom_dicts); 1)
							
							DOM GET XML ELEMENT VALUE:C731($tDom_dicts{$i}; $Txt_key)
							
							$o.content[$Txt_key]:=New shared object:C1526
							
							Use ($o.content[$Txt_key])
								
								$Dom_value:=DOM Get next sibling XML element:C724($tDom_dicts{$i})
								
								DOM GET XML ELEMENT NAME:C730($Dom_value; $Txt_element)
								
								Case of 
										
										//______________________________________________________
									: ($Txt_element="string")
										
										DOM GET XML ELEMENT VALUE:C731($Dom_value; $t)
										$o.content[$Txt_key].value:=$t
										
										//______________________________________________________
									Else 
										
										ASSERT:C1129(Structure file:C489#Structure file:C489(*))  //  #ERROR
										
										//______________________________________________________
								End case 
							End use 
						End for 
					End use 
				End if 
				
				DOM CLOSE XML:C722($Dom_root)
				
			End if 
		End use 
		
	Else 
		
		// A "If" statement should never omit "Else"
		
	End if 
	
Else 
	
	$o:=New object:C1471
	
	Use (This:C1470)
		
		Case of 
				
				//______________________________________________________
			: ($1="get")
				
				$o.success:=(This:C1470.content[$2.key]#Null:C1517)
				
				// Could test if we create or not
				
				$o.value:=This:C1470.content[$2.key].value
				
				//______________________________________________________
			: ($1="set")
				
				This:C1470.content[$2.key].value:=String:C10($2.value)
				
				$o:=This:C1470
				
				//______________________________________________________
			: ($1="save")
				
				$o.success:=False:C215
				
				$Dom_root:=DOM Create XML Ref:C861("plist")
				
				If (Bool:C1537(OK))
					
					$t:=DOM Append XML child node:C1080($Dom_root; XML DOCTYPE:K45:19; "plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd")
					
					DOM SET XML ATTRIBUTE:C866($Dom_root; \
						"version"; "1.0")
					
					$Dom_key:=DOM Create XML element:C865($Dom_root; "/plist/dict")
					
					If (Bool:C1537(OK))
						
						For each ($t; This:C1470.content)
							
							DOM SET XML ELEMENT VALUE:C868(DOM Create XML element:C865($Dom_key; "key"); $t)
							DOM SET XML ELEMENT VALUE:C868(DOM Create XML element:C865($Dom_key; "string"); This:C1470.content[$t].value)
							
						End for each 
						
						DOM EXPORT TO FILE:C862($Dom_root; This:C1470.file.platformPath)
						
						$o.success:=Bool:C1537(OK)
						
					End if 
					
					DOM CLOSE XML:C722($Dom_root)
					
				End if 
				
				//______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215; "Unknown entry point: \""+$1+"\"")
				
				//______________________________________________________
		End case 
	End use 
End if 

$0:=$o