property home:=Folder:C1567(fk home folder:K87:24)
property _history:=[]
property errors:=[]
property success:=True:C214
property lastError:=""
property outputType : Integer
property resultInErrorStream:=False:C215
property charSet:="UTF-8"

property environmentVariables:={\
_4D_OPTION_CURRENT_DIRECTORY: ""; \
_4D_OPTION_HIDE_CONSOLE: "true"; \
_4D_OPTION_BLOCKING_EXTERNAL_PROCESS: "true"\
}

property command; inputStream; outputStream; errorStream
property pid; startTime : Integer

property debug:=Not:C34(Is compiled mode:C492)

Class constructor
	
	Super:C1705()
	
	This:C1470.reset()
	
	//MARK:-
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
	// The time spend in millisecondes since the last countTimeInit() call
Function get timeSpent() : Integer
	
	return Milliseconds:C459-This:C1470.startTime
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get history() : Text
	
	return This:C1470._history.join("\n")
	
	//MARK:-
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Restores the initial values of the class
Function reset() : cs:C1710.lep
	
	This:C1470.success:=True:C214
	This:C1470.errors:=[]
	This:C1470.lastError:=""
	This:C1470.command:=Null:C1517
	This:C1470.inputStream:=Null:C1517
	This:C1470.outputStream:=Null:C1517
	This:C1470.errorStream:=""
	This:C1470.pid:=0
	
	This:C1470.resultInErrorStream:=False:C215  // Allows, if True, to reroutes stderr message to stdout
	
	This:C1470.setCharSet()
	This:C1470.setOutputType()
	This:C1470.setEnvironnementVariable()
	
	This:C1470.countTimeInit()
	
	return This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Initialization of the counting of the time spent
