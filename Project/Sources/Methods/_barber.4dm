//%attributes = {}
// Initialize the progress accessor
If (Storage:C1525.progress=Null:C1517)
	
	Use (Storage:C1525)
		
		Storage:C1525.progress:=New shared object:C1526
		
	End use 
End if 

Use (Storage:C1525.progress)
	
	Storage:C1525.progress.indicator:=Null:C1517
	Storage:C1525.progress.title:=""
	Storage:C1525.progress.value:=0
	
End use 

// Open barber
CALL WORKER:C1389("$AppMakerBarber"; Formula:C1597(Open form window:C675("Barber"; Controller form window:K39:17+Form has no menu bar:K39:18; Horizontally centered:K39:1; Vertically centered:K39:4; *)))
CALL WORKER:C1389("$AppMakerBarber"; Formula:C1597(DIALOG:C40("Barber")))

// Barber
Use (Storage:C1525.progress)
	
	Storage:C1525.progress.title:="Barber shop"
	Storage:C1525.progress.indicator:=Barber shop:K42:35
	
End use 

DELAY PROCESS:C323(Current process:C322; 50)

// Hide barber
Use (Storage:C1525.progress)
	
	Storage:C1525.progress.title:="Hide barber"
	Storage:C1525.progress.indicator:=Null:C1517
	
End use 

DELAY PROCESS:C323(Current process:C322; 50)

// Thermometer
Use (Storage:C1525.progress)
	
	Storage:C1525.progress.title:="Progress bar"
	Storage:C1525.progress.indicator:=Progress bar:K42:34
	Storage:C1525.progress.value:=0
	
End use 

var $i : Integer
For ($i; 1; 100; 1)
	
	Use (Storage:C1525.progress)
		
		Storage:C1525.progress.value+=1
		
	End use 
	
	DELAY PROCESS:C323(Current process:C322; 5)
	
End for 

DELAY PROCESS:C323(Current process:C322; 50)

// Barber
Use (Storage:C1525.progress)
	
	Storage:C1525.progress.title:="Barber shop 2"
	Storage:C1525.progress.indicator:=Barber shop:K42:35
	
End use 

DELAY PROCESS:C323(Current process:C322; 100)

// Close
Use (Storage:C1525.progress)
	
	Storage:C1525.progress.indicator:=-1
	
End use 

KILL WORKER:C1390("$AppMakerBarber")