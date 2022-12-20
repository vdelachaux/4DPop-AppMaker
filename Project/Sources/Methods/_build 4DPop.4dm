//%attributes = {}
var $appName; $cmd; $commitMessage; $err; $in; $out : Text
var $pathname : Text
var $isMatrix; $success : Boolean
var $progress : Integer
var $component; $make : Object
var $exe; $makeFile : 4D:C1709.File
var $target : 4D:C1709.Folder

If (Asserted:C1132(Is macOS:C1572))
	
	$appName:=Select document:C905(8858; ".app"; "select the 4D Application to use"; 0)
	
	If (Bool:C1537(OK))
		
		$exe:=Folder:C1567(DOCUMENT; fk platform path:K87:2).file("Contents/MacOS/4D")
		
		If ($exe.exists)
			
			// Get the the builder branch
			var $o : Object
			$o:=Folder:C1567(DOCUMENT; fk platform path:K87:2).file("Contents/Info.plist").getAppInfo()
			
			ARRAY LONGINT:C221($pos; 0x0000)
			ARRAY LONGINT:C221($len; 0x0000)
			
			var $branch : Text
			$branch:=Match regex:C1019("(?mi-s)build\\s(.*)\\."; $o.CFBundleShortVersionString; 1; $pos; $len)\
				 ? Substring:C12($o.CFBundleShortVersionString; $pos{1}; $len{1})\
				 : cs:C1710.motor.new().branch
			
			$commitMessage:="Compilation "+$branch
			
			// Select the target folder
			$pathname:=Select folder:C670("select the component folder"; 8859)
			
			If (Bool:C1537(OK))
				
				$isMatrix:=Structure file:C489=Structure file:C489(*)
				
				$progress:=Progress New
				
				If ($isMatrix)
					
					// Build me
					Progress SET TITLE($progress; "Build "+Folder:C1567(fk database folder:K87:14).name+"…")
					popAppMakerRun
					
				End if 
				
				$target:=Folder:C1567($pathname; fk platform path:K87:2)
				
				$makeFile:=$target.file("make.json")
				
				If ($makeFile.exists)
					
					$make:=JSON Parse:C1218($makeFile.getText())
					
					For each ($component; $make.components)
						
						$component.folder:=$makeFile.parent.path+$component.name
						
						If ($isMatrix && ($component.name="4DPop AppMaker"))
							
							Progress SET TITLE($progress; "Git push "+$component.name+"…")
							gitCommit($component; $commitMessage)
							continue
							
						End if 
						
						Progress SET TITLE($progress; "Build "+$component.name+"…")
						
						$cmd:=Char:C90(Quote:K15:44)+$exe.path+Char:C90(Quote:K15:44)
						$cmd+=" --project "+Char:C90(Quote:K15:44)+$component.folder+"/Project/"+$component.name+".4DProject"+Char:C90(Quote:K15:44)
						$cmd+=" --opening-mode interpreted"
						$cmd+=" --user-param build"
						$cmd+=" --dataless"
						//$cmd+=" --headless"
						
						LAUNCH EXTERNAL PROCESS:C811($cmd; $in; $out; $err)
						
						// MARK:Git push
						Progress SET TITLE($progress; "Git push "+$component.name+"…")
						$success:=gitCommit($component; $commitMessage)
						
						If (Not:C34($success))
							
							break
							
						End if 
					End for each 
					
					If ($success)
						
						// MARK:Copy to family folder
						Progress SET TITLE($progress; "Make Family folder…")
						
						var $family; $src; $tgt : 4D:C1709.Folder
						$family:=$target.folder("4DPop-Family-"+$branch)
						
						Progress SET TITLE($progress; "Creating: "+$family.fullName+"…")
						
						If ($family.exists)
							
							$family.delete(fk recursive:K87:7)
							
						End if 
						
						$family.create()
						
						For each ($component; $make.components)
							
							$src:=$target.folder($component.name).folder("Build/Components").folder($component.name+".4dbase")
							
							If ($src.exists)
								
								$tgt:=$src.copyTo($family)
								
							End if 
						End for each 
						
						// MARK:Make dmg & push to github
						Progress SET TITLE($progress; "Make Family DMG…")
						
						$success:=makeDMG($family)
						
						If (Not:C34($success))
							
							ALERT:C41("makeDMG failed")
							
						End if 
						
						
					Else 
						
						ALERT:C41("Faied to commit: "+$component.name)
						
					End if 
					
				Else 
					
					ALERT:C41("Missing file: "+$makeFile.fullName)
					
				End if 
				
				Progress QUIT($progress)
				
			End if 
			
		End if 
	End if 
	
Else 
	
	// TODO:On windows
	
End if 