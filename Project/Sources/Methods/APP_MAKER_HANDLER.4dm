//%attributes = {}
// ----------------------------------------------------
// Method :  APP_MAKER_HANDLER
// Created 30/05/08 by Vincent de Lachaux
// ----------------------------------------------------
// Description
// Build application and more...
// ----------------------------------------------------
// Declarations
C_TEXT:C284($1)

C_BOOLEAN:C305($Boo_auto; $Boo_compiled; $Boo_component; $Boo_execute; $Boo_KO; $Boo_OK)
C_BOOLEAN:C305($Boo_server; $Boo_standalone)
C_LONGINT:C283($Lon_bottom; $Lon_i; $Lon_left; $Lon_parameters; $Lon_process; $Lon_right)
C_LONGINT:C283($Lon_Start; $Lon_top; $Win_hdl)
C_TEXT:C284($Dir_compiled; $Dir_component; $Dir_server; $Dir_standalone; $Dom_element; $Dom_node)
C_TEXT:C284($Dom_root; $kTxt_currentMethod; $t; $Txt_archiveFilePath; $Txt_buildApplicationName; $Txt_cmd)
C_TEXT:C284($Txt_entryPoint; $Txt_fileName; $Txt_filePath; $Txt_path; $Txt_relativeCompiledTarget; $Txt_relativeComponentTarget)
C_TEXT:C284($Txt_relativeServerTarget; $Txt_relativeStandaloneTarget; $Txt_structure)
C_OBJECT:C1216($ƒ; $o; $Obj_database; $Obj_environment; $Obj_paths)
C_COLLECTION:C1488($c)

If (False:C215)
	C_TEXT:C284(APP_MAKER_HANDLER; $1)
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If ($Lon_parameters>=1)
	
	$Txt_entryPoint:=$1
	
End if 

$kTxt_currentMethod:=Current method name:C684

