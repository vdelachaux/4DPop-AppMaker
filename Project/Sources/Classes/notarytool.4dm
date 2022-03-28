Class extends lep

Class constructor($keychainProfile : Text)
	
	Super:C1705()
	
	// This.verbose:=False
	This:C1470.version:=This:C1470.getVersion()
	This:C1470.available:=This:C1470.success
	
	If (This:C1470.available)
		
		This:C1470.keychainProfile:=$keychainProfile ? $keychainProfile : Null:C1517
		
	Else 
		
		ALERT:C41("The command line tool \"notarytool\" is not available!")
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
	/// Outputs the current version and build number of notarytool.
Function getVersion() : Text
	
	This:C1470.launch("xcrun notarytool --version")
	
	return (This:C1470.success ? This:C1470.outputStream : "")
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
/*
Save authentication credentials for the Apple notary service to the default login keychain.
	
	
If using --key-path to pass the file path of a private key, the contents of the private key are stored
	
	
in the new keychain item and the private key file can be deleted.
*/
Function storeCredential($keychainProfile : Text; $appleId : Text; $teamID : Text; $password : Text)
	
/*
xcrun notarytool store-credentials "AC_PASSWORD"
--apple-id "AC_USERNAME"
--team-id <WWDRTeamID>
--password <secret_2FA_password>
*/
	
	If (This:C1470.available)
		
		If (Count parameters:C259<4)
			
			// TODO:Display a dialog
			
		Else 
			
			This:C1470.launch("xcrun notarytool store-credentials "+This:C1470.quoted($keychainProfile)\
				+" --apple-id "+This:C1470.quoted($appleId)\
				+" --team-id "+$teamID\
				+" --password "+$password\
				)
			
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
/*
Submit an archive to the Apple notary service.
*/
Function submit($pathname : Text; $keychainProfile : Text) : Object
	
	// xcrun notarytool submit hello-1.0.pkg --keychain-profile "notary-scriptingosx" --wait
	
	If (This:C1470.available)
		
		$keychainProfile:=$keychainProfile ? $keychainProfile : This:C1470.keychainProfile
		
		This:C1470.success:=(Length:C16($keychainProfile)>0)
		
		If (This:C1470.success)
			
			This:C1470.setOutputType(Is object:K8:27)
			
			This:C1470.launch("xcrun notarytool submit "+This:C1470.quoted($pathname)\
				+" --keychain-profile "+This:C1470.quoted($keychainProfile)\
				+" --output-format json --wait")
			
			This:C1470.setOutputType()
			
			If (This:C1470.success)
				
				This:C1470.success:=(This:C1470.outputStream.status="Accepted")
				
				return (This:C1470.outputStream)
				
			End if 
			
		Else 
			
			// TODO:ERROR
			
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
/*
Get status information for a previous submission.
$id is a Submission ID returned from a previous invocation of the submit subcommand.
*/
Function info($id : Text; $keychainProfile : Text) : Object
	
	//xcrun notarytool info "REQUEST_ID" --keychain-profile "AC_PASSWORD"
	
	If (This:C1470.available)
		
		//
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
/*
Retrieve notarization log for a single completed submission as JSON.
$id is a Submission ID returned from a previous invocation of the submit subcommand.
*/
Function log($id : Text; $keychainProfile : Text)
	
	//% xcrun notarytool log "REQUEST_ID" --keychain-profile "AC_PASSWORD" developer_log.json
	
	If (This:C1470.available)
		
		//
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
/*
Get a list of previous submissions for your development team that were submitted via notarytool.
*/
Function history($keychainProfile : Text)
	
	//xcrun notarytool history --keychain-profile "AC_PASSWORD"
	
	If (This:C1470.available)
		
		//
		
	End if 