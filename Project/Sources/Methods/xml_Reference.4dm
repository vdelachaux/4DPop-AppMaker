//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : xml_Reference
  // ID[2E0F4785D2DD4276AB7BC45B3553D99B]
  // Created 10/05/11 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_BOOLEAN:C305($0)
C_TEXT:C284($1)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Dom_reference;$Dom_rootr)

If (False:C215)
	C_BOOLEAN:C305(xml_Reference ;$0)
	C_TEXT:C284(xml_Reference ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	$Dom_reference:=$1
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
ON ERR CALL:C155("xml_noError")

$Dom_rootr:=DOM Get XML document ref:C1088($Dom_reference)

$0:=(OK=1)

ON ERR CALL:C155("")

  // ----------------------------------------------------
  // End 