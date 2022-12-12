//%attributes = {}
// ----------------------------------------------------
// Method :  APP_MAKER_HANDLER
// Created 30/05/08 by Vincent de Lachaux
// ----------------------------------------------------
// Description
// Build application and more...
// ----------------------------------------------------
// Declarations
#DECLARE($action : Text)

If (False:C215)
	C_TEXT:C284(APP_MAKER_HANDLER; $1)
End if 

var $Dir_compiled; $node; $node; $pathComponent; $pathname; $pathServer : Text
var $pathStandalone; $root; $t; $Txt_archiveFilePath; $buildApplicationName; $Txt_cmd : Text
var $Txt_fileName; $Txt_filePath; $Txt_relativeCompiledTarget; $Txt_relativeComponentTarget; $Txt_relativeServerTarget; $Txt_relativeStandaloneTarget : Text
var $Txt_structure : Text
var $batch; $Boo_KO; $builComponent; $buildCompiled; $buildServer; $buildStandalone : Boolean
var $run; $success : Boolean
var $Lon_bottom; $Lon_i; $Lon_left; $Lon_right; $Lon_top; $process : Integer
var $start : Integer
var $data; $database; $environment; $preferences; $o; $Obj_paths : Object
var $c : Collection
var $file : 4D:C1709.File
var $build : cs:C1710.build
var $hdutil : cs:C1710.hdutil

