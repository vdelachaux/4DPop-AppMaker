//%attributes = {"invisible":true,"shared":true,"preemptive":"incapable"}
// ----------------------------------------------------
// Project method : popAppMakerRun
// ID[B150A0DC18B342C8A555BD1CD36B43F4]
// Created 10/05/11 by Vincent de Lachaux
// ----------------------------------------------------
#DECLARE($ptr : Pointer; $cmd : Text)

var $AppMaker : cs:C1710.AppMaker
$AppMaker:=cs:C1710.AppMaker.new()
$AppMaker.run()