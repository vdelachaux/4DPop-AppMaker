// ----------------------------------------------------
// Method :  Host Database Event - (4DPop AppMaker)
// ID[4537E73A0BBF411E90C9310E3043E4F8]
// Created #18-12-2013 by Vincent de Lachaux
// ----------------------------------------------------
#DECLARE($eventCode : Integer)

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: ($eventCode=On before host database startup:K74:3)
		
		//The host database has just been started. The On Startup database method method
		//of the host database has not yet been called.
		//The On Startup database method of the host database is not called while the On
		//Host Database Event database method of the component is running
		var $userParameters : Text
		var $real : Real
		$real:=Get database parameter:C643(User param value:K37:94; $userParameters)
		
		If ($userParameters="build")
			
			popAppMakerRun
			QUIT 4D:C291
			
		End if 
		
		//______________________________________________________
	: ($eventCode=On after host database startup:K74:4)
		
		//The On Startup database method of the host database just finished running
		
		If (Not:C34(Is compiled mode:C492(*)))
			
			ARRAY TEXT:C222($componentsArray; 0x0000)
			COMPONENT LIST:C1001($componentsArray)
			
			If (Find in array:C230($componentsArray; "4DPop QuickOpen")>0)
				
				quickOpenActions
				
			End if 
		End if 
		
		//______________________________________________________
	: ($eventCode=On before host database exit:K74:5)
		
		//The host database is closing. The On Exit database method of the host database
		//has not yet been called.
		//The On Exit database method of the host database is not called while the On Host
		//Database Event database method of the component is running
		
		//$success:=PHP Execute(""; "quit_4d_php")
		
		//______________________________________________________
	: ($eventCode=On after host database exit:K74:6)
		
		//The On Exit database method of the host database has just finished running
		
		//$success:=PHP Execute(""; "quit_4d_php")
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Form event activated unnecessary ("+String:C10($eventCode)+")")
		
		//______________________________________________________
End case 