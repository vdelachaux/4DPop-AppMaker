//%attributes = {"invisible":true,"shared":true}
// ----------------------------------------------------
// Project method : popAppMakerRun
// ID[B150A0DC18B342C8A555BD1CD36B43F4]
// Created 10/05/11 by Vincent de Lachaux
// ----------------------------------------------------
#DECLARE($ptr : Pointer; $cmd : Text)

BRING TO FRONT:C326(New process:C317(Formula:C1597(APP_MAKER_HANDLER).source; 0; "$AppMaker"; "_run"+$cmd; *))