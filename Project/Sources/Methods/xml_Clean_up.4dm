//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : xml_Clean_up
  // ID[70F46CF3F0D04A94A2D65A00B1D30D27]
  // Created 10/05/11 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Make a clean XML file by removing unwanted white characters
  // ----------------------------------------------------
  // Declarations
C_BOOLEAN:C305($0)
C_TEXT:C284($1)
C_TEXT:C284($2)

C_BLOB:C604($Blb_buffer)
C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Dom_root;$Txt_buffer;$Txt_encoding;$Txt_path)

If (False:C215)
	C_BOOLEAN:C305(xml_Clean_up ;$0)
	C_TEXT:C284(xml_Clean_up ;$1)
	C_TEXT:C284(xml_Clean_up ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=2;"Missing parameter"))
	
	$Dom_root:=$1
	$Txt_path:=$2
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
$Txt_encoding:=DOM Get XML information:C721($Dom_root;Encoding:K45:4)

DOCUMENT TO BLOB:C525($Txt_path;$Blb_buffer)

If (Asserted:C1132(OK=1))
	
	$Txt_buffer:=Convert to text:C1012($Blb_buffer;$Txt_encoding)
	
	If (Asserted:C1132(OK=1))
		
		$Txt_buffer:=Replace string:C233($Txt_buffer;"\r\n";"")
		$Txt_buffer:=Replace string:C233($Txt_buffer;"\n";"")
		$Txt_buffer:=Replace string:C233($Txt_buffer;"\r";"")
		$Txt_buffer:=Replace string:C233($Txt_buffer;"\t";"")
		
		While (Position:C15("  ";$Txt_buffer)>0)
			
			$Txt_buffer:=Replace string:C233($Txt_buffer;"  ";" ")
			
		End while 
		
		$Txt_buffer:=Replace string:C233($Txt_buffer;"> <";"><")
		
		CONVERT FROM TEXT:C1011($Txt_buffer;$Txt_encoding;$Blb_buffer)
		
		If (Asserted:C1132(OK=1))
			
			BLOB TO DOCUMENT:C526($Txt_path;$Blb_buffer)
			
		End if 
	End if 
End if 

$0:=(OK=1)

  // ----------------------------------------------------
  // End