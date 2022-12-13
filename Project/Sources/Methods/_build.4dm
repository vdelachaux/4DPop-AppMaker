//%attributes = {}
var $appName; $cmd; $component; $err; $in; $out : Text
var $pathname; $tJSON : Text
var $file; $make : Object
var $exe; $makeFile : 4D:C1709.File

If (Asserted:C1132(Is macOS:C1572))
	
	$appName:=Select document:C905(8858; ".app"; "select the 4D Application to use"; 0)
	
	If (Bool:C1537(OK))
		
		$exe:=Folder:C1567(DOCUMENT; fk platform path:K87:2).file("Contents/MacOS/4D")
		
		If ($exe.exists)
			
			$pathname:=Select folder:C670("select the component folder"; 8859)
			
			If (Bool:C1537(OK))
				
				var $isMatrix : Boolean
				$isMatrix:=Structure file:C489=Structure file:C489(*)
				
				var $builme : Boolean
				var $headless : Boolean
				
				$headless:=True:C214
				
				If ($isMatrix && $builme)
					
					// Build me
					popAppMakerRun
					
				End if 
				
				$makeFile:=Folder:C1567($pathname; fk platform path:K87:2).file("make.json")
				
				If ($makeFile.exists)
					
					$make:=JSON Parse:C1218($makeFile.getText())
					
					For each ($component; $make.components)
						
						If ($isMatrix && ($component="4DPop AppMaker"))
							
							continue
							
						End if 
						
						$cmd:=Char:C90(Quote:K15:44)+$exe.path+Char:C90(Quote:K15:44)
						$cmd+=" --project "+Char:C90(Quote:K15:44)+$makeFile.parent.path+$component+"/Project/"+$component+".4DProject"+Char:C90(Quote:K15:44)
						$cmd+=" --opening-mode interpreted"
						$cmd+=" --user-param build"
						$cmd+=" --dataless"
						$cmd+=" --headless"
						
						LAUNCH EXTERNAL PROCESS:C811($cmd; $in; $out; $err)
						
						// TODO:Git push
						// TODO:Copy to family folder
						
					End for each 
					
					// TODO:Make dmg & push to github
					
				End if 
			End if 
		End if 
	End if 
	
Else 
	
	// TODO:On windows
	
End if 