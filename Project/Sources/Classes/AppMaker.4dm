Class constructor()
	
	var $file : 4D:C1709.File
	
	This:C1470.env:=cs:C1710.env.new()
	This:C1470.motor:=cs:C1710.motor.new()
	This:C1470.database:=cs:C1710.database.new()
	
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
Function run($withUI : Boolean)
	
	This:C1470.withUI:=Count parameters:C259=0 ? True:C214 : $withUI
	
	This:C1470._initBarber()._openBarber("Starting…")
	
	FLUSH CACHE:C297
	
	// Load preferences
	var $prefs : Object
	$prefs:=This:C1470.prefs.load()
	
	// MARK:-Host database method to run before generation
	If (Length:C16(String:C10($prefs.methods.before))>0)
		
		This:C1470._callBarber("🛠 "+Replace string:C233(Get localized string:C991("executionOfMethod"); "{methodName}"; $prefs.methods.before); Barber shop:K42:35)
		
		DELAY PROCESS:C323(Current process:C322; 50)
		
		var $success : Boolean
		EXECUTE METHOD:C1007(String:C10($prefs.methods.before); $success)  // The host database must return true
		
		If (Not:C34($success))
			
			This:C1470._error("❌ "+Replace string:C233(Get localized string:C991("methodFailed"); "{methodName}"; $prefs.methods.before))
			return 
			
		End if 
	End if 
	
	var $build : cs:C1710.build
	$build:=cs:C1710.build.new(This:C1470.buildAppFile; This:C1470.credentials)
	This:C1470.applicationName:=$build.settings.BuildApplicationName
	
	// MARK:-Update the Info.plist file
	If ($prefs["info.plist"]#Null:C1517)
		
		This:C1470._callBarber("🚧 "+Get localized string:C991("Preparations")+"…")
		
		If (Not:C34(This:C1470.database.plistFile.exists))
			
			// Create a default from template
			var $json : Text
			$json:=File:C1566("/RESOURCES/InfoPlist.template").getText()
			$json:=Replace string:C233($json; "{name}"; This:C1470.applicationName)
			$json:=Replace string:C233($json; "{version}"; This:C1470.motor.branch)
			$json:=Replace string:C233($json; "{build}"; "1")
			$json:=Replace string:C233($json; "{copyright}"; "©"+String:C10(Year of:C25(Current date:C33)))
			This:C1470.database.plistFile.setText($json)
			
		End if 
		
		If (This:C1470.database.plistFile.exists)
			
			var $plistContent : Object
			This:C1470.plist:=This:C1470.database.plistFile.getAppInfo()
			
			var $infos : Object
			$infos:=$prefs["info.plist"]
			This:C1470.plist.CFBundleName:=This:C1470.applicationName
			This:C1470.plist.CFBundleVersion:=Num:C11(This:C1470.plist.CFBundleVersion)  // +1
			This:C1470.plist.CFBundleGetInfoString:=This:C1470.motor.branch
			This:C1470.plist.CFBundleShortVersionString:=This:C1470.motor.branch
			This:C1470.plist.CFBundleLongVersionString:=This:C1470.plist.CFBundleShortVersionString+(This:C1470.plist.CFBundleVersion#Null:C1517 ? (" ("+String:C10(This:C1470.plist.CFBundleVersion)+")") : "")
			This:C1470.plist.NSHumanReadableCopyright:=Length:C16(String:C10($infos.NSHumanReadableCopyright))>0 ? Replace string:C233(String:C10($infos.NSHumanReadableCopyright); "{currentYear}"; String:C10(Year of:C25(Current date:C33))) : "©"+String:C10(Year of:C25(Current date:C33))
			This:C1470.database.plistFile.setAppInfo(This:C1470.plist)
			
		Else 
			
			This:C1470._error("❌ Failed to update info.plist")
			return 
			
		End if 
	End if 
	
	Repeat 
		
		This:C1470._wait()
		This:C1470._callBarber("⚙️ "+Get localized string:C991("CompilationAndGeneration"); Barber shop:K42:35)
		
		// TODO:Detecting a version change
		// Always re-compile the whole thing
		This:C1470.database.clearCompiledCode()
		
		If (Not:C34($build.run()))
			
			This:C1470._error("❌ Build failed")
			return 
			
		End if 
	Until (This:C1470._wait(2000))
	
	// MARK:-Options
	// MARK:Increments the bundleVersion key
	If (Bool:C1537($prefs.options.increment_version))
		
		This:C1470._callBarber("🚧 "+Get localized string:C991("Preparation"); Barber shop:K42:35)
		
		// Create the 'InfoPlist.strings' file
		var $t : Text
		$t:=File:C1566("/RESOURCES/InfoPlist.template").getText()
		$t:=Replace string:C233($t; "{name}"; This:C1470.applicationName)
		$t:=Replace string:C233($t; "{version}"; This:C1470.motor.branch)
		$t:=Replace string:C233($t; "{build}"; String:C10(Num:C11(This:C1470.plist.CFBundleVersion)))
		$t:=Replace string:C233($t; "{copyright}"; This:C1470.plist.NSHumanReadableCopyright)
		
		This:C1470.database.resourcesFolder.file("InfoPlist.strings").setText($t; "UTF-16")
		
		This:C1470.plist.CFBundleVersion:=Num:C11(This:C1470.plist.CFBundleVersion)+1
		This:C1470.database.plistFile.setAppInfo(This:C1470.plist)
		
		// Delete the (older) unused localized files, if any
		var $folder : 4D:C1709.Folder
		
		For each ($folder; This:C1470.database.resourcesFolder.folders().query("extension='.lproj'"))
			
			$folder.file("InfoPlist.strings").delete()
			
		End for each 
	End if 
	
	// MARK:Delete Mac content
	If (Is macOS:C1572 && Bool:C1537($prefs.options.delete_mac_content))
		
		Repeat 
			
			This:C1470._wait()
			This:C1470._callBarber("🧽 "+Get localized string:C991("deleteMacOsSpecificFiles"); Barber shop:K42:35)
			
			DELAY PROCESS:C323(Current process:C322; 50)
			
			var $file : 4D:C1709.File
			
			For each ($file; $build.buildTarget.files(fk recursive:K87:7).query("name = :1"; ".@"))
				
				$file.delete()
				
			End for each 
		Until (This:C1470._wait(2000))
	End if 
	
	// MARK:Delete help files and the non necessary resources for the final user
	If (Bool:C1537($prefs.options.removeDevResources))  // && ($buildCompiled || $buildStandalone || $buildServer))
		
		This:C1470._callBarber("🗜 Deleting unnecessary resources"; Barber shop:K42:35)
		
		$file:=This:C1470.database.preferencesFolder.file("AppMaker delete.xml")
		
		If (Not:C34($file.exists))
			
			// Use the default set
			$file:=File:C1566("/RESOURCES/AppMaker delete.xml")
			
		End if 
		
		If ($file.exists)
			
			// Load the list of items to delete
			var $xml : cs:C1710.xml
			$xml:=cs:C1710.xml.new($file)
			
			// Remove from compiled package if any
			This:C1470._deleteResources($build.buildTarget; $xml.toObject().item.extract("$"))
			
			$xml.close()
			
		End if 
	End if 
	
	// MARK:-Copy
	If ($prefs.copy#Null:C1517)
		
		If (Value type:C1509($prefs.copy.array.item)#Is collection:K8:32)
			
			$prefs.copy.array.item:=New collection:C1472($prefs.copy.array.item)
			
		End if 
		
		This:C1470._callBarber("⚙️ "+Get localized string:C991("preparationOfCopy"); Progress bar:K42:34)
		
		DELAY PROCESS:C323(Current process:C322; 50)
		
		This:C1470._copy($build.buildTarget; $prefs.copy.array.item.extract("$"))
		
	End if 
	
	// MARK:-Deletion
	If ($prefs.delete#Null:C1517)
		
		If (Value type:C1509($prefs.delete.array.item)#Is collection:K8:32)
			
			$prefs.delete.array.item:=New collection:C1472($prefs.delete.array.item)
			
		End if 
		
		This:C1470._callBarber("🚧 "+Get localized string:C991("preparingForRemoval"); Progress bar:K42:34)
		
		DELAY PROCESS:C323(Current process:C322; 50)
		
		This:C1470._delete($build.buildTarget; $prefs.delete.array.item.extract("$"))
		
	End if 
	
	// MARK:-Make the package and its content readable/executable and writable by everyone
	// TODO: Use $build.unlockDirectory()
	SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_HIDE_CONSOLE"; "true")
	SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_CURRENT_DIRECTORY"; $build.buildTarget.path)
	
	If (Is Windows:C1573)
		
		LAUNCH EXTERNAL PROCESS:C811("attrib.exe -R /S /D")
		
	Else 
		
		LAUNCH EXTERNAL PROCESS:C811("chmod -R 777 "+Replace string:C233($build.buildTarget.path; " "; "\\ "))
		
	End if 
	
	// MARK:-Host database method to run at the end
	If (Length:C16(String:C10($prefs.methods.after))>0)
		
		This:C1470._callBarber("🛠 "+Replace string:C233(Get localized string:C991("executionOfMethod"); "{methodName}"; $prefs.methods.after); Barber shop:K42:35)
		
		DELAY PROCESS:C323(Current process:C322; 50)
		
		var $success : Boolean
		EXECUTE METHOD:C1007(String:C10($prefs.methods.after); $success)  // The host database must return true
		
		If (Not:C34($success))
			
			This:C1470._error("❌ "+Replace string:C233(Get localized string:C991("methodFailed"); "{methodName}"; $prefs.methods.after))
			return 
			
		End if 
	End if 
	
	// MARK:-Notarization
	// ONLY AVAILABLE FOR COMPONENTS FOR THE MOMENT
	If (Is macOS:C1572 && Bool:C1537($prefs.options.notarize) && ($build.lib4d#Null:C1517))
		
		This:C1470._callBarber("🍏 Notarization process"; Barber shop:K42:35)
		
		var $codesign : cs:C1710.codesign
		$codesign:=cs:C1710.codesign.new(This:C1470.credentials)
		
		//$codesign.removeSignature($build.lib4d.path)
		
		If ($codesign.sign($build.lib4d))
			
			var $hdutil : cs:C1710.hdutil
			$hdutil:=cs:C1710.hdutil.new($build.lib4d.parent.parent.parent.file($build.lib4d.name+".dmg"))
			
			If ($hdutil.create($build.lib4d))
				
				var $notarytool : cs:C1710.notarytool
				$notarytool:=cs:C1710.notarytool.new($hdutil.target; This:C1470.credentials.keychainProfile)
				
				If ($notarytool.submit())
					
					If ($notarytool.staple())
						
						If ($notarytool.ckeckWithGatekeeper($build.lib4d.path; This:C1470.credentials.certificate))
							
							//If ($hdutil.attach())
							//$file:=$hdutil.disk.file($build.lib4d.fullName).copyTo($build.lib4d.parent; fk overwrite)
							//If ($file.exists)
							
							BEEP:C151
							DISPLAY NOTIFICATION:C910(This:C1470.database.name; "Successfully notarized for : "+This:C1470.credentials.certificate)
							
							//If ($hdutil.detach())
							
							If (This:C1470.database.isComponent)
								
								$hdutil.target.delete()
								
							End if 
							
							// End if
							// End if
							// End if
							
						End if 
					End if 
				End if 
			End if 
		End if 
		
		If (Not:C34($build.success))
			
			ALERT:C41($build.lastError || $hdutil.lastError)
			
		End if 
	End if 
	
	This:C1470._closeBarber()
	
	// MARK:-
	
	// === === === === === === === === === === === === === === === === === === ===
Function _error($error : Text)
	
	This:C1470.errors.push($error)
	This:C1470._displayError($error)
	
	// === === === === === === === === === === === === === === === === === === ===
Function _warning($error : Text)
	
	This:C1470.warnings.push($error)
	
	// === === === === === === === === === === === === === === === === === === ===
Function _delete($target : 4D:C1709.Folder; $c : Collection)
	
	var $item : Text
	var $tgt : Object
	
	For each ($item; $c)
		
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
			
			Storage:C1525.progress.value+=Round:C94(100/$c.length; 0)
			
		End use 
		
		DELAY PROCESS:C323(Current process:C322; 10)
		
	End for each 
	
	// === === === === === === === === === === === === === === === === === === ===
Function _copy($target : 4D:C1709.Folder; $c : Collection)
	
	var $item : Text
	var $src; $tgt : Object
	
	For each ($item; $c)
		
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
			
			Storage:C1525.progress.value+=Round:C94(100/$c.length; 0)
			
		End use 
		
		DELAY PROCESS:C323(Current process:C322; 10)
		
	End for each 
	
	// === === === === === === === === === === === === === === === === === === ===
Function _deleteResources($target : 4D:C1709.Folder; $resources : Collection)
	
	// TODO:Delete according to the target
	
	// === === === === === === === === === === === === === === === === === === ===
Function _wait($delay : Integer) : Boolean
	
	If (Count parameters:C259=0)
		
		This:C1470.start:=Milliseconds:C459
		
	Else 
		
		While ((Milliseconds:C459-This:C1470.start)<$delay)
			
			DELAY PROCESS:C323(Current process:C322; 5)
			
		End while 
		
		return True:C214
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === ===
Function _initBarber() : cs:C1710.AppMaker
	
	Use (Storage:C1525.progress)
		
		Storage:C1525.progress.indicator:=Null:C1517
		Storage:C1525.progress.title:=""
		Storage:C1525.progress.value:=0
		
	End use 
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === ===
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
	
	// === === === === === === === === === === === === === === === === === === ===
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
	
	// === === === === === === === === === === === === === === === === === === ===
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
	
	// === === === === === === === === === === === === === === === === === === ===
Function _closeBarber()
	
	If (This:C1470.withUI)
		
		Use (Storage:C1525.progress)
			
			Storage:C1525.progress.indicator:=-1
			
		End use 
		
		KILL WORKER:C1390("$AppMakerBarber")
		
	End if 