//%attributes = {"invisible":true}
C_TEXT:C284($0)
C_LONGINT:C283($1)

C_TEXT:C284($Dir_result;$Dir_target;$Dom_node;$Dom_root;$File_structure;$Txt_applicationName)
C_OBJECT:C1216($Obj_structure)

If (False:C215)
	C_TEXT:C284(_o_APP_MAKER_Get_target_path ;$0)
	C_LONGINT:C283(_o_APP_MAKER_Get_target_path ;$1)
End if 

Compiler_component 

If (Test path name:C476(Storage:C1525.environment.buildApp)=Is a document:K24:1)
	
	$Dom_root:=DOM Parse XML source:C719(Storage:C1525.environment.buildApp)
	
	If (OK=1)
		
		$Dom_node:=DOM Find XML element:C864($Dom_root;"/Preferences4D/BuildApp/BuildApplicationName")
		
		If (OK=1)
			
			DOM GET XML ELEMENT VALUE:C731($Dom_node;$Txt_applicationName)
			
		End if 
	End if 
	
	$Dom_node:=DOM Find XML element:C864($Dom_root;"/Preferences4D/BuildApp/"+Choose:C955(Is Windows:C1573;"BuildWinDestFolder";"BuildMacDestFolder"))
	
	If (OK=1)
		
		DOM GET XML ELEMENT VALUE:C731($Dom_node;$Dir_target)
		
		If ($Dir_target[[Length:C16($Dir_target)]]=Folder separator:K24:12)
			
			$Dir_target:=Delete string:C232($Dir_target;Length:C16($Dir_target);1)
			
		End if 
	End if 
	
	DOM CLOSE XML:C722($Dom_root)
	
End if 

If (Length:C16($Txt_applicationName)=0)
	
	$Txt_applicationName:=Path to object:C1547(Structure file:C489(*)).name
	
End if 

$File_structure:=Get 4D folder:C485(Database folder:K5:14;*)
$Obj_structure:=Path to object:C1547($File_structure)

Case of 
		
		  //______________________________________________________
	: (Length:C16($Dir_target)=0)\
		 | ($Dir_target="::")\
		 | ($Dir_target="..\\")
		
		$Dir_target:=$Obj_structure.parentFolder
		
		  //______________________________________________________
	: ($Dir_target="::@")
		
		$Dir_target:=Replace string:C233($Dir_target;"::";$Obj_structure.parentFolder)
		
		  //______________________________________________________
	: ($Dir_target="..\\@")
		
		$Dir_target:=Replace string:C233($Dir_target;"..\\";$Obj_structure.parentFolder)
		
		  //______________________________________________________
End case 

Case of 
		
		  //______________________________________________________
	: (Count parameters:C259=0)
		
		$Dir_result:=$Dir_target+$Obj_structure.name+$Obj_structure.extension+Folder separator:K24:12+$Txt_applicationName+".4DC"
		
		  //______________________________________________________
	: ($1=kRoot)
		
		$Dir_result:=$Dir_target+$Obj_structure.name+$Obj_structure.extension+Folder separator:K24:12
		
		  //______________________________________________________
	: ($1=kResources)
		
		$Dir_result:=$Dir_target+$Obj_structure.name+$Obj_structure.extension+Folder separator:K24:12+"Resources"+Folder separator:K24:12
		
		If (Test path name:C476($Dir_result)#Is a folder:K24:2)
			
			CREATE FOLDER:C475($Dir_result;*)
			
		End if 
		
		  //______________________________________________________
	: ($1=kComponents)
		
		$Dir_result:=$Dir_target+$Obj_structure.name+$Obj_structure.extension+Folder separator:K24:12+"Components"+Folder separator:K24:12
		
		If (Test path name:C476($Dir_result)#Is a folder:K24:2)
			
			CREATE FOLDER:C475($Dir_result;*)
			
		End if 
		
		  //______________________________________________________
	: ($1=kPlugins)
		
		$Dir_result:=Path to object:C1547($Dir_target).parentFolder+"Plugins"+Folder separator:K24:12
		
		If (Test path name:C476($Dir_result)#Is a folder:K24:2)
			
			CREATE FOLDER:C475($Dir_result;*)
			
		End if 
		
		  //______________________________________________________
	: ($1=8)  // Build folder
		
		$Dir_result:=$Dir_target+Folder separator:K24:12
		
		  //______________________________________________________
	: ($1=80)  // Component's folder
		
		$Dir_result:=$Dir_target+Folder separator:K24:12+"Components"+Folder separator:K24:12
		
		  //______________________________________________________
	: ($1=800)  // Component
		
		$Dir_result:=$Dir_target+Folder separator:K24:12+"Components"+Folder separator:K24:12+$Txt_applicationName+".4dbase"+Folder separator:K24:12
		
		  //______________________________________________________
	: ($1=81)  // Compiled Database's folder
		
		$Dir_result:=$Dir_target+Folder separator:K24:12+"Compiled Database"+Folder separator:K24:12
		
		  //______________________________________________________
	: ($1=810)  // Compiled Database
		
		$Dir_result:=$Dir_target+Folder separator:K24:12+"Compiled Database"+Folder separator:K24:12+$Txt_applicationName+".4dbase"
		
		  //______________________________________________________
	: ($1=82)  // Final Application's folder
		
		$Dir_result:=$Dir_target+Folder separator:K24:12+"Final Application"+Folder separator:K24:12
		
		  //______________________________________________________
	: ($1=820)  // Final Application
		
		$Dir_result:=$Dir_target+Folder separator:K24:12+"Final Application"+Folder separator:K24:12+$Txt_applicationName+Choose:C955(Is Windows:C1573;"";".app")
		
		  //______________________________________________________
	: ($1=83)  // Client Server executable's folder
		
		$Dir_result:=$Dir_target+Folder separator:K24:12+"Client Server executable"+Folder separator:K24:12
		
		  //______________________________________________________
	: ($1=830)  // Client Server executable
		
		$Dir_result:=$Dir_target+Folder separator:K24:12+"Client Server executable"+Folder separator:K24:12+$Txt_applicationName+" Server"+Choose:C955(Is Windows:C1573;"";".app")
		
		  //______________________________________________________
	Else 
		
		  // Nothing more to do
		
		  //______________________________________________________
End case 

$0:=$Dir_result