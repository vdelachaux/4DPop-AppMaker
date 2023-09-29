property env : cs:C1710.env
property database : cs:C1710.database
property motor : cs:C1710.motor
property prefs : cs:C1710.prefs
property build : cs:C1710.build
property preferencesFile; buildAppFile; entitlementsFile : 4D:C1709.File
property target : 4D:C1709.Folder
property credentials : Object
property errors; warnings : Collection

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
	
	This:C1470.entitlementsFile:=Folder:C1567(Folder:C1567(fk resources folder:K87:11).platformPath; fk platform path:K87:2).file("Components.entitlements")
	
	// Initialize the progress accessor
	If (Storage:C1525.progress=Null:C1517)
		
		Use (Storage:C1525)
			
			Storage:C1525.progress:=New shared object:C1526
			
		End use 
	End if 
	
	This:C1470.errors:=[]
	This:C1470.warnings:=[]
	
	// <== <== <== <== <== <== <== <==  <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get target() : 4D:C1709.Folder
	
	return This:C1470.build.buildTarget
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function run($withUI : Boolean) : Boolean
	
	This:C1470.withUI:=Count parameters:C259=0 ? Not:C34(This:C1470.motor.headless) : $withUI
	
	This:C1470._initBarber()._openBarber("Starting…")
	
	FLUSH CACHE:C297
	
	This:C1470.build:=cs:C1710.build.new(This:C1470.buildAppFile)  //; This.credentials)
	This:C1470.applicationName:=This:C1470.build.settings.BuildApplicationName
	
	// Load preferences
	var $prefs : Object
	$prefs:=This:C1470.prefs.load()
	
	var $success : Boolean
	$success:=True:C214
	
	// Mark:Execute before build method
	If ($prefs.methods.before#Null:C1517)
		
		$success:=This:C1470.executeMethod($prefs.methods.before)
		
	End if 
	
	// Mark:Update info.plist
	If ($success && ($prefs["info.plist"]#Null:C1517))
		
		$success:=This:C1470.updateInfoPlist($prefs["info.plist"])
		
	End if 
	
	// Mark:Compilation & generation
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
			
			$success:=This:C1470.build.run()
			
			If (Not:C34($success))
				
				This:C1470._error("❌ Build failed")
				
			End if 
			
		Else 
			
			This:C1470._error("❌ "+This:C1470.database.errors.pop().message)
			
		End if 
	End if 
	
	// Mark:Make sure the target directory is writable
	If ($success)
		
		$success:=cs:C1710.lep.new().unlockDirectory(This:C1470.target).success
		
	End if 
	
	// Mark:Increment bundle version
	If ($success && Bool:C1537($prefs.options.increment_version))
		
		$success:=This:C1470.incrementBundleVersion()
		
	End if 
	
	// Mark:Delete macOS content
	If ($success && Is macOS:C1572 && Bool:C1537($prefs.options.delete_mac_content))
		
		$success:=This:C1470.deleteMacContent(This:C1470.target)
		
	End if 
	
	// Mark:Delete dev resources
	If ($success && Bool:C1537($prefs.options.removeDevResources))
		
		$success:=This:C1470.deleteResources(This:C1470.target)
		
	End if 
	
	// Mark:Copy items into the target
	If ($success && ($prefs.copy#Null:C1517))
		
		If (Value type:C1509($prefs.copy.array.item)#Is collection:K8:32)
			
			$prefs.copy.array.item:=New collection:C1472($prefs.copy.array.item)
			
		End if 
		
		This:C1470._callBarber("⚙️ "+Get localized string:C991("preparationOfCopy"); Progress bar:K42:34)
		
		DELAY PROCESS:C323(Current process:C322; 50)
		
		This:C1470.copy(This:C1470.target; $prefs.copy.array.item.extract("$"))
		
	End if 
	
	// Mark:Delete items from the target
	If ($success && ($prefs.delete#Null:C1517))
		
		If (Value type:C1509($prefs.delete.array.item)#Is collection:K8:32)
			
			$prefs.delete.array.item:=New collection:C1472($prefs.delete.array.item)
			
		End if 
		
		This:C1470._callBarber("🚧 "+Get localized string:C991("preparingForRemoval"); Progress bar:K42:34)
		
		DELAY PROCESS:C323(Current process:C322; 50)
		
		This:C1470.delete(This:C1470.target; $prefs.delete.array.item.extract("$"))
		
	End if 
	
	// Mark:Execute post-build method
	If ($success && Bool:C1537($prefs.methods.after))
		
		$success:=This:C1470.executeMethod($prefs.methods.after)
		
	End if 
	
	// Mark:Sign & notarize
	If ($success && Is macOS:C1572 && Bool:C1537($prefs.options.notarize) && (This:C1470.build.lib4d#Null:C1517))
		
		// Sign the component
		$success:=This:C1470.sign()
		
		If ($success)
			
			Case of 
					
					//______________________________________________________
					
				: (This:C1470.target.parent.name="Components")
					
					$success:=This:C1470.notarizelib4D()
					
					//______________________________________________________
				Else 
					
					// Notarize & staple
					$success:=This:C1470.notarize()
					
					//______________________________________________________
			End case 
		End if 
	End if 
	
	This:C1470._closeBarber()
	
	return $success
	
	// MARK:-
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function CommitAndPush($stapled : Object; $commitMessage : Text) : Boolean
	
	var $err; $in; $out : Text
	
	SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_CURRENT_DIRECTORY"; $stapled.folder)
	SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_HIDE_CONSOLE"; "true")
	LAUNCH EXTERNAL PROCESS:C811("git add --all"; $in; $out; $err)
	
	If (Length:C16($out+$err)>0) && (Position:C15("warning: "; $err)=0)
		
		return 
		
	Else 
		
		SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_CURRENT_DIRECTORY"; $stapled.folder)
		SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_HIDE_CONSOLE"; "true")
		LAUNCH EXTERNAL PROCESS:C811("git commit -a -q -m "+Char:C90(34)+$commitMessage+Char:C90(34); $in; $out; $err)
		
		If (Length:C16($out+$err)>0 && (Position:C15("warning: "; $err)=0))
			
			return 
			
		Else 
			
			SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_CURRENT_DIRECTORY"; $stapled.folder)
			SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_HIDE_CONSOLE"; "true")
			LAUNCH EXTERNAL PROCESS:C811("git push"; $in; $out; $err)
			
			If ($err="@master -> master@")
				
				return True:C214
				
			End if 
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function sign($target : 4D:C1709.File) : Boolean
	
	var $commandLine : Text
	var $entitlementsFile; $scriptFile : 4D:C1709.File
	var $4D : 4D:C1709.Folder
	var $worker : 4D:C1709.SystemWorker
	
	This:C1470._callBarber("✍️ Signature"; Barber shop:K42:35)
	
	$target:=$target || This:C1470.target
	
	// Get 4D signature script and entitlements
	$4D:=Folder:C1567(Application file:C491; fk platform path:K87:2)
	$scriptFile:=$4D.file("Contents/Resources/SignApp.sh")
	$entitlementsFile:=$4D.file("Contents/Resources/4D.entitlements")
	
	If ($scriptFile.exists && $entitlementsFile.exists)
		
		If (This:C1470.credentials.certificate#"")
			
			// Run the signature script
			$commandLine:="'"+$scriptFile.path+"' '"
			$commandLine+=This:C1470.credentials.certificate+"' '"
			$commandLine+=$target.path+"' '"
			$commandLine+=$entitlementsFile.path+"'"
			
			$worker:=4D:C1709.SystemWorker.new($commandLine)
			$worker.wait(120)
			
			If ($worker.terminated)
				
				If ($worker.exitCode=0)
					
					return True:C214
					
				Else 
					
					This:C1470._error("Signature error: "+$worker.response)
					return 
					
				End if 
				
			Else 
				
				This:C1470._error("Signature timeout.")
				return 
				
			End if 
			
		Else 
			
			This:C1470._error("No certificate defined.")
			return 
			
		End if 
		
	Else 
		
		This:C1470._error("Signature files are missing.")
		return 
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Notarize & staple the lib
Function notarizelib4D() : Boolean
	
	var $success : Boolean
	var $dmg; $zip : 4D:C1709.File
	var $root; $lib; $target : 4D:C1709.Folder
	var $ditto : cs:C1710.ditto
	var $hdutil : cs:C1710.hdutil
	var $notarytool : cs:C1710.notarytool
	
	If (This:C1470.build.lib4d.exists)
		
		$target:=This:C1470.target
		$root:=$target.parent.parent
		
		This:C1470._callBarber("🍏 Notarization process"; Barber shop:K42:35)
		
		// Archive the library in a DMG
		$dmg:=$root.file($target.name+".dmg")
		$hdutil:=cs:C1710.hdutil.new($dmg)
		
		If ($hdutil.create(This:C1470.build.lib4d))
			
			// Send the dmg for notarization
			$notarytool:=cs:C1710.notarytool.new($hdutil.target; This:C1470.credentials.keychainProfile)
			
			If ($notarytool.submit())
				
				If ($notarytool.staple($hdutil.target))
					
					// Mount the virtual disk
					If ($hdutil.attach())
						
						// Get the stapled lib
						$lib:=$hdutil.disk.file(This:C1470.build.lib4d.fullName)
						
						// Replace the original into the component
						$lib.copyTo($target.folder("Libraries"); fk overwrite:K87:5)
						
						// Create an archive to preserve the stapple ticket
						$zip:=$root.file($target.name+".4dbase.zip")
						$zip.delete()
						
						$ditto:=cs:C1710.ditto.new($target; $zip; {keepParent: False:C215})
						
						If ($ditto.archive())
							
							$success:=True:C214
							
							// Delete dmg file
							$dmg.delete()
							
						Else 
							
							This:C1470._error($ditto.lastError)
							
						End if 
						
						Folder:C1567(fk logs folder:K87:17; *).file("ditto.log").setText($ditto.history.join("\n"))
						
						// Unmount the virtual disk
						$hdutil.detach()
						
					End if 
				End if 
			End if 
			
			Folder:C1567(fk logs folder:K87:17; *).file("notarytool.log").setText($notarytool.history.join("\n"))
			
		End if 
		
		Folder:C1567(fk logs folder:K87:17; *).file("hdutil.log").setText($hdutil.history.join("\n"))
		
	End if 
	
	return $success
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Notarize & staple the target
Function notarize() : Boolean
	
	var $success : Boolean
	var $dmg; $zip : 4D:C1709.File
	var $root; $stapled : 4D:C1709.Folder
	var $ditto : cs:C1710.ditto
	var $hdutil : cs:C1710.hdutil
	var $notarytool : cs:C1710.notarytool
	
	$root:=This:C1470.target.parent.parent
	
	// Create a dmg
	$dmg:=$root.file(This:C1470.target.name+".dmg")
	$hdutil:=cs:C1710.hdutil.new($dmg)
	
	If ($hdutil.create(This:C1470.target))
		
		// Sign the dmg (not mandatory, but preferable)
		If (This:C1470.sign($dmg))
			
			This:C1470._callBarber("🍏 Notarization process"; Barber shop:K42:35)
			
			// Send the dmg for notarization
			$notarytool:=cs:C1710.notarytool.new($hdutil.target; This:C1470.credentials.keychainProfile)
			
			If ($notarytool.submit())
				
				If ($notarytool.staple($dmg))
					
					// Mount the virtual disk
					If ($hdutil.attach())
						
						// Get the stapled element
						$stapled:=$hdutil.disk.folders().pop()
						
						// Replace the original component
						$stapled.copyTo($dmg.parent.folder("Components"); fk overwrite:K87:5)
						
						// Create an archive to preserve the stapple ticket
						$zip:=$root.file(This:C1470.target.name+".4dbase.zip")
						$zip.delete()
						
						$ditto:=cs:C1710.ditto.new($stapled; $zip; {keepParent: False:C215})
						
						If ($ditto.archive())
							
							$success:=True:C214
							
							// Delete dmg file
							$dmg.delete()
							
						Else 
							
							This:C1470._error($ditto.lastError)
							
						End if 
						
						// Unmount the virtual disk
						$hdutil.detach()
						
					Else 
						
						This:C1470._error($hdutil.lastError)
						
					End if 
					
				Else 
					
					This:C1470._error($notarytool.lastError)
					
				End if 
				
			Else 
				
				This:C1470._error($notarytool.lastError)
				
			End if 
			
		End if 
		
	Else 
		
		This:C1470._error($hdutil.lastError)
		
	End if 
	
	// Keep a log of all operations
	Folder:C1567(fk logs folder:K87:17; *).file("hdutil.log").setText($hdutil.history.join("\n"))
	Folder:C1567(fk logs folder:K87:17; *).file("notarytool.log").setText($notarytool.history.join("\n"))
	Folder:C1567(fk logs folder:K87:17; *).file("ditto.log").setText($ditto.history.join("\n"))
	
	return $success
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Delete help files and the non necessary resources for the final user
Function deleteResources($target : 4D:C1709.Folder) : Boolean
	
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
			
			$path:=This:C1470.target.path+$path
			
			If ($path="@/")
				
				Folder:C1567($path).delete(fk recursive:K87:7)
				
			Else 
				
				File:C1566($path).delete()
				
			End if 
		End for each 
		
		$xml.close()
		
	End if 
	
	return True:C214
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function deleteMacContent($target : 4D:C1709.Folder) : Boolean
	
	var $file : 4D:C1709.File
	
	Repeat 
		
		This:C1470._wait()
		This:C1470._callBarber("🧽 "+Get localized string:C991("deleteMacOsSpecificFiles"); Barber shop:K42:35)
		
		DELAY PROCESS:C323(Current process:C322; 50)
		
		For each ($file; This:C1470.target.files(fk recursive:K87:7).query("name = :1"; ".@"))
			
			$file.delete()
			
		End for each 
	Until (This:C1470._wait(2000))
	
	return True:C214
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function incrementBundleVersion() : Boolean
	
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
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function executeMethod($method : Text) : Boolean
	
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
	
	// === === === === === === === === === === === === === === === === === === === === === === === === 
Function updateInfoPlist($infos : Object) : Boolean
	
	var $template : Text
	
	This:C1470._callBarber("🚧 "+Get localized string:C991("Preparations")+"…")
	
	If (Not:C34(This:C1470.database.plistFile.exists))
		
		// Create a default from template
		$template:=File:C1566("/RESOURCES/InfoPlist.template").getText()
		$template:=Replace string:C233($template; "{name}"; This:C1470.applicationName)
		$template:=Replace string:C233($template; "{version}"; This:C1470.motor.branch)
		$template:=Replace string:C233($template; "{build}"; "1")
		$template:=Replace string:C233($template; "{copyright}"; "©"+String:C10(Year of:C25(Current date:C33)))
		This:C1470.database.plistFile.setText($template)
		
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
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function delete($target : 4D:C1709.Folder; $items : Collection)
	
	var $item : Text
	var $tgt : Object
	
	For each ($item; $items)
		
		Use (Storage:C1525.progress)
			
			Storage:C1525.progress.title:=Get localized string:C991("remove")+$item
			
		End use 
		
		$item:=$item="./@" ? Delete string:C232($item; 1; 2) : $item
		
		If ($item="@/")
			
			$tgt:=This:C1470.target.folder($item)
			
			If ($tgt.exists)
				
				$tgt.delete(Delete with contents:K24:24)
				
			Else 
				
				This:C1470._warning($tgt.path+" not found for removal")
				
			End if 
			
		Else 
			
			$tgt:=This:C1470.target.file($item)
			
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
	
	// === === === === === === === === === === === === === === === === === === === === === === === === 
Function copy($target : 4D:C1709.Folder; $items : Collection)
	
	var $item : Text
	var $src; $tgt : Object
	
	For each ($item; $items)
		
		Use (Storage:C1525.progress)
			
			Storage:C1525.progress.title:=Get localized string:C991("copy")+$item
			
		End use 
		
		If ($item="@/")
			
			$src:=This:C1470.database.databaseFolder.folder($item)
			$tgt:=This:C1470.target.folder($item).parent
			
		Else 
			
			$src:=This:C1470.database.databaseFolder.file($item)
			$tgt:=This:C1470.target.file($item).parent
			
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
	
	// MARK:-Tools
Function makeFamily($target : 4D:C1709.Folder) : Boolean
	
	var $familyName; $pathname : Text
	var $success : Boolean
	var $i : Integer
	var $component; $make : Object
	var $dmg; $makeFile : 4D:C1709.File
	var $family; $src; $tgt : 4D:C1709.Folder
	var $hdutil : cs:C1710.hdutil
	var $notarytool : cs:C1710.notarytool
	
	If (Count parameters:C259=0)
		
		$pathname:=Select folder:C670("Select the family folder"; 8858)
		
		If (Bool:C1537(OK))
			
			$target:=Folder:C1567($pathname; fk platform path:K87:2)
			
		End if 
	End if 
	
	If ($target=Null:C1517) || Not:C34($target.exists)
		
		return 
		
	End if 
	
	$makeFile:=$target.file("make.json")
	
	If (Not:C34($makeFile.exists))
		
		ALERT:C41("Missing file \"make.json+\"")
		return 
		
	End if 
	
	This:C1470.withUI:=True:C214  // Allow barber
	
	This:C1470._initBarber()._openBarber("Starting…")
	
	$make:=JSON Parse:C1218($makeFile.getText())
	
	$familyName:="4DPop-Family-"+This:C1470.motor.branch
	$family:=$target.folder($familyName)
	
	If ($family.exists)
		
		$family.delete(fk recursive:K87:7)
		
	End if 
	
	$family:=$family.folder("Components")
	
	$family.create()
	
	// Make a copy of all family items
	This:C1470._callBarber("1️⃣ Copy of all family items"; Progress bar:K42:34)
	
	For each ($component; $make.components)
		
		$i+=1
		
		If (Not:C34($component.family))
			
			continue
			
		End if 
		
		$src:=$target.folder($component.name).folder("Build/Components").folder($component.name+".4dbase")
		
		If (Not:C34($src.exists))
			
			// Try with a github-compliant name
			$src:=$target.folder(Replace string:C233($component.name; " "; "-")).folder("Build/Components").folder($component.name+".4dbase")
			
		End if 
		
		If ($src.exists)
			
			$tgt:=$src.copyTo($family)
			
		End if 
		
		Use (Storage:C1525.progress)
			
			Storage:C1525.progress.value+=Round:C94((100*$i)/$make.components.length; 0)
			
		End use 
	End for each 
	
	// Create a dmg
	This:C1470._callBarber("2️⃣ Create the dmg"; Barber shop:K42:35)
	
	$dmg:=File:C1566($target.folder($familyName).path+$familyName+".dmg")
	$hdutil:=cs:C1710.hdutil.new($dmg)
	
	$success:=$hdutil.create($family)
	
	If (Not:C34($success))
		
		TRACE:C157
		
	End if 
	
	// Sign the dmg (not mandatory, but preferable)
	This:C1470._callBarber("3️⃣ Sign the dmg (not mandatory, but preferable)"; Barber shop:K42:35)
	
	$success:=This:C1470.sign($dmg)
	
	If (Not:C34($success))
		
		TRACE:C157
		
	End if 
	
	// Send the dmg for notarization
	This:C1470._callBarber("4️⃣ Send the dmg for notarization"; Barber shop:K42:35)
	$notarytool:=cs:C1710.notarytool.new($hdutil.target; This:C1470.credentials.keychainProfile)
	
	$success:=$notarytool.submit()
	
	If (Not:C34($success))
		
		TRACE:C157
		
	End if 
	
	// Staple
	This:C1470._callBarber("5️⃣ Staple"; Barber shop:K42:35)
	$success:=$notarytool.staple($dmg)
	
	If (Not:C34($success))
		
		TRACE:C157
		
	End if 
	
	// Mount the virtual disk
	This:C1470._callBarber("6️⃣ Mount the virtual disk"; Barber shop:K42:35)
	$success:=$hdutil.attach()
	
	If (Not:C34($success))
		
		TRACE:C157
		
	End if 
	
	This:C1470._closeBarber()
	
	return $success
	
	// MARK:-
	// === === === === === === === === === === === === === === === === === === === === === === === === 
Function _error($error : Text)
	
	This:C1470.errors.push($error)
	This:C1470._displayError($error)
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function _warning($error : Text)
	
	This:C1470.warnings.push($error)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === 
Function _wait($delay : Integer) : Boolean
	
	If (Count parameters:C259=0)
		
		This:C1470.start:=Milliseconds:C459
		
	Else 
		
		While ((Milliseconds:C459-This:C1470.start)<$delay)
			
			DELAY PROCESS:C323(Current process:C322; 5)
			
		End while 
		
		return True:C214
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === 
Function _initBarber() : cs:C1710.AppMaker
	
	Use (Storage:C1525.progress)
		
		Storage:C1525.progress.indicator:=Null:C1517
		Storage:C1525.progress.title:=""
		Storage:C1525.progress.value:=0
		
	End use 
	
	If (This:C1470.withUI)
		
		// Bringing 4D to the forefront
		If (Is macOS:C1572)
			
			LAUNCH EXTERNAL PROCESS:C811("osascript -e 'tell app \""+Application file:C491+"\" to activate'")
			
		Else 
			
			LAUNCH EXTERNAL PROCESS:C811("Powershell.exe (New-Object -ComObject WScript.Shell).AppActivate((get-process 4D).id)")
			
		End if 
	End if 
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function _openBarber($title : Text; $indicator : Integer)
	
	If (This:C1470.withUI)
		
		// ⚠️ :Even if the formula calls non-preemptive code, CALL WORKER creates a preemptive process.
		//CALL WORKER("$AppMakerBarber"; Formula(Open form window("Barber"; Controller form window+Form has no menu bar; Horizontally centered; Vertically centered; *)))
		//CALL WORKER("$AppMakerBarber"; Formula(DIALOG("Barber")))
		// We therefore need to use a method that is declared as not thread-safe
		CALL WORKER:C1389("$AppMakerBarber"; Formula:C1597(_barber))
		
		If (Count parameters:C259>=1)
			
			Use (Storage:C1525.progress)
				
				Storage:C1525.progress.title:=$title
				
				If (Count parameters:C259>=2)
					
					Storage:C1525.progress.indicator:=$indicator
					
				End if 
			End use 
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === 
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
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
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
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function _closeBarber()
	
	If (This:C1470.withUI)
		
		Use (Storage:C1525.progress)
			
			Storage:C1525.progress.indicator:=-1
			
		End use 
		
		KILL WORKER:C1390("$AppMakerBarber")
		
	End if 