// ----------------------------------------------------
Case of 
		
		//================================================================================
	: (Length:C16($action)=0)  // No parameter
		
		Case of 
				
				//……………………………………………………………………
			: (Method called on error:C704=Current method name:C684)
				
				// Error managemnt routine
				
				//……………………………………………………………………
			Else 
				
				// This method must be executed in a new process
				BRING TO FRONT:C326(New process:C317(Current method name:C684; 0; "$"+Current method name:C684; "_open"; *))
				
				//……………………………………………………………………
		End case 
		
		//================================================================================
	: ($action="_open")  // Display the main dialog
		
		APP_MAKER_HANDLER("_declarations")
		APP_MAKER_HANDLER("_init")
		
		$data:=New object:C1471(\
			"process"; Current process:C322; \
			"window"; Open form window:C675("Editor"; Plain form window:K39:10; Horizontally centered:K39:1; Vertically centered:K39:4; *))
		DIALOG:C40("Editor"; $data)
		CLOSE WINDOW:C154($data.window)
		
		If (Storage:C1525.environment.domBuildApp#Null:C1517)
			
			If (Bool:C1537($data.modified))
				
				DOM EXPORT TO FILE:C862(Storage:C1525.environment.domBuildApp; Storage:C1525.environment.buildApp)
				
			End if 
			
			Use (Storage:C1525)
				
				Use (Storage:C1525.environment)
					
					DOM CLOSE XML:C722(Storage:C1525.environment.domBuildApp)
					Storage:C1525.environment.domBuildApp:=Null:C1517
					
				End use 
			End use 
		End if 
		
		Storage:C1525.preferences.save()
		
		APP_MAKER_HANDLER("_deinit")
		
		//================================================================================
	: ($action="_run@")\
		 | ($action="_autoBuild")  // Build the application
		
		ARRAY TEXT:C222($tTxt_path; 0x0000)
		
		$batch:=($action="_autoBuild")
		
		// First launch of this method executed in a new process
		APP_MAKER_HANDLER("_declarations")
		APP_MAKER_HANDLER("_init")
		
		FLUSH CACHE:C297
		
		$database:=_o_database  // Storage.database
		$environment:=Storage:C1525.environment
		
		// Start the Barber
		$process:=New process:C317(Formula:C1597(_o_BARBER).source; 0; "$AppMakerBarber"; "barber.open"; *)
		
		var $xml : cs:C1710.xml
		var $pref : Object
		$xml:=cs:C1710.xml.new(Storage:C1525.preferences.content)
		$pref:=$xml.toObject()
		$xml.close()
		
		// MARK:-Host database method to run before generation
		If (Length:C16(String:C10($pref.methods.before))>0)
			
			Use (Storage:C1525.progress)
				
				Storage:C1525.progress.indicator:=Barber shop:K42:35
				Storage:C1525.progress.title:="🛠 "+Replace string:C233(Get localized string:C991("executionOfMethod"); "{methodName}"; String:C10($pref.methods.before))
				
			End use 
			
			DELAY PROCESS:C323(Current process:C322; 50)
			
			EXECUTE METHOD:C1007(String:C10($pref.methods.before); $success)  // The host database must return true
			
			If (Not:C34($success))
				
				Use (Storage:C1525.progress)
					
					Storage:C1525.progress.title:="❌ "+Replace string:C233(Get localized string:C991("methodFailed"); "{methodName}"; String:C10($pref.methods.before))
					
				End use 
				
				_o_BARBER("barber.error")
				
				return 
				
			End if 
		End if 
		
		// MARK:-Update the Info.plist file
		If ($pref["info.plist"]#Null:C1517)
			
			Use (Storage:C1525.progress)
				
				Storage:C1525.progress.indicator:=Barber shop:K42:35
				Storage:C1525.progress.title:="🚧 "+Get localized string:C991("Preparations")+"…"
				
			End use 
			
			// Get the final application name
			var $buildAppSettings : Object
			var $xml : cs:C1710.xml
			
			$xml:=cs:C1710.xml.new(File:C1566(Storage:C1525.environment.buildApp; fk platform path:K87:2))
			$buildAppSettings:=$xml.toObject().BuildApp
			$xml.close()
			
			$buildApplicationName:=String:C10($buildAppSettings.BuildApplicationName.$)
			
			var $plist : 4D:C1709.File
			$plist:=$database.root.file("Info.plist")
			
			var $branch : Text
			$branch:=_o_application.branch
			
			If (Not:C34($plist.exists))
				
				$t:=File:C1566("/RESOURCES/InfoPlist.template").getText()
				$t:=Replace string:C233($t; "{name}"; $buildApplicationName)
				$t:=Replace string:C233($t; "{version}"; $branch)
				$t:=Replace string:C233($t; "{build}"; "1")
				$t:=Replace string:C233($t; "{copyright}"; "©"+String:C10(Year of:C25(Current date:C33)))
				
			End if 
			
			If ($plist.exists)
				
				var $content : Object
				$content:=$plist.getAppInfo()
				$o:=$pref["info.plist"]
				$content.CFBundleName:=$buildApplicationName
				$content.CFBundleVersion:=Num:C11($content.CFBundleVersion)+1
				$content.CFBundleGetInfoString:=$branch
				$content.CFBundleShortVersionString:=$branch
				$content.CFBundleLongVersionString:=$content.CFBundleShortVersionString+($content.CFBundleVersion#Null:C1517 ? (" ("+String:C10($content.CFBundleVersion)+")") : "")
				$content.NSHumanReadableCopyright:=Length:C16(String:C10($o.NSHumanReadableCopyright))>0 ? Replace string:C233(String:C10($o.NSHumanReadableCopyright); "{currentYear}"; String:C10(Year of:C25(Current date:C33))) : "©"+String:C10(Year of:C25(Current date:C33))
				$plist.setAppInfo($content)
				
			Else 
				
				ASSERT:C1129(False:C215; "Failed to update info.plist")
				
			End if 
		End if 
		
		$build:=cs:C1710.build.new()
		
		// MARK:-Launch the application generation process
		If ($build.success)\
			 & ($action#"@noBuild@")
			
			Repeat 
				
				$start:=Milliseconds:C459
				
				Use (Storage:C1525.progress)
					
					Storage:C1525.progress.indicator:=Barber shop:K42:35
					Storage:C1525.progress.title:="⚙️ "+Get localized string:C991("CompilationAndGeneration")
					
				End use 
				
				If (Not:C34($build.run()))
					
					Use (Storage:C1525.progress)
						
						Storage:C1525.progress.title:="❌ ERROR"
						
					End use 
					
					_o_BARBER("barber.error")
					
					return 
					
				End if 
				
			Until (_o_wait($start; 2000; Current process:C322; 5))
			
		Else 
			
			//FIXME:ERROR
			
		End if 
		
		// MARK:-Get the useful paths
		//FIXME:???
		$Obj_paths:=New object:C1471
		
		// Get the common part for structure folder and target path
		
		// Keep the variable part of any target if any
		XML DECODE:C1091(String:C10($buildAppSettings.BuildComponent.$); $builComponent)
		
		If ($builComponent)
			
			$pathComponent:=_o_APP_MAKER_Get_target_path(800)
			$Txt_relativeComponentTarget:=Replace string:C233($pathComponent; String:C10($Obj_paths.root); ""; 1)
			
		End if 
		
		XML DECODE:C1091(String:C10($buildAppSettings.BuildCompiled.$); $buildCompiled)
		
		If ($buildCompiled)
			
			$Dir_compiled:=_o_APP_MAKER_Get_target_path(810)+Folder separator:K24:12
			$Txt_relativeCompiledTarget:=Replace string:C233($Dir_compiled; String:C10($Obj_paths.root); ""; 1)
			
		End if 
		
		XML DECODE:C1091(String:C10($buildAppSettings.BuildApplicationSerialized.$); $buildStandalone)
		
		If ($buildStandalone)
			
			$pathStandalone:=_o_APP_MAKER_Get_target_path(820)+Folder separator:K24:12
			$Txt_relativeStandaloneTarget:=Replace string:C233($pathStandalone; String:C10($Obj_paths.root); ""; 1)
			
		End if 
		
		XML DECODE:C1091(String:C10($buildAppSettings.BuildServerApplication.$); $buildServer)
		
		If ($buildServer)
			
			$pathServer:=_o_APP_MAKER_Get_target_path(830)+Folder separator:K24:12
			$Txt_relativeServerTarget:=Replace string:C233($pathServer; String:C10($Obj_paths.root); ""; 1)
			
		End if 
		
		
		// MARK:-Options
		
		// MARK:Increments the bundleVersion key
		If (Bool:C1537($pref.options.increment_version))
			
			Use (Storage:C1525.progress)
				
				Storage:C1525.progress.indicator:=Barber shop:K42:35
				Storage:C1525.progress.title:="🚧 "+Get localized string:C991("Preparation")
				
			End use 
			
			If ($plist.exists)
				
				// Create the 'InfoPlist.strings' file
				$t:=File:C1566("/RESOURCES/InfoPlist.template").getText()
				$t:=Replace string:C233($t; "{name}"; $buildApplicationName)
				$t:=Replace string:C233($t; "{version}"; $branch)
				$t:=Replace string:C233($t; "{build}"; String:C10(Num:C11($content.CFBundleVersion)))
				$t:=Replace string:C233($t; "{copyright}"; $content.NSHumanReadableCopyright)
				
				Folder:C1567(fk resources folder:K87:11; *).file("InfoPlist.strings").setText($t; "UTF-16")
				
				// Delete the (older) unused localized files, if any
				For each ($o; Folder:C1567(fk resources folder:K87:11; *).folders().query("extension='.lproj'"))
					
					$o.file("InfoPlist.strings").delete()
					
				End for each 
			End if 
		End if 
		
		If ($database.isDatabase)
			
			// MARK:Export structure
			If (Bool:C1537($pref.options.exportStructure))
				
				Repeat 
					
					$start:=Milliseconds:C459
					
					Use (Storage:C1525.progress)
						
						Storage:C1525.progress.indicator:=Barber shop:K42:35
						Storage:C1525.progress.title:="🚚 "+Get localized string:C991("exportProject")
						
					End use 
					
					_o_EXPORT_PROJECT
					
				Until (_o_wait($start; 2000; Current process:C322; 5))
			End if 
			
			// MARK:Zip sources
			If (Bool:C1537($pref.options.zip_source))
				
				// TODO: Use 4D.zip
				
				Repeat 
					
					$start:=Milliseconds:C459
					
					Use (Storage:C1525.progress)
						
						Storage:C1525.progress.indicator:=Barber shop:K42:35
						Storage:C1525.progress.title:="🗜 "+Get localized string:C991("compression")
						
					End use 
					
					// Structure file path
					$Txt_structure:=Structure file:C489(*)
					$Txt_filePath:=Convert path system to POSIX:C1106($Txt_structure)
					$Txt_fileName:=Replace string:C233($Txt_structure; $environment.databaseFolder; "")
					
					// Archive file path
					$Txt_archiveFilePath:=$environment.databaseFolder+"SOURCES"+Folder separator:K24:12
					CREATE FOLDER:C475($Txt_archiveFilePath; *)
					
					If (Test path name:C476($Txt_archiveFilePath)=Is a folder:K24:2)
						
						$Boo_KO:=_o_PHP_zip_archive_to($Txt_structure; $Txt_archiveFilePath+Replace string:C233($Txt_fileName; ".4db"; ".zip"))
						
					End if 
				Until (_o_wait($start; 2000; Current process:C322; 5))
			End if 
		End if 
		
		// MARK:Delete Mac content
		If (Is macOS:C1572 && Bool:C1537($pref.options.delete_mac_content))
			
			Repeat 
				
				$start:=Milliseconds:C459
				
				Use (Storage:C1525.progress)
					
					Storage:C1525.progress.indicator:=Barber shop:K42:35
					Storage:C1525.progress.title:="🧽 "+Get localized string:C991("deleteMacOsSpecificFiles")
					
				End use 
				
				DELAY PROCESS:C323(Current process:C322; 50)
				
				If ($builComponent)
					
					For each ($file; Folder:C1567($pathComponent; fk platform path:K87:2).files(fk recursive:K87:7).query("name = :1"; ".@"))
						
						$file.delete()
						
					End for each 
					
				End if 
				
				If ($buildCompiled)
					
				End if 
				
				If ($buildStandalone)
					
				End if 
				
				If ($buildServer)
					
				End if 
			Until (_o_wait($start; 5000; Current process:C322; 5))
		End if 
		
		// MARK:Delete help files and the non necessary resources for the final user
		If ($buildCompiled || $buildStandalone || $buildServer)\
			 && (Bool:C1537($pref.options.removeDevResources))
			
			$start:=Milliseconds:C459
			
			Use (Storage:C1525.progress)
				
				Storage:C1525.progress.indicator:=Barber shop:K42:35
				Storage:C1525.progress.title:="🗜 Deleting unnecessary resources"
				
			End use 
			
			// Relative paths are listed in the file AppMaker delete.xml in the Preferences folder of the host database…
			$pathname:=Replace string:C233(Get 4D folder:C485(Current resources folder:K5:16; *); "Resources"; "Preferences")+"AppMaker delete.xml"
			
			If (Test path name:C476($pathname)#Is a document:K24:1)
				
				// Use the default set
				$pathname:=Get 4D folder:C485(Current resources folder:K5:16)+"AppMaker delete.xml"
				
			End if 
			
			If (Test path name:C476($pathname)=Is a document:K24:1)
				
				// Load the list of items to delete
				$root:=DOM Parse XML source:C719($pathname)
				
				If (OK=1)
					
					ARRAY TEXT:C222($nodes; 0x0000)
					$nodes{0}:=DOM Find XML element:C864($root; "items/item"; $nodes)
					
					For ($Lon_i; 1; Size of array:C274($nodes); 1)
						
						DOM GET XML ELEMENT VALUE:C731($nodes{$Lon_i}; $t)
						APPEND TO ARRAY:C911($tTxt_path; Replace string:C233($t; "/"; Folder separator:K24:12))
						
					End for 
					
					DOM CLOSE XML:C722($root)
					
				End if 
				
				// Remove from compiled package if any
				If ($buildCompiled)
					
					_o_buildApp_DELETE_RESOURCES($Dir_compiled; ->$tTxt_path)
					
				End if 
				
				// Remove from final application if any
				If ($buildStandalone)
					
					_o_buildApp_DELETE_RESOURCES($pathStandalone+Choose:C955(Is macOS:C1572; "Contents"+Folder separator:K24:12; ""); ->$tTxt_path)
					
				End if 
				
				// Remove from server application if any
				If ($buildServer)
					
					_o_buildApp_DELETE_RESOURCES($pathServer+Choose:C955(Is macOS:C1572; "Contents"+Folder separator:K24:12; ""); ->$tTxt_path)
					
				End if 
			End if 
		End if 
		
		
		// MARK:-Copy
		If ($pref.copy#Null:C1517)
			
			If (Value type:C1509($pref.copy.array.item)#Is collection:K8:32)
				
				$pref.copy.array.item:=New collection:C1472($pref.copy.array.item)
				
			End if 
			
			Use (Storage:C1525.progress)
				
				Storage:C1525.progress.indicator:=0
				Storage:C1525.progress.value:=$pref.copy.array.item.length*(Num:C11($builComponent)+Num:C11($buildCompiled)+Num:C11($buildStandalone)+Num:C11($buildServer))
				Storage:C1525.progress.title:="⚙️ "+Get localized string:C991("preparationOfCopy")
				
			End use 
			
			DELAY PROCESS:C323(Current process:C322; 50)
			
			If ($builComponent)
				
				_o_COPY(String:C10($Obj_paths.root)+$Txt_relativeComponentTarget; $pref.copy.array.item.extract("$"))
				
			End if 
			
			If ($buildCompiled)
				
				_o_COPY(String:C10($Obj_paths.root)+$Txt_relativeCompiledTarget; $pref.copy.array.item.extract("$"))
				
			End if 
			
			If ($buildStandalone)
				
				_o_COPY(String:C10($Obj_paths.root)+$Txt_relativeStandaloneTarget+Choose:C955(Is macOS:C1572; "Contents"+Folder separator:K24:12; "")+"Database"+Folder separator:K24:12; $pref.copy.array.item.extract("$"))
				
			End if 
			
			If ($buildServer)
				
				_o_COPY(String:C10($Obj_paths.root)+$Txt_relativeServerTarget+Choose:C955(Is macOS:C1572; "Contents"+Folder separator:K24:12; "")+"Server Database"+Folder separator:K24:12; $pref.copy.array.item.extract("$"))
				
			End if 
		End if 
		
		// MARK:-Deletion
		If ($pref.delete#Null:C1517)
			
			If (Value type:C1509($pref.delete.array.item)#Is collection:K8:32)
				
				$pref.delete.array.item:=New collection:C1472($pref.delete.array.item)
				
			End if 
			
			Use (Storage:C1525.progress)
				
				Storage:C1525.progress.indicator:=0
				Storage:C1525.progress.value:=$pref.delete.array.item.length*(Num:C11($builComponent)+Num:C11($buildCompiled)+Num:C11($buildStandalone)+Num:C11($buildServer))
				Storage:C1525.progress.title:="🚧 "+Get localized string:C991("preparingForRemoval")
				
			End use 
			
			DELAY PROCESS:C323(Current process:C322; 50)
			
			If ($builComponent)
				
				_o_DELETE(String:C10($Obj_paths.root); $pref.delete.array.item.extract("$"); $Txt_relativeComponentTarget)
				
			End if 
			
			If ($buildCompiled)
				
				_o_DELETE(String:C10($Obj_paths.root); $pref.delete.array.item.extract("$"); $Txt_relativeCompiledTarget)
				
			End if 
			
			If ($buildStandalone)
				
				_o_DELETE(String:C10($Obj_paths.root); $pref.delete.array.item.extract("$"); $Txt_relativeStandaloneTarget+Choose:C955(Is macOS:C1572; "Contents"+Folder separator:K24:12; "")+"Database"+Folder separator:K24:12)
				
			End if 
			
			If ($buildServer)
				
				_o_DELETE(String:C10($Obj_paths.root); $pref.delete.array.item.extract("$"); $Txt_relativeServerTarget+Choose:C955(Is macOS:C1572; "Contents"+Folder separator:K24:12; "")+"Server Database"+Folder separator:K24:12)
				
			End if 
		End if 
		
		
		// MARK:-Make the package and its content readable/executable and writable by everyone
		// TODO: Use $build.unlockDirectory()
		SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_HIDE_CONSOLE"; "true")
		SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_CURRENT_DIRECTORY"; String:C10($Obj_paths.root))
		
		If (Is Windows:C1573)
			
			$Txt_cmd:="attrib.exe -R /S /D"
			LAUNCH EXTERNAL PROCESS:C811($Txt_cmd)
			
		Else 
			
			// -R Change the modes of the file hierarchies rooted in the files instead of just the files themselves.
			// 755 Make the package and its content readable/executable and writable by everyone
			$Txt_cmd:="chmod -R 777 "+Replace string:C233(Convert path system to POSIX:C1106(String:C10($Obj_paths.root)); " "; "\\ ")
			LAUNCH EXTERNAL PROCESS:C811($Txt_cmd)
			
		End if 
		
		// MARK:-Host database method to run at the end
		If (Length:C16(String:C10($pref.methods.after))>0)
			
			Use (Storage:C1525.progress)
				
				Storage:C1525.progress.indicator:=Barber shop:K42:35
				Storage:C1525.progress.title:="🛠 "+Replace string:C233(Get localized string:C991("executionOfMethod"); "{methodName}"; String:C10($pref.methods.after))
				
			End use 
			
			DELAY PROCESS:C323(Current process:C322; 50)
			
			EXECUTE METHOD:C1007(String:C10($pref.methods.after); $success)  // The host database must return true
			
			If (Not:C34($success))
				
				Use (Storage:C1525.progress)
					
					Storage:C1525.progress.title:="❌ "+Replace string:C233(Get localized string:C991("methodFailed"); "{methodName}"; String:C10($pref.methods.after))
					
				End use 
				
				_o_BARBER("barber.error")
				
				return 
				
			End if 
		End if 
		
		// MARK:-Notarization
		If (Is macOS:C1572 && Bool:C1537($pref.options.notarize))
			
			Use (Storage:C1525.progress)
				
				Storage:C1525.progress.indicator:=Barber shop:K42:35
				Storage:C1525.progress.value:=$c.length*(Num:C11($builComponent)+Num:C11($buildCompiled)+Num:C11($buildStandalone)+Num:C11($buildServer))
				Storage:C1525.progress.title:="🍏 Notarization process"
				
			End use 
			
			//$build.removeSignature()
			
			var $codesign : cs:C1710.codesign
			$codesign:=cs:C1710.codesign.new(New object:C1471(\
				"appleID"; $build.appleID; \
				"certificate"; $build.certificate; \
				"publicID"; $build.publicID))
			
			If ($codesign.sign($build.lib4d))
				
				$hdutil:=cs:C1710.hdutil.new($build.buildTarget.parent.file($build.buildTarget.name+".dmg"))
				
				If ($hdutil.create($build.lib4d))
					
					If ($build.notarize($hdutil.target))
						
						If ($build.staple($hdutil.target))
							
							$t:=$build.ckeckWithGatekeeper()
							
							If ($build.success)
								
								If ($hdutil.attach())
									
									$file:=$hdutil.disk.file($build.lib4d.fullName).copyTo($build.lib4d.parent; fk overwrite:K87:5)
									
									If ($file.exists)
										
										DISPLAY NOTIFICATION:C910($database.structure.name; "Successfully notarized for : "+$t)
										
										If ($hdutil.detach())
											
											$hdutil.target.delete()
											
										End if 
									End if 
								End if 
							End if 
						End if 
					End if 
				End if 
			End if 
			
			If (Not:C34($build.success))
				
				ALERT:C41($build.lastError || $hdutil.lastError)
				
			End if 
		End if 
		
		_o_BARBER("barber.close")
		
		// MARK:-Reveal he target
		If (Length:C16(String:C10($pref.reveal.path))>0)
			
			Case of 
					
					//………………………………………………………………
				: ($builComponent)
					
					SHOW ON DISK:C922($pathComponent)
					
					//………………………………………………………………
				: ($buildCompiled)
					
					SHOW ON DISK:C922($Dir_compiled)
					
					//………………………………………………………………
				: ($buildStandalone)
					
					SHOW ON DISK:C922($pathStandalone)
					
					//………………………………………………………………
				: ($buildServer)
					
					SHOW ON DISK:C922($pathServer)
					
					//………………………………………………………………
			End case 
		End if 
		
		// MARK:-Close the dialog
		If (Bool:C1537($pref.options.close))
			
			CANCEL:C270
			
		End if 
		
		// MARK:-Launch target
		Case of 
				
				//…………………………………………………………………………………
			: (Not:C34(Bool:C1537($pref.options.launch)))\
				 | ($builComponent)
				
				// NOTHING MORE TO DO
				
				//…………………………………………………………………………………
			: ($buildCompiled)
				
				EXECUTE FORMULA:C63(Command name:C538(1321)+"($Dir_compiled)")
				
				//…………………………………………………………………………………
			: ($buildStandalone)
				
				SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_BLOCKING_EXTERNAL_PROCESS"; "false")
				LAUNCH EXTERNAL PROCESS:C811(Choose:C955(Is Windows:C1573; $pathStandalone; "open '"+Convert path system to POSIX:C1106($pathStandalone)+"'"))
				
				//…………………………………………………………………………………
			: ($buildServer)
				
				SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_BLOCKING_EXTERNAL_PROCESS"; "false")
				LAUNCH EXTERNAL PROCESS:C811(Choose:C955(Is Windows:C1573; $pathServer; "open '"+Convert path system to POSIX:C1106($pathServer)+"'"))
				
				//…………………………………………………………………………………
		End case 
		
		// MARK:-Notification
		DISPLAY NOTIFICATION:C910($database.structure.name; Get localized string:C991("theBuildIsAchieved"))
		
		If ($batch)
			
			QUIT 4D:C291
			
		End if 
		
		APP_MAKER_HANDLER("_deinit")
		
		//================================================================================
	: ($action="_declarations")
		
		COMPILER_o_
		
		//================================================================================
	: ($action="_init")
		
		_o_appMaker_INIT
		
		//================================================================================
	: ($action="_deinit")
		
		$success:=PHP Execute:C1058(""; "quit_4d_php")
		
		//================================================================================
	Else 
		
		TRACE:C157
		
		//================================================================================
End case 