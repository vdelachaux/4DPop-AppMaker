//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : EXPORT_PROJECT
  // ---------------------------------------------------
  // Description:
  // Bugs: method in subfolders are exported multiple times
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($1)

C_BOOLEAN:C305($Boo_git)
C_LONGINT:C283($Lon_bundleVersion;$Lon_parameters)
C_TEXT:C284($Dom_node;$Txt_buildApplicationName)
C_OBJECT:C1216($o;$Obj_;$Obj_export;$Obj_git;$Obj_params;$Obj_result)

If (False:C215)
	C_OBJECT:C1216(EXPORT_PROJECT ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	If ($Lon_parameters>=1)
		
		$Obj_params:=$1
		
	Else 
		
		$Obj_params:=New object:C1471
		
		$Obj_params.withLog:="ifNotEmpty"
		
		$Obj_params.filter:=New object:C1471
		$Obj_params.filter.projectMethods:=True:C214
		$Obj_params.filter.databaseMethods:=True:C214
		$Obj_params.filter.triggerMethods:=True:C214
		$Obj_params.filter.forms:=True:C214
		$Obj_params.filter.catalog:=True:C214
		$Obj_params.filter.folders:=True:C214
		$Obj_params.filter.settings:=True:C214
		$Obj_params.filter.trash:=True:C214
		
	End if 
End if 

If ($Obj_params.directory=Null:C1517)
	
	$Obj_:=Path to object:C1547(Get 4D folder:C485(Database folder:K5:14;*))
	
	$Obj_params.directory:=Object to path:C1548(New object:C1471(\
		"name";$Obj_.name+" Project";\
		"isFolder";True:C214;\
		"parentFolder";$Obj_.parentFolder))
	
End if 

  // Ensure the directory exist
doc_EMPTY_FOLDER ($Obj_params.directory;New collection:C1472(".git";".gitattributes";".DS_Store"))

  // Do export
$Obj_export:=New object:C1471(\
"filter";$Obj_params.filter)
$Obj_result:=Export structure file:C1565($Obj_params.directory;$Obj_export)

If ($Obj_result.success)
	
	If (Storage:C1525.environment.gitAvailable)
		
		XML DECODE:C1091(String:C10(Storage:C1525.preferences.get("options@removeDevResources").value);$Boo_git)
		
		If ($Boo_git)
			
			  // Get the repository status
			$Obj_git:=New object:C1471(\
				"action";"--commit";\
				"path";$Obj_params.directory;\
				"comment";Timestamp:C1445)
			
			  // Create a comment with build application name & bundle version
			$Dom_node:=DOM Find XML element:C864(Storage:C1525.environment.domBuildApp;"/Preferences4D/BuildApp/BuildApplicationName")
			
			If (OK=1)
				
				DOM GET XML ELEMENT VALUE:C731($Dom_node;$Txt_buildApplicationName)
				
				$o:=Storage:C1525.database.root.file("Info.plist")
				
				If ($o.exists)
					
					$Lon_bundleVersion:=Num:C11(pList ($o.platformPath).get("CFBundleVersion").value)
					
				End if 
				
				$Obj_git.comment:=$Txt_buildApplicationName+" - "+String:C10($Lon_bundleVersion)
				
			End if 
			
			$Obj_result:=git ($Obj_git)
			
		End if 
	End if 
	
Else 
	
	  //
	
End if 

  // ----------------------------------------------------
  // End