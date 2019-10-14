//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Method :  param_GET
  // Created 21/05/10 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($0)
C_TEXT:C284($1)
C_TEXT:C284($2)
C_POINTER:C301($3)

C_LONGINT:C283($Lon_parameters;$Lon_x)
C_POINTER:C301($Ptr_value)
C_TEXT:C284($Dom_element;$Dom_root;$Txt_attributeName;$Txt_buffer;$Txt_XPATH)

If (False:C215)
	C_TEXT:C284(_o_param_Get_value ;$0)
	C_TEXT:C284(_o_param_Get_value ;$1)
	C_TEXT:C284(_o_param_Get_value ;$2)
	C_POINTER:C301(_o_param_Get_value ;$3)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=2))
	
	$Dom_root:=$1
	$Txt_XPATH:=$2
	
	If ($Lon_parameters>=3)
		
		$Ptr_value:=$3
		
	End if 
End if 

If (Position:C15("appMaker";$Txt_XPATH)#1)
	
	$Txt_XPATH:="appMaker/"+$Txt_XPATH
	
End if 

$Lon_x:=Position:C15("@";$Txt_XPATH;*)

If ($Lon_x>0)
	
	$Txt_attributeName:=Substring:C12($Txt_XPATH;$Lon_x+1)
	$Txt_XPATH:=Substring:C12($Txt_XPATH;1;$Lon_x-1)
	
End if 

  // ----------------------------------------------------
ON ERR CALL:C155("xml_noError")
$Dom_element:=DOM Find XML element:C864($Dom_root;$Txt_XPATH)
ON ERR CALL:C155("")

If (OK=1)
	
	If (Length:C16($Txt_attributeName)>0)
		
		ON ERR CALL:C155("noERROR")
		DOM GET XML ATTRIBUTE BY NAME:C728($Dom_element;$Txt_attributeName;$Txt_buffer)
		
		If (OK=1)
			
			If (Is nil pointer:C315($Ptr_value))
				
				$Txt_buffer:=Replace string:C233($Txt_buffer;"{CurrentYear}";String:C10(Year of:C25(Current date:C33)))
				
				$0:=$Txt_buffer
				
			Else 
				
				DOM GET XML ATTRIBUTE BY NAME:C728($Dom_element;$Txt_attributeName;$Ptr_value->)
				
			End if 
		End if 
		
		ON ERR CALL:C155("")
		
	Else 
		
		$0:=$Dom_element
		
	End if 
End if 