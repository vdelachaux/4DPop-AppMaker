// ----------------------------------------------------
// Method : Form Method: Barber
// Created 30/05/08 by vdl
// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: (Form event code:C388=On Load:K2:1)
		
		OBJECT SET INDICATOR TYPE:C1246(*; "progress"; Progress bar:K42:34)
		OBJECT SET FORMAT:C236(*; "progress"; "0;100;1;")
		OBJECT SET INDICATOR TYPE:C1246(*; "barber"; Barber shop:K42:35)
		
		SET TIMER:C645(1)
		
		//______________________________________________________
	: (Form event code:C388=On Timer:K2:25)
		
		Use (Storage:C1525.progress)
			
			Case of 
					
					//…………………………………………………………………………………………………………………………
				: (Storage:C1525.progress.indicator=Null:C1517)  // Hide thermometer
					
					OBJECT SET VISIBLE:C603(*; "progress"; False:C215)
					OBJECT SET VISIBLE:C603(*; "barber"; False:C215)
					OBJECT SET VISIBLE:C603(*; "percent"; False:C215)
					OBJECT SET VALUE:C1742("barber"; 0)  // Stop
					
					//…………………………………………………………………………………………………………………………
				: (Storage:C1525.progress.indicator=Progress bar:K42:34)
					
					OBJECT SET VISIBLE:C603(*; "progress"; True:C214)
					OBJECT SET VISIBLE:C603(*; "percent"; True:C214)
					OBJECT SET VISIBLE:C603(*; "barber"; False:C215)
					OBJECT SET VALUE:C1742("barber"; 0)  // Stop
					OBJECT SET VALUE:C1742("progress"; Storage:C1525.progress.value)
					
					//…………………………………………………………………………………………………………………………
				: (Storage:C1525.progress.indicator=Barber shop:K42:35)
					
					OBJECT SET VISIBLE:C603(*; "progress"; False:C215)
					OBJECT SET VISIBLE:C603(*; "percent"; False:C215)
					OBJECT SET VISIBLE:C603(*; "barber"; True:C214)
					OBJECT SET VALUE:C1742("barber"; 1)  // Start
					
					//…………………………………………………………………………………………………………………………
				: (Storage:C1525.progress.indicator=-1)  // Close
					
					SET TIMER:C645(0)
					CANCEL:C270
					
					//…………………………………………………………………………………………………………………………
			End case 
		End use 
		
		//______________________________________________________
		//: (Form event code=On Close Box)
		//If (Macintosh option down | Windows Alt down)  // Force close
		//SET TIMER(0)
		//CANCEL
		//Else 
		//REJECT
		//End if 
		
		//______________________________________________________
End case 