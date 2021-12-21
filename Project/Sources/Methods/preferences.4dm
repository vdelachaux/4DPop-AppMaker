//%attributes = {"invisible":true}
C_OBJECT:C1216($0)
C_TEXT:C284($1)
C_OBJECT:C1216($2)

C_LONGINT:C283($i; $Lon_count; $Lon_x)
C_TEXT:C284($Dom_element; $Dom_root; $t; $Txt_attributeName; $Txt_name; $Txt_value)
C_TEXT:C284($Txt_XPATH)
C_OBJECT:C1216($o; $oo)
C_COLLECTION:C1488($c)

ARRAY TEXT:C222($tDom_items; 0)

If (False:C215)
	C_OBJECT:C1216(preferences; $0)
	C_TEXT:C284(preferences; $1)
	C_OBJECT:C1216(preferences; $2)
End if 

If (This:C1470=Null:C1517)
	
	$o:=New shared object:C1526
	
	Use ($o)
		
		$o.rootElement:="appMaker"
		$o.file:=Folder:C1567(fk database folder:K87:14; *).file("Preferences/4DPop AppMaker.xml")
		
		If ($o.file.exists)
			
			$o.content:=$o.file.getText()
			
		Else 
			
			$Dom_root:=DOM Create XML Ref:C861($o.rootElement)
			DOM EXPORT TO VAR:C863($Dom_root; $t)
			DOM CLOSE XML:C722($Dom_root)
			$o.content:=$t
			
		End if 
		
		$o.open:=Formula:C1597(preferences("open"))
		$o.close:=Formula:C1597(preferences("close"))
		$o.save:=Formula:C1597(preferences("save"))
		$o.get:=Formula:C1597(preferences("get"; New object:C1471("xpath"; $1)))
		$o.set:=Formula:C1597(preferences("set"; New object:C1471("xpath"; $1; "value"; $2)))
		
	End use 
	
