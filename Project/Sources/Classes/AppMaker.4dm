Class constructor()
	
	var $file : 4D:C1709.File
	
	This:C1470.env:=cs:C1710.env.new()
	This:C1470.database:=cs:C1710.database.new()
	This:C1470.motor:=cs:C1710.motor.new()
	
	// Ensure the preferences folder exists
	This:C1470.database.preferencesFolder.create()
	
	If (Is macOS:C1572)
		
		// Get credentials
		$file:=This:C1470.database.preferencesFolder.file("notarise.json")  // Project embedded credentials
		
		If (Not:C34($file.exists))
			
			$file:=This:C1470.database.userPreferencesFolder.file("notarise.json")  // Project credentials into the user prefernces folder
			
			If (Not:C34($file.exists))
				
				$file:=This:C1470.database.userPreferencesFolder.parent.file("notarise.json")  // Shared credentials
				
			End if 
		End if 
		
		If ($file.exists)
			
			This:C1470.credentials:=JSON Parse:C1218($file.getText())
			
		End if 
		
		This:C1470.codesign:=cs:C1710.codesign.new(This:C1470.credentials)
		
	End if 
	
	// Preferences
	This:C1470.preferencesFile:=This:C1470.database.preferencesFolder.file("4DPop AppMaker.xml")
	This:C1470.prefs:=cs:C1710.prefs.new(This:C1470.preferencesFile; "appMaker")
	
	// BuildApp settings
	This:C1470.buildAppFile:=This:C1470.database.settingsFolder.file("buildApp.4DSettings")
	
	If (Not:C34(This:C1470.buildAppFile.exists))
		
		$file:=This:C1470.database.preferencesFolder.file("BuildApp.xml")
		
		If ($file.exists)
			
			This:C1470.buildAppFile:=$file.copyTo(This:C1470.database.settingsFolder; "buildApp.4DSettings")
			
		End if 
	End if 
	
	// Initialize the progress accessor
	If (Storage:C1525.progress=Null:C1517)
		
		Use (Storage:C1525)
			
			Storage:C1525.progress:=New shared object:C1526
			
		End use 
	End if 
	
	This:C1470.errors:=New collection:C1472
	This:C1470.warnings:=New collection:C1472
	
	// === === === === === === === === === === === === === === === === === === ===