// ----------------------------------------------------
Case of 
		
		//================================================================================
	: (Length:C16($Txt_entryPoint)=0)  // No parameter
		
		Case of 
				
				//……………………………………………………………………
			: (Method called on error:C704=$kTxt_currentMethod)
				
				// Error managemnt routine
				
				//……………………………………………………………………
			Else 
				
				// This method must be executed in a new process
				BRING TO FRONT:C326(New process:C317($kTxt_currentMethod; 0; "$"+$kTxt_currentMethod; "_open"; *))
				
				//……………………………………………………………………
		End case 
		
		//================================================================================
	: ($Txt_entryPoint="_open")  // Display the main dialog
		
		APP_MAKER_HANDLER("_declarations")
		APP_MAKER_HANDLER("_init")
		
		$Win_hdl:=Open form window:C675("Editor"; Plain form window:K39:10; Horizontally centered:K39:1; Vertically centered:K39:4; *)
		DIALOG:C40("Editor")
		CLOSE WINDOW:C154
		
		Storage:C1525.preferences.save()
		
		APP_MAKER_HANDLER("_deinit")
		
		//================================================================================
	: ($Txt_entryPoint="_run@")\
		 | ($Txt_entryPoint="_autoBuild")  // Build the application
		
		ARRAY TEXT:C222($tTxt_path; 0x0000)
		
		$Boo_auto:=($Txt_entryPoint="_autoBuild")
		
		// First launch of this method executed in a new process
		APP_MAKER_HANDLER("_declarations")
		APP_MAKER_HANDLER("_init")
		
		FLUSH CACHE:C297
		
		$Obj_database:=database  //Storage.database
		$Obj_environment:=Storage:C1525.environment
		
		$Lon_process:=New process:C317("BARBER"; 0; "$"+"BARBER"; "barber.open"; *)
		
		$Lon_process:=Current process:C322
		
		$ƒ:=Storage:C1525.preferences
		
		// Host database method to run before generation
		$t:=String:C10($ƒ.get("methods@before").value)
		
		$Boo_OK:=(Length:C16($t)=0)
		
		If (Not:C34($Boo_OK))
			
			Use (Storage:C1525.progress)
				
				Storage:C1525.progress.barber:=-2
				Storage:C1525.progress.title:=Replace string:C233(Get localized string:C991("executionOfMethod"); "{methodName}"; $t)
				
			End use 
			
			DELAY PROCESS:C323($Lon_process; 50)
			
			EXECUTE METHOD:C1007($t; $Boo_OK)  // The host database must return true
			
			If (Not:C34($Boo_OK))
				
				BEEP:C151
				
				Use (Storage:C1525.progress)
					
					Storage:C1525.progress.title:=Replace string:C233(Get localized string:C991("methodFailed"); "{methodName}"; $t)
					
				End use 
				
				DELAY PROCESS:C323($Lon_process; 500)
				
			End if 
		End if 
		
		// Update the Info.plist file
		If ($Boo_OK)
			
			$c:=$ƒ.get("info.plist").value
			
			If ($c.length>0)
				
				Use (Storage:C1525.progress)
					
					Storage:C1525.progress.barber:=-2
					Storage:C1525.progress.title:=Get localized string:C991("Preparations")+"…"
					
				End use 
				
				// Get the final application
				$Dom_node:=DOM Find XML element:C864($Obj_environment.domBuildApp; "/Preferences4D/BuildApp/BuildApplicationName")
				
				If (Bool:C1537(OK))
					
					DOM GET XML ELEMENT VALUE:C731($Dom_node; $Txt_buildApplicationName)
					
					$o:=$Obj_database.root.file("Info.plist")
					
					If ($o.exists)
						
						DOCUMENT:=$o.platformPath
						
					Else 
						
						$Dom_root:=DOM Create XML Ref:C861("plist")
						
						If (Bool:C1537(OK))
							
							DOM SET XML ATTRIBUTE:C866($Dom_root; \
								"version"; "1.0")
							
							If (Bool:C1537(OK))
								
								$Dom_element:=DOM Append XML child node:C1080($Dom_root; XML DOCTYPE:K45:19; "plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\"")
								
								If (Bool:C1537(OK))
									
									$Dom_element:=DOM Create XML element:C865($Dom_root; "dict")
									
									If (Bool:C1537(OK))
										
										DOM EXPORT TO FILE:C862($Dom_root; $o.platformPath)
										
										If (Bool:C1537(OK))
											
											DOCUMENT:=$o.platformPath
											
										End if 
									End if 
								End if 
							End if 
							
							DOM CLOSE XML:C722($Dom_root)
							
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
		
		// Launch the application generation process
		If ($Boo_OK)\
			 & ($Txt_entryPoint#"@noBuild@")
			
			Repeat 
				
				$Lon_Start:=Milliseconds:C459
				
				Use (Storage:C1525.progress)
					
					Storage:C1525.progress.barber:=-2
					Storage:C1525.progress.title:=Get localized string:C991("CompilationAndGeneration")
					
				End use 
				
				$o:=File:C1566($Obj_environment.buildApp; fk platform path:K87:2)
				
				If ($o.exists)
					
					If (Is Windows:C1573)  // Turn around  ACI0071484
						
						DELETE_MAC_CONTENT($Obj_environment.databaseFolder)
						
					End if 
					
					MESSAGES OFF:C175
					$t:=Storage:C1525.environment.buildApp
					BUILD APPLICATION:C871($t)
					$Boo_OK:=Bool:C1537(OK)
					
					MESSAGES ON:C181
					
				Else 
					
					$Boo_OK:=False:C215
					
				End if 
			Until (wait($Lon_Start; 2000; $Lon_process; 5))
		End if 
		
		// Get the useful paths
		If ($Boo_OK)
			
			$Obj_paths:=New object:C1471
			
			// Get the common part for structure folder and target path
			$Obj_paths.root:=doc_getCommonPath($Obj_environment.databaseFolder; _o_APP_MAKER_Get_target_path(8))
			
			// Keep the variable part of any target if any
			$Dom_node:=DOM Find XML element:C864($Obj_environment.domBuildApp; "/Preferences4D/BuildApp/BuildComponent")
			
			If (Bool:C1537(OK))
				
				DOM GET XML ELEMENT VALUE:C731($Dom_node; $Boo_component)
				
				If ($Boo_component)
					
					$Dir_component:=_o_APP_MAKER_Get_target_path(800)
					$Txt_relativeComponentTarget:=Replace string:C233($Dir_component; String:C10($Obj_paths.root); ""; 1)
					
				End if 
			End if 
			
			$Dom_node:=DOM Find XML element:C864($Obj_environment.domBuildApp; "/Preferences4D/BuildApp/BuildCompiled")
			
			If (Bool:C1537(OK))
				
				DOM GET XML ELEMENT VALUE:C731($Dom_node; $Boo_compiled)
				
				If ($Boo_compiled)
					
					$Dir_compiled:=_o_APP_MAKER_Get_target_path(810)+Folder separator:K24:12
					$Txt_relativeCompiledTarget:=Replace string:C233($Dir_compiled; String:C10($Obj_paths.root); ""; 1)
					
				End if 
			End if 
			
			$Dom_node:=DOM Find XML element:C864($Obj_environment.domBuildApp; "/Preferences4D/BuildApp/BuildApplicationSerialized")
			
			If (Bool:C1537(OK))
				
				DOM GET XML ELEMENT VALUE:C731($Dom_node; $Boo_standalone)
				
				If ($Boo_standalone)
					
					$Dir_standalone:=_o_APP_MAKER_Get_target_path(820)+Folder separator:K24:12
					$Txt_relativeStandaloneTarget:=Replace string:C233($Dir_standalone; String:C10($Obj_paths.root); ""; 1)
					
				End if 
			End if 
			
			$Dom_node:=DOM Find XML element:C864($Obj_environment.domBuildApp; "/Preferences4D/BuildApp/CS/BuildServerApplication")
			
			If (Bool:C1537(OK))
				
				DOM GET XML ELEMENT VALUE:C731($Dom_node; $Boo_server)
				
				If ($Boo_server)
					
					$Dir_server:=_o_APP_MAKER_Get_target_path(830)+Folder separator:K24:12
					$Txt_relativeServerTarget:=Replace string:C233($Dir_server; String:C10($Obj_paths.root); ""; 1)
					
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
		If ($Boo_OK)
			
			// Increments the bundleVersion key
			XML DECODE:C1091(String:C10($ƒ.get("options@increment_version").value); $Boo_execute)
			
			If ($Boo_execute)
				
				Use (Storage:C1525.progress)
					
					Storage:C1525.progress.barber:=-2
					Storage:C1525.progress.title:=Get localized string:C991("Preparation")
					
				End use 
				
				$o:=$Obj_database.root.file("Info.plist")
				
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
			
			If ($Obj_database.isDatabase)
				
				XML DECODE:C1091(String:C10($ƒ.get("options@exportStructure").value); $Boo_execute)
				
				If ($Boo_execute)
					
					Repeat 
						
						$Lon_Start:=Milliseconds:C459
						
						Use (Storage:C1525.progress)
							
							Storage:C1525.progress.barber:=-2
							Storage:C1525.progress.title:=Get localized string:C991("exportProject")
							
						End use 
						
						EXPORT_PROJECT
						
					Until (wait($Lon_Start; 2000; $Lon_process; 5))
				End if 
				
				// Zip sources
				XML DECODE:C1091(String:C10($ƒ.get("options@zip_source").value); $Boo_execute)
				
				If ($Boo_execute)
					
					Repeat 
						
						$Lon_Start:=Milliseconds:C459
						
						Use (Storage:C1525.progress)
							
							Storage:C1525.progress.barber:=-2
							Storage:C1525.progress.title:=Get localized string:C991("compression")
							
						End use 
						
						// Structure file path
						$Txt_structure:=Structure file:C489(*)
						$Txt_filePath:=Convert path system to POSIX:C1106($Txt_structure)
						$Txt_fileName:=Replace string:C233($Txt_structure; $Obj_environment.databaseFolder; "")
						
						// Archive file path
						$Txt_archiveFilePath:=$Obj_environment.databaseFolder+"SOURCES"+Folder separator:K24:12
						CREATE FOLDER:C475($Txt_archiveFilePath; *)
						
						If (Test path name:C476($Txt_archiveFilePath)=Is a folder:K24:2)
							
							$Boo_KO:=PHP_zip_archive_to($Txt_structure; $Txt_archiveFilePath+Replace string:C233($Txt_fileName; ".4db"; ".zip"))
							
						End if 
					Until (wait($Lon_Start; 2000; $Lon_process; 5))
				End if 
			End if 
			
			// Delete Mac content
			If (Is macOS:C1572)
				
				XML DECODE:C1091(String:C10($ƒ.get("options@delete_mac_content").value); $Boo_execute)
				
				If ($Boo_execute)
					
					Repeat 
						
						$Lon_Start:=Milliseconds:C459
						
						Use (Storage:C1525.progress)
							
							Storage:C1525.progress.barber:=-2
							Storage:C1525.progress.title:=Get localized string:C991("deleteMacOsSpecificFiles")
							
						End use 
						
						DELAY PROCESS:C323($Lon_process; 50)
						
						If ($Boo_component)
							
							DELETE_MAC_CONTENT($Dir_component)
							
						End if 
						
						If ($Boo_compiled)
							
							DELETE_MAC_CONTENT($Dir_compiled)
							
						End if 
						
						If ($Boo_standalone)
							
							DELETE_MAC_CONTENT($Dir_standalone)
							
						End if 
						
						If ($Boo_server)
							
							DELETE_MAC_CONTENT($Dir_server)
							
						End if 
					Until (wait($Lon_Start; 5000; $Lon_process; 5))
				End if 
			End if 
			
			// Delete help files and the non necessary resources for the final user
			XML DECODE:C1091(String:C10($ƒ.get("options@removeDevResources").value); $Boo_execute)
			
			If ($Boo_execute)\
				 & ($Boo_compiled | $Boo_standalone | $Boo_server)
				
				$Lon_Start:=Milliseconds:C459
				
				Use (Storage:C1525.progress)
					
					Storage:C1525.progress.barber:=-2
					Storage:C1525.progress.title:=".Deleting unnecessary resources"
					
				End use 
				
				// Relative paths are listed in the file AppMaker delete.xml in the Preferences folder of the host database…
				$Txt_path:=Replace string:C233(Get 4D folder:C485(Current resources folder:K5:16; *); "Resources"; "Preferences")+"AppMaker delete.xml"
				
				If (Test path name:C476($Txt_path)#Is a document:K24:1)
					
					// Use the default set
					$Txt_path:=Get 4D folder:C485(Current resources folder:K5:16)+"AppMaker delete.xml"
					
				End if 
				
				If (Test path name:C476($Txt_path)=Is a document:K24:1)
					
					// Load the list of items to delete
					$Dom_root:=DOM Parse XML source:C719($Txt_path)
					
					If (OK=1)
						
						ARRAY TEXT:C222($tDom_items; 0x0000)
						$tDom_items{0}:=DOM Find XML element:C864($Dom_root; "items/item"; $tDom_items)
						
						For ($Lon_i; 1; Size of array:C274($tDom_items); 1)
							
							DOM GET XML ELEMENT VALUE:C731($tDom_items{$Lon_i}; $t)
							APPEND TO ARRAY:C911($tTxt_path; Replace string:C233($t; "/"; Folder separator:K24:12))
							
						End for 
						
						DOM CLOSE XML:C722($Dom_root)
						
					End if 
					
					// Remove from compiled package if any
					If ($Boo_compiled)
						
						buildApp_DELETE_RESOURCES($Dir_compiled; ->$tTxt_path)
						
					End if 
					
					// Remove from final application if any
					If ($Boo_standalone)
						
						buildApp_DELETE_RESOURCES($Dir_standalone+Choose:C955(Is macOS:C1572; "Contents"+Folder separator:K24:12; ""); ->$tTxt_path)
						
					End if 
					
					// Remove from server application if any
					If ($Boo_server)
						
						buildApp_DELETE_RESOURCES($Dir_server+Choose:C955(Is macOS:C1572; "Contents"+Folder separator:K24:12; ""); ->$tTxt_path)
						
					End if 
				End if 
			End if 
		End if 
		
		// Copy
		If ($Boo_OK)
			
			$c:=$ƒ.get("copy").value
			
			If ($c.length>0)
				
				Use (Storage:C1525.progress)
					
					Storage:C1525.progress.barber:=-2
					Storage:C1525.progress.barber:=0
					Storage:C1525.progress.max:=$c.length*(Num:C11($Boo_component)+Num:C11($Boo_compiled)+Num:C11($Boo_standalone)+Num:C11($Boo_server))
					Storage:C1525.progress.title:=Get localized string:C991("preparationOfCopy")
					
				End use 
				
				DELAY PROCESS:C323($Lon_process; 50)
				
				If ($Boo_component)
					
					COPY(String:C10($Obj_paths.root)+$Txt_relativeComponentTarget; $c)
					
				End if 
				
				If ($Boo_compiled)
					
					COPY(String:C10($Obj_paths.root)+$Txt_relativeCompiledTarget; $c)
					
				End if 
				
				If ($Boo_standalone)
					
					COPY(String:C10($Obj_paths.root)+$Txt_relativeStandaloneTarget+Choose:C955(Is macOS:C1572; "Contents"+Folder separator:K24:12; "")+"Database"+Folder separator:K24:12; $c)
					
				End if 
				
				If ($Boo_server)
					
					COPY(String:C10($Obj_paths.root)+$Txt_relativeServerTarget+Choose:C955(Is macOS:C1572; "Contents"+Folder separator:K24:12; "")+"Server Database"+Folder separator:K24:12; $c)
					
				End if 
			End if 
		End if 
		
		// Deletion
		If ($Boo_OK)
			
			$c:=$ƒ.get("delete").value
			
			If ($c.length>0)
				
				Use (Storage:C1525.progress)
					
					Storage:C1525.progress.barber:=-2
					Storage:C1525.progress.barber:=0
					Storage:C1525.progress.max:=$c.length*(Num:C11($Boo_component)+Num:C11($Boo_compiled)+Num:C11($Boo_standalone)+Num:C11($Boo_server))
					Storage:C1525.progress.title:=Get localized string:C991("preparingForRemoval")
					
				End use 
				
				DELAY PROCESS:C323($Lon_process; 50)
				
				If ($Boo_component)
					
					DELETE(String:C10($Obj_paths.root); $c; $Txt_relativeComponentTarget)
					
				End if 
				
				If ($Boo_compiled)
					
					DELETE(String:C10($Obj_paths.root); $c; $Txt_relativeCompiledTarget)
					
				End if 
				
				If ($Boo_standalone)
					
					DELETE(String:C10($Obj_paths.root); $c; $Txt_relativeStandaloneTarget+Choose:C955(Is macOS:C1572; "Contents"+Folder separator:K24:12; "")+"Database"+Folder separator:K24:12)
					
				End if 
				
				If ($Boo_server)
					
					DELETE(String:C10($Obj_paths.root); $c; $Txt_relativeServerTarget+Choose:C955(Is macOS:C1572; "Contents"+Folder separator:K24:12; "")+"Server Database"+Folder separator:K24:12)
					
				End if 
			End if 
		End if 
		
		// Make the package and its content readable/executable and writable by everyone
		If ($Boo_OK)
			
			SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_HIDE_CONSOLE"; "true")
			SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_CURRENT_DIRECTORY"; String:C10($Obj_paths.root))
			
			If (Is Windows:C1573)
				
				$Txt_cmd:="attrib.exe -R /S /D"
				LAUNCH EXTERNAL PROCESS:C811($Txt_cmd)
				
			Else 
				
				// -R Change the modes of the file hierarchies rooted in the files instead of just the files themselves.
				//755 Make the package and its content readable/executable and writable by everyone
				$Txt_cmd:="chmod -R 777 "+Replace string:C233(Convert path system to POSIX:C1106(String:C10($Obj_paths.root)); " "; "\\ ")
				LAUNCH EXTERNAL PROCESS:C811($Txt_cmd)
				
			End if 
		End if 
		
		If ($Txt_entryPoint="_autoBuild")
			
			//#MARK_TODO
			
		End if 
		
		BARBER("barber.close")
		
		// Host database method to run at the end
		If ($Boo_OK)
			
			$t:=String:C10($ƒ.get("methods@after").value)
			
			If (Length:C16($t)>0)
				
				EXECUTE METHOD:C1007($t)
				
			End if 
		End if 
		
		// p4 tool
		If ($Boo_OK)
			
			If ($Obj_database.componentAvailable("p4"))  // Need p4
				
				EXECUTE METHOD:C1007("perforce_AFTER_BUILD"; $Boo_OK)
				
			End if 
		End if 
		
		// Reveal he target
		If ($Boo_OK)
			
			XML DECODE:C1091(String:C10($ƒ.get("reveal@path").value); $Boo_execute)
			
			If (Not:C34($Boo_execute) | $Boo_component)
				
				$t:=String:C10($ƒ.get("reveal@path").value)
				
				If ($Boo_OK)\
					 & (Length:C16($t)>0)
					
					Case of 
							
							//………………………………………………………………
						: ($Boo_component)
							
							SHOW ON DISK:C922($Dir_component)
							
							//………………………………………………………………
						: ($Boo_compiled)
							
							SHOW ON DISK:C922($Dir_compiled)
							
							//………………………………………………………………
						: ($Boo_standalone)
							
							SHOW ON DISK:C922($Dir_standalone)
							
							//………………………………………………………………
						: ($Boo_server)
							
							SHOW ON DISK:C922($Dir_server)
							
							//………………………………………………………………
					End case 
				End if 
			End if 
		End if 
		
		// Close the dialog
		XML DECODE:C1091(String:C10($ƒ.get("options@close").value); $Boo_execute)
		
		If ($Boo_OK & $Boo_execute)
			
			CANCEL:C270
			
		End if 
		
		// Launch target
		If ($Boo_OK)
			
			XML DECODE:C1091(String:C10($ƒ.get("options@launch").value); $Boo_execute)
			
			Case of 
					
					//…………………………………………………………………………………
				: (Not:C34($Boo_execute))\
					 | ($Boo_component)
					
					// NOTHING MORE TO DO
					
					//…………………………………………………………………………………
				: ($Boo_compiled)
					
					EXECUTE FORMULA:C63(Command name:C538(1321)+"($Dir_compiled)")
					
					//…………………………………………………………………………………
				: ($Boo_standalone)
					
					SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_BLOCKING_EXTERNAL_PROCESS"; "false")
					LAUNCH EXTERNAL PROCESS:C811(Choose:C955(Is Windows:C1573; $Dir_standalone; "open '"+Convert path system to POSIX:C1106($Dir_standalone)+"'"))
					
					//…………………………………………………………………………………
				: ($Boo_server)
					
					SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_BLOCKING_EXTERNAL_PROCESS"; "false")
					LAUNCH EXTERNAL PROCESS:C811(Choose:C955(Is Windows:C1573; $Dir_server; "open '"+Convert path system to POSIX:C1106($Dir_server)+"'"))
					
					//…………………………………………………………………………………
			End case 
		End if 
		
		// Notification
		If ($Boo_OK)
			
			DISPLAY NOTIFICATION:C910($Obj_database.structure.name; Get localized string:C991("theBuildIsAchieved"))
			
		End if 
		
		If ($Boo_OK & $Boo_auto)
			
			QUIT 4D:C291
			
		End if 
		
		APP_MAKER_HANDLER("_deinit")
		
		//================================================================================
	: ($Txt_entryPoint="_declarations")
		
		Compiler_component
		
		//================================================================================
	: ($Txt_entryPoint="_init")
		
		init
		
		//================================================================================
	: ($Txt_entryPoint="_deinit")
		
		If (Storage:C1525.environment.domBuildApp#Null:C1517)
			
			Use (Storage:C1525)
				
				Use (Storage:C1525.environment)
					
					DOM CLOSE XML:C722(Storage:C1525.environment.domBuildApp)
					Storage:C1525.environment.domBuildApp:=Null:C1517
					
				End use 
			End use 
		End if 
		
		$Boo_OK:=PHP Execute:C1058(""; "quit_4d_php")
		
		//================================================================================
	Else 
		
		TRACE:C157
		
		//================================================================================
End case 