Class extends lep

//=== === === === === === === === === === === === === === === === === === === === === === ===
Class constructor($settings : 4D:C1709.File)
	
	var $o : Object
	var $identities : Collection
	var $file : 4D:C1709.File
	
	Super:C1705()
	
	This:C1470.package:=Folder:C1567(Get 4D folder:C485(Database folder:K5:14; *); fk platform path:K87:2)
	This:C1470._SettingsUsed:=""
	This:C1470._Source:=""
	
	This:C1470.buildResults:=New collection:C1472
	This:C1470.lib4d:=File:C1566("📄")
	
	This:C1470.password:="@keychain:altool"
	
	$file:=This:C1470.package.file("Preferences/notarise.json")
	
	If ($file.exists)
		
		$o:=JSON Parse:C1218($file.getText())
		This:C1470.appleID:=$o.appleID#Null:C1517 ? String:C10($o.appleID) : ""
		This:C1470.certificate:=$o.certificate#Null:C1517 ? String:C10($o.certificate) : Null:C1517
		This:C1470.publicID:=$o.publicID#Null:C1517 ? String:C10($o.publicID) : Null:C1517
		
	Else 
		
		$identities:=This:C1470.findIdentity()
		This:C1470.identity:=This:C1470.success ? $identities.query("name == :1"; "Developer ID Application:@").pop() : Null:C1517
		
	End if 
	
	This:C1470.requestUID:=Null:C1517
	This:C1470.configurationFile:=Count parameters:C259>=1 ? $settings : File:C1566(Get 4D file:C1418(Build application settings file:K5:60; *); fk platform path:K87:2)
	
	This:C1470.success:=Bool:C1537(This:C1470.configurationFile.exists)
	
	//=== === === === === === === === === === === === === === === === === === === === === === ===
Function buildApp($settings)
	
	var $message; $root : Text
	var $i : Integer
	
	If (Count parameters:C259>=1)
		
		If (Value type:C1509($settings)=Is object:K8:27)
			
			This:C1470.configurationFile:=$settings
			
		Else 
			
			// Pathname
			This:C1470.configurationFile:=File:C1566(String:C10($settings))
			
		End if 
	End if 
	
	This:C1470.buildResults:=New collection:C1472
	
	This:C1470.success:=Bool:C1537(This:C1470.configurationFile.exists)
	
	If (This:C1470.success)
		
		BUILD APPLICATION:C871(This:C1470.configurationFile.platformPath)
		This:C1470.lastBuildLog:=File:C1566(Get 4D file:C1418(Build application log file:K5:46; *); fk platform path:K87:2)
		This:C1470.success:=Bool:C1537(OK)
		
		If (This:C1470.success)
			
			$root:=DOM Parse XML source:C719(This:C1470.lastBuildLog.platformPath)
			
			If (Bool:C1537(OK))
				
				ARRAY TEXT:C222($nodes; 0x0000)
				$nodes{0}:=DOM Find XML element:C864($root; "Log/Message"; $nodes)
				
				If (Bool:C1537(OK))
					
					For ($i; 1; Size of array:C274($nodes); 1)
						
						DOM GET XML ELEMENT VALUE:C731($nodes{$i}; $message)
						This:C1470.buildResults.push($message)
						
					End for 
				End if 
				
				DOM CLOSE XML:C722($root)
				
			End if 
			
			This:C1470.success:=(This:C1470.buildResults.length>0)
			
			If (This:C1470.success)
				
				This:C1470.lib4d:=This:C1470._getLib4D()
				This:C1470.buildTarget:=This:C1470._getBuildTarget()
				
			End if 
			
		Else 
			
			This:C1470._pushError(This:C1470.lastBuildLog.getText())
			
		End if 
		
	Else 
		
		This:C1470._pushError("File not found: "+String:C10(This:C1470.configurationFile.path))
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === ===
Function removeSignature()
	
	This:C1470.launch("codesign --remove-signature "+This:C1470.quoted(This:C1470.lib4d.path))
	
	//=== === === === === === === === === === === === === === === === === === === === === === ===
