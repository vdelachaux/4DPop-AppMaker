Class extends lep

//=== === === === === === === === === === === === === === === === === === === === === === ===
Class constructor($buildAppSettingsFile)
	
	var $o : Object
	var $file : 4D:C1709.File
	
	Super:C1705()
	
	// Project
	This:C1470.package:=Folder:C1567(Folder:C1567(fk database folder:K87:14; *).platformPath; fk platform path:K87:2)  // Unsandboxed
	
	// Settings
	Case of 
			
			//______________________________________________________
		: (Value type:C1509($buildAppSettingsFile)=Is object:K8:27)
			
			This:C1470.buildAppSettingsFile:=OB Instance of:C1731($buildAppSettingsFile; 4D:C1709.File) ? $buildAppSettingsFile : Null:C1517
			
			//______________________________________________________
		: (Value type:C1509($buildAppSettingsFile)=Is text:K8:3)\
			 && (Length:C16($buildAppSettingsFile)>0)  // Pathname
			
			This:C1470.buildAppSettingsFile:=File:C1566(String:C10($buildAppSettingsFile))
			
			//______________________________________________________
		Else   // Default
			
			$buildAppSettingsFile:=File:C1566(File:C1566(Build application settings file:K5:60; *).platformPath; fk platform path:K87:2)  // Unsandboxed
			This:C1470.buildAppSettingsFile:=$buildAppSettingsFile.exists ? $buildAppSettingsFile : Null:C1517
			
			//______________________________________________________
	End case 
	
	This:C1470.settings:=This:C1470._getSettings(This:C1470.buildAppSettingsFile)
	
	// Notarization settings
	$file:=This:C1470.package.file("Preferences/notarise.json")
	
	If ($file.exists)
		
		$o:=JSON Parse:C1218($file.getText())
		This:C1470.appleID:=$o.appleID ? String:C10($o.appleID) : Null:C1517
		This:C1470.certificate:=$o.certificate ? String:C10($o.certificate) : Null:C1517
		This:C1470.publicID:=$o.publicID ? String:C10($o.publicID) : Null:C1517
		This:C1470.keychainProfile:=$o.keychainProfile ? String:C10($o.keychainProfile) : Null:C1517
		
	Else 
		
		This:C1470.keychainProfile:="4DPOP"
		
	End if 
	
	This:C1470.lib4d:=File:C1566("📄")
	This:C1470.buildStatus:=Null:C1517
	This:C1470.requestUID:=Null:C1517
	
	//MARK:[COMPUTED]
	//=== === === === === === === === === === === === === === === === === === === === === === ===
