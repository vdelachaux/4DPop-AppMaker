//%attributes = {"invisible":true,"shared":true}
  // ----------------------------------------------------
  // Method :  env_Get_infoPlistKey
  // Created 25/09/07 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($0)
C_TEXT:C284($1)
C_TEXT:C284($2)

C_LONGINT:C283($Lon_count;$Lon_i;$Lon_parameters)
C_TEXT:C284($Dom_element;$Dom_node;$Dom_root;$Txt_key;$Txt_keyName;$Txt_path;$Txt_result)

If (False:C215)
	C_TEXT:C284(_o_AppMaker_Get_infoPlistKey ;$0)
	C_TEXT:C284(_o_AppMaker_Get_infoPlistKey ;$1)
	C_TEXT:C284(_o_AppMaker_Get_infoPlistKey ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259
$Txt_path:=Get 4D folder:C485(Database folder:K5:14;*)+"Info.plist"

If (Asserted:C1132($Lon_parameters>=1))
	
	$Txt_key:=$1
	
	If ($Lon_parameters>=2)
		
		$Txt_path:=$2
		
	End if 
End if 

  // ----------------------------------------------------
If (Asserted:C1132(Test path name:C476($Txt_path)=Is a document:K24:1;"Error 43 - File not found"))
	
	$Dom_root:=DOM Parse XML source:C719($Txt_path)
	
	If (OK=1)
		
		$Dom_node:=DOM Find XML element:C864($Dom_root;"plist/dict/")
		
		If (OK=1)
			
			$Lon_count:=DOM Count XML elements:C726($Dom_node;"key")
			
			For ($Lon_i;1;$Lon_count;1)
				
				$Dom_element:=DOM Get XML element:C725($Dom_node;"key";$Lon_i;$Txt_keyName)
				
				If ($Txt_keyName=$Txt_key)
					
					$Dom_element:=DOM Get next sibling XML element:C724($Dom_element;$Txt_keyName;$Txt_result)
					
					$Lon_i:=MAXLONG:K35:2-1
					
				End if 
			End for 
		End if 
		
		DOM CLOSE XML:C722($Dom_root)
		
	End if 
End if 

$0:=$Txt_result