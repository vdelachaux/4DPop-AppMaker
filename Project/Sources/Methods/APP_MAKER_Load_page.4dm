//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Method : APP_MAKER_Load_page
  // Created 30/05/08 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description
  //
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($1)

C_BOOLEAN:C305($Boo_expanded;$Boo_load;$Boo_on)
C_LONGINT:C283($Lon_i;$Lon_page;$Lon_reference;$Lon_sublist;$Lon_UID)
C_PICTURE:C286($Pic_mark)
C_TEXT:C284($Dom_node;$Dom_root;$Txt_buffer;$Txt_filePath)
C_OBJECT:C1216($ƒ)

If (False:C215)
	C_LONGINT:C283(APP_MAKER_Load_page ;$1)
End if 

$Lon_page:=$1

$ƒ:=Storage:C1525.preferences

If ($Lon_page<=(Form:C1466.loaded.length-1))
	
	  // Test if page was already loaded
	$Boo_load:=Not:C34(Bool:C1537(Form:C1466.loaded[$Lon_page]))
	
Else 
	
	$Boo_load:=True:C214
	
End if 

Case of 
		
		  //………………………………………………………
	: ($Lon_page=1)
		
		If (OBJECT Get visible:C1075(*;"tips.run"))
			
			OBJECT SET VISIBLE:C603(*;"tips.run";False:C215)
			
		End if 
		
		  //………………………………………………………
	: ($Lon_page=2)  // BuildApp
		
		If (Count list items:C380(Form:C1466.buildApp)=0)
			
			READ PICTURE FILE:C678(Get 4D folder:C485(Current resources folder:K5:16)+"Images"+Folder separator:K24:12+"xml_mark.png";$Pic_mark)
			
			  // Description file
			$Txt_filePath:=Get 4D folder:C485(Current resources folder:K5:16)+"BuildAppKey.xml"
			
			If (Asserted:C1132(Test path name:C476($Txt_filePath)=Is a document:K24:1))
				
				$Dom_root:=DOM Parse XML source:C719($Txt_filePath)
				
				If (Asserted:C1132(OK=1))
					
					$Lon_UID:=1
					
					XML_TO_LIST ($Dom_root;Form:C1466.buildApp;->$Lon_UID;"/Preferences4D")
					
					If (Count list items:C380(Form:C1466.buildApp)>0)
						
						GET LIST ITEM:C378(Form:C1466.buildApp;1;$Lon_reference;$Txt_buffer;$Lon_sublist;$Boo_expanded)
						SET LIST ITEM:C385(Form:C1466.buildApp;$Lon_reference;$Txt_buffer;$Lon_reference;$Lon_sublist;True:C214)
						SELECT LIST ITEMS BY POSITION:C381(Form:C1466.buildApp;1)
						
					End if 
					
					DOM CLOSE XML:C722($Dom_root)
					
				End if 
			End if 
			
			If (Asserted:C1132(OK=1))
				
				For ($Lon_i;1;Count list items:C380(Form:C1466.buildApp;*))
					
					GET LIST ITEM:C378(Form:C1466.buildApp;$Lon_i;$Lon_reference;$Txt_buffer;$Lon_sublist;$Boo_expanded)
					
					OK:=Num:C11($Lon_sublist=0)
					
					If (OK=1)
						
						GET LIST ITEM PARAMETER:C985(Form:C1466.buildApp;$Lon_reference;"xpath";$Txt_buffer)
						$Dom_node:=DOM Find XML element:C864(Storage:C1525.environment.domBuildApp;$Txt_buffer)
						
						If (OK=1)
							
							SET LIST ITEM PARAMETER:C986(Form:C1466.buildApp;$Lon_reference;"UID";$Dom_node)
							
						End if 
					End if 
					
					If (OK=1)
						
						key_mark (True:C214;$Lon_reference;$Pic_mark)
						
					Else 
						
						key_mark (False:C215;$Lon_reference)
						
					End if 
				End for 
			End if 
			
			key_UPDATE 
			
		End if 
		
		  //………………………………………………………
	: ($Lon_page=3)  // Before
		
		If ($Boo_load)
			
			Form:C1466.methods.before:=String:C10($ƒ.get("methods@before").value)
			Form:C1466.plist:=$ƒ.get("info.plist").value
			
		End if 
		
		LISTBOX SELECT ROW:C912(*;"info.listbox";0;lk remove from selection:K53:3)
		OBJECT SET ENABLED:C1123(*;"b.key.delete";False:C215)
		
		GOTO OBJECT:C206(*;"method.before.box")
		
		  //………………………………………………………
	: ($Lon_page=4)  // Options
		
		If ($Boo_load)
			
			XML DECODE:C1091(String:C10($ƒ.get("options@increment_version").value);$Boo_on)
			Form:C1466.options.increment_version:=$Boo_on
			
			OBJECT SET ENABLED:C1123(*;"option.increment-build";File:C1566("/PACKAGE/Info.plist";*).exists)
			
			XML DECODE:C1091(String:C10($ƒ.get("options@zip_source").value);$Boo_on)
			Form:C1466.options.zip_source:=$Boo_on
			OBJECT SET ENABLED:C1123(*;"option.zip-sources";Storage:C1525.database.isDatabase)
			
			XML DECODE:C1091(String:C10($ƒ.get("options@close").value);$Boo_on)
			Form:C1466.options.close:=$Boo_on
			
			XML DECODE:C1091(String:C10($ƒ.get("options@delete_mac_content").value);$Boo_on)
			Form:C1466.options.delete_mac_content:=$Boo_on
			OBJECT SET ENABLED:C1123(*;"option.delete-mac-content";Is macOS:C1572)
			
			Form:C1466.reveal.path:=(String:C10($ƒ.get("reveal@path").value)="./")
			
			XML DECODE:C1091(String:C10($ƒ.get("options@removeDevResources").value);$Boo_on)
			Form:C1466.options.removeDevResources:=$Boo_on
			
			XML DECODE:C1091(String:C10($ƒ.get("options@launch").value);$Boo_on)
			Form:C1466.options.launch:=$Boo_on
			
			XML DECODE:C1091(String:C10($ƒ.get("options@exportStructure").value);$Boo_on)
			Form:C1466.options.exportStructure:=$Boo_on
			
			XML DECODE:C1091(String:C10($ƒ.get("options@gitRepository").value);$Boo_on)
			Form:C1466.options.gitRepository:=$Boo_on
			
			If (Storage:C1525.database.isProject)
				
				OBJECT SET ENABLED:C1123(*;"option.exportStructure";False:C215)
				OBJECT SET ENABLED:C1123(*;"option.gitRepository";False:C215)
				
			Else 
				
				OBJECT SET ENABLED:C1123(*;"option.gitRepository";Form:C1466.options.exportStructure & Storage:C1525.environment.gitAvailable & Storage:C1525.database.isDatabase & Is macOS:C1572)
				
			End if 
		End if 
		
		  //………………………………………………………
	: ($Lon_page=5)  // After
		
		If ($Boo_load)
			
			Form:C1466.copy:=$ƒ.get("copy").value
			Form:C1466.delete:=$ƒ.get("delete").value
			Form:C1466.methods.after:=String:C10($ƒ.get("methods@after").value)
			
		End if 
		
		LISTBOX SELECT ROW:C912(*;"list.copy";0;lk remove from selection:K53:3)
		OBJECT SET ENABLED:C1123(*;"b.copy.delete";False:C215)
		
		LISTBOX SELECT ROW:C912(*;"list.delete";0;lk remove from selection:K53:3)
		OBJECT SET ENABLED:C1123(*;"b.delete.delete";False:C215)
		
		  //………………………………………………………
	Else 
		
		TRACE:C157
		
		  //………………………………………………………
End case 

Form:C1466.loaded[$Lon_page]:=True:C214