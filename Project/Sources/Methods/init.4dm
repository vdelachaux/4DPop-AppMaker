//%attributes = {}
C_TEXT:C284($t)
C_OBJECT:C1216($o)

If (Storage:C1525.database=Null:C1517)\
 | (Structure file:C489=Structure file:C489(*))
	
	$o:=New shared object:C1526
	
	Use ($o)
		
		$o:=database 
		
		Use ($o)
			
			  // Ensure the preferences folder exists
			$o.preferences.create()
			
			  //***************************************************
			$o.preferencesFolder:=New shared object:C1526
			
			Use ($o.preferencesFolder)
				
				$o.preferencesFolder:=$o.root.folder("Preferences")
				
			End use 
			
			$o.preferencesFolder.create()
			
			$o.buildSettings:=New shared object:C1526
			
			Use ($o.buildSettings)
				
				If ($o.isNewArchitecture)
					
					$o.buildSettings:=$o.preferencesFolder
					
				Else 
					
					$o.buildSettings:=$o.root.folder("Preferences/BuildApp")
					$o.buildSettings.create()
					
				End if 
			End use 
		End use 
	End use 
	
	Use (Storage:C1525)
		
		Storage:C1525.database:=$o
		
	End use 
End if 

  // COMPONENT
$o:=New shared object:C1526

Use ($o)
	
	$o:=preferences 
	
End use 

Use (Storage:C1525)
	
	Storage:C1525.preferences:=$o
	
End use 

If (Storage:C1525.environment=Null:C1517)\
 | (Structure file:C489=Structure file:C489(*))
	
	Use (Storage:C1525)
		
		Storage:C1525.environment:=New shared object:C1526
		
	End use 
	
	Use (Storage:C1525.environment)
		
		Storage:C1525.environment.databaseFolder:=Storage:C1525.database.root.platformPath
		Storage:C1525.environment.preferencesFolder:=Storage:C1525.database.root.folder(Choose:C955(Storage:C1525.database.isDatabase;"Preferences";"Settings"))  // .platformPath
		Storage:C1525.environment.preferences:=Storage:C1525.environment.preferencesFolder.file("4DPop AppMaker.xml").platformPath
		Storage:C1525.environment.gitAvailable:=git (New object:C1471("action";"--version")).success
		
		If (Num:C11(Application version:C493)>=1800)
			
			$o:=Folder:C1567(fk database folder:K87:14;*).file("Settings/buildApp.4DSettings")
			
			If (Not:C34($o.exists))
				
				$o:=Folder:C1567(fk database folder:K87:14;*).file("Preferences/BuildApp.xml")
				
				If ($o.exists)
					
					$o.copyTo(Folder:C1567(fk database folder:K87:14;*).folder("Settings");"buildApp.4DSettings")
					
				End if 
			End if 
			
			$o:=Folder:C1567(fk database folder:K87:14;*).file("Settings/buildApp.4DSettings")
			
		Else 
			
			$o:=Folder:C1567(fk database folder:K87:14;*).file("Preferences/BuildApp/BuildApp.xml")
			
		End if 
		
		Storage:C1525.environment.buildApp:=$o.platformPath
		
		If ($o.exists)
			
			  // <NOTHING MORE TO DO>
			
		Else 
			
			  // Create a default file from template
			$o.create()
			$t:=File:C1566("/RESOURCES/BuildApp.xml").getText()
			$t:=Replace string:C233($o.getText();"{BuildApplicationName}";Storage:C1525.database.structure.name)
			$o.setText($t)
			
		End if 
	End use 
End if 

Use (Storage:C1525.environment)
	
	Storage:C1525.environment.domBuildApp:=DOM Parse XML source:C719(Storage:C1525.environment.buildApp)
	
End use 

If (Storage:C1525.progress=Null:C1517)
	
	Use (Storage:C1525)
		
		Storage:C1525.progress:=New shared object:C1526
		
	End use 
	
	Use (Storage:C1525.progress)
		
		Storage:C1525.progress.barber:=1
		Storage:C1525.progress.title:="…"
		Storage:C1525.progress.value:=0
		Storage:C1525.progress.max:=100
		
	End use 
End if 