Function sign()
	
	var $identity : Text
	
	Case of 
			//______________________________________________________
		: (This:C1470.certificate#Null:C1517)
			
			$identity:=This:C1470.quoted("Developer ID Application: "+This:C1470.certificate)
			
			//______________________________________________________
		: (This:C1470.identity#Null:C1517)
			
			$identity:=This:C1470.identity.name
			
			//______________________________________________________
		Else 
			
			This:C1470._pushError("No certificate provided nor identity found")
			
			//______________________________________________________
	End case 
	
	If (Length:C16($identity)>0)
		
		// ⚠️ RESULT IS ON ERROR STREAM
		This:C1470.resultInErrorStream:=True:C214
		This:C1470.launch("codesign --verbose --deep --timestamp --force --sign "+$identity+" "+This:C1470.quoted(This:C1470.lib4d.path))
		This:C1470.resultInErrorStream:=False:C215
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === ===
Function verifySignature($target : Object)->$success : Boolean
	
	If (Count parameters:C259>=1)
		
		This:C1470.launch("codesign --verify --verbose --deep --strict  "+This:C1470.quoted($target.path))
		
	Else 
		
		This:C1470.launch("codesign --verify --verbose --deep --strict  "+This:C1470.quoted(This:C1470.lib4d.path))
		
	End if 
	
	If (This:C1470.success)
		
/*
lib4d-arm64.dylib: valid on disk
lib4d-arm64.dylib: satisfies its Designated Requirement
*/
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
Function ckeckWithGatekeeper()->$result : Text
	
	// ⚠️ RESULT IS ON ERROR STREAM
	This:C1470.resultInErrorStream:=True:C214
	This:C1470.launch("spctl --assess --type install -vvvv "+This:C1470.quoted(This:C1470.lib4d.path))
	This:C1470.resultInErrorStream:=False:C215
	
	If (This:C1470.success)
		
/*
lib4d-arm64.dylib: accepted
source=Notarized Developer ID
origin=Developer ID Application: Vincent de Lachaux (DYRKW64QA9)
*/
		
		ARRAY LONGINT:C221($len; 0)
		ARRAY LONGINT:C221($pos; 0)
		If (Match regex:C1019("(?mi-s): accepted\\nsource=Notarized Developer ID\\norigin=Developer ID Application: ([^$]*)$"; This:C1470.outputStream; 1; $pos; $len))
			
			$result:=Substring:C12(This:C1470.outputStream; $pos{1}; $len{1})
			
		End if 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === ===
Function zip()
	
	This:C1470.archive:=This:C1470.buildTarget.parent.file(This:C1470.buildTarget.name+".zip")
	This:C1470.archive.delete()
	
	This:C1470.launch("/usr/bin/ditto -c -k --keepParent "+This:C1470.quoted(This:C1470.buildTarget.path)+" "+This:C1470.quoted(This:C1470.archive.path))
	
	//=== === === === === === === === === === === === === === === === === === === === === === ===
Function dmg()
	
	This:C1470.archive:=This:C1470.buildTarget.parent.file(This:C1470.buildTarget.name+".dmg")
	This:C1470.archive.delete()
	
	This:C1470.launch("hdiutil create -format UDBZ -plist -srcfolder "+This:C1470.quoted(This:C1470.buildTarget.path)+" "+This:C1470.quoted(This:C1470.archive.path))
	
	//=== === === === === === === === === === === === === === === === === === === === === === ===
Function notarize()
	
	This:C1470.requestUID:=Null:C1517
	
	var $bundleIdentifer : Text
	$bundleIdentifer:="com."+Replace string:C233(This:C1470.package.name; " "; "_")
	
	This:C1470.setOutputType(Is object:K8:27)
	This:C1470.launch("xcrun altool --notarize-app --output-format json"\
		+" -u "+This:C1470.appleID\
		+" -p "+This:C1470.quoted(This:C1470.password)\
		+" --primary-bundle-id "+$bundleIdentifer\
		+" -f "+This:C1470.quoted(This:C1470.archive.path)\
		+" --asc-public-id "+This:C1470.publicID)
	This:C1470.setOutputType()
	
	If (This:C1470.success)
		
		This:C1470.requestUID:=This:C1470.outputStream["notarization-upload"].RequestUUID
		This:C1470.success:=(This:C1470.requestUID#Null:C1517)
		
	Else 
		
		ARRAY LONGINT:C221($pos; 0)
		ARRAY LONGINT:C221($len; 0)
		
		If (Match regex:C1019("(?msi)Package Summary:\\W*(.*)"; This:C1470.errorStream; 1; $pos; $len))
			
			This:C1470._pushError(Substring:C12(This:C1470.errorStream; $pos{1}; $len{1}))
			
		End if 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === ===
Function waitForNotarizeResult()
	
	var $notarized : Boolean
	
	This:C1470.setOutputType(Is object:K8:27)
	
	While (Not:C34($notarized) & This:C1470.success)
		
		DELAY PROCESS:C323(Current process:C322; 30*60)  // Check twice a minute
		
		This:C1470.launch("xcrun altool --notarization-info  "+This:C1470.requestUID+" --output-format json -u "+This:C1470.appleID+" -p "+This:C1470.quoted(This:C1470.password))
		
		Case of 
				
				//______________________________________________________
			: (Not:C34(This:C1470.success))
				
				// <NOTHING MORE TO DO>
				
				//______________________________________________________
			: (This:C1470.outputStream["success-message"]#"No errors getting notarization info.")
				
				This:C1470._pushError(This:C1470.outputStream["success-message"])
				This:C1470.success:=False:C215
				
				//______________________________________________________
			: (This:C1470.outputStream["notarization-info"].Status="in progress")
				
				// A little patience, the elves are working 🧝
				
				//______________________________________________________
			: (This:C1470.outputStream["notarization-info"].Status="success")
				
				$notarized:=(This:C1470.outputStream["notarization-info"]["Status Message"]="Package Approved")
				
				//______________________________________________________
		End case 
	End while 
	
	This:C1470.setOutputType()
	
	//=== === === === === === === === === === === === === === === === === === === === === === ===
Function staple()
	
	This:C1470.launch("xcrun stapler staple "+This:C1470.quoted(This:C1470.archive.path))
	This:C1470.success:=Match regex:C1019("(?mi-s)The staple and validate action worked!"; This:C1470.outputStream; 1)
	
	If (Not:C34(This:C1470.success))
		
		This:C1470._pushError(This:C1470.outputStream)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === ===
Function compile($options : Object)->$error : Object
	
	If (Count parameters:C259>0)
		
		$error:=Compile project:C1760($options)
		
	Else 
		
		$error:=Compile project:C1760
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === ===
	/// 
Function findIdentity()->$identities : Collection
	
	var $info : Text
	var $start : Integer
	
	ARRAY LONGINT:C221($pos; 0)
	ARRAY LONGINT:C221($len; 0)
	
	$identities:=New collection:C1472
	
	This:C1470.launch("security find-identity -p basic -v")
	
	If (This:C1470.success)
		
		$start:=1
		
		While (Match regex:C1019("(?m)\\s+(\\d+\\))\\s+([:Hex_Digit:]+)\\s+\"([^\"]+)\"$"; This:C1470.outputStream; $start; $pos; $len))
			
			$identities.push(New object:C1471(\
				"id"; Substring:C12($info; $pos{2}; $len{2}); \
				"name"; Substring:C12(This:C1470.outputStream; $pos{3}; $len{3})))
			
			$start:=$pos{3}+$len{3}
			
		End while 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === ===
Function _getPublicID($password : Text)
	
	This:C1470.launch("xcrun altool --list-providers -u "+This:C1470.appleID+" -p "+$password)
	
/*
ProviderNameProviderShortname    PublicID                             WWDRTeamID
-------------------------------------- ------------------------------------ ----------
4D                 LaurentEsnault134048 69a6de71-ef2e-47e3-e053-5b8c7c11a4d1 37UG5W39Z2
Vincent de Lachaux DYRKW64QA9 ad963670-a233-4090-a45f-ceca3bd61c9b DYRKW64QA9
*/
	
	//=== === === === === === === === === === === === === === === === === === === === === === ===
Function _getLib4D()->$lib4DFile : 4D:C1709.File
	
	var $index : Integer
	
	$lib4DFile:=File:C1566("📄")
	
	$index:=This:C1470.buildResults.indexOf("Signed file:@")
	
	If ($index>=0)
		
		ARRAY LONGINT:C221($pos; 0x0000)
		ARRAY LONGINT:C221($len; 0x0000)
		
		If (Match regex:C1019("(?m-si)(/[^:]*):"; This:C1470.buildResults[$index]; 1; $pos; $len))
			
			$lib4DFile:=File:C1566(Substring:C12(This:C1470.buildResults[$index]; $pos{1}; $len{1}))
			
		End if 
	End if 
	
	This:C1470.success:=$lib4DFile.exists
	
	If (Not:C34(This:C1470.success))
		
		This:C1470._pushError("Unable to locate the file lib4d-arm64.dylib")
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === ===
Function _getBuildTarget()->$target : 4D:C1709.File
	
	var $index : Integer
	
	$index:=This:C1470.buildResults.indexOf("Start copying files :@")
	
	If ($index>=0)
		
		ARRAY LONGINT:C221($pos; 0x0000)
		ARRAY LONGINT:C221($len; 0x0000)
		
		If (Match regex:C1019("(?mi-s)\\s:\\s(.*)$"; This:C1470.buildResults[$index]; 1; $pos; $len))
			
			$target:=File:C1566(Substring:C12(This:C1470.buildResults[$index]; $pos{1}; $len{1}); fk platform path:K87:2).parent
			
		End if 
	End if 
	
	This:C1470.success:=$target.exists
	
	If (Not:C34(This:C1470.success))
		
		This:C1470._pushError("Unable to locate the build result")
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === ===
Function CommitAndPush($message : Text)->$error : Object
	
	var $cmd; $err; $in; $out; $path : Text
	
	$path:=Get 4D folder:C485(Database folder:K5:14; *)
	SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_CURRENT_DIRECTORY"; $path)
	LAUNCH EXTERNAL PROCESS:C811("git add --all"; $in; $out; $err)
	
	If (($out#"")\
		 | ($err#""))
		
		$error:=New object:C1471(\
			"success"; False:C215; \
			"Error git add"; $out+" "+$err)
		
	Else 
		
		SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_CURRENT_DIRECTORY"; $path)
		$cmd:="git commit -a -q -m "+Char:C90(34)+$message+Char:C90(34)
		LAUNCH EXTERNAL PROCESS:C811($cmd; $in; $out; $err)
		
		If (($out#"")\
			 | ($err#""))
			
			$error:=New object:C1471(\
				"success"; False:C215; \
				"Error git commit"; $out+" "+$err)
			
		Else 
			
			SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_CURRENT_DIRECTORY"; $path)
			LAUNCH EXTERNAL PROCESS:C811("git push"; $in; $out; $err)
			
			If ($err#"")
				
				$error:=New object:C1471(\
					"success"; False:C215; \
					"Error git push"; $err)
				
			Else 
				
				$error:=New object:C1471(\
					"success"; True:C214; \
					"git commit"; $out)
				
			End if 
		End if 
	End if 