Function countTimeInit()
	
	This:C1470.startTime:=Milliseconds:C459
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Pause current process if the condition is true, in any case returns the time spent. 
Function delay($condition : Boolean; $delay : Integer) : Integer
	
	If ($condition)
		
		IDLE:C311
		DELAY PROCESS:C323(Current process:C322; $delay=0 ? 60 : $delay)
		
	End if 
	
	return This:C1470.timeSpent
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setCharSet($charset : Text) : cs:C1710.lep
	
	This:C1470.charSet:=$charset || "UTF-8"
	return This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setOutputType($outputType : Integer) : cs:C1710.lep
	
	This:C1470.outputType:=$outputType=0 ? Is text:K8:3 : $outputType
	return This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setEnvironnementVariable($variables; $value : Text) : cs:C1710.lep
	
	This:C1470.success:=True:C214
	
	Case of 
			
			//……………………………………………………………………
		: (Count parameters:C259=0)  // Reset to default
			
			This:C1470.environmentVariables:=New object:C1471(\
				"_4D_OPTION_CURRENT_DIRECTORY"; ""; \
				"_4D_OPTION_HIDE_CONSOLE"; "true"; \
				"_4D_OPTION_BLOCKING_EXTERNAL_PROCESS"; "true"\
				)
			
			//______________________________________________________
		: (Value type:C1509($variables)=Is text:K8:3)
			
			If (Count parameters:C259>=2)
				
				This:C1470.environmentVariables[This:C1470._shortcut($variables)]:=$value
				
			Else 
				
				// Reset
				If (This:C1470._shortcut($variables)="_4D_OPTION_CURRENT_DIRECTORY")
					
					// Empty string
					This:C1470.environmentVariables[This:C1470._shortcut($variables)]:=""
					
				Else 
					
					// False is default
					This:C1470.environmentVariables[This:C1470._shortcut($variables)]:="false"
					
				End if 
			End if 
			
			//______________________________________________________
		: (Value type:C1509($variables)=Is object:K8:27)
			
			var $o : Object
			For each ($o; OB Entries:C1720($variables))
				
				If ($o.key#Null:C1517)
					
					This:C1470.environmentVariables[This:C1470._shortcut($o.key)]:=String:C10($o.value)
					
				Else 
					
					This:C1470._pushError("Missig key properties")
					
				End if 
			End for each 
			
			//______________________________________________________
		: (Value type:C1509($variables)=Is collection:K8:32)
			
			var $v : Variant
			For each ($v; $variables)
				
				If (Value type:C1509($v)=Is object:K8:27)
					
					$o:=OB Entries:C1720($v).pop()
					
					If ($o.key#Null:C1517)
						
						This:C1470.environmentVariables[This:C1470._shortcut($o.key)]:=String:C10($o.value)
						
					Else 
						
						This:C1470._pushError("Missig key properties")
						
					End if 
					
				Else 
					
					This:C1470._pushError("Waiting for a collection of objects")
					
				End if 
			End for each 
			
			//______________________________________________________
		Else 
			
			This:C1470._pushError("Waiting for a parameter Text, Object or Collection")
			
			//______________________________________________________
	End case 
	
	return This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Execute the external process in asynchronous mode then restore the default synchronous mode
Function launchAsync($command; $arguments : Variant) : cs:C1710.lep
	
	This:C1470.asynchronous()
	
	If (Count parameters:C259>=2)
		
		This:C1470.launch($command; $arguments)
		
	Else 
		
		This:C1470.launch($command)
		
	End if 
	
	This:C1470.synchronous()
	
	return This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function launch($command; $arguments : Variant) : cs:C1710.lep
	
	This:C1470.outputStream:=Null:C1517
	This:C1470.errorStream:=""
	This:C1470.pid:=0
	
	If (Value type:C1509($command)=Is object:K8:27)  // File script
		
		This:C1470.command:=This:C1470.escape($command.path)
		
	Else 
		
		// Path must be POSIX
		This:C1470.command:=String:C10($command)
		
		Case of 
				
				//______________________________________________________
			: (This:C1470.command="shell")
				
				This:C1470.command:="/bin/sh"
				
				//______________________________________________________
			: (This:C1470.command="bat")
				
				This:C1470.command:="cmd.exe /C start /B"
				
				//______________________________________________________
		End case 
	End if 
	
	If (Count parameters:C259>=2)
		
		//This.command:=This.command+" "+This.escape($arguments)
		Case of 
				
				//______________________________________________________
			: (Value type:C1509($arguments)=Is text:K8:3)
				
				This:C1470.command:=This:C1470.command+" "+$arguments
				
				//______________________________________________________
			: (Value type:C1509($arguments)=Is collection:K8:32)
				
				This:C1470.command:=This:C1470.command+$arguments.join(" ")
				
				//______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215; "$2 must be a text or a collection")
				
				//______________________________________________________
		End case 
	End if 
	
	var $t : Text
	For each ($t; This:C1470.environmentVariables)
		
		SET ENVIRONMENT VARIABLE:C812($t; String:C10(This:C1470.environmentVariables[$t]))
		
	End for each 
	
	var $inputStream; $outputStream : Blob
	var $errorStream : Text
	
	Case of 
			
			//……………………………………………………………………
		: (This:C1470.inputStream=Null:C1517)
			
			// <NOTHING MORE TO DO>
			
			//……………………………………………………………………
		: (Value type:C1509(This:C1470.inputStream)=Is text:K8:3)\
			 | (Value type:C1509(This:C1470.inputStream)=Is alpha field:K8:1)
			
			CONVERT FROM TEXT:C1011(This:C1470.inputStream; This:C1470.charSet; $inputStream)
			
			//……………………………………………………………………
		: (Value type:C1509(This:C1470.inputStream)=Is boolean:K8:9)
			
			CONVERT FROM TEXT:C1011(Choose:C955(This:C1470.inputStream; "true"; "false"); This:C1470.charSet; $inputStream)
			
			//……………………………………………………………………
		: (Value type:C1509(This:C1470.inputStream)=Is longint:K8:6)\
			 | (Value type:C1509(This:C1470)=Is integer:K8:5)\
			 | (Value type:C1509(This:C1470.inputStream)=Is integer 64 bits:K8:25)\
			 | (Value type:C1509(This:C1470.inputStream)=Is real:K8:4)
			
			CONVERT FROM TEXT:C1011(String:C10(This:C1470.inputStream; "&xml"); This:C1470.charSet; $inputStream)
			
			//……………………………………………………………………
		Else 
			
			$inputStream:=This:C1470.inputStream  // Blob
			
			//……………………………………………………………………
	End case 
	
	var $history:="% "+$command+"\n"
	var $pid : Integer
	
	LAUNCH EXTERNAL PROCESS:C811(This:C1470.command; $inputStream; $outputStream; $errorStream; $pid)
	
	This:C1470.success:=Bool:C1537(OK)
	
	If (This:C1470.resultInErrorStream)
		
		$t:=$errorStream
		CLEAR VARIABLE:C89($errorStream)
		
	Else 
		
		If (BLOB size:C605($outputStream)>0)  // Else OK is reset to 0
			
			$t:=Convert to text:C1012($outputStream; This:C1470.charSet)
			
		Else 
			
			CLEAR VARIABLE:C89($t)
			
		End if 
	End if 
	
	$t:=This:C1470._cleanupStream($t)
	
	If (Length:C16($errorStream)=0)
		
		$history+=" | "+Replace string:C233($t; "\n"; "\n | ")
		
		If (Not:C34(This:C1470.resultInErrorStream))
			
			// ⚠️ Some commands return the error in the output stream
			
			If (Position:C15("ERROR"; $t; *)=1)\
				 | (Position:C15("FAILED"; $t; *)=1)\
				 | (Position:C15("Failure"; $t; *)=1)
				
				$errorStream:=$t
				This:C1470.success:=False:C215
				
			End if 
		End if 
		
	Else 
		
		This:C1470.errorStream:=This:C1470._cleanupStream($errorStream)
		This:C1470._pushError(This:C1470.errorStream)
		
		$history+=" | "+Replace string:C233(This:C1470.errorStream; "\n"; "\n | ")
		
	End if 
	
	This:C1470._history.push($history)
	
	If (This:C1470.success)
		
		This:C1470.pid:=$pid
		
		Case of 
				
				//……………………………………………………………………
			: (This:C1470.outputType=Is text:K8:3)
				
				This:C1470.outputStream:=$t
				
				//……………………………………………………………………
			: (This:C1470.outputType=Is object:K8:27)
				
				If (Length:C16($t)>0)
					
					This:C1470.success:=(Match regex:C1019("(?si-m)^(?:\\{.*\\})|(?:^\\[.*\\])$"; $t; 1))
					
				End if 
				
				If (This:C1470.success)
					
					This:C1470.outputStream:=JSON Parse:C1218($t)
					
				Else 
					
					This:C1470.errorStream:=$t
					
				End if 
				
				//……………………………………………………………………
			: (This:C1470.outputType=Is collection:K8:32)
				
				This:C1470.outputStream:=Split string:C1554($t; "\n")
				
				//……………………………………………………………………
			: (This:C1470.outputType=Is boolean:K8:9)
				
				This:C1470.outputStream:=($t="true")
				
				//……………………………………………………………………
			: (This:C1470.outputType=Is longint:K8:6)\
				 | (This:C1470.outputType=Is integer:K8:5)\
				 | (This:C1470.outputType=Is integer 64 bits:K8:25)\
				 | (This:C1470.outputType=Is real:K8:4)
				
				This:C1470.outputStream:=Num:C11($t)
				
				//……………………………………………………………………
			Else 
				
				This:C1470.outputStream:=$outputStream  // Blob
				
				//……………………………………………………………………
		End case 
		
	Else 
		
		This:C1470.pid:=0
		This:C1470.outputStream:=$t
		This:C1470.errorStream:=This:C1470._cleanupStream($errorStream)
		This:C1470._pushError(This:C1470.errorStream)
		
	End if 
	
	If (This:C1470.debug)
		
		This:C1470._log()
		
	End if 
	
	return This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Execute the external process in synchronous mode
	// ⚠️ Must be call before .launch()
Function synchronous($mode : Boolean) : cs:C1710.lep
	
	This:C1470.setEnvironnementVariable("asynchronous"; (Count parameters:C259>=1) ? ($mode ? "true" : "false") : "true")
	
	return This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Execute the external process in asynchronous mode
	// ⚠️ Must be call before .launch()
Function asynchronous($mode : Boolean) : cs:C1710.lep
	
	This:C1470.setEnvironnementVariable("asynchronous"; (Count parameters:C259>=1) ? ($mode ? "false" : "true") : "false")
	
	return This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function setDirectory($folder : 4D:C1709.Folder) : cs:C1710.lep
	
	This:C1470.environmentVariables["_4D_OPTION_CURRENT_DIRECTORY"]:=Count parameters:C259>=1 ? $folder.platformPath : ""
	This:C1470.success:=True:C214
	
	return This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function showConsole() : cs:C1710.lep
	
	This:C1470.environmentVariables["_4D_OPTION_HIDE_CONSOLE"]:="false"
	
	return This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function hideConsole() : cs:C1710.lep
	
	This:C1470.environmentVariables["_4D_OPTION_HIDE_CONSOLE"]:="true"
	
	return This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns an object containing all the environment variables
Function getEnvironnementVariables() : Object
	
	This:C1470.launch(Choose:C955(Is macOS:C1572; "/usr/bin/env"; "set"))
	
	If (This:C1470.success)
		
		var $variables:={}
		
		For each ($t; Split string:C1554(This:C1470.outputStream; "\n"; sk ignore empty strings:K86:1))
			
			var $c:=Split string:C1554($t; "=")
			
			If ($c.length=2)
				
				$variables[$c[0]]:=$c[1]
				
			End if 
		End for each 
		
		// Add the currents variables
		var $t : Text
		For each ($t; This:C1470.environmentVariables)
			
			If ($variables[$t]=Null:C1517)
				
				$variables[$t]:=This:C1470.environmentVariables[$t]
				
			End if 
		End for each 
		
		return $variables
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns the content of an environment variable from its name
Function getEnvironnementVariable($name : Text; $diacritic : Boolean) : Text
	
	This:C1470.success:=Count parameters:C259>=1
	
	If (This:C1470.success)
		
		var $o : Object
		var $t : Text:=This:C1470._shortcut($name)
		
		If (Count parameters:C259>=2 ? $diacritic : True:C214)
			
			If (This:C1470.environmentVariables[$t]#Null:C1517)
				
				return This:C1470.environmentVariables[$t]
				
			Else 
				
				$o:=This:C1470.getEnvironnementVariables()
				This:C1470.success:=$o[$name]#Null:C1517
				
				If (This:C1470.success)
					
					return $o[$name]
					
				Else 
					
					This:C1470.errors.push("Variable \""+$name+"\" not found")
					
				End if 
			End if 
			
		Else 
			
			$o:=OB Entries:C1720(This:C1470.environmentVariables).query("key = :1"; $t).pop()\
				 || OB Entries:C1720(This:C1470.getEnvironnementVariables()).query("key = :1"; $t).pop()
			
			return $o#Null:C1517 ? $o.value : ""
			
		End if 
		
	Else 
		
		This:C1470.errors.push("Missing variable name parameter")
		
	End if 
	
	//MARK:- 🛠 Tools
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Escape special caracters for lep commands
Function escape($text : Text) : Text
	
	var $char : Text
	
	For each ($char; Split string:C1554("\\!\"#$%&'()=~|<>?;*`[] "; ""))
		
		$text:=Replace string:C233($text; $char; "\\"+$char; *)
		
	End for each 
	
	return $text
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Enclose, if necessary, the string in single quotation marks
Function singleQuoted($string : Text) : Text
	
	return Match regex:C1019("^'.*'$"; $string; 1) ? $string : ("'"+$string+"'")
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns the string between quotes
Function quoted($string : Text) : Text
	
	return Match regex:C1019("^\".*\"$"; $string; 1) ? $string : ("\""+$string+"\"")
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Compare two string version
	// -  0 if the version and the reference are equal
	// -  1 if the version is higher than the reference
	// - -1 if the version is lower than the reference
Function versionCompare($current : Text; $reference : Text; $separator : Text) : Integer
	
	$separator:=$separator || "."  // Dot is default separator
	
	var $c1:=Split string:C1554($current; $separator)
	var $c2:=Split string:C1554($reference; $separator)
	
	Case of 
			
			//______________________________________________________
		: ($c1.length>$c2.length)
			
			$c2.resize($c1.length; "0")
			
			//______________________________________________________
		: ($c2.length>$c1.length)
			
			$c1.resize($c2.length; "0")
			
			//______________________________________________________
	End case 
	
	var $i : Integer
	For ($i; 0; $c2.length-1; 1)
		
		Case of 
				
				//______________________________________________________
			: (Num:C11($c1[$i])>Num:C11($c2[$i]))
				
				return 1
				
				//______________________________________________________
			: (Num:C11($c1[$i])<Num:C11($c2[$i]))
				
				return -1
				
				//______________________________________________________
		End case 
	End for 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Set write accesses to a file or a directory with all its subfolders and files
Function makeWritable($cible : 4D:C1709.Document) : cs:C1710.lep
	
	If (Bool:C1537($cible.exists))
		
		If (Is macOS:C1572)
			
/*
chmod [-fv] [-R [-H | -L | -P]] mode file ...
chmod [-fv] [-R [-H | -L | -P]] [-a | +a | =a] ACE file ...
chmod [-fhv] [-R [-H | -L | -P]] [-E] file ...
chmod [-fhv] [-R [-H | -L | -P]] [-C] file ...
chmod [-fhv] [-R [-H | -L | -P]] [-N] file ...
			
The generic options are as follows:
-f      Do not display a diagnostic message if chmod could not modify the
mode for file.
-H      If the -R option is specified, symbolic links on the command line
are followed.  (Symbolic links encountered in the tree traversal
are not followed by default.)
-h      If the file is a symbolic link, change the mode of the link
itself rather than the file that the link points to.
-L      If the -R option is specified, all symbolic links are followed.
-P      If the -R option is specified, no symbolic links are followed.
This is the default.
-R      Change the modes of the file hierarchies rooted in the files
instead of just the files themselves.
-v      Cause chmod to be verbose, showing filenames as the mode is modi-
fied.  If the -v flag is specified more than once, the old and
new modes of the file will also be printed, in both octal and
symbolic notation.
The -H, -L and -P options are ignored unless the -R option is specified.
In addition, these options override each other and the command's actions
are determined by the last one specified.
*/
			
			
			If ($cible.isFolder)
				
				This:C1470.launch("chmod -R u+rwX "+This:C1470.singleQuoted($cible.path))
				
			Else 
				
				This:C1470.launch("chmod u+rwX "+This:C1470.singleQuoted($cible.path))
				
			End if 
			
		Else 
			
/*
ATTRIB [+R | -R] [+A | -A ] [+S | -S] [+H | -H] [+I | -I]
       [drive:][path][filename] [/S [/D] [/L]]
			
  +   Sets an attribute.
  -   Clears an attribute.
  R   Read-only file attribute.
  A   Archive file attribute.
  S   System file attribute.
  H   Hidden file attribute.
  I   Not content indexed file attribute.
      Spécifie un ou plusieurs fichiers à traiter par attrib.
  /S  Processes matching files in the current folder and all subfolders.
  /D  Process folders as well.
  /L  Work on the attributes of the Symbolic Link versus the target of the Symbolic Link
*/
			
			If ($cible.isFolder)
				
				This:C1470.setEnvironnementVariable("directory"; $cible.platformPath)
				This:C1470.launch("attrib.exe -R /D /S")
				
			Else 
				
				This:C1470.launch("attrib.exe -R "+This:C1470.singleQuoted($cible.path))
				
			End if 
			
			
		End if 
		
	Else 
		
		This:C1470._pushError("Invalid pathname: "+String:C10($cible.path))
		
	End if 
	
	return This:C1470
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//Set write accesses to a directory with all its sub-folders and files
Function unlockDirectory($folder : 4D:C1709.Folder) : cs:C1710.lep
	
	If (Bool:C1537($folder.exists))
		
		If ($folder.isFolder)
			
			This:C1470.setEnvironnementVariable("directory"; $folder.platformPath)
			
			If (Is Windows:C1573)
				
				This:C1470.launch("attrib.exe -R /D /S")
				
			Else 
				
				This:C1470.launch("chmod -R u+rwX "+This:C1470.singleQuoted($folder.path))
				
			End if 
			
		Else 
			
			This:C1470._pushError($folder.path+" is not a directory!")
			
		End if 
		
	Else 
		
		This:C1470._pushError("Folder not found: "+String:C10($folder.path))
		
	End if 
	
	return This:C1470
	
	//MARK:-
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Remove unnecessary carriage returns and line breaks from the error/output stream
Function _cleanupStream($textToCleanUp : Text) : Text
	
	If (Length:C16($textToCleanUp)=0)
		
		return 
		
	End if 
	
	return Split string:C1554(Replace string:C233($textToCleanUp; "\r\n"; "\n"); "\\n"; sk ignore empty strings:K86:1).join("\\n")
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function _shortcut($string : Text) : Text
	
	Case of   // Shortcuts
			
			//…………………………………………………………………………………………
		: ($string="directory")\
			 || ($string="currentDirectory")
			
			return "_4D_OPTION_CURRENT_DIRECTORY"
			
			//…………………………………………………………………………………………
		: ($string="asynchronous")\
			 || ($string="non-blocking")
			
			return "_4D_OPTION_BLOCKING_EXTERNAL_PROCESS"
			
			//…………………………………………………………………………………………
		: ($string="console")\
			 || ($string="hideConsole")
			
			return "_4D_OPTION_HIDE_CONSOLE"
			
			//…………………………………………………………………………………………
		Else 
			
			return $string
			
			//…………………………………………………………………………………………
	End case 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function _pushError($message : Text)
	
	This:C1470.success:=False:C215
	
	var $c:=Call chain:C1662
	var $current; $o : Object
	
	For each ($o; $c)
		
		If (Position:C15("lep."; $o.name)#1)
			
			$current:=$o
			break
			
		End if 
	End for each 
	
	If ($current#Null:C1517)
		
		If (Length:C16($message)>0)
			
			This:C1470.lastError:=$current.name+" - "+$message
			
		Else 
			
			// Unknown error
			This:C1470.lastError:=$current.name+" - Unknown error at line "+String:C10($current.line)
			
		End if 
		
	Else 
		
		If ($c.length>0)
			
			If (Length:C16($message)>0)
				
				This:C1470.lastError:=$c[1].name+" - "+$message
				
			Else 
				
				// Unknown error
				This:C1470.lastError:=$c[1].name+" - Unknown error at line "+String:C10($c[1].line)
				
			End if 
			
		Else 
			
			This:C1470.lastError:="Unknown but annoying error"
			
		End if 
	End if 
	
	This:C1470.errors.push(This:C1470.lastError)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function _log()
	
	var $current; $o : Object
	
	var $log:=[]
	var $c:=Call chain:C1662
	
	For each ($o; $c)
		
		If (Position:C15("lep."; $o.name)#1)
			
			$current:=$o
			break
			
		End if 
	End for each 
	
	If ($current#Null:C1517)
		
		$log.push($current.name+("()"*Num:C11(Position:C15("."; $current.name)>0)))
		$log.push("\r\rCMD:")
		
	Else 
		
		$log.push("CMD:")
		
	End if 
	
	$log.push(This:C1470.command)
	$log.push("\r\rSTATUS:")
	$log.push(Choose:C955(This:C1470.success; "success"; "failed"))
	
	Case of 
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: ((Value type:C1509(This:C1470.outputStream)=Is object:K8:27)\
			 | (Value type:C1509(This:C1470.outputStream)=Is collection:K8:32))
			
			$log.push("\r\rOUTPUT:")
			$log.push(JSON Stringify:C1217(This:C1470.outputStream))
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: (Value type:C1509(This:C1470.outputStream)=Is boolean:K8:9)
			
			$log.push("\r\rOUTPUT:")
			$log.push(Choose:C955(This:C1470.outputStream; "true"; "false"))
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: ((Value type:C1509(This:C1470.outputStream)=Is longint:K8:6)\
			 | (Value type:C1509(This:C1470.outputStream)=Is integer:K8:5)\
			 | (Value type:C1509(This:C1470.outputStream)=Is integer 64 bits:K8:25)\
			 | (Value type:C1509(This:C1470.outputStream)=Is real:K8:4))
			
			$log.push("\r\rOUTPUT:")
			$log.push(String:C10(This:C1470.outputStream))
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		Else 
			
			If (Length:C16(String:C10(This:C1470.outputStream))>0)
				
				$log.push("\r\rOUTPUT:")
				$log.push(String:C10(This:C1470.outputStream))
				
			End if 
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	End case 
	
	If (Length:C16(String:C10(This:C1470.errorStream))>0)
		
		$log.push("\r\rERROR:")
		$log.push(String:C10(This:C1470.errorStream))
		
	End if 
	
	LOG EVENT:C667(Into 4D debug message:K38:5; $log.join(" "); Error message:K38:3)