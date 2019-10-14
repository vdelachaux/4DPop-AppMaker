//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Method :  env_GET_infoPListPath
  // Created 21/05/10 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($0)
C_TEXT:C284($1)
C_BOOLEAN:C305($2)

C_BOOLEAN:C305($Boo_create)
C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Dom_element;$Dom_root;$Txt_path)

If (False:C215)
	C_TEXT:C284(_o_env_GET_infoPListPath ;$0)
	C_TEXT:C284(_o_env_GET_infoPListPath ;$1)
	C_BOOLEAN:C305(_o_env_GET_infoPListPath ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1))
	
	$Txt_path:=$1
	
	If ($Lon_parameters>=2)
		
		$Boo_create:=$2
		
	End if 
End if 

$Txt_path:=$Txt_path+"Info.plist"

  // ----------------------------------------------------
If (Test path name:C476($Txt_path)=Is a document:K24:1)
	
	$0:=$Txt_path
	
Else 
	
	If ($Boo_create)
		
		$Dom_root:=DOM Create XML Ref:C861("plist")
		
		If (OK=1)
			
			DOM SET XML ATTRIBUTE:C866($Dom_root;"version";"1.0")
			
			If (OK=1)
				
				$Dom_element:=DOM Append XML child node:C1080($Dom_root;XML DOCTYPE:K45:19;"plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\"")
				
				If (OK=1)
					
					$Dom_element:=DOM Create XML element:C865($Dom_root;"dict")
					
					If (OK=1)
						
						DOM EXPORT TO FILE:C862($Dom_root;$Txt_path)
						
						If (OK=1)
							
							$0:=$Txt_path
							
						End if 
					End if 
				End if 
			End if 
		End if 
	End if 
End if 