Function run($withUI : Boolean) : Boolean
	
	This:C1470.withUI:=Count parameters:C259=0 ? Not:C34(This:C1470.motor.headless) : $withUI
	
	This:C1470._initBarber()._openBarber("Starting…")
	
	FLUSH CACHE:C297
	
	var $build : cs:C1710.build
	$build:=cs:C1710.build.new(This:C1470.buildAppFile; This:C1470.credentials)
	This:C1470.applicationName:=$build.settings.BuildApplicationName
	
	// Load preferences
	var $prefs : Object
	$prefs:=This:C1470.prefs.load()
	
	var $success : Boolean
	$success:=True:C214
	
	If ($prefs.methods.before#Null:C1517)
		
		$success:=This:C1470._executeMethod($prefs.methods.before)
		
	End if 
	
	If ($success && ($prefs["info.plist"]#Null:C1517))
		
		$success:=This:C1470._updateInfoPlist($prefs["info.plist"])
		
	End if 
	
	If ($success)
		
		This:C1470._callBarber("⚙️ "+Get localized string:C991("CompilationAndGeneration"); Barber shop:K42:35)
		
		var $lastbuild : 4D:C1709.File
		$lastbuild:=This:C1470.database.databaseFolder.file("lastbuild")
		$lastbuild.create()
		
		If ($lastbuild.getText()#This:C1470.motor.branch)
			
			This:C1470.database.clearCompiledCode()
			$lastbuild.setText(This:C1470.motor.branch)
			
		End if 
		
		$success:=This:C1470.database.compile()
		
		If ($success)
			
			$success:=$build.run()
			
			If (Not:C34($success))
				
				This:C1470._error("❌ Build failed")
				
			End if 
			
		Else 
			
			This:C1470._error("❌ "+This:C1470.database.errors.pop().message)
			
		End if 
	End if 
	
	If ($success)
		
		$success:=cs:C1710.lep.new().unlockDirectory($build.buildTarget).success
		
	End if 
	
	If ($success && Bool:C1537($prefs.options.increment_version))
		
		$success:=This:C1470._incrementBundleVersion()
		
	End if 
	
	If (Is macOS:C1572 && Bool:C1537($prefs.options.delete_mac_content))
		
		$success:=This:C1470._deleteMacContent($build.buildTarget)
		
	End if 
	
	If ($success && Bool:C1537($prefs.options.removeDevResources))
		
		$success:=This:C1470._deleteResources($build.buildTarget)
		
	End if 
	
	If ($prefs.copy#Null:C1517)
		
		If (Value type:C1509($prefs.copy.array.item)#Is collection:K8:32)
			
			$prefs.copy.array.item:=New collection:C1472($prefs.copy.array.item)
			
		End if 
		
		This:C1470._callBarber("⚙️ "+Get localized string:C991("preparationOfCopy"); Progress bar:K42:34)
		
		DELAY PROCESS:C323(Current process:C322; 50)
		
		This:C1470._copy($build.buildTarget; $prefs.copy.array.item.extract("$"))
		
	End if 
	
	If ($prefs.delete#Null:C1517)
		
		If (Value type:C1509($prefs.delete.array.item)#Is collection:K8:32)
			
			$prefs.delete.array.item:=New collection:C1472($prefs.delete.array.item)
			
		End if 
		
		This:C1470._callBarber("🚧 "+Get localized string:C991("preparingForRemoval"); Progress bar:K42:34)
		
		DELAY PROCESS:C323(Current process:C322; 50)
		
		This:C1470._delete($build.buildTarget; $prefs.delete.array.item.extract("$"))
		
	End if 
	
	If ($success && Bool:C1537($prefs.methods.after))
		
		$success:=This:C1470._executeMethod($prefs.methods.after)
		
	End if 
	
	If ($success && Is macOS:C1572 && Bool:C1537($prefs.options.notarize) && ($build.lib4d#Null:C1517))
		
		This:C1470._callBarber("🍏 Notarization process"; Barber shop:K42:35)
		
		$success:=False:C215
		
		// Sign the lib4d-arm64.dylib
		var $codesign : cs:C1710.codesign
		$codesign:=cs:C1710.codesign.new(This:C1470.credentials)
		
		If ($codesign.sign($build.lib4d))
			
			// Deploy them as zip, signed, notarized, but not stapled.
			var $ditto : cs:C1710.ditto
			$ditto:=cs:C1710.ditto.new($build.buildTarget)
			
			If ($ditto.archive(File:C1566($build.buildTarget.parent.path+$build.buildTarget.name+" "+This:C1470.motor.branch+".zip")))
				
				If ($codesign.sign($ditto.tgt))
					
					var $notarytool : cs:C1710.notarytool
					$notarytool:=cs:C1710.notarytool.new($ditto.tgt; This:C1470.credentials.keychainProfile)
					
					If ($notarytool.submit())
						
						$success:=True:C214
						
					Else 
						
						Folder:C1567(fk logs folder:K87:17).file("notarytool.log").setText($notarytool.history.join("\n"))
						This:C1470._error($notarytool.lastError)
						
					End if 
					
				Else 
					
					Folder:C1567(fk logs folder:K87:17).file("codesign.log").setText($codesign.history.join("\n"))
					This:C1470._error($codesign.lastError)
					
				End if 
				
			Else 
				
				Folder:C1567(fk logs folder:K87:17).file("ditto.log").setText($ditto.history.join("\n"))
				This:C1470._error($ditto.lastError)
				
			End if 
			
		Else 
			
			Folder:C1567(fk logs folder:K87:17).file("codesign.log").setText($codesign.history.join("\n"))
			This:C1470._error($codesign.lastError)
			
		End if 
		
		This:C1470._closeBarber()
		
		If (This:C1470.database.isMatrix)
			
			Folder:C1567(fk logs folder:K87:17).file("codesign.log").setText($codesign.history.join("\n"))
			Folder:C1567(fk logs folder:K87:17).file("notarytool.log").setText($notarytool.history.join("\n"))
			Folder:C1567(fk logs folder:K87:17).file("ditto.log").setText($ditto.history.join("\n"))
			
		End if 
		
	End if 
	
	return $success
	
	// === === === === === === === === === === === === === === === === === === ===
Function CommitAndPush($message : Text) : Object
	
	var $cmd; $err; $in; $out; $path : Text
	var $error : Object
	
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
	
	return $error
	
	// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
	// Delete help files and the non necessary resources for the final user
Function _deleteResources($target : 4D:C1709.Folder) : Boolean
	
	var $path : Text
	var $file : 4D:C1709.File
	var $xml : cs:C1710.xml
	
	This:C1470._callBarber("🗜 Deleting unnecessary resources"; Barber shop:K42:35)
	
	$file:=This:C1470.database.preferencesFolder.file("AppMaker delete.xml")
	
	If (Not:C34($file.exists))
		
		// Use the default set
		$file:=File:C1566("/RESOURCES/AppMaker delete.xml")
		
	End if 
	
	If ($file.exists)
		
		// Load the list of items to delete
		$xml:=cs:C1710.xml.new($file)
		
		For each ($path; $xml.toObject().item.extract("$"))
			
			$path:=$target.path+$path
			
			If ($path="@/")
				
				Folder:C1567($path).delete(fk recursive:K87:7)
				
			Else 
				
				File:C1566($path).delete()
				
			End if 
		End for each 
		
		$xml.close()
		
	End if 
	
	return True:C214
	
	// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---  
Function _deleteMacContent($target : 4D:C1709.Folder) : Boolean
	
	var $file : 4D:C1709.File
	
	Repeat 
		
		This:C1470._wait()
		This:C1470._callBarber("🧽 "+Get localized string:C991("deleteMacOsSpecificFiles"); Barber shop:K42:35)
		
		DELAY PROCESS:C323(Current process:C322; 50)
		
		For each ($file; $target.files(fk recursive:K87:7).query("name = :1"; ".@"))
			
			$file.delete()
			
		End for each 
	Until (This:C1470._wait(2000))
	
	return True:C214
	
	// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---  
Function _incrementBundleVersion() : Boolean
	
	var $template : Text
	
	This:C1470._callBarber("🚧 "+Get localized string:C991("Preparation"); Barber shop:K42:35)
	
	This:C1470.plist.CFBundleVersion:=Num:C11(This:C1470.plist.CFBundleVersion)+1
	This:C1470.database.plistFile.setAppInfo(This:C1470.plist)
	
	// Create the 'InfoPlist.strings' file
	$template:=File:C1566("/RESOURCES/InfoPlist.template").getText()
	$template:=Replace string:C233($template; "{name}"; This:C1470.applicationName)
	$template:=Replace string:C233($template; "{version}"; This:C1470.motor.branch)
	$template:=Replace string:C233($template; "{build}"; String:C10(Num:C11(This:C1470.plist.CFBundleVersion)))
	$template:=Replace string:C233($template; "{copyright}"; This:C1470.plist.NSHumanReadableCopyright)
	
	This:C1470.database.resourcesFolder.file("InfoPlist.strings").setText($template; "UTF-16")
	
	// Delete the (older) unused localized files, if any
	var $folder : 4D:C1709.Folder
	For each ($folder; This:C1470.database.resourcesFolder.folders().query("extension='.lproj'"))
		
		$folder.file("InfoPlist.strings").delete()
		
	End for each 
	
	return True:C214
	
	// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---  
Function _executeMethod($method : Text) : Boolean
	
	var $success : Boolean
	
	This:C1470._callBarber("🛠 "+Replace string:C233(Get localized string:C991("executionOfMethod"); "{methodName}"; $method); Barber shop:K42:35)
	
	DELAY PROCESS:C323(Current process:C322; 50)
	
	EXECUTE METHOD:C1007(String:C10($method); $success)  // The host database must return true
	
	If ($success)
		
		return True:C214
		
	Else 
		
		This:C1470._error("❌ "+Replace string:C233(Get localized string:C991("methodFailed"); "{methodName}"; $method))
		return 
		
	End if 
	
	// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---  
Function _updateInfoPlist($infos : Object) : Boolean
	
	var $json : Text
	
	This:C1470._callBarber("🚧 "+Get localized string:C991("Preparations")+"…")
	
	If (Not:C34(This:C1470.database.plistFile.exists))
		
		// Create a default from template
		$json:=File:C1566("/RESOURCES/InfoPlist.template").getText()
		$json:=Replace string:C233($json; "{name}"; This:C1470.applicationName)
		$json:=Replace string:C233($json; "{version}"; This:C1470.motor.branch)
		$json:=Replace string:C233($json; "{build}"; "1")
		$json:=Replace string:C233($json; "{copyright}"; "©"+String:C10(Year of:C25(Current date:C33)))
		This:C1470.database.plistFile.setText($json)
		
	End if 
	
	If (This:C1470.database.plistFile.exists)
		
		This:C1470.plist:=This:C1470.database.plistFile.getAppInfo()
		
		This:C1470.plist.CFBundleName:=This:C1470.applicationName
		This:C1470.plist.CFBundleVersion:=Num:C11(This:C1470.plist.CFBundleVersion)
		This:C1470.plist.CFBundleGetInfoString:=This:C1470.motor.branch
		This:C1470.plist.CFBundleShortVersionString:=This:C1470.motor.branch
		This:C1470.plist.CFBundleLongVersionString:=This:C1470.plist.CFBundleShortVersionString+(This:C1470.plist.CFBundleVersion#Null:C1517 ? (" ("+String:C10(This:C1470.plist.CFBundleVersion)+")") : "")
		This:C1470.plist.NSHumanReadableCopyright:=Length:C16(String:C10($infos.NSHumanReadableCopyright))>0 ? Replace string:C233(String:C10($infos.NSHumanReadableCopyright); "{currentYear}"; String:C10(Year of:C25(Current date:C33))) : "©"+String:C10(Year of:C25(Current date:C33))
		This:C1470.database.plistFile.setAppInfo(This:C1470.plist)
		
		return True:C214
		
	Else 
		
		This:C1470._error("❌ Failed to update info.plist")
		return 
		
	End if 
	
	// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---  
Function _error($error : Text)
	
	This:C1470.errors.push($error)
	This:C1470._displayError($error)
	
	// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
Function _warning($error : Text)
	
	This:C1470.warnings.push($error)
	
	// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
Function _delete($target : 4D:C1709.Folder; $items : Collection)
	
	var $item : Text
	var $tgt : Object
	
	For each ($item; $items)
		
		Use (Storage:C1525.progress)
			
			Storage:C1525.progress.title:=Get localized string:C991("remove")+$item
			
		End use 
		
		$item:=$item="./@" ? Delete string:C232($item; 1; 2) : $item
		
		If ($item="@/")
			
			$tgt:=$target.folder($item)
			
			If ($tgt.exists)
				
				$tgt.delete(Delete with contents:K24:24)
				
			Else 
				
				This:C1470._warning($tgt.path+" not found for removal")
				
			End if 
			
		Else 
			
			$tgt:=$target.file($item)
			
			If ($tgt.exists)
				
				$tgt.delete()
				
			Else 
				
				This:C1470._warning($tgt.path+" not found for removal")
				
			End if 
		End if 
		
		Use (Storage:C1525.progress)
			
			Storage:C1525.progress.value+=Round:C94(100/$items.length; 0)
			
		End use 
		
		DELAY PROCESS:C323(Current process:C322; 10)
		
	End for each 
	
	// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---  
Function _copy($target : 4D:C1709.Folder; $items : Collection)
	
	var $item : Text
	var $src; $tgt : Object
	
	For each ($item; $items)
		
		Use (Storage:C1525.progress)
			
			Storage:C1525.progress.title:=Get localized string:C991("copy")+$item
			
		End use 
		
		If ($item="@/")
			
			$src:=This:C1470.database.databaseFolder.folder($item)
			$tgt:=$target.folder($item).parent
			
		Else 
			
			$src:=This:C1470.database.databaseFolder.file($item)
			$tgt:=$target.file($item).parent
			
		End if 
		
		If ($src.exists)
			
			$src.copyTo($tgt; fk overwrite:K87:5)
			
		Else 
			
			This:C1470._warning($src.path+" not found for copying")
			
		End if 
		
		Use (Storage:C1525.progress)
			
			Storage:C1525.progress.value+=Round:C94(100/$items.length; 0)
			
		End use 
		
		DELAY PROCESS:C323(Current process:C322; 10)
		
	End for each 
	
	// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---  
Function _wait($delay : Integer) : Boolean
	
	If (Count parameters:C259=0)
		
		This:C1470.start:=Milliseconds:C459
		
	Else 
		
		While ((Milliseconds:C459-This:C1470.start)<$delay)
			
			DELAY PROCESS:C323(Current process:C322; 5)
			
		End while 
		
		return True:C214
		
	End if 
	
	// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---  
Function _initBarber() : cs:C1710.AppMaker
	
	Use (Storage:C1525.progress)
		
		Storage:C1525.progress.indicator:=Null:C1517
		Storage:C1525.progress.title:=""
		Storage:C1525.progress.value:=0
		
	End use 
	
	If (This:C1470.withUI)
		
		If (Is macOS:C1572)
			
			LAUNCH EXTERNAL PROCESS:C811("osascript -e 'tell app \""+Application file:C491+"\" to activate'")
			
		Else 
			
			// TODO:On windows
			
		End if 
	End if 
	
	return This:C1470
	
	// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---  
Function _openBarber($title : Text; $indicator : Integer)
	
	If (This:C1470.withUI)
		
		CALL WORKER:C1389("$AppMakerBarber"; Formula:C1597(Open form window:C675("Barber"; Controller form window:K39:17+Form has no menu bar:K39:18; Horizontally centered:K39:1; Vertically centered:K39:4; *)))
		CALL WORKER:C1389("$AppMakerBarber"; Formula:C1597(DIALOG:C40("Barber")))
		
		If (Count parameters:C259>=1)
			
			Use (Storage:C1525.progress)
				
				Storage:C1525.progress.title:=$title
				
				If (Count parameters:C259>=2)
					
					Storage:C1525.progress.indicator:=$indicator
					
				End if 
			End use 
		End if 
	End if 
	
	// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---  
Function _callBarber($title : Text; $indicator : Integer)
	
	If (This:C1470.withUI)
		
		Use (Storage:C1525.progress)
			
			Storage:C1525.progress.title:=$title
			
			If (Count parameters:C259>=2)
				
				Storage:C1525.progress.indicator:=$indicator
				
				If ($indicator=Progress bar:K42:34)
					
					// Reset to 0
					Storage:C1525.progress.value:=0
					
				End if 
			End if 
		End use 
	End if 
	
	// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---  
Function _displayError($error : Text)
	
	If (This:C1470.withUI)
		
		Use (Storage:C1525.progress)
			
			Storage:C1525.progress.title:=$error
			
		End use 
		
		BEEP:C151
		
		DELAY PROCESS:C323(Current process:C322; 100)
		
		Use (Storage:C1525.progress)
			
			Storage:C1525.progress.indicator:=-1
			
		End use 
		
		KILL WORKER:C1390("$AppMakerBarber")
		
	End if 
	
	// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---  
Function _closeBarber()
	
	If (This:C1470.withUI)
		
		Use (Storage:C1525.progress)
			
			Storage:C1525.progress.indicator:=-1
			
		End use 
		
		KILL WORKER:C1390("$AppMakerBarber")
		
	End if 