//%attributes = {}
  // ----------------------------------------------------
  // Project method : pref
  // ID[CE99103490E44A58BE11172AF9A10DD6]
  // Created #5-7-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)
C_OBJECT:C1216($2)

C_BOOLEAN:C305($b)
C_DATE:C307($d)
C_LONGINT:C283($i;$l)
C_TIME:C306($h)
C_REAL:C285($n)
C_TEXT:C284($Dom_element;$Dom_root;$t;$tt;$Txt_folder;$Txt_method)
C_TEXT:C284($Txt_name;$Txt_path;$Txt_value)
C_OBJECT:C1216($o;$oo)
C_COLLECTION:C1488($c)

If (False:C215)
	C_OBJECT:C1216(pref ;$0)
	C_TEXT:C284(pref ;$1)
	C_OBJECT:C1216(pref ;$2)
End if 

  // ----------------------------------------------------
If (This:C1470._is=Null:C1517)
	
	$t:=String:C10($1)
	
	$o:=New object:C1471(\
		"_is";"pref";\
		"file";"";\
		"content";"";\
		"rootElement";"pref";\
		"type";"json";\
		"reference";Null:C1517;\
		"open";Formula:C1597(pref ("open"));\
		"close";Formula:C1597(pref ("close"));\
		"get";Formula:C1597(pref ("get";New object:C1471("path";$1;"type";$2)).value);\
		"set";Formula:C1597(pref ("set";New object:C1471("path";$1;"value";$2)));\
		"save";Formula:C1597(pref ("save";New object:C1471("keep";Bool:C1537($1))))\
		)
	
	  // v18: The "Preferences" folder was renamed "Settings"
	$Txt_folder:=Choose:C955(Num:C11(Application version:C493)<1800;"Preferences";"Settings")
	
	If (Count parameters:C259>=1)
		
		  // Test for an absolute path
		$o.file:=File:C1566($t)
		
		  //#TO_DO: Accept relative path into the database folder
		
		If ($o.file.exists)  // Use the file
			
			$o.type:=Delete string:C232($o.file.extension;1;1)
			
		Else 
			
			$c:=Split string:C1554($t;";")
			
			If ($c.length>0)  // File name
				
				If ($c.length>=2)  // Location (managed below)
					
					If ($c.length>=3)  // File type
						
						$o.type:=$c[2]
						$c[2]:="."+$c[2]
						$t:=$c[0]+($c[2]*Num:C11($c[0]#("@"+$c[2])))
						
						If ($c.length>=4)  // Root element
							
							$o.rootElement:=$c[3]
							
						End if 
						
					Else 
						
						  // Try to get the file type from the file name extension
						$t:=File:C1566($c[0]).extension
						
						If (Length:C16($t)>0)
							
							$o.type:=Delete string:C232($t;1;1)
							
							$t:=$c[0]
							
						Else 
							
							$t:=$c[0]+"."+$o.type
							
						End if 
					End if 
					
					Case of 
							
							  //______________________________________________________
						: ($c[1]="database")
							
							If (Num:C11(Application version:C493)<1800)
								
								$o.file:=Folder:C1567(fk database folder:K87:14;*).folder("Preferences").file($t)
								
							Else 
								
								$o.file:=Folder:C1567(fk database folder:K87:14;*).folder("Settings").file($t)
								
							End if 
							
							  //______________________________________________________
						: ($c[1]="user")
							
							$o.file:=Folder:C1567(fk user preferences folder:K87:10).folder(Folder:C1567(fk database folder:K87:14;*).name).file($t)
							
							  //______________________________________________________
						: ($c[1]="4D")
							
							$o.file:=Folder:C1567(fk user preferences folder:K87:10).file($t)
							
							  //______________________________________________________
						Else 
							
							$o.file:=Folder:C1567(fk user preferences folder:K87:10).file($t)
							
							  //______________________________________________________
					End case 
					
				Else 
					
					  // Default: file named as root.extension into the database Preferences/Settings folder
					$o.file:=Folder:C1567(fk database folder:K87:14;*).folder($Txt_folder).file($o.rootElement+"."+$o.type)
					
				End if 
				
			Else 
				
				  // Default: file named as root.extension into the database Preferences/Settings folder
				$o.file:=Folder:C1567(fk database folder:K87:14;*).folder($Txt_folder).file($o.rootElement+"."+$o.type)
				
			End if 
			
			If (Num:C11(Application version:C493)>=1800)\
				 & (Position:C15(Folder:C1567(fk database folder:K87:14;*).path;$o.file.path)=1)\
				 & (Not:C34($o.file.exists))
				
				  // Recover the file, if any, from the old location
				$oo:=Folder:C1567(fk database folder:K87:14;*).folder("Preferences").file($t)
				
				If ($oo.exists)
					
					$oo.moveTo($o.file.parent)
					
				End if 
			End if 
		End if 
		
	Else 
		
		  // Default: file named as Pref.extension into the database Preferences/Settings folder
		$o.file:=Folder:C1567(fk database folder:K87:14;*).folder($Txt_folder).file("Pref."+$o.type)
		
	End if 
	
	Case of 
			
			  //______________________________________________________
		: (Not:C34($o.file.exists))
			
			$o.file.create()
			
			Case of 
					
					  //………………………………………………………………………………………………………
				: ($o.type="xml")
					
					$Dom_root:=DOM Create XML Ref:C861($o.rootElement)
					DOM EXPORT TO VAR:C863($Dom_root;$t)
					DOM CLOSE XML:C722($Dom_root)
					$o.content:=$t
					
					$o.file.setText($t)
					
					  //………………………………………………………………………………………………………
				: ($o.type="json")
					
					$t:=JSON Stringify:C1217(New object:C1471;*)
					$o.content:=$t
					
					$o.file.setText($t)
					
					  //………………………………………………………………………………………………………
			End case 
			
			  //______________________________________________________
		: ($o.type="xml")
			
			$Dom_root:=DOM Create XML Ref:C861($o.rootElement)
			DOM EXPORT TO VAR:C863($Dom_root;$t)
			DOM CLOSE XML:C722($Dom_root)
			$o.content:=$t
			
			  //______________________________________________________
		: ($o.type="json")
			
			$o.content:=JSON Stringify:C1217(New object:C1471;*)
			
			  //______________________________________________________
		Else 
			
			$o.content:=$o.file.getText()
			
			  //______________________________________________________
	End case 
	
	
Else 
	
	$o:=This:C1470
	
	Case of 
			
			  //______________________________________________________
		: ($o=Null:C1517)
			
			ASSERT:C1129(False:C215;"OOPS, this method must be called from a member method")
			
			  //______________________________________________________
		: ($1="open")
			
			$t:=String:C10($o.content)
			
			Case of 
					
					  //…………………………………………………………………………………………………………………………
				: (Length:C16($t)=0)
					
					  // Unknown type
					
					  //…………………………………………………………………………………………………………………………
				: ($o.type=".xml")
					
					$Dom_root:=DOM Parse XML variable:C720($t)
					
					If (Bool:C1537(OK))
						
						$o.reference:=$Dom_root
						DOM GET XML ELEMENT NAME:C730($Dom_root;$t)
						$o.rootElement:=$t
						
					End if 
					
					  //…………………………………………………………………………………………………………………………
				: ($o.type=".json")
					
					$o.reference:=JSON Parse:C1218($t)
					
					  //…………………………………………………………………………………………………………………………
				Else 
					
					  // Unknown type
					
					  //…………………………………………………………………………………………………………………………
			End case 
			
			  //______________________________________________________
		: ($1="close")
			
			Case of 
					
					  //…………………………………………………………………………………………………………………………
				: ($o.type=".xml")
					
					If ($o.reference#Null:C1517)
						
						DOM CLOSE XML:C722($o.reference)
						$o.reference:=Null:C1517
						
					End if 
					
					  //…………………………………………………………………………………………………………………………
				: ($o.type=".json")
					
					$o.reference:=Null:C1517
					
					  //…………………………………………………………………………………………………………………………
				Else 
					
					  // Unknown type
					
					  //…………………………………………………………………………………………………………………………
			End case 
			
			  //______________________________________________________
		: ($1="save")
			
			Case of 
					
					  //…………………………………………………………………………………………………………………………
				: ($o.type=".xml")
					
					DOM EXPORT TO VAR:C863($o.reference;$t)
					
					  //…………………………………………………………………………………………………………………………
				: ($o.type=".json")
					
					$t:=JSON Stringify:C1217($o.reference;*)
					
					  //…………………………………………………………………………………………………………………………
				Else 
					
					  // Unknown type
					
					  //…………………………………………………………………………………………………………………………
			End case 
			
			$o.file.setText($t)
			
			If (Not:C34($2.keep))
				
				$o.close()
				
			End if 
			
			  //________________________________________
		Else 
			
			$o:=New object:C1471(\
				"success";False:C215;\
				"value";Null:C1517)
			
			If (This:C1470.reference=Null:C1517)
				
				This:C1470.open()
				
			End if 
			
			Case of 
					
					  //______________________________________________________
				: ((This:C1470.reference=Null:C1517))
					
					ASSERT:C1129(False:C215)
					
					  //______________________________________________________
				: ($1="get")
					
					Case of 
							
							  //…………………………………………………………………………………………………………………………
						: (This:C1470.type=".xml")
							
							$Txt_path:=String:C10($2.path)
							
							If (Position:C15(This:C1470.rootElement;$Txt_path)#1)
								
								$Txt_path:=This:C1470.rootElement+"/"+$Txt_path
								
							End if 
							
							$l:=Position:C15("@";$Txt_path;*)
							
							If ($l>0)
								
								$Txt_name:=Substring:C12($Txt_path;$l+1)
								$Txt_path:=Substring:C12($Txt_path;1;$l-1)
								
							End if 
							
							$Txt_method:=Method called on error:C704
							ON ERR CALL:C155("xml_noError")  // ============================================================= [
							
							$Dom_element:=DOM Find XML element:C864(This:C1470.reference;$Txt_path)
							$o.success:=Bool:C1537(OK)
							
							If ($o.success)
								
								If (Length:C16($Txt_name)>0)
									
									DOM GET XML ATTRIBUTE BY NAME:C728($Dom_element;$Txt_name;$Txt_value)
									
									$o.success:=Bool:C1537(OK)
									
									If ($o.success)
										
										$l:=Num:C11($2.type)
										
										Case of 
												
												  //______________________________________________________
											: ($l=Is alpha field:K8:1)\
												 | ($l=Is text:K8:3)\
												 | ($l=Is string var:K8:2)
												
												$Txt_value:=Replace string:C233($Txt_value;"{CurrentYear}";String:C10(Year of:C25(Current date:C33)))
												$o.value:=$Txt_value
												
												  //______________________________________________________
											: ($l=Is boolean:K8:9)
												
												XML DECODE:C1091($Txt_value;$b)
												$o.value:=$b
												
												  //______________________________________________________
											: ($l=Is date:K8:7)
												
												XML DECODE:C1091($Txt_value;$d)
												$o.value:=$d
												
												  //______________________________________________________
											: ($l=Is time:K8:8)
												
												XML DECODE:C1091($Txt_value;$h)
												$o.value:=$h
												
												  //______________________________________________________
											: ($l=Is BLOB:K8:12)
												
												  //#TO_DO
												
												  //______________________________________________________
											: ($l=Is picture:K8:10)
												
												  //#TO_DO
												
												  //______________________________________________________
											Else 
												
												  // Return as numeric
												XML DECODE:C1091($Txt_value;$n)
												$o.value:=$n
												
												  //______________________________________________________
										End case 
									End if 
									
								Else 
									
									$l:=DOM Count XML attributes:C727($Dom_element)
									
									If ($l>1)
										
										$o.value:=New collection:C1472
										
										For ($i;1;$l;1)
											
											DOM GET XML ATTRIBUTE BY INDEX:C729($Dom_element;$i;$Txt_name;$Txt_value)
											
											$o.value.push(New object:C1471(\
												"key";$Txt_name;\
												"value";$Txt_value))
											
										End for 
										
									Else 
										
										$t:=DOM Find XML element:C864(DOM Get parent XML element:C923($Dom_element);"/"+$Txt_path+"/array")
										
										If (Bool:C1537(OK))
											
											$o.value:=New collection:C1472
											
											ARRAY TEXT:C222($tDom_items;0x0000)
											$tDom_items{0}:=DOM Find XML element:C864($t;"/array/item";$tDom_items)
											
											For ($i;1;Size of array:C274($tDom_items);1)
												
												DOM GET XML ELEMENT VALUE:C731($tDom_items{$i};$Txt_value)
												$o.value.push($Txt_value)
												
											End for 
											
										Else 
											
											$o.value:=$Dom_element
											
										End if 
									End if 
								End if 
							End if 
							
							ON ERR CALL:C155($Txt_method)  // ================================================================ ]
							
							  //…………………………………………………………………………………………………………………………
						: (This:C1470.type=".json")
							
							  //#TO_DO
							
							  //$o.success:=ob_testPath(This.reference;$Txt_path)
							  //If ($o.success)
							  //$o.value:=ob_getByPath
							  // End if
							
							  //…………………………………………………………………………………………………………………………
						Else 
							
							  // Unknown type
							
							  //…………………………………………………………………………………………………………………………
					End case 
					
					  //______________________________________________________
				: ($1="set")
					
					Case of 
							
							  //…………………………………………………………………………………………………………………………
						: (This:C1470.type=".xml")  // Define only the attributes for now
							
							$Txt_path:=String:C10($2.path)
							
							If (Position:C15(This:C1470.rootElement;$Txt_path)#1)
								
								$Txt_path:=This:C1470.rootElement+"/"+$Txt_path
								
							End if 
							
							$l:=Position:C15("@";$Txt_path;*)
							
							If ($l>0)
								
								$Txt_name:=Substring:C12($Txt_path;$l+1)
								$Txt_path:=Substring:C12($Txt_path;1;$l-1)
								
							End if 
							
							$Dom_element:=DOM Find XML element:C864(This:C1470.reference;$Txt_path)
							
							If (OK=0)
								
								$Dom_element:=DOM Create XML element:C865(This:C1470.reference;$Txt_path)
								
							End if 
							
							$o.success:=Bool:C1537(OK)
							
							If ($o.success)
								
								If (Value type:C1509($2.value)=Is collection:K8:32)
									
									  // Delete existing attributes
									$Txt_method:=Method called on error:C704
									ON ERR CALL:C155("noERROR")  // ============================================================= [
									
									For ($i;1;DOM Count XML attributes:C727($Dom_element);1)
										
										DOM GET XML ATTRIBUTE BY INDEX:C729($Dom_element;$i;$t;$tt)
										DOM REMOVE XML ATTRIBUTE:C1084($Dom_element;$t)
										
									End for 
									
									ON ERR CALL:C155($Txt_method)  // ============================================================ ]
									
									  // Set new attributes
									$c:=$2.value
									
									For each ($oo;$c)
										
										DOM SET XML ATTRIBUTE:C866($Dom_element;\
											$oo.key;$oo.value)
										
									End for each 
									
								Else 
									
									DOM SET XML ATTRIBUTE:C866($Dom_element;\
										$Txt_name;$2.value)
									
								End if 
							End if 
							
							  //…………………………………………………………………………………………………………………………
						: (This:C1470.type=".json")
							
							  //#TO_DO
							
							  //…………………………………………………………………………………………………………………………
						Else 
							
							  // Unknown type
							
							  //…………………………………………………………………………………………………………………………
					End case 
					
					  //______________________________________________________
				Else 
					
					ASSERT:C1129(False:C215;"Unknown entry point: \""+$1+"\"")
					
					  //______________________________________________________
			End case 
			
			  //________________________________________
	End case 
End if 

  // ----------------------------------------------------
  // Return
$0:=$o

  // ----------------------------------------------------
  // End