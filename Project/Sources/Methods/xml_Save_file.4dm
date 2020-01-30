//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : xml_Save_file
  // ID[F6E3EAAB6BA644E0B0144721FFEA2C9E]
  // Created 10/05/11 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_BOOLEAN:C305($0)
C_TEXT:C284($1)
C_TEXT:C284($2)
C_BOOLEAN:C305($3)

C_BOOLEAN:C305($Boo_close)
C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Dom_root;$Txt_path)

If (False:C215)
	C_BOOLEAN:C305(xml_Save_file ;$0)
	C_TEXT:C284(xml_Save_file ;$1)
	C_TEXT:C284(xml_Save_file ;$2)
	C_BOOLEAN:C305(xml_Save_file ;$3)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	$Dom_root:=$1
	
	If ($Lon_parameters>=2)
		
		$Txt_path:=$2
		
		If ($Lon_parameters>=3)
			
			$Boo_close:=$3
			
		End if 
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
DOM EXPORT TO FILE:C862($Dom_root;$Txt_path)

If (Asserted:C1132(OK=1))
	
	$0:=xml_Clean_up ($Dom_root;DOCUMENT)
	
	If ($Boo_close)
		
		DOM CLOSE XML:C722($Dom_root)
		
	End if 
	
End if 

  // ----------------------------------------------------
  // End  