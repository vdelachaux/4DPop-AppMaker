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

var $Dir_compiled; $Dom_element; $node; $pathComponent; $pathname; $pathServer : Text
var $pathStandalone; $root; $t; $Txt_archiveFilePath; $Txt_buildApplicationName; $Txt_cmd : Text
var $Txt_fileName; $Txt_filePath; $Txt_relativeCompiledTarget; $Txt_relativeComponentTarget; $Txt_relativeServerTarget; $Txt_relativeStandaloneTarget : Text
var $Txt_structure : Text
var $batch; $Boo_KO; $builComponent; $buildCompiled; $buildServer; $buildStandalone : Boolean
var $run; $success : Boolean
var $Lon_bottom; $Lon_i; $Lon_left; $Lon_right; $Lon_top; $process : Integer
var $start : Integer
var $data; $database; $environment; $ƒ; $o; $Obj_paths : Object
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
		
		$database:=database  // Storage.database
		$environment:=Storage:C1525.environment
		
		$process:=New process:C317("BARBER"; 0; "$"+"BARBER"; "barber.open"; *)
		
		$process:=Current process:C322
		
		$ƒ:=Storage:C1525.preferences
		
		// Host database method to run before generation
		$t:=String:C10($ƒ.get("methods@before").value)
		
		$success:=(Length:C16($t)=0)
		
		If (Not:C34($success))
			
			Use (Storage:C1525.progress)
				
				Storage:C1525.progress.barber:=-2
				Storage:C1525.progress.title:="🛠 "+Replace string:C233(Get localized string:C991("executionOfMethod"); "{methodName}"; $t)
				
			End use 
			
			DELAY PROCESS:C323($process; 50)
			
			EXECUTE METHOD:C1007($t; $success)  // The host database must return true
			
			If (Not:C34($success))
				
				BEEP:C151
				
				Use (Storage:C1525.progress)
					
					Storage:C1525.progress.title:=Replace string:C233(Get localized string:C991("methodFailed"); "{methodName}"; $t)
					
				End use 
				
				DELAY PROCESS:C323($process; 500)
				
			End if 
		End if 
		
		// MARK:Update the Info.plist file
		If ($success)
			
			$c:=$ƒ.get("info.plist").value
			
			If ($c.length>0)
				
				Use (Storage:C1525.progress)
					
					Storage:C1525.progress.barber:=-2
					Storage:C1525.progress.title:="🚧 "+Get localized string:C991("Preparations")+"…"
					
				End use 
				
				// Get the final application
				$node:=DOM Find XML element:C864($environment.domBuildApp; "/Preferences4D/BuildApp/BuildApplicationName")
				
				If (Bool:C1537(OK))
					
					DOM GET XML ELEMENT VALUE:C731($node; $Txt_buildApplicationName)
					
					$o:=$database.root.file("Info.plist")
					
					If ($o.exists)
						
						DOCUMENT:=$o.platformPath
						
					Else 
						
						$root:=DOM Create XML Ref:C861("plist")
						
						If (Bool:C1537(OK))
							
							DOM SET XML ATTRIBUTE:C866($root; \
								"version"; "1.0")
							
							If (Bool:C1537(OK))
								
								$Dom_element:=DOM Append XML child node:C1080($root; XML DOCTYPE:K45:19; "plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\"")
								
								If (Bool:C1537(OK))
									
									$Dom_element:=DOM Create XML element:C865($root; "dict")
									
									If (Bool:C1537(OK))
										
										DOM EXPORT TO FILE:C862($root; $o.platformPath)
										
										If (Bool:C1537(OK))
											
											DOCUMENT:=$o.platformPath
											
										End if 
									End if 
								End if 
							End if 
							
							DOM CLOSE XML:C722($root)
							
						End if 
					End if 
				End if 
				
				If (Bool:C1537(OK))
					
					$t:=DOCUMENT
					_o_AppMaker_SET_infoPlistKey("CFBundleName"; $Txt_buildApplicationName; $t)
					_o_AppMaker_SET_infoPlistKey("CFBundleGetInfoString"; String:C10($ƒ.get("info.plist@CFBundleGetInfoString").value); $t)
					_o_AppMaker_SET_infoPlistKey("CFBundleShortVersionString"; String:C10($ƒ.get("info.plist@CFBundleGetInfoString").value); $t)
					_o_AppMaker_SET_infoPlistKey("CFBundleLongVersionString"; String:C10($ƒ.get("info.plist@CFBundleLongVersionString").value); $t)
					_o_AppMaker_SET_infoPlistKey("NSHumanReadableCopyright"; String:C10($ƒ.get("info.plist@NSHumanReadableCopyright").value); $t)
					
				Else 
					
					ASSERT:C1129(False:C215; "Failed to update info.plist")
					
				End if 
			End if 
		End if 
		
		$build:=cs:C1710.build.new()
		
		// MARK:Launch the application generation process
		If ($build.success)\
			 & ($action#"@noBuild@")
			
			Repeat 
				
				$start:=Milliseconds:C459
				
				Use (Storage:C1525.progress)
					
					Storage:C1525.progress.barber:=-2
					Storage:C1525.progress.title:="⚙️ "+Get localized string:C991("CompilationAndGeneration")
					
				End use 
				
				$success:=$build.run()
				
			Until (wait($start; 2000; $process; 5))
			
		Else 
			
			// TODO:ERROR
			
		End if 
		
		// MARK:Get the useful paths
		If ($success)
			
			$Obj_paths:=New object:C1471
			
			// Get the common part for structure folder and target path
			
			// Keep the variable part of any target if any
			$node:=DOM Find XML element:C864($environment.domBuildApp; "/Preferences4D/BuildApp/BuildComponent")
			
			If (Bool:C1537(OK))
				
				DOM GET XML ELEMENT VALUE:C731($node; $builComponent)
				
				If ($builComponent)
					
					$pathComponent:=_o_APP_MAKER_Get_target_path(800)
					$Txt_relativeComponentTarget:=Replace string:C233($pathComponent; String:C10($Obj_paths.root); ""; 1)
					
				End if 
			End if 
			
			$node:=DOM Find XML element:C864($environment.domBuildApp; "/Preferences4D/BuildApp/BuildCompiled")
			
			If (Bool:C1537(OK))
				
				DOM GET XML ELEMENT VALUE:C731($node; $buildCompiled)
				
				If ($buildCompiled)
					
					$Dir_compiled:=_o_APP_MAKER_Get_target_path(810)+Folder separator:K24:12
					$Txt_relativeCompiledTarget:=Replace string:C233($Dir_compiled; String:C10($Obj_paths.root); ""; 1)
					
				End if 
			End if 
			
			$node:=DOM Find XML element:C864($environment.domBuildApp; "/Preferences4D/BuildApp/BuildApplicationSerialized")
			
			If (Bool:C1537(OK))
				
				DOM GET XML ELEMENT VALUE:C731($node; $buildStandalone)
				
				If ($buildStandalone)
					
					$pathStandalone:=_o_APP_MAKER_Get_target_path(820)+Folder separator:K24:12
					$Txt_relativeStandaloneTarget:=Replace string:C233($pathStandalone; String:C10($Obj_paths.root); ""; 1)
					
				End if 
			End if 
			
			$node:=DOM Find XML element:C864($environment.domBuildApp; "/Preferences4D/BuildApp/CS/BuildServerApplication")
			
			If (Bool:C1537(OK))
				
				DOM GET XML ELEMENT VALUE:C731($node; $buildServer)
				
				If ($buildServer)
					
					$pathServer:=_o_APP_MAKER_Get_target_path(830)+Folder separator:K24:12
					$Txt_relativeServerTarget:=Replace string:C233($pathServer; String:C10($Obj_paths.root); ""; 1)
					
				End if 
			End if 
			
		Else 
			
			// Opens the compiler window, if not, or bring it to front.
			If ($Lon_i#MAXLONG:K35:2)
				
				POST KEY:C465(Character code:C91("*"); 0 ?+ Command key bit:K16:2)
				
			Else 
				
				ARRAY LONGINT:C221($tWin_hdl; 0x0000)
				WINDOW LIST:C442($tWin_hdl)
				
				For ($Lon_i; 1; Size of array:C274($tWin_hdl); 1)
					
					If (Get window title:C450($tWin_hdl{$Lon_i})=Get localized string:C991("Window_compiler"))
						
						GET WINDOW RECT:C443($Lon_left; $Lon_top; $Lon_right; $Lon_bottom; $tWin_hdl{$Lon_i})
						SET WINDOW RECT:C444($Lon_left; $Lon_top; $Lon_right; $Lon_bottom; $tWin_hdl{$Lon_i})
						$Lon_i:=MAXLONG:K35:2-1
						
					End if 
				End for 
				
				GET WINDOW RECT:C443($Lon_left; $Lon_top; $Lon_right; $Lon_bottom; $tWin_hdl{0})
				SET WINDOW RECT:C444($Lon_left; $Lon_top; $Lon_right; $Lon_bottom; $tWin_hdl{0})
				
			End if 
		End if 
		
		// Options
		If ($success)
			
			// MARK:Increments the bundleVersion key
			XML DECODE:C1091(String:C10($ƒ.get("options@increment_version").value); $run)
			
			If ($run)
				
				Use (Storage:C1525.progress)
					
					Storage:C1525.progress.barber:=-2
					Storage:C1525.progress.title:="🚧 "+Get localized string:C991("Preparation")
					
				End use 
				
				$o:=$database.root.file("Info.plist")
				
				If ($o.exists)
					
					// Update the 'Info.plist' file
					$t:=application.branch
					$o:=pList($o.platformPath)
					$o.set(New object:C1471("key"; "CFBundleGetInfoString"; "value"; $Txt_buildApplicationName))\
						.set(New object:C1471("key"; "CFBundleShortVersionString"; "value"; $t))\
						.set(New object:C1471("key"; "CFBundleLongVersionString"; "value"; $t))\
						.set(New object:C1471("key"; "CFBundleVersion"; "value"; Num:C11($o.get("CFBundleVersion").value)+1))\
						.save()
					
					// Create the 'InfoPlist.strings' file
					$t:=File:C1566("/RESOURCES/InfoPlist.template").getText()
					$t:=Replace string:C233($t; "{name}"; $Txt_buildApplicationName)
					$t:=Replace string:C233($t; "{version}"; String:C10($o.get("CFBundleShortVersionString").value))
					$t:=Replace string:C233($t; "{build}"; String:C10($o.get("CFBundleVersion").value))
					$t:=Replace string:C233($t; "{copyright}"; String:C10($o.get("NSHumanReadableCopyright").value))
					
					Folder:C1567(fk resources folder:K87:11; *).file("InfoPlist.strings").setText($t; "UTF-16")
					
					// Delete the (older) unused localized files, if any
					For each ($o; Folder:C1567(fk resources folder:K87:11; *).folders().query("extension='.lproj'"))
						
						$o.file("InfoPlist.strings").delete()
						
					End for each 
					
				Else 
					
					// <NOTHING MORE TO DO>
					
				End if 
			End if 
			
			If ($database.isDatabase)
				
				XML DECODE:C1091(String:C10($ƒ.get("options@exportStructure").value); $run)
				
				If ($run)
					
					Repeat 
						
						$start:=Milliseconds:C459
						
						Use (Storage:C1525.progress)
							
							Storage:C1525.progress.barber:=-2
							Storage:C1525.progress.title:="🚚 "+Get localized string:C991("exportProject")
							
						End use 
						
						EXPORT_PROJECT
						
					Until (wait($start; 2000; $process; 5))
				End if 
				
				// MARK:Zip sources
				XML DECODE:C1091(String:C10($ƒ.get("options@zip_source").value); $run)
				
				If ($run)
					
					// TODO: Use 4D.zip
					
					Repeat 
						
						$start:=Milliseconds:C459
						
						Use (Storage:C1525.progress)
							
							Storage:C1525.progress.barber:=-2
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
							
							$Boo_KO:=PHP_zip_archive_to($Txt_structure; $Txt_archiveFilePath+Replace string:C233($Txt_fileName; ".4db"; ".zip"))
							
						End if 
					Until (wait($start; 2000; $process; 5))
				End if 
			End if 
			
			// MARK:Delete Mac content
			XML DECODE:C1091(String:C10($ƒ.get("options@delete_mac_content").value); $run)
			
			If ($run && Is macOS:C1572)
				
				Repeat 
					
					$start:=Milliseconds:C459
					
					Use (Storage:C1525.progress)
						
						Storage:C1525.progress.barber:=-2
						Storage:C1525.progress.title:="🧽 "+Get localized string:C991("deleteMacOsSpecificFiles")
						
					End use 
					
					DELAY PROCESS:C323($process; 50)
					
					If ($builComponent)
						
					End if 
					
					If ($buildCompiled)
						
					End if 
					
					If ($buildStandalone)
						
					End if 
					
					If ($buildServer)
						
					End if 
				Until (wait($start; 5000; $process; 5))
			End if 
			
			// MARK:Delete help files and the non necessary resources for the final user
			XML DECODE:C1091(String:C10($ƒ.get("options@removeDevResources").value); $run)
			
			If ($run)\
				 && ($buildCompiled || $buildStandalone || $buildServer)
				
				$start:=Milliseconds:C459
				
				Use (Storage:C1525.progress)
					
					Storage:C1525.progress.barber:=-2
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
						
						buildApp_DELETE_RESOURCES($Dir_compiled; ->$tTxt_path)
						
					End if 
					
					// Remove from final application if any
					If ($buildStandalone)
						
						buildApp_DELETE_RESOURCES($pathStandalone+Choose:C955(Is macOS:C1572; "Contents"+Folder separator:K24:12; ""); ->$tTxt_path)
						
					End if 
					
					// Remove from server application if any
					If ($buildServer)
						
						buildApp_DELETE_RESOURCES($pathServer+Choose:C955(Is macOS:C1572; "Contents"+Folder separator:K24:12; ""); ->$tTxt_path)
						
					End if 
				End if 
			End if 
		End if 
		
		// MARK:Copy
		If ($success)
			
			$c:=$ƒ.get("copy").value
			
			If ($c.length>0)
				
				Use (Storage:C1525.progress)
					
					Storage:C1525.progress.barber:=0
					Storage:C1525.progress.max:=$c.length*(Num:C11($builComponent)+Num:C11($buildCompiled)+Num:C11($buildStandalone)+Num:C11($buildServer))
					Storage:C1525.progress.title:="⚙️ "+Get localized string:C991("preparationOfCopy")
					
				End use 
				
				DELAY PROCESS:C323($process; 50)
				
				If ($builComponent)
					
					COPY(String:C10($Obj_paths.root)+$Txt_relativeComponentTarget; $c)
					
				End if 
				
				If ($buildCompiled)
					
					COPY(String:C10($Obj_paths.root)+$Txt_relativeCompiledTarget; $c)
					
				End if 
				
				If ($buildStandalone)
					
					COPY(String:C10($Obj_paths.root)+$Txt_relativeStandaloneTarget+Choose:C955(Is macOS:C1572; "Contents"+Folder separator:K24:12; "")+"Database"+Folder separator:K24:12; $c)
					
				End if 
				
				If ($buildServer)
					
					COPY(String:C10($Obj_paths.root)+$Txt_relativeServerTarget+Choose:C955(Is macOS:C1572; "Contents"+Folder separator:K24:12; "")+"Server Database"+Folder separator:K24:12; $c)
					
				End if 
			End if 
		End if 
		
		// MARK:Deletion
		If ($success)
			
			$c:=$ƒ.get("delete").value
			
			If ($c.length>0)
				
				Use (Storage:C1525.progress)
					
					Storage:C1525.progress.barber:=0
					Storage:C1525.progress.max:=$c.length*(Num:C11($builComponent)+Num:C11($buildCompiled)+Num:C11($buildStandalone)+Num:C11($buildServer))
					Storage:C1525.progress.title:="🚧 "+Get localized string:C991("preparingForRemoval")
					
				End use 
				
				DELAY PROCESS:C323($process; 50)
				
				If ($builComponent)
					
					DELETE(String:C10($Obj_paths.root); $c; $Txt_relativeComponentTarget)
					
				End if 
				
				If ($buildCompiled)
					
					DELETE(String:C10($Obj_paths.root); $c; $Txt_relativeCompiledTarget)
					
				End if 
				
				If ($buildStandalone)
					
					DELETE(String:C10($Obj_paths.root); $c; $Txt_relativeStandaloneTarget+Choose:C955(Is macOS:C1572; "Contents"+Folder separator:K24:12; "")+"Database"+Folder separator:K24:12)
					
				End if 
				
				If ($buildServer)
					
					DELETE(String:C10($Obj_paths.root); $c; $Txt_relativeServerTarget+Choose:C955(Is macOS:C1572; "Contents"+Folder separator:K24:12; "")+"Server Database"+Folder separator:K24:12)
					
				End if 
			End if 
		End if 
		
		// MARK:Make the package and its content readable/executable and writable by everyone
		// TODO: Use $build.unlockDirectory()
		If ($success)
			
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
		End if 
		
		// MARK:Host database method to run at the end
		If ($success)
			
			$t:=String:C10($ƒ.get("methods@after").value)
			
			If (Length:C16($t)>0)
				
				EXECUTE METHOD:C1007($t)
				
			End if 
		End if 
		
		If ($success)
			
			// MARK:Notarization
			XML DECODE:C1091(String:C10($ƒ.get("options@notarize").value); $run)
			
			If ($run && Is macOS:C1572)
				
				Use (Storage:C1525.progress)
					
					Storage:C1525.progress.barber:=-2
					Storage:C1525.progress.max:=$c.length*(Num:C11($builComponent)+Num:C11($buildCompiled)+Num:C11($buildStandalone)+Num:C11($buildServer))
					Storage:C1525.progress.title:="🍏 Notarization process"
					
				End use 
				
				If ($build.removeSignature())
					
					If ($build.sign())
						
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
				End if 
				
				If (Not:C34($build.success))
					
					ALERT:C41($build.lastError || $hdutil.lastError)
					
				End if 
			End if 
		End if 
		
		BARBER("barber.close")
		
		// P4 tool
		//If ($success)
		//If ($database.componentAvailable("p4"))  // Need p4
		//EXECUTE METHOD("perforce_AFTER_BUILD"; $success)
		// End if
		// End if
		
		If ($success)
			
			XML DECODE:C1091(String:C10($ƒ.get("reveal@path").value); $run)
			
			// MARK:Reveal he target
			If (Not:C34($run) | $builComponent)
				
				$t:=String:C10($ƒ.get("reveal@path").value)
				
				If ($success)\
					 & (Length:C16($t)>0)
					
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
			End if 
		End if 
		
		// MARK:Close the dialog
		XML DECODE:C1091(String:C10($ƒ.get("options@close").value); $run)
		
		If ($success & $run)
			
			CANCEL:C270
			
		End if 
		
		// MARK:Launch target
		If ($success)
			
			XML DECODE:C1091(String:C10($ƒ.get("options@launch").value); $run)
			
			Case of 
					
					//…………………………………………………………………………………
				: (Not:C34($run))\
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
		End if 
		
		// MARK:Notification
		If ($success)
			
			DISPLAY NOTIFICATION:C910($database.structure.name; Get localized string:C991("theBuildIsAchieved"))
			
		End if 
		
		If ($success & $batch)
			
			QUIT 4D:C291
			
		End if 
		
		APP_MAKER_HANDLER("_deinit")
		
		//================================================================================
	: ($action="_declarations")
		
		Compiler_component
		
		//================================================================================
	: ($action="_init")
		
		appMaker_INIT
		
		//================================================================================
	: ($action="_deinit")
		
		$success:=PHP Execute:C1058(""; "quit_4d_php")
		
		//================================================================================
	Else 
		
		TRACE:C157
		
		//================================================================================
End case 