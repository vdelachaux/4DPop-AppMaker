//%attributes = {"invisible":true}
//C_BOOLEAN($b)
//C_DATE($d)
//C_TEXT($t)
//C_OBJECT($o)
//C_COLLECTION($c)

//$o:=application
//$o:=pref

//$o:=pref ("myPreferences")
//$o:=pref ("root;Settings")

//$o:=pref ("pref;Prefs;database")
//$o:=pref ("pref;Preferences;user")
//$o:=pref ("pref;Settings;4D")

//$o:=pref ("test;Settings;user;.xml")
//ASSERT($o.get("delete")=Null)

//  // Open a file
//$o:=pref (Folder(fk database folder;*).folder("Preferences").file("4DPop AppMaker.xml").path)

//$b:=$o.get("options@remove4DSVGHelp";Is boolean)
//$c:=$o.get("delete")
//$c:=$o.get("options")

//  // Close
//$o.close()

//$o:=pref (Folder(fk database folder;*).folder("Preferences").file("test.xml").path)
//$o.set("test/test@bool";False)
//$o.set("test/test@date";Current date)
//$o.save(True)

//$d:=$o.get("test/test@date";Is date)
//$t:=$o.get("test/test@bool")
//$b:=$o.get("test/test@bool";Is boolean)

//$o.close()

//$c:=Folder(fk database folder).files(fk recursive)
//$cc:=$c.query("fullName = .@ OR parent.name = @tempo")

// Create a default file from template
//$o:=File("/RESOURCES/BuildApp.xml")
//$t:=$o.getText()
//$t:=Replace string($t;"{BuildApplicationName}";Storage.database.structure.name)
//$o:=File(Build application configuration file;*)
//$o.create()
//$o.setText($t)

//$o:=pref
//$o.close()

//$o:=pref("4DPop AppMaker.xml;database;xml;appMaker")
//$o.close()

//$o:=pref("test;database;xml")
//$o.close()

Case of 
		
		//______________________________________________________
	: (True:C214)
		
		var $status : Object
		var $target : 4D:C1709.Folder
		var $buildApp : cs:C1710.BuildApp
		
		$buildApp:=cs:C1710.BuildApp.new()
		
		$status:=$buildApp.build()
		
		If ($status.success)
			
			If (Bool:C1537($buildApp.settings.BuildComponent))  //component
				
				$target:=$buildApp.getPlatformDestinationFolder().folder("Components").folder($buildApp.settings.BuildApplicationName+".4dbase")
				
				
				//continue with SignApp
				
				var $credentials : Object
				$credentials:=New object:C1471
				$credentials.username:="keisuke.miyako@4d.com"  //apple ID
				$credentials.password:="@keychain:altool"  //app specific password or keychain label; must be literal to use listProviders()
				
				var $signApp : cs:C1710.SignApp
				$signApp:=cs:C1710.SignApp.new($credentials)
				
				var $app : 4D:C1709.Folder
				$app:=Folder:C1567("Macintosh HD:Applications:BugBase Client.app:"; fk platform path:K87:2)
				
				$status:=$signApp.sign($app)
				
				$status:=$signApp.archive($app)
				
				If ($status.success)
					$status:=$signApp.notarize($status.file)
				End if 
				
			End if 
			
			
			//If (Bool($buildApp.settings.BuildComponent))  //component
			
			//$target:=$buildApp.getPlatformDestinationFolder().folder("Components").folder($buildApp.settings.BuildApplicationName+".4dbase")
			
			//End if 
			
			
			
			
			
		Else 
			
			$buildApp.openProject("BBEdit")
			
		End if 
		
		//______________________________________________________
	: (True:C214)
		
		var $identity : Object
		var $c : Collection
		var $build : cs:C1710.build
		
		$build:=cs:C1710.build.new()
		
		$c:=$build.findIdentity()
		
		If ($build.success)
			
			$identity:=$c.query("name == :1"; "Developer ID Application:@").pop()
			
		Else 
			
			// A "If" statement should never omit "Else"
			
		End if 
		
		//______________________________________________________
	: (True:C214)
		
		
		
		//______________________________________________________
End case 


