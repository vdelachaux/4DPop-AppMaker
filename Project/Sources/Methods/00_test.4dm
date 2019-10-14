//%attributes = {"invisible":true}
  //C_BOOLEAN($b)
  //C_DATE($d)
  //C_TEXT($t)
  //C_OBJECT($o)
  //C_COLLECTION($c)
C_TEXT:C284($t)
C_OBJECT:C1216($o)

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

$o:=pref 
$o.close()

$o:=pref ("4DPop AppMaker.xml;database;xml;appMaker")
$o.close()

$o:=pref ("test;database;xml")
$o.close()





