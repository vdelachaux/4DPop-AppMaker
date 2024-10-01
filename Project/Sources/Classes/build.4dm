property settings : Object
property buildStatus : Collection
property buildAppSettingsFile; lib4d : 4D:C1709.File
property buildTarget : 4D:C1709.Folder

Class extends lep

//=== === === === === === === === === === === === === === === === === === === === === === ===
Class constructor($settings)  //; $credentials : Object)
	
	Super:C1705()
	
	var $o : Object
	var $file : 4D:C1709.File
	
	// Project
	
	
	// Settings
	Case of 
			
			//______________________________________________________
		: (Value type:C1509($settings)=Is object:K8:27)
			
			This:C1470.buildAppSettingsFile:=OB Instance of:C1731($settings; 4D:C1709.File) ? $settings : Null:C1517
			
			//______________________________________________________
		: (Value type:C1509($settings)=Is text:K8:3)\
			 && (Length:C16($settings)>0)  // Pathname
			
			This:C1470.buildAppSettingsFile:=File:C1566(String:C10($settings))
			
			//______________________________________________________
		Else   // Default
			
			$settings:=File:C1566(File:C1566(Build application settings file:K5:60; *).platformPath; fk platform path:K87:2)  // Unsandboxed
			This:C1470.buildAppSettingsFile:=$settings.exists ? $settings : Null:C1517
			
			//______________________________________________________
	End case 
	
	This:C1470.settings:=This:C1470._getSettings(This:C1470.buildAppSettingsFile)
	
	// Notarization settings
	//FIXME: Usefull ?
	//This.credentials:=$credentials
	
	This:C1470.buildStatus:=Null:C1517
	
	// <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> 
