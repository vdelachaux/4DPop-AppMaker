//%attributes = {"invisible":true}
#DECLARE($run : Boolean)

If ($run)
	
	var $database:=cs:C1710.database.new()
	
	// Allow assertions for the matrix database & me ;-)
	SET ASSERT ENABLED:C1131($database.isMatrix | $database.isDebug; *)
	
	var $AppMaker:=cs:C1710.AppMaker.new()
	$AppMaker.run()
	
Else 
	
	CALL WORKER:C1389("$4DPop APP MAKER"; Current method name:C684; True:C214)
	
End if 