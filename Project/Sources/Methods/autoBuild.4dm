//%attributes = {"invisible":true,"preemptive":"incapable"}
var $AppMaker : cs:C1710.AppMaker

// Build
$AppMaker:=cs:C1710.AppMaker.new()

If ($AppMaker.run())
	
	QUIT 4D:C291
	
End if 