Function get destinationFolder() : 4D:C1709.Folder
	
	var $parentFolderPath; $path : Text
	
	If (This:C1470.settings#Null:C1517)
		
		$path:=Is Windows:C1573 ? This:C1470.settings.BuildWinDestFolder : This:C1470.settings.BuildMacDestFolder
		
		If ($path[[1]]=Folder separator:K24:12)
			
			return (Folder:C1567("/PACKAGE/"; *).folder(Replace string:C233(Delete string:C232($path; 1; 1); Folder separator:K24:12; "/")))
			
		Else 
			
			return (Folder:C1567($path; fk platform path:K87:2))
			
		End if 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === ===
Function run() : Boolean
	
	var $code; $desc; $message; $root; $target; $type : Text
	var $i : Integer
	var $o : Object
	var $file : 4D:C1709.File
	var $folder : 4D:C1709.Folder
	
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
			This:C1470.lib4d:=Null:C1517  // NOT COMPILED FOR AMD
			This:C1470.buildTarget:=Null:C1517
			
			If (This:C1470.success)
				
				$o:=This:C1470.buildStatus.query("message = :1"; "Start copying files : @").pop()
				
				If ($o#Null:C1517)
					
					$folder:=File:C1566(Replace string:C233($o.message; "Start copying files : "; ""); fk platform path:K87:2).parent
					
					If ($folder.exists)
						
						This:C1470.buildTarget:=$folder
						
					Else 
						
						// TODO:ERROR
						
					End if 
					
				Else 
					
					// TODO:ERROR
					
				End if 
				
				$file:=This:C1470.buildTarget.file("Libraries/lib4d-arm64.dylib")
				
				If ($file.exists)
					
					This:C1470.lib4d:=$file
					
				Else 
					
					// TODO:ERROR
					
				End if 
			End if 
			
		Else 
			
			This:C1470._pushError(This:C1470.lastBuildLog.getText())
			
		End if 
		
	Else 
		
		This:C1470._pushError("File not found: "+String:C10(This:C1470.buildAppSettingsFile.path))
		
	End if 
	
	return This:C1470.success
	
	//MARK:[PRIVATE]
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
	
	If (Bool:C1537($settingsFile.exists))
		
		$root:=DOM Parse XML source:C719($settingsFile.platformPath)
		
		If (Bool:C1537(OK))
			
			$linkModes:=New collection:C1472("InDbStruct"; "ByAppName"; "ByAppPath")
			
			$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/BuildApplicationName")
			
			If (Bool:C1537(OK))
				
				DOM GET XML ELEMENT VALUE:C731($node; $string)
				$settings.BuildApplicationName:=$string
				
			End if 
			
			$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/BuildCompiled")
			
			If (Bool:C1537(OK))
				
				DOM GET XML ELEMENT VALUE:C731($node; $bool)
				$settings.BuildCompiled:=$bool
				
			End if 
			
			$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/IncludeAssociatedFolders")
			
			If (Bool:C1537(OK))
				
				DOM GET XML ELEMENT VALUE:C731($node; $bool)
				$settings.IncludeAssociatedFolders:=$bool
				
			End if 
			
			$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/BuildComponent")
			
			If (Bool:C1537(OK))
				
				DOM GET XML ELEMENT VALUE:C731($node; $bool)
				$settings.BuildComponent:=$bool
				
			End if 
			
			$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/BuildApplicationSerialized")
			
			If (Bool:C1537(OK))
				
				DOM GET XML ELEMENT VALUE:C731($node; $bool)
				$settings.BuildApplicationSerialized:=$bool
				
			End if 
			
			$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/BuildApplicationLight")
			
			If (Bool:C1537(OK))
				
				DOM GET XML ELEMENT VALUE:C731($node; $bool)
				$settings.BuildApplicationLight:=$bool
				
			End if 
			
			$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/BuildMacDestFolder")
			
			If (Bool:C1537(OK))
				
				DOM GET XML ELEMENT VALUE:C731($node; $string)
				$settings.BuildMacDestFolder:=$string
				
			End if 
			
			$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/PackProject")
			
			If (Bool:C1537(OK))
				
				DOM GET XML ELEMENT VALUE:C731($node; $bool)
				$settings.PackProject:=$bool
				
			End if 
			
			$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/UseStandardZipFormat")
			
			If (Bool:C1537(OK))
				
				DOM GET XML ELEMENT VALUE:C731($node; $bool)
				$settings.UseStandardZipFormat:=$bool
				
			End if 
			
			$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/BuildWinDestFolder")
			
			If (Bool:C1537(OK))
				
				DOM GET XML ELEMENT VALUE:C731($node; $string)
				$settings.BuildWinDestFolder:=$string
				
			End if 
			
			$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/SourcesFiles/RuntimeVL/RuntimeVLIncludeIt")
			
			If (Bool:C1537(OK))
				
				DOM GET XML ELEMENT VALUE:C731($node; $bool)
				$settings.SourcesFiles.RuntimeVL.RuntimeVLIncludeIt:=$bool
				
			End if 
			
			$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/SourcesFiles/RuntimeVL/RuntimeVLMacFolder")
			
			If (Bool:C1537(OK))
				
				DOM GET XML ELEMENT VALUE:C731($node; $string)
				$settings.SourcesFiles.RuntimeVL.RuntimeVLMacFolder:=$string
				
			End if 
			
			$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/SourcesFiles/RuntimeVL/RuntimeVLWinFolder")
			
			If (Bool:C1537(OK))
				
				DOM GET XML ELEMENT VALUE:C731($node; $string)
				$settings.SourcesFiles.RuntimeVL.RuntimeVLWinFolder:=$string
				
			End if 
			
			$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/SourcesFiles/RuntimeVL/IsOEM")
			
			If (Bool:C1537(OK))
				
				DOM GET XML ELEMENT VALUE:C731($node; $bool)
				$settings.SourcesFiles.RuntimeVL.IsOEM:=$bool
				
			End if 
			
			$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/SourcesFiles/CS/ServerIncludeIt")
			
			If (Bool:C1537(OK))
				
				DOM GET XML ELEMENT VALUE:C731($node; $bool)
				$settings.SourcesFiles.CS.ServerIncludeIt:=$bool
				
			End if 
			
			$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/SourcesFiles/CS/ClientMacIncludeIt")
			
			If (Bool:C1537(OK))
				
				DOM GET XML ELEMENT VALUE:C731($node; $bool)
				$settings.SourcesFiles.CS.ClientMacIncludeIt:=$bool
				
			End if 
			
			$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/SourcesFiles/CS/ClientWinIncludeIt")
			
			If (Bool:C1537(OK))
				
				DOM GET XML ELEMENT VALUE:C731($node; $bool)
				$settings.SourcesFiles.CS.ClientWinIncludeIt:=$bool
				
			End if 
			
			$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/SourcesFiles/CS/ServerMacFolder")
			
			If (Bool:C1537(OK))
				
				DOM GET XML ELEMENT VALUE:C731($node; $string)
				$settings.SourcesFiles.CS.ServerMacFolder:=$string
				
			End if 
			
			$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/SourcesFiles/CS/ServerWinFolder")
			
			If (Bool:C1537(OK))
				
				DOM GET XML ELEMENT VALUE:C731($node; $string)
				$settings.SourcesFiles.CS.ServerWinFolder:=$string
				
			End if 
			
			$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/SourcesFiles/CS/ClientWinFolderToWin")
			
			If (Bool:C1537(OK))
				
				DOM GET XML ELEMENT VALUE:C731($node; $string)
				$settings.SourcesFiles.CS.ClientWinFolderToWin:=$string
				
			End if 
			
			$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/SourcesFiles/CS/ClientWinFolderToMac")
			
			If (Bool:C1537(OK))
				
				DOM GET XML ELEMENT VALUE:C731($node; $string)
				$settings.SourcesFiles.CS.ClientWinFolderToMac:=$string
				
			End if 
			
			$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/SourcesFiles/CS/ClientMacFolderToWin")
			
			If (Bool:C1537(OK))
				
				DOM GET XML ELEMENT VALUE:C731($node; $string)
				$settings.SourcesFiles.CS.ClientMacFolderToWin:=$string
				
			End if 
			
			$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/SourcesFiles/CS/ClientMacFolderToMac")
			
			If (Bool:C1537(OK))
				
				DOM GET XML ELEMENT VALUE:C731($node; $string)
				$settings.SourcesFiles.CS.ClientMacFolderToMac:=$string
				
			End if 
			
			$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/SourcesFiles/CS/ServerIconWinPath")
			
			If (Bool:C1537(OK))
				
				DOM GET XML ELEMENT VALUE:C731($node; $string)
				$settings.SourcesFiles.CS.ServerIconWinPath:=$string
				
			End if 
			
			$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/SourcesFiles/CS/ServerIconMacPath")
			
			If (Bool:C1537(OK))
				
				DOM GET XML ELEMENT VALUE:C731($node; $string)
				$settings.SourcesFiles.CS.ServerIconMacPath:=$string
				
			End if 
			
			$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/SourcesFiles/CS/ClientMacIconForMacPath")
			
			If (Bool:C1537(OK))
				
				DOM GET XML ELEMENT VALUE:C731($node; $string)
				$settings.SourcesFiles.CS.ClientMacIconForMacPath:=$string
				
			End if 
			
			$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/SourcesFiles/CS/ClientWinIconForMacPath")
			
			If (Bool:C1537(OK))
				
				DOM GET XML ELEMENT VALUE:C731($node; $string)
				$settings.SourcesFiles.CS.ClientWinIconForMacPath:=$string
				
			End if 
			
			$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/SourcesFiles/CS/ClientMacIconForWinPath")
			
			If (Bool:C1537(OK))
				
				DOM GET XML ELEMENT VALUE:C731($node; $string)
				$settings.SourcesFiles.CS.ClientMacIconForWinPath:=$string
				
			End if 
			
			$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/SourcesFiles/CS/ClientWinIconForWinPath")
			
			If (Bool:C1537(OK))
				
				DOM GET XML ELEMENT VALUE:C731($node; $string)
				$settings.SourcesFiles.CS.ClientWinIconForWinPath:=$string
				
			End if 
			
			$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/SourcesFiles/CS/DatabaseToEmbedInClientMacFolder")
			
			If (Bool:C1537(OK))
				
				DOM GET XML ELEMENT VALUE:C731($node; $string)
				$settings.SourcesFiles.CS.DatabaseToEmbedInClientMacFolder:=$string
				
			End if 
			
			$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/SourcesFiles/CS/DatabaseToEmbedInClientWinFolder")
			
			If (Bool:C1537(OK))
				
				DOM GET XML ELEMENT VALUE:C731($node; $string)
				$settings.SourcesFiles.CS.DatabaseToEmbedInClientWinFolder:=$string
				
			End if 
			
			$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/SourcesFiles/CS/IsOEM")
			
			If (Bool:C1537(OK))
				
				DOM GET XML ELEMENT VALUE:C731($node; $bool)
				$settings.SourcesFiles.RuntimeVL.IsOEM:=$bool
				
			End if 
			
			$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/CS/BuildServerApplication")
			
			If (Bool:C1537(OK))
				
				DOM GET XML ELEMENT VALUE:C731($node; $bool)
				$settings.CS.BuildServerApplication:=$bool
				
			End if 
			
			$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/CS/LastDataPathLookup")
			
			If (Bool:C1537(OK))
				
				DOM GET XML ELEMENT VALUE:C731($node; $string)
				
				If ($linkModes.indexOf($string)#-1)
					
					$settings.CS.LastDataPathLookup:=$string
					
				End if 
			End if 
			
			$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/CS/BuildCSUpgradeable")
			
			If (Bool:C1537(OK))
				
				DOM GET XML ELEMENT VALUE:C731($node; $bool)
				$settings.CS.BuildCSUpgradeable:=$bool
				
			End if 
			
			$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/CS/CurrentVers")
			
			If (Bool:C1537(OK))
				
				DOM GET XML ELEMENT VALUE:C731($node; $integer)
				
				If ($integer>0)
					
					$settings.CS.CurrentVers:=$integer
					
				End if 
			End if 
			
			$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/CS/HardLink")
			
			If (Bool:C1537(OK))
				
				DOM GET XML ELEMENT VALUE:C731($node; $string)
				$settings.CS.HardLink:=$string
				
			End if 
			
			$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/CS/BuildV13ClientUpgrades")
			
			If (Bool:C1537(OK))
				
				DOM GET XML ELEMENT VALUE:C731($node; $bool)
				$settings.CS.BuildV13ClientUpgrades:=$bool
				
			End if 
			
			$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/CS/IPAddress")
			
			If (Bool:C1537(OK))
				
				DOM GET XML ELEMENT VALUE:C731($node; $string)
				$settings.CS.IPAddress:=$string
				
			End if 
			
			$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/CS/PortNumber")
			
			If (Bool:C1537(OK))
				
				DOM GET XML ELEMENT VALUE:C731($node; $integer)
				$settings.CS.PortNumber:=$integer
				
			End if 
			
			$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/CS/RangeVersMin")
			
			If (Bool:C1537(OK))
				
				DOM GET XML ELEMENT VALUE:C731($node; $integer)
				
				If ($integer>0)
					
					$settings.CS.RangeVersMin:=$integer
					
				End if 
			End if 
			
			$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/CS/RangeVersMax")
			
			If (Bool:C1537(OK))
				
				DOM GET XML ELEMENT VALUE:C731($node; $integer)
				
				If ($integer>0)
					
					$settings.CS.RangeVersMax:=$integer
					
				End if 
			End if 
			
			$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/CS/ServerSelectionAllowed")
			
			If (Bool:C1537(OK))
				
				DOM GET XML ELEMENT VALUE:C731($node; $bool)
				$settings.CS.ServerSelectionAllowed:=$bool
				
			End if 
			
			$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/CS/MacCompiledDatabaseToWin")
			
			If (Bool:C1537(OK))
				
				DOM GET XML ELEMENT VALUE:C731($node; $string)
				$settings.CS.MacCompiledDatabaseToWin:=$string
				
			End if 
			
			$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/CS/MacCompiledDatabaseToWinIncludeIt")
			
			If (Bool:C1537(OK))
				
				DOM GET XML ELEMENT VALUE:C731($node; $bool)
				$settings.CS.MacCompiledDatabaseToWinIncludeIt:=$bool
				
			End if 
			
			$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/SignApplication/MacSignature")
			
			If (Bool:C1537(OK))
				
				DOM GET XML ELEMENT VALUE:C731($node; $bool)
				$settings.SignApplication.MacSignature:=$bool
				
			End if 
			
			$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/SignApplication/MacCertificate")
			
			If (Bool:C1537(OK))
				
				DOM GET XML ELEMENT VALUE:C731($node; $string)
				$settings.SignApplication.MacCertificate:=$string
				
			End if 
			
			$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/SignApplication/AdHocSign")
			
			If (Bool:C1537(OK))
				
				DOM GET XML ELEMENT VALUE:C731($node; $bool)
				$settings.SignApplication.AdHocSign:=$bool
				
			End if 
			
			$node:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/RuntimeVL/LastDataPathLookup")
			
			If (Bool:C1537(OK))
				
				DOM GET XML ELEMENT VALUE:C731($node; $string)
				
				If ($linkModes.indexOf($string)#-1)
					
					$settings.RuntimeVL.LastDataPathLookup:=$string
					
				End if 
			End if 
			
			OB GET PROPERTY NAMES:C1232($settings.Licenses; $names)
			
			For ($i; 1; Size of array:C274($names); 1)
				
				$name:=$names{$i}
				$count:=DOM Find XML element:C864($root; "/Preferences4D/BuildApp/Licenses/"+$name+"/ItemsCount")
				
				If (Bool:C1537(OK))
					
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
				
				If (Bool:C1537(OK))
					
					DOM GET XML ELEMENT VALUE:C731($node; $integer)
					$settings[$name].ItemsCount:=$integer
					
					$node:=DOM Get next sibling XML element:C724($node)
					
					If (Bool:C1537(OK))
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
			
			If (Bool:C1537(OK))
				
				For ($i; 1; Size of array:C274($names); 1)
					
					$name:=$names{$i}
					$parent:=DOM Find XML element:C864($node; $name)
					
					OB GET PROPERTY NAMES:C1232($settings.Versioning[$name]; $itemNames)
					
					For ($j; 1; Size of array:C274($itemNames); 1)
						
						$itemName:=$itemNames{$j}
						$child:=DOM Find XML element:C864($parent; $itemName)
						
						If (Bool:C1537(OK))
							
							DOM GET XML ELEMENT VALUE:C731($child; $string)
							$settings.Versioning[$name][$itemName]:=$string
							
						End if 
					End for 
				End for 
			End if 
			
			DOM CLOSE XML:C722($root)
			
		End if 
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
	