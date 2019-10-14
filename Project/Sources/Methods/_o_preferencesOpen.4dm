//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Method :  preferencesOpen
  // Created 21/05/10 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($0)

C_TEXT:C284($Dom_root)
C_OBJECT:C1216($o)

If (False:C215)
	C_TEXT:C284(_o_preferencesOpen ;$0)
End if 

  // ----------------------------------------------------
  // Initialisations
$o:=Storage:C1525.component.preferences

  // ----------------------------------------------------
If ($o.exists)
	
	$Dom_root:=DOM Parse XML source:C719($o.platformPath)
	
Else 
	
	  // Create
	$Dom_root:=DOM Create XML Ref:C861("appMaker")
	
End if 

If (Bool:C1537(OK))
	
	XML SET OPTIONS:C1090($Dom_root;XML indentation:K45:34;XML no indentation:K45:36)
	
	$0:=$Dom_root
	
End if 