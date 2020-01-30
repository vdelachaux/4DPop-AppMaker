//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : buildApp_DELETE
  // Database: 4DPop AppMaker
  // ID[22B5A6D4B50845588A1CAE8CF1DA985D]
  // Created #17-12-2013 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($1)
C_COLLECTION:C1488($2)
C_TEXT:C284($3)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($t;$Txt_relative;$Txt_rootPath)
C_COLLECTION:C1488($c)

If (False:C215)
	C_TEXT:C284(DELETE ;$1)
	C_COLLECTION:C1488(DELETE ;$2)
	C_TEXT:C284(DELETE ;$3)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=2;"Missing parameter"))
	
	$Txt_rootPath:=$1
	$c:=$2
	
	If ($Lon_parameters>=3)
		
		$Txt_relative:=$3
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Use (Storage:C1525.progress)
	
	Storage:C1525.progress.barber:=0
	
End use 

DELAY PROCESS:C323(Current process:C322;5)

For each ($t;$c)
	
	Use (Storage:C1525.progress)
		
		Storage:C1525.progress.barber:=Num:C11(Storage:C1525.progress.barber)+1
		Storage:C1525.progress.title:=Get localized string:C991("remove")+$t
		
	End use 
	
	$t:=Replace string:C233($t;"./";$Txt_relative;1)
	$t:=Replace string:C233($t;"/";Folder separator:K24:12)
	$t:=$Txt_rootPath+$t
	
	If ($t[[Length:C16($t)]]=Folder separator:K24:12)
		
		Folder:C1567($t;fk platform path:K87:2).delete(Delete with contents:K24:24)
		
	Else 
		
		File:C1566($t;fk platform path:K87:2).delete()
		
	End if 
	
	DELAY PROCESS:C323(Current process:C322;5)
	
End for each 

  // ----------------------------------------------------
  // End  