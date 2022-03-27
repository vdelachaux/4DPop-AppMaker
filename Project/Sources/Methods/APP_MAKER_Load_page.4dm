//%attributes = {"invisible":true}
// ----------------------------------------------------
// Method : APP_MAKER_Load_page
// Created 30/05/08 by Vincent de Lachaux
// ----------------------------------------------------
// Description
//
// ----------------------------------------------------
// Declarations
#DECLARE($page : Integer)

If (False:C215)
	C_LONGINT:C283(APP_MAKER_Load_page; $1)
End if 

var $node; $root; $t : Text
var $notSet; $set : Picture
var $expanded; $isOn; $loaded : Boolean
var $i; $page; $ref; $sublist; $uid : Integer
var $ƒ : Object
var $xml : cs:C1710.xml

$ƒ:=Storage:C1525.preferences

// Test if page was already loaded
$loaded:=$page>(Form:C1466.loaded.length-1) ? False:C215 : Bool:C1537(Form:C1466.loaded[$page])

Case of 
		
		//………………………………………………………
	: ($page=1)
		
		If (OBJECT Get visible:C1075(*; "tips.run"))
			
			OBJECT SET VISIBLE:C603(*; "tips.run"; False:C215)
			
		End if 
		
		//………………………………………………………
	: ($page=2)  // BuildApp
		
		If (Not:C34($loaded))
			
			READ PICTURE FILE:C678(File:C1566("/RESOURCES/Images/xml_mark.png").platformPath; $set)
			CREATE THUMBNAIL:C679($notSet; $notSet; 8; 8)
			
			// ⚠️ Delete the empty list created during loading
			CLEAR LIST:C377(Form:C1466.buildApp; *)
			
			// Load the description file
			$xml:=cs:C1710.xml.new(File:C1566("/RESOURCES/BuildAppKey.xml"))
			Form:C1466.buildApp:=$xml.toList($xml.root; ->$uid; "/Preferences4D")
			$xml.close()
			
			OBJECT SET VALUE:C1742("key.list"; Form:C1466.buildApp)
			
			// Load the user buildApp settings
			$root:=Storage:C1525.environment.domBuildApp
			
			For ($i; 1; Count list items:C380(Form:C1466.buildApp; *))
				
				GET LIST ITEM:C378(Form:C1466.buildApp; $i; $ref; $t; $sublist; $expanded)
				
				OK:=Num:C11($sublist=0)
				
				If (Bool:C1537(OK))
					
					GET LIST ITEM PARAMETER:C985(Form:C1466.buildApp; $ref; "xpath"; $t)
					$node:=DOM Find XML element:C864($root; $t)
					
					If (Bool:C1537(OK))
						
						SET LIST ITEM PARAMETER:C986(Form:C1466.buildApp; $ref; "dom"; $node)
						
					End if 
				End if 
				
				SET LIST ITEM ICON:C950(Form:C1466.buildApp; $ref; Choose:C955(Bool:C1537(OK); $set; $notSet))
				
			End for 
			
			key_UPDATE
			
			OBJECT SET VALUE:C1742("key.list"; Form:C1466.buildApp)
			
		End if 
		
		//………………………………………………………
	: ($page=3)  // Before
		
		If ($loaded)
			
			Form:C1466.methods.before:=String:C10($ƒ.get("methods@before").value)
			Form:C1466.plist:=$ƒ.get("info.plist").value
			
		End if 
		
		LISTBOX SELECT ROW:C912(*; "info.listbox"; 0; lk remove from selection:K53:3)
		OBJECT SET ENABLED:C1123(*; "b.key.delete"; False:C215)
		
		GOTO OBJECT:C206(*; "method.before.box")
		
		//………………………………………………………
	: ($page=4)  // Options
		
		If ($loaded)
			
			XML DECODE:C1091(String:C10($ƒ.get("options@increment_version").value); $isOn)
			Form:C1466.options.increment_version:=$isOn
			
			OBJECT SET ENABLED:C1123(*; "option.increment-build"; File:C1566("/PACKAGE/Info.plist"; *).exists)
			
			XML DECODE:C1091(String:C10($ƒ.get("options@zip_source").value); $isOn)
			Form:C1466.options.zip_source:=$isOn
			OBJECT SET ENABLED:C1123(*; "option.zip-sources"; Storage:C1525.database.isDatabase)
			
			XML DECODE:C1091(String:C10($ƒ.get("options@close").value); $isOn)
			Form:C1466.options.close:=$isOn
			
			XML DECODE:C1091(String:C10($ƒ.get("options@delete_mac_content").value); $isOn)
			OBJECT SET ENABLED:C1123(*; "option.delete-mac-content"; Is macOS:C1572)
			
			Form:C1466.reveal.path:=(String:C10($ƒ.get("reveal@path").value)="./")
			
			XML DECODE:C1091(String:C10($ƒ.get("options@removeDevResources").value); $isOn)
			Form:C1466.options.removeDevResources:=$isOn
			
			XML DECODE:C1091(String:C10($ƒ.get("options@launch").value); $isOn)
			Form:C1466.options.launch:=$isOn
			
			XML DECODE:C1091(String:C10($ƒ.get("options@exportStructure").value); $isOn)
			Form:C1466.options.exportStructure:=$isOn
			
			XML DECODE:C1091(String:C10($ƒ.get("options@gitRepository").value); $isOn)
			Form:C1466.options.gitRepository:=$isOn
			
			If (Storage:C1525.database.isProject)
				
				OBJECT SET ENABLED:C1123(*; "option.exportStructure"; False:C215)
				OBJECT SET ENABLED:C1123(*; "option.gitRepository"; False:C215)
				
			Else 
				
				OBJECT SET ENABLED:C1123(*; "option.gitRepository"; Form:C1466.options.exportStructure & Storage:C1525.environment.gitAvailable & Storage:C1525.database.isDatabase & Is macOS:C1572)
				
			End if 
			
			XML DECODE:C1091(String:C10($ƒ.get("options@notarize").value); $isOn)
			Form:C1466.options.notarize:=$isOn
			
		End if 
		
		//………………………………………………………
	: ($page=5)  // After
		
		If ($loaded)
			
			Form:C1466.copy:=$ƒ.get("copy").value
			Form:C1466.delete:=$ƒ.get("delete").value
			Form:C1466.methods.after:=String:C10($ƒ.get("methods@after").value)
			
		End if 
		
		LISTBOX SELECT ROW:C912(*; "list.copy"; 0; lk remove from selection:K53:3)
		OBJECT SET ENABLED:C1123(*; "b.copy.delete"; False:C215)
		
		LISTBOX SELECT ROW:C912(*; "list.delete"; 0; lk remove from selection:K53:3)
		OBJECT SET ENABLED:C1123(*; "b.delete.delete"; False:C215)
		
		//………………………………………………………
	Else 
		
		TRACE:C157
		
		//………………………………………………………
End case 

Form:C1466.loaded[$page]:=True:C214