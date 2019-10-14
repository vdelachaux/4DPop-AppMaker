  // ----------------------------------------------------
  // Method : Méthode formulaire : Barber
  // Created 30/05/08 by vdl
  // ----------------------------------------------------
  // Description
  //
  // ----------------------------------------------------
  // Declarations

  // ----------------------------------------------------
  // Initialisations

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: (Form event:C388=On Load:K2:1)
		
		Use (Storage:C1525.progress)
			
			Storage:C1525.progress.barber:=1  // begin run
			
		End use 
		
		SET TIMER:C645(1)
		
		  //______________________________________________________
	: (Form event:C388=On Timer:K2:25)
		
		Use (Storage:C1525.progress)
			
			Case of 
					
					  //…………………………………………………………………………………………………………………………
				: (Storage:C1525.progress.barber=0)  // Thermometer mode
					
					OBJECT SET FORMAT:C236(*;"progress";"0;"+String:C10(Num:C11(Storage:C1525.progress.max))+";1;0")
					
					  //…………………………………………………………………………………………………………………………
				: (Storage:C1525.progress.barber=-2)  // Activates the "Barber shop"
					
					OBJECT SET INDICATOR TYPE:C1246(*;"progress";Barber shop:K42:35)
					
					Storage:C1525.progress.barber:=1  // begin run
					
					  //…………………………………………………………………………………………………………………………
				: (Storage:C1525.progress.barber=-1)  // Close
					
					SET TIMER:C645(0)
					CANCEL:C270
					
					  //…………………………………………………………………………………………………………………………
			End case 
		End use 
		
		  //______________________________________________________
	: (Form event:C388=On Close Box:K2:21)
		
		If (Macintosh option down:C545 | Windows Alt down:C563)
			
			SET TIMER:C645(0)
			CANCEL:C270
			
		Else 
			
			REJECT:C38
			
		End if 
		
		  //______________________________________________________
End case 