Function get destinationFolder() : 4D:C1709.Folder
	
	If (This:C1470.settings#Null:C1517)
		
		Case of 
				
				//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
			: (Is Windows:C1573)
				
				$path:=This:C1470.settings.BuildWinDestFolder
				
				//MARK: TO TEST
				If (Substring:C12($path; 1; 1)=Folder separator:K24:12)
					
					var $parentFolderPath; $path : Text
					$parentFolderPath:=Folder:C1567(Get 4D folder:C485(Database folder:K5:14; *); fk platform path:K87:2).parent.parent.platformPath
					$parentFolderPath:=Substring:C12($parentFolderPath; 1; Length:C16($parentFolderPath)-1)
					$parentFolderPath:=$parentFolderPath+Delete string:C232($path; 1; 1)
					
					return (Folder:C1567($parentFolderPath; fk platform path:K87:2))
					
				Else 
					
					return (Folder:C1567($path; fk platform path:K87:2))
					
				End if 
				
				//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
			: (Is macOS:C1572)
				
				$path:=This:C1470.settings.BuildMacDestFolder
				
				If ($path[[1]]=":")
					
					return (Folder:C1567(Get 4D folder:C485(Database folder:K5:14; *); fk platform path:K87:2).folder(Replace string:C233(Delete string:C232($path; 1; 1); Folder separator:K24:12; "/")))
					
				End if 
				
				//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		End case 
	End if 
	
	
	//=== === === === === === === === === === === === === === === === === === === === === === ===
Function run() : Boolean
	
	var $code; $desc; $message; $root; $target; $type : Text
	var $i : Integer
	
	If (This:C1470.success)
		
		If (This:C1470.buildAppSettingsFile#Null:C1517)\
			 && (This:C1470.buildAppSettingsFile.exists)
			
			BUILD APPLICATION:C871(This:C1470.buildAppSettingsFile.platformPath)
			
		Else 
			
			BUILD APPLICATION:C871()
			
		End if 
		
		This:C1470.success:=Bool:C1537(OK)
		
		This:C1470.lastBuildLog:=File:C1566(Build application log file:K5:46; *)
		
		If (This:C1470.success)
			
			This:C1470.buildStatus:=New collection:C1472
			
			$root:=DOM Parse XML source:C719(This:C1470.lastBuildLog.platformPath)
			
			If (Bool:C1537(OK))
				
				ARRAY TEXT:C222($nodes; 0x0000)
				$nodes{0}:=DOM Find XML element:C864($root; "Log"; $nodes)
				
				If (Bool:C1537(OK))
					
					For ($i; 1; Size of array:C274($nodes); 1)
						
						DOM GET XML ELEMENT VALUE:C731(DOM Find XML element:C864($nodes{$i}; "MessageType"); $type)
						DOM GET XML ELEMENT VALUE:C731(DOM Find XML element:C864($nodes{$i}; "Target"); $target)
						DOM GET XML ELEMENT VALUE:C731(DOM Find XML element:C864($nodes{$i}; "CodeDesc"); $desc)
						DOM GET XML ELEMENT VALUE:C731(DOM Find XML element:C864($nodes{$i}; "CodeId"); $code)
						DOM GET XML ELEMENT VALUE:C731(DOM Find XML element:C864($nodes{$i}; "Message"); $message)
						
						This:C1470.buildStatus.push(New object:C1471(\
							"messageType"; $type; \
							"target"; $target; \
							"codeDesc"; $desc; \
							"codeId"; $code; \
							"message"; $message))
						
					End for 
				End if 
				
				DOM CLOSE XML:C722($root)
				
			End if 
			
			This:C1470.success:=(This:C1470.buildStatus.length>0)
			
			If (This:C1470.success)
				
				This:C1470.buildTarget:=This:C1470._getBuildTarget()
				This:C1470.lib4d:=This:C1470._getLib4D()
				
			End if 
			
		Else 
			
			This:C1470._pushError(This:C1470.lastBuildLog.getText())
			
		End if 
		
	Else 
		
		This:C1470._pushError("File not found: "+String:C10(This:C1470.buildAppSettingsFile.path))
		
	End if 
	
	return (This:C1470.success)
	
	//=== === === === === === === === === === === === === === === === === === === === === === ===
Function removeSignature() : Boolean
	
	This:C1470.launch("codesign --remove-signature "+This:C1470.quoted(This:C1470.lib4d.path))
	
	return (This:C1470.success)
	
	//=== === === === === === === === === === === === === === === === === === === === === === ===
Function sign() : Boolean
	
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
	
	return (This:C1470.success)
	
	//=== === === === === === === === === === === === === === === === === === === === === === ===
Function notarize($target : 4D:C1709.File) : Boolean
	
	This:C1470.success:=(OB Instance of:C1731($target; 4D:C1709.File))
	
	This:C1470.setOutputType(Is object:K8:27)
	This:C1470.launch("xcrun notarytool submit "+This:C1470.quoted($target.path)\
		+" --keychain-profile "+This:C1470.quoted(This:C1470.keychainProfile)\
		+" --output-format json --wait")
	This:C1470.setOutputType()
	
	If (This:C1470.success)
		
		This:C1470.requestStatus:=String:C10(This:C1470.outputStream.status)
		This:C1470.requestUID:=String:C10(This:C1470.outputStream.id)
		This:C1470.success:=(This:C1470.requestStatus="Accepted")
		
	End if 
	
	return (This:C1470.success)
	
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
Function storeCredential() : Boolean
	
	
	
	//=== === === === === === === === === === === === === === === === === === === === === === ===
Function staple($target : 4D:C1709.File) : Boolean
	
	This:C1470.launch("xcrun stapler staple "+This:C1470.quoted($target.path))
	This:C1470.success:=Match regex:C1019("(?mi-s)The staple and validate action worked!"; This:C1470.outputStream; 1)
	
	If (Not:C34(This:C1470.success))
		
		This:C1470._pushError(This:C1470.outputStream)
		
	End if 
	
	return (This:C1470.success)
	
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
	
	//=== === === === === === === === === === === === === === === === === === === === === === ===
Function _getPublicID($password : Text)
	
	This:C1470.launch("xcrun altool --list-providers -u "+This:C1470.appleID+" -p "+$password)
	
	//MARK:[COMPUTED]
	//=== === === === === === === === === === === === === === === === === === === === === === ===
	// Returns settings as object
Function _getSettings($settingsFile : 4D:C1709.File)->$settings : Object
	
	var $child; $count; $itemName; $name; $node; $parent : Text
	var $root; $string : Text
	var $bool : Boolean
	var $i; $integer; $j : Integer
	var $linkModes : Collection
	
	ARRAY TEXT:C222($itemNames; 0)
	ARRAY TEXT:C222($names; 0)
	
	$settings:=This:C1470._defaultBuildSettings()
	
	If (OB Instance of:C1731($settingsFile; 4D:C1709.File))
		
		If ($settingsFile.exists)
			
			$root:=DOM Parse XML source:C719($settingsFile.platformPath)
			
			If (OK=1)
				
				$linkModes:=New collection:C1472("InDbStruct"; "ByAppName"; "ByAppPath")
				
				$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/BuildApplicationName")
				
				If (OK=1)
					
					DOM GET XML ELEMENT VALUE:C731($node; $string)
					$settings.BuildApplicationName:=$string
					
				End if 
				
				$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/BuildCompiled")
				
				If (OK=1)
					
					DOM GET XML ELEMENT VALUE:C731($node; $bool)
					$settings.BuildCompiled:=$bool
					
				End if 
				
				$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/IncludeAssociatedFolders")
				
				If (OK=1)
					
					DOM GET XML ELEMENT VALUE:C731($node; $bool)
					$settings.IncludeAssociatedFolders:=$bool
					
				End if 
				
				$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/BuildComponent")
				
				If (OK=1)
					
					DOM GET XML ELEMENT VALUE:C731($node; $bool)
					$settings.BuildComponent:=$bool
					
				End if 
				
				$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/BuildApplicationSerialized")
				
				If (OK=1)
					
					DOM GET XML ELEMENT VALUE:C731($node; $bool)
					$settings.BuildApplicationSerialized:=$bool
					
				End if 
				
				$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/BuildApplicationLight")
				
				If (OK=1)
					
					DOM GET XML ELEMENT VALUE:C731($node; $bool)
					$settings.BuildApplicationLight:=$bool
					
				End if 
				
				$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/BuildMacDestFolder")
				
				If (OK=1)
					
					DOM GET XML ELEMENT VALUE:C731($node; $string)
					$settings.BuildMacDestFolder:=$string
					
				End if 
				
				$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/PackProject")
				
				If (OK=1)
					
					DOM GET XML ELEMENT VALUE:C731($node; $bool)
					$settings.PackProject:=$bool
					
				End if 
				
				$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/UseStandardZipFormat")
				
				If (OK=1)
					
					DOM GET XML ELEMENT VALUE:C731($node; $bool)
					$settings.UseStandardZipFormat:=$bool
					
				End if 
				
				$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/BuildWinDestFolder")
				
				If (OK=1)
					
					DOM GET XML ELEMENT VALUE:C731($node; $string)
					$settings.BuildWinDestFolder:=$string
					
				End if 
				
				$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/SourcesFiles/RuntimeVL/RuntimeVLIncludeIt")
				
				If (OK=1)
					
					DOM GET XML ELEMENT VALUE:C731($node; $bool)
					$settings.SourcesFiles.RuntimeVL.RuntimeVLIncludeIt:=$bool
					
				End if 
				
				$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/SourcesFiles/RuntimeVL/RuntimeVLMacFolder")
				
				If (OK=1)
					
					DOM GET XML ELEMENT VALUE:C731($node; $string)
					$settings.SourcesFiles.RuntimeVL.RuntimeVLMacFolder:=$string
					
				End if 
				
				$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/SourcesFiles/RuntimeVL/RuntimeVLWinFolder")
				
				If (OK=1)
					
					DOM GET XML ELEMENT VALUE:C731($node; $string)
					$settings.SourcesFiles.RuntimeVL.RuntimeVLWinFolder:=$string
					
				End if 
				
				$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/SourcesFiles/RuntimeVL/IsOEM")
				
				If (OK=1)
					
					DOM GET XML ELEMENT VALUE:C731($node; $bool)
					$settings.SourcesFiles.RuntimeVL.IsOEM:=$bool
					
				End if 
				
				$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/SourcesFiles/CS/ServerIncludeIt")
				
				If (OK=1)
					
					DOM GET XML ELEMENT VALUE:C731($node; $bool)
					$settings.SourcesFiles.CS.ServerIncludeIt:=$bool
					
				End if 
				
				$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/SourcesFiles/CS/ClientMacIncludeIt")
				
				If (OK=1)
					
					DOM GET XML ELEMENT VALUE:C731($node; $bool)
					$settings.SourcesFiles.CS.ClientMacIncludeIt:=$bool
					
				End if 
				
				$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/SourcesFiles/CS/ClientWinIncludeIt")
				
				If (OK=1)
					
					DOM GET XML ELEMENT VALUE:C731($node; $bool)
					$settings.SourcesFiles.CS.ClientWinIncludeIt:=$bool
					
				End if 
				
				$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/SourcesFiles/CS/ServerMacFolder")
				
				If (OK=1)
					
					DOM GET XML ELEMENT VALUE:C731($node; $string)
					$settings.SourcesFiles.CS.ServerMacFolder:=$string
					
				End if 
				
				$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/SourcesFiles/CS/ServerWinFolder")
				
				If (OK=1)
					
					DOM GET XML ELEMENT VALUE:C731($node; $string)
					$settings.SourcesFiles.CS.ServerWinFolder:=$string
					
				End if 
				
				$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/SourcesFiles/CS/ClientWinFolderToWin")
				
				If (OK=1)
					
					DOM GET XML ELEMENT VALUE:C731($node; $string)
					$settings.SourcesFiles.CS.ClientWinFolderToWin:=$string
					
				End if 
				
				$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/SourcesFiles/CS/ClientWinFolderToMac")
				
				If (OK=1)
					
					DOM GET XML ELEMENT VALUE:C731($node; $string)
					$settings.SourcesFiles.CS.ClientWinFolderToMac:=$string
					
				End if 
				
				$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/SourcesFiles/CS/ClientMacFolderToWin")
				
				If (OK=1)
					
					DOM GET XML ELEMENT VALUE:C731($node; $string)
					$settings.SourcesFiles.CS.ClientMacFolderToWin:=$string
					
				End if 
				
				$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/SourcesFiles/CS/ClientMacFolderToMac")
				
				If (OK=1)
					
					DOM GET XML ELEMENT VALUE:C731($node; $string)
					$settings.SourcesFiles.CS.ClientMacFolderToMac:=$string
					
				End if 
				
				$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/SourcesFiles/CS/ServerIconWinPath")
				
				If (OK=1)
					
					DOM GET XML ELEMENT VALUE:C731($node; $string)
					$settings.SourcesFiles.CS.ServerIconWinPath:=$string
					
				End if 
				
				$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/SourcesFiles/CS/ServerIconMacPath")
				
				If (OK=1)
					
					DOM GET XML ELEMENT VALUE:C731($node; $string)
					$settings.SourcesFiles.CS.ServerIconMacPath:=$string
					
				End if 
				
				$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/SourcesFiles/CS/ClientMacIconForMacPath")
				
				If (OK=1)
					
					DOM GET XML ELEMENT VALUE:C731($node; $string)
					$settings.SourcesFiles.CS.ClientMacIconForMacPath:=$string
					
				End if 
				
				$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/SourcesFiles/CS/ClientWinIconForMacPath")
				
				If (OK=1)
					
					DOM GET XML ELEMENT VALUE:C731($node; $string)
					$settings.SourcesFiles.CS.ClientWinIconForMacPath:=$string
					
				End if 
				
				$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/SourcesFiles/CS/ClientMacIconForWinPath")
				
				If (OK=1)
					
					DOM GET XML ELEMENT VALUE:C731($node; $string)
					$settings.SourcesFiles.CS.ClientMacIconForWinPath:=$string
					
				End if 
				
				$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/SourcesFiles/CS/ClientWinIconForWinPath")
				
				If (OK=1)
					
					DOM GET XML ELEMENT VALUE:C731($node; $string)
					$settings.SourcesFiles.CS.ClientWinIconForWinPath:=$string
					
				End if 
				
				$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/SourcesFiles/CS/DatabaseToEmbedInClientMacFolder")
				
				If (OK=1)
					
					DOM GET XML ELEMENT VALUE:C731($node; $string)
					$settings.SourcesFiles.CS.DatabaseToEmbedInClientMacFolder:=$string
					
				End if 
				
				$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/SourcesFiles/CS/DatabaseToEmbedInClientWinFolder")
				
				If (OK=1)
					
					DOM GET XML ELEMENT VALUE:C731($node; $string)
					$settings.SourcesFiles.CS.DatabaseToEmbedInClientWinFolder:=$string
					
				End if 
				
				$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/SourcesFiles/CS/IsOEM")
				
				If (OK=1)
					
					DOM GET XML ELEMENT VALUE:C731($node; $bool)
					$settings.SourcesFiles.RuntimeVL.IsOEM:=$bool
					
				End if 
				
				$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/CS/BuildServerApplication")
				
				If (OK=1)
					
					DOM GET XML ELEMENT VALUE:C731($node; $bool)
					$settings.CS.BuildServerApplication:=$bool
					
				End if 
				
				$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/CS/LastDataPathLookup")
				
				If (OK=1)
					
					DOM GET XML ELEMENT VALUE:C731($node; $string)
					
					If ($linkModes.indexOf($string)#-1)
						
						$settings.CS.LastDataPathLookup:=$string
						
					End if 
				End if 
				
				$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/CS/BuildCSUpgradeable")
				
				If (OK=1)
					
					DOM GET XML ELEMENT VALUE:C731($node; $bool)
					$settings.CS.BuildCSUpgradeable:=$bool
					
				End if 
				
				$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/CS/CurrentVers")
				
				If (OK=1)
					
					DOM GET XML ELEMENT VALUE:C731($node; $integer)
					
					If ($integer>0)
						
						$settings.CS.CurrentVers:=$integer
						
					End if 
				End if 
				
				$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/CS/HardLink")
				
				If (OK=1)
					
					DOM GET XML ELEMENT VALUE:C731($node; $string)
					$settings.CS.HardLink:=$string
					
				End if 
				
				$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/CS/BuildV13ClientUpgrades")
				
				If (OK=1)
					
					DOM GET XML ELEMENT VALUE:C731($node; $bool)
					$settings.CS.BuildV13ClientUpgrades:=$bool
					
				End if 
				
				$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/CS/IPAddress")
				
				If (OK=1)
					
					DOM GET XML ELEMENT VALUE:C731($node; $string)
					$settings.CS.IPAddress:=$string
					
				End if 
				
				$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/CS/PortNumber")
				
				If (OK=1)
					
					DOM GET XML ELEMENT VALUE:C731($node; $integer)
					$settings.CS.PortNumber:=$integer
					
				End if 
				
				$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/CS/RangeVersMin")
				
				If (OK=1)
					
					DOM GET XML ELEMENT VALUE:C731($node; $integer)
					
					If ($integer>0)
						
						$settings.CS.RangeVersMin:=$integer
						
					End if 
				End if 
				
				$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/CS/RangeVersMax")
				
				If (OK=1)
					
					DOM GET XML ELEMENT VALUE:C731($node; $integer)
					
					If ($integer>0)
						
						$settings.CS.RangeVersMax:=$integer
						
					End if 
				End if 
				
				$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/CS/ServerSelectionAllowed")
				
				If (OK=1)
					
					DOM GET XML ELEMENT VALUE:C731($node; $bool)
					$settings.CS.ServerSelectionAllowed:=$bool
					
				End if 
				
				$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/CS/MacCompiledDatabaseToWin")
				
				If (OK=1)
					
					DOM GET XML ELEMENT VALUE:C731($node; $string)
					$settings.CS.MacCompiledDatabaseToWin:=$string
					
				End if 
				
				$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/CS/MacCompiledDatabaseToWinIncludeIt")
				
				If (OK=1)
					
					DOM GET XML ELEMENT VALUE:C731($node; $bool)
					$settings.CS.MacCompiledDatabaseToWinIncludeIt:=$bool
					
				End if 
				
				$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/SignApplication/MacSignature")
				
				If (OK=1)
					
					DOM GET XML ELEMENT VALUE:C731($node; $bool)
					$settings.SignApplication.MacSignature:=$bool
					
				End if 
				
				$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/SignApplication/MacCertificate")
				
				If (OK=1)
					
					DOM GET XML ELEMENT VALUE:C731($node; $string)
					$settings.SignApplication.MacCertificate:=$string
					
				End if 
				
				$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/SignApplication/AdHocSign")
				
				If (OK=1)
					
					DOM GET XML ELEMENT VALUE:C731($node; $bool)
					$settings.SignApplication.AdHocSign:=$bool
					
				End if 
				
				$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/RuntimeVL/LastDataPathLookup")
				
				If (OK=1)
					
					DOM GET XML ELEMENT VALUE:C731($node; $string)
					
					If ($linkModes.indexOf($string)#-1)
						
						$settings.RuntimeVL.LastDataPathLookup:=$string
						
					End if 
				End if 
				
				OB GET PROPERTY NAMES:C1232($settings.Licenses; $names)
				
				For ($i; 1; Size of array:C274($names); 1)
					
					$name:=$names{$i}
					$count:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/Licenses/"+$name+"/ItemsCount")
					
					If (OK=1)
						
						DOM GET XML ELEMENT VALUE:C731($count; $integer)
						
						$node:=DOM Get next sibling XML element:C724($count)
						
						For ($j; 0; $integer-1)
							
							DOM GET XML ELEMENT VALUE:C731($node; $string)
							$settings.Licenses[$name].Item[$j]:=$string ? $string : Null:C1517
							$node:=DOM Get next sibling XML element:C724($node)
							
						End for 
					End if 
				End for 
				
				For each ($name; New collection:C1472(\
					"ArrayExcludedPluginName"; \
					"ArrayExcludedPluginID"; \
					"ArrayExcludedComponentName"))
					
					$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/"+$name+"/ItemsCount")
					
					If (OK=1)
						
						DOM GET XML ELEMENT VALUE:C731($node; $integer)
						$settings[$name].ItemsCount:=$integer
						
						$node:=DOM Get next sibling XML element:C724($node)
						
						If (OK=1)
							For ($j; 0; $integer-1)
								
								DOM GET XML ELEMENT VALUE:C731($node; $string)
								$settings[$name].Item[$j]:=$string ? $string : Null:C1517
								$node:=DOM Get next sibling XML element:C724($node)
								
							End for 
						End if 
					End if 
				End for each 
				
				OB GET PROPERTY NAMES:C1232($settings.Versioning; $names)
				$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/Versioning")
				
				If (OK=1)
					
					For ($i; 1; Size of array:C274($names); 1)
						
						$name:=$names{$i}
						$parent:=DOM Find XML element:C864($node; $name)
						
						OB GET PROPERTY NAMES:C1232($settings.Versioning[$name]; $itemNames)
						
						For ($j; 1; Size of array:C274($itemNames); 1)
							
							$itemName:=$itemNames{$j}
							$child:=DOM Find XML element:C864($parent; $itemName)
							
							If (OK=1)
								
								DOM GET XML ELEMENT VALUE:C731($child; $string)
								$settings.Versioning[$name][$itemName]:=$string
								
							End if 
						End for 
					End for 
				End if 
				
				DOM CLOSE XML:C722($root)
				
			End if 
		End if 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === ===
Function _getBuildTarget() : 4D:C1709.Folder
	
	var $o : Object
	var $folder : 4D:C1709.Folder
	
	$o:=This:C1470.buildStatus.query("message = :1"; "Start copying files : @").pop()
	
	If ($o#Null:C1517)
		
		$folder:=File:C1566(Replace string:C233($o.message; "Start copying files : "; ""); fk platform path:K87:2).parent
		
		If ($folder.exists)
			
			return ($folder)
			
		Else 
			
			// TODO:ERROR
			
		End if 
		
	Else 
		
		// TODO:ERROR
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === ===
Function _getLib4D() : 4D:C1709.File
	
	var $file : 4D:C1709.File
	
	$file:=This:C1470.buildTarget.file("Libraries/lib4d-arm64.dylib")
	
	If ($file.exists)
		
		return ($file)
		
	Else 
		
		// NOT COMPILED FOR AMD
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === ===
Function _defaultBuildSettings() : Object
	
	var $o : Object
	
	$o:=New object:C1471(\
		"BuildApplicationName"; Null:C1517; \
		"BuildWinDestFolder"; Null:C1517; \
		"BuildMacDestFolder"; Null:C1517; \
		"DataFilePath"; Null:C1517; \
		"BuildApplicationSerialized"; False:C215; \
		"BuildApplicationLight"; False:C215; \
		"IncludeAssociatedFolders"; False:C215; \
		"BuildComponent"; False:C215; \
		"BuildCompiled"; False:C215; \
		"ArrayExcludedPluginName"; New object:C1471("ItemsCount"; 0; "Item"; New collection:C1472); \
		"ArrayExcludedPluginID"; New object:C1471("ItemsCount"; 0; "Item"; New collection:C1472); \
		"ArrayExcludedComponentName"; New object:C1471("ItemsCount"; 0; "Item"; New collection:C1472); \
		"UseStandardZipFormat"; False:C215; \
		"PackProject"; True:C214)
	
	$o.AutoUpdate:=New object:C1471(\
		"CS"; \
		New object:C1471(\
		"Client"; New object:C1471("StartElevated"; Null:C1517); \
		"ClientUpdateWin"; New object:C1471("StartElevated"; Null:C1517); \
		"Server"; New object:C1471("StartElevated"; Null:C1517)); \
		"RuntimeVL"; New object:C1471(\
		"StartElevated"; Null:C1517))
	
	$o.CS:=New object:C1471(\
		"BuildServerApplication"; False:C215; \
		"BuildCSUpgradeable"; False:C215; \
		"BuildV13ClientUpgrades"; False:C215; \
		"IPAddress"; Null:C1517; \
		"PortNumber"; Null:C1517; \
		"HardLink"; Null:C1517; \
		"RangeVersMin"; 1; \
		"RangeVersMax"; 1; \
		"CurrentVers"; 1; \
		"LastDataPathLookup"; Null:C1517; \
		"ServerSelectionAllowed"; False:C215; \
		"MacCompiledDatabaseToWin"; Null:C1517; \
		"MacCompiledDatabaseToWinIncludeIt"; False:C215)
	
	$o.Licenses:=New object:C1471(\
		"ArrayLicenseWin"; New object:C1471("ItemsCount"; Formula:C1597(This:C1470.Item.length); "Item"; New collection:C1472); \
		"ArrayLicenseMac"; New object:C1471(\
		"ItemsCount"; Formula:C1597(This:C1470.Item.length); \
		"Item"; New collection:C1472))
	
	$o.RuntimeVL:=New object:C1471(\
		"LastDataPathLookup"; "ByAppName")
	
	$o.SignApplication:=New object:C1471(\
		"MacSignature"; Null:C1517; \
		"MacCertificate"; Null:C1517; \
		"AdHocSign"; Null:C1517)
	
	$o.SourcesFiles:=New object:C1471(\
		"RuntimeVL"; New object:C1471(\
		"RuntimeVLIncludeIt"; False:C215; \
		"RuntimeVLWinFolder"; Null:C1517; \
		"RuntimeVLMacFolder"; Null:C1517; \
		"RuntimeVLIconWinPath"; Null:C1517; \
		"RuntimeVLIconMacPath"; Null:C1517; \
		"IsOEM"; False:C215); \
		"CS"; New object:C1471(\
		"ServerIncludeIt"; False:C215; \
		"ServerWinFolder"; Null:C1517; \
		"ServerMacFolder"; Null:C1517; \
		"ClientWinIncludeIt"; False:C215; \
		"ClientWinFolderToWin"; Null:C1517; \
		"ClientWinFolderToMac"; Null:C1517; \
		"ClientMacIncludeIt"; False:C215; \
		"ClientMacFolderToWin"; Null:C1517; \
		"ClientMacFolderToMac"; Null:C1517; \
		"ServerIconWinPath"; Null:C1517; \
		"ServerIconMacPath"; Null:C1517; \
		"ClientMacIconForMacPath"; Null:C1517; \
		"ClientWinIconForMacPath"; Null:C1517; \
		"ClientMacIconForWinPath"; Null:C1517; \
		"ClientWinIconForWinPath"; Null:C1517; \
		"DatabaseToEmbedInClientWinFolder"; Null:C1517; \
		"DatabaseToEmbedInClientMacFolder"; Null:C1517; \
		"IsOEM"; False:C215))
	
	$o.Versioning:=New object:C1471(\
		"Common"; New object:C1471(\
		"CommonVersion"; Null:C1517; \
		"CommonCopyright"; Null:C1517; \
		"CommonCreator"; Null:C1517; \
		"CommonComment"; Null:C1517; \
		"CommonCompanyName"; Null:C1517; \
		"CommonFileDescription"; Null:C1517; \
		"CommonInternalName"; Null:C1517; \
		"CommonLegalTrademark"; Null:C1517; \
		"CommonPrivateBuild"; Null:C1517; \
		"CommonSpecialBuild"; Null:C1517); \
		"RuntimeVL"; New object:C1471(\
		"RuntimeVLVersion"; Null:C1517; \
		"RuntimeVLCopyright"; Null:C1517; \
		"RuntimeVLCreator"; Null:C1517; \
		"RuntimeVLComment"; Null:C1517; \
		"RuntimeVLCompanyName"; Null:C1517; \
		"RuntimeVLFileDescription"; Null:C1517; \
		"RuntimeVLInternalName"; Null:C1517; \
		"RuntimeVLLegalTrademark"; Null:C1517; \
		"RuntimeVLPrivateBuild"; Null:C1517; \
		"RuntimeVLSpecialBuild"; Null:C1517); \
		"Server"; New object:C1471(\
		"ServerVersion"; Null:C1517; \
		"ServerCopyright"; Null:C1517; \
		"ServerCreator"; Null:C1517; \
		"ServerComment"; Null:C1517; \
		"ServerCompanyName"; Null:C1517; \
		"ServerFileDescription"; Null:C1517; \
		"ServerInternalName"; Null:C1517; \
		"ServerLegalTrademark"; Null:C1517; \
		"ServerPrivateBuild"; Null:C1517; \
		"ServerSpecialBuild"; Null:C1517); \
		"Client"; New object:C1471(\
		"ClientVersion"; Null:C1517; \
		"ClientCopyright"; Null:C1517; \
		"ClientCreator"; Null:C1517; \
		"ClientComment"; Null:C1517; \
		"ClientCompanyName"; Null:C1517; \
		"ClientFileDescription"; Null:C1517; \
		"ClientInternalName"; Null:C1517; \
		"ClientLegalTrademark"; Null:C1517; \
		"ClientPrivateBuild"; Null:C1517; \
		"ClientSpecialBuild"; Null:C1517))
	
	return ($o)
	
	