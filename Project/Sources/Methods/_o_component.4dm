//%attributes = {"invisible":true}
C_OBJECT:C1216($0)
C_TEXT:C284($1)

C_OBJECT:C1216($o; $oo)

If (False:C215)
	C_OBJECT:C1216(_o_component; $0)
	C_TEXT:C284(_o_component; $1)
End if 

If (This:C1470=Null:C1517)
	
	$o:=New object:C1471("structure"; File:C1566(Structure file:C489; fk platform path:K87:2).original; \
		"version"; "?"; \
		"isCompiled"; Is compiled mode:C492; \
		"isInterpreted"; Not:C34(Is compiled mode:C492); \
		"isDebug"; False:C215; \
		"isProject"; False:C215; \
		"clearCompiledCode"; Formula:C1597(This:C1470.structure.parent.folder("DerivedData/CompiledCode").delete(Delete with contents:K24:24)))
	
	$o.isProject:=($o.structure.extension=".4DProject")
	
	$o.isDebug:=$o.isInterpreted\
		 | (Position:C15("debug"; Application version:C493(*))>0)\
		 | Folder:C1567(fk user preferences folder:K87:10).file("_vdl").exists
	
	$oo:=_o_pList(File:C1566("/PACKAGE/Info.plist").platformPath)
	
	If ($oo.file.exists)
		
		$o.version:=$oo.get("CFBundleShortVersionString").value\
			+" ("+$oo.get("CFBundleVersion").value+")"
		
	End if 
	
Else 
	
	$o:=This:C1470
	
	Case of 
			
			//______________________________________________________
		: ($1="xxx")
			
			//______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215; "Unknown entry point: \""+$1+"\"")
			
			//______________________________________________________
	End case 
End if 

$0:=$o