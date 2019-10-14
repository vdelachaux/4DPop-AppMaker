//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Method : XML_TO_LIST
  // Created 30/05/08 by vdl
  // ----------------------------------------------------
  // Description
  // XML_TO_LIST(XML node reference ; list to populate; uid{; xpath})
  // ----------------------------------------------------
C_TEXT:C284($1)
C_LONGINT:C283($2)
C_POINTER:C301($3)
C_TEXT:C284($4)

C_LONGINT:C283($Lon_Attribut_Number;$Lon_i;$Lon_ID;$Lon_List;$Lon_Sublist)
C_POINTER:C301($Ptr_UID)
C_TEXT:C284($Txt_Element_Reference;$Txt_Root;$Txt_Tag_Name;$Txt_Tag_Value;$Txt_XPATH;$Txt_XPATH_Root)

If (False:C215)
	C_TEXT:C284(XML_TO_LIST ;$1)
	C_LONGINT:C283(XML_TO_LIST ;$2)
	C_POINTER:C301(XML_TO_LIST ;$3)
	C_TEXT:C284(XML_TO_LIST ;$4)
End if 

$Txt_Root:=$1
$Lon_List:=$2
$Ptr_UID:=$3
If (Count parameters:C259>=4)
	$Txt_XPATH_Root:=$4
End if 

DOM GET XML ELEMENT NAME:C730($Txt_Root;$Txt_Tag_Name)
DOM GET XML ELEMENT VALUE:C731($Txt_Root;$Txt_Tag_Value)

Repeat 
	
	$Txt_XPATH:=$Txt_XPATH_Root+"/"+$Txt_Tag_Name
	$Ptr_UID->:=$Ptr_UID->+1
	$Lon_ID:=$Ptr_UID->
	
	  //ATTRIBUTS
	  //{
	$Lon_Attribut_Number:=DOM Count XML attributes:C727($Txt_Root)
	ARRAY TEXT:C222($tTxt_Attribute_Names;$Lon_Attribut_Number)
	ARRAY TEXT:C222($tTxt_Attribute_Values;$Lon_Attribut_Number)
	
	If ($Lon_Attribut_Number>0)
		For ($Lon_i;1;$Lon_Attribut_Number)
			DOM GET XML ATTRIBUTE BY INDEX:C729($Txt_Root;$Lon_i;$tTxt_Attribute_Names{$Lon_i};$tTxt_Attribute_Values{$Lon_i})
		End for 
	End if 
	  //}
	
	  //ELEMENTS
	  //{
	$Txt_Element_Reference:=DOM Get first child XML element:C723($Txt_Root)
	
	If (OK=1)
		
		  //Has sons
		
		$Lon_Sublist:=New list:C375
		XML_TO_LIST ($Txt_Element_Reference;$Lon_Sublist;$Ptr_UID;$Txt_XPATH)  // <==== RECURSIVE
		
		APPEND TO LIST:C376($Lon_List;$Txt_Tag_Name;$Lon_ID;$Lon_Sublist;True:C214)
		SET LIST ITEM PROPERTIES:C386($Lon_List;0;False:C215;Bold:K14:2;0)
		
	Else 
		
		If ($Txt_Tag_Name#"")
			APPEND TO LIST:C376($Lon_List;$Txt_Tag_Name;$Lon_ID)
			SET LIST ITEM PARAMETER:C986($Lon_List;0;"Value";$Txt_Tag_Value)
			For ($Lon_i;1;$Lon_Attribut_Number;1)
				SET LIST ITEM PARAMETER:C986($Lon_List;0;$tTxt_Attribute_Names{$Lon_i};$tTxt_Attribute_Values{$Lon_i})
			End for 
			
		End if 
		
	End if 
	
	SET LIST ITEM PARAMETER:C986($Lon_List;0;"xpath";$Txt_XPATH)
	  //}
	
	$Txt_Root:=DOM Get next sibling XML element:C724($Txt_Root;$Txt_Tag_Name;$Txt_Tag_Value)
	
Until (OK=0)


