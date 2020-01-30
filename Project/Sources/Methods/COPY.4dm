//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : build_COPY
  // Database: 4DPop AppMaker
  // ID[2251E486FE2640BDB4E2FD0AA0E3E9B7]
  // Created #17-12-2013 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($1)
C_COLLECTION:C1488($2)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Txt_item;$Txt_root;$Txt_source)
C_OBJECT:C1216($o;$Obj_target)
C_COLLECTION:C1488($Col_items)

If (False:C215)
	C_TEXT:C284(COPY ;$1)
	C_COLLECTION:C1488(COPY ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=2;"Missing parameter"))
	
	$Txt_root:=$1
	$Col_items:=$2
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Use (Storage:C1525.progress)
	
	Storage:C1525.progress.barber:=0
	
End use 

DELAY PROCESS:C323(Current process:C322;5)

For each ($Txt_item;$Col_items)
	
	Use (Storage:C1525.progress)
		
		Storage:C1525.progress.barber:=Storage:C1525.progress.barber+1
		Storage:C1525.progress.title:=Get localized string:C991("copy")+$Txt_item
		
	End use 
	
	$Txt_item:=Replace string:C233($Txt_item;"/";Folder separator:K24:12)
	$Obj_target:=Folder:C1567($Txt_root+$Txt_item;fk platform path:K87:2).parent
	
	$Txt_source:=Storage:C1525.environment.databaseFolder+$Txt_item
	$o:=Path to object:C1547($Txt_source)
	
	If (Bool:C1537($o.isFolder))
		
		  // Copy folder
		$o:=Folder:C1567($Txt_source;fk platform path:K87:2)
		
		If ($o.exists)
			
			$o:=$o.copyTo($Obj_target;fk overwrite:K87:5)
			
		End if 
		
	Else 
		
		  // Copy file
		$o:=File:C1566($Txt_source;fk platform path:K87:2)
		
		If ($o.exists)
			
			$o:=$o.copyTo($Obj_target;fk overwrite:K87:5)
			
		End if 
	End if 
	
	DELAY PROCESS:C323(Current process:C322;5)
	
End for each 

  // ----------------------------------------------------
  // End  