Else 
	
	$o:=New object:C1471
	
	Use (This:C1470)
		
		Case of 
				
				//______________________________________________________
			: ($1="open")
				
				$t:=String:C10(This:C1470.content)
				$Dom_root:=DOM Parse XML variable:C720($t)
				
				If (Bool:C1537(OK))
					
					This:C1470.reference:=$Dom_root
					
				End if 
				
				//______________________________________________________
			: ($1="save")
				
				If (This:C1470.reference#Null:C1517)
					
					DOM EXPORT TO VAR:C863(This:C1470.reference; $t)
					
					This:C1470.file.create()
					This:C1470.file.setText($t)
					
					This:C1470.close()
					
				End if 
				
				//______________________________________________________
			: ($1="close")
				
				If (This:C1470.reference#Null:C1517)
					
					DOM CLOSE XML:C722(This:C1470.reference)
					This:C1470.reference:=Null:C1517
					
				End if 
				
				//______________________________________________________
			: ($1="get")
				
				If (Asserted:C1132($2.xpath#Null:C1517))
					
					If (This:C1470.reference=Null:C1517)
						
						This:C1470.open()
						
					End if 
					
					$o.success:=False:C215
					
					$Txt_XPATH:=String:C10($2.xpath)
					
					If (Position:C15("/"+This:C1470.rootElement; $Txt_XPATH)#1)
						
						$Txt_XPATH:="/"+This:C1470.rootElement+"/"+$Txt_XPATH
						
					End if 
					
					$Lon_x:=Position:C15("@"; $Txt_XPATH; *)
					
					If ($Lon_x>0)
						
						$Txt_attributeName:=Substring:C12($Txt_XPATH; $Lon_x+1)
						$Txt_XPATH:=Substring:C12($Txt_XPATH; 1; $Lon_x-1)
						
					End if 
					
					var $onErr : Text
					$onErr:=Method called on error:C704
					ON ERR CALL:C155("xml_noError")  // ============================================================= [
					
					$Dom_element:=DOM Find XML element:C864(This:C1470.reference; $Txt_XPATH)
					$o.success:=($Dom_element#("0"*32))
					
					If ($o.success)
						
						If (Length:C16($Txt_attributeName)>0)
							
							DOM GET XML ATTRIBUTE BY NAME:C728($Dom_element; $Txt_attributeName; $Txt_value)
							$o.success:=Bool:C1537(OK)
							
							If ($o.success)
								
								$Txt_value:=Replace string:C233($Txt_value; "{CurrentYear}"; String:C10(Year of:C25(Current date:C33)))
								$o.value:=$Txt_value
								
							End if 
							
						Else 
							
							$Lon_count:=DOM Count XML attributes:C727($Dom_element)
							
							If ($Lon_count>1)
								
								$o.value:=New collection:C1472
								
								For ($i; 1; $Lon_count; 1)
									
									DOM GET XML ATTRIBUTE BY INDEX:C729($Dom_element; $i; $Txt_attributeName; $Txt_value)
									
									$o.value.push(New object:C1471(\
										"key"; $Txt_attributeName; \
										"value"; $Txt_value))
									
								End for 
								
							Else 
								
								$t:=DOM Find XML element:C864(This:C1470.reference; $Txt_XPATH+"/array")
								
								If ($t#("0"*32))
									
									$o.value:=New collection:C1472
									
									$tDom_items{0}:=DOM Find XML element:C864(This:C1470.reference; $Txt_XPATH+"/array/item"; $tDom_items)
									
									For ($i; 1; Size of array:C274($tDom_items); 1)
										
										DOM GET XML ELEMENT VALUE:C731($tDom_items{$i}; $Txt_value)
										$o.value.push($Txt_value)
										
									End for 
									
								Else 
									
									$o.value:=$Dom_element
									
								End if 
							End if 
						End if 
					End if 
					
					ON ERR CALL:C155($onErr)  // ======================================================================== ]
					
				End if 
				
				//______________________________________________________
			: ($1="set")
				
				If (Asserted:C1132(($2.xpath#Null:C1517)\
					 & ($2.value#Null:C1517)))
					
					If (This:C1470.reference=Null:C1517)
						
						This:C1470.open()
						
					End if 
					
					$o.success:=False:C215
					
					$Txt_XPATH:=String:C10($2.xpath)
					
					If (Position:C15("/"+This:C1470.rootElement; $Txt_XPATH)#1)
						
						$Txt_XPATH:="/"+This:C1470.rootElement+"/"+$Txt_XPATH
						
					End if 
					
					$Lon_x:=Position:C15("@"; $Txt_XPATH; *)
					
					If ($Lon_x>0)
						
						$Txt_attributeName:=Substring:C12($Txt_XPATH; $Lon_x+1)
						$Txt_XPATH:=Substring:C12($Txt_XPATH; 1; $Lon_x-1)
						
					End if 
					
					$Dom_element:=DOM Find XML element:C864(This:C1470.reference; $Txt_XPATH)
					
					If ($Dom_element=("0"*32))
						
						$Dom_element:=DOM Create XML element:C865(This:C1470.reference; $Txt_XPATH)
						
					End if 
					
					$o.success:=($Dom_element#("0"*32))
					
					If ($o.success)
						
						If (Value type:C1509($2.value)=Is collection:K8:32)
							
							// Delete existing attributes
							ON ERR CALL:C155("noERROR")
							
							For ($i; 1; DOM Count XML attributes:C727($Dom_element); 1)
								
								DOM GET XML ATTRIBUTE BY INDEX:C729($Dom_element; $i; $Txt_name; $t)
								DOM REMOVE XML ATTRIBUTE:C1084($Dom_element; $Txt_name)
								
							End for 
							
							ON ERR CALL:C155("")
							
							// Set new attributes
							$c:=$2.value
							
							For each ($oo; $c)
								
								DOM SET XML ATTRIBUTE:C866($Dom_element; \
									$oo.key; $oo.value)
								
							End for each 
							
						Else 
							
							DOM SET XML ATTRIBUTE:C866($Dom_element; \
								$Txt_attributeName; String:C10($2.value))
							
						End if 
					End if 
				End if 
				
				//______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215; "Unknown entry point: \""+$1+"\"")
				
				//______________________________________________________
		End case 
	End use 
End if 

$0:=$o