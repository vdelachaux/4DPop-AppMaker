//%attributes = {"invisible":true,"preemptive":"incapable"}
/*
Non-thread-safe screen commands to be called in a cooperative process
*/
#DECLARE($signal : Object)

If (False:C215)
	C_OBJECT:C1216(envScreens; $1)
End if 

var $bottom; $i; $left; $right; $top : Integer
var $screen : Object
var $screens : Collection

$screens:=New collection:C1472

For ($i; 1; Count screens:C437; 1)
	
	$screen:=New object:C1471(\
		"coordinates"; New object:C1471; \
		"workArea"; New object:C1471)
	
	SCREEN COORDINATES:C438($left; $top; $right; $bottom; $i; Screen size:K27:9)
	$screen.coordinates.left:=$left
	$screen.coordinates.top:=$top
	$screen.coordinates.right:=$right
	$screen.coordinates.bottom:=$bottom
	
	SCREEN COORDINATES:C438($left; $top; $right; $bottom; $i; Screen work area:K27:10)
	$screen.workArea.left:=$left
	$screen.workArea.top:=$top
	$screen.workArea.right:=$right
	$screen.workArea.bottom:=$bottom
	
	$screens.push($screen)
	
End for 

Use ($signal)
	
	$signal.mainScreenID:=Menu bar screen:C441  // On Windows, Menu bar screen always returns 1
	$signal.menuBarHeight:=Menu bar height:C440
	$signal.screens:=$screens.copy(ck shared:K85:29; $signal)
	$signal.toolBarHeight:=Tool bar height:C1016
	
End use 

$signal.trigger()