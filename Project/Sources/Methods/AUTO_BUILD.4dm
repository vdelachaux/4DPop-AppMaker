//%attributes = {"invisible":true}
C_TEXT:C284($Dom_node;$Dom_root;$File_auto;$File_target;$Txt_version)
C_OBJECT:C1216($Obj_param)

$File_auto:=Get 4D folder:C485(Database folder:K5:14;*)+"auto-appMaker.flag"

If (Test path name:C476($File_auto)=Is a document:K24:1)
	
	$Obj_param:=JSON Parse:C1218(Document to text:C1236($File_auto))
	
	DELETE DOCUMENT:C159($File_auto)
	
	If (OB Is defined:C1231($Obj_param;"version"))
		
		$Txt_version:=OB Get:C1224($Obj_param;"version";Is text:K8:3)
		
		$File_target:=Get 4D folder:C485(Database folder:K5:14;*)+"Preferences"+Folder separator:K24:12+"4DPop AppMaker.xml"
		
		If (Test path name:C476($File_target)=Is a document:K24:1)
			
			$Dom_root:=DOM Parse XML source:C719($File_target)
			
			If (OK=1)
				
				$Dom_node:=DOM Find XML element:C864($Dom_root;"appMaker/info.plist")
				
				If (OK=1)
					
					DOM SET XML ATTRIBUTE:C866($Dom_node;\
						"CFBundleLongVersionString";$Txt_version;\
						"CFBundleShortVersionString";$Txt_version;\
						"CFBundleGetInfoString";$Txt_version)
					
					DOM EXPORT TO FILE:C862($Dom_root;$File_target)
					
				End if 
				
				DOM CLOSE XML:C722($Dom_root)
				
			End if 
		End if 
	End if 
	
	BRING TO FRONT:C326(New process:C317("APP_MAKER_HANDLER";0;"$APP_MAKER_HANDLER";"_autoBuild";*))
	
End if 