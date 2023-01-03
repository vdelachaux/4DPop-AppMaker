//%attributes = {"invisible":true,"preemptive":"incapable"}
var $AppMaker : cs:C1710.AppMaker

// Launch Build
$AppMaker:=cs:C1710.AppMaker.new()

If ($AppMaker.run())
	
	// Then quit
	QUIT 4D:C291
	
End if 