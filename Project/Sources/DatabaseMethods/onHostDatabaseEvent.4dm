// ----------------------------------------------------
// Method :  Host Database Event - (4DPop AppMaker)
// ID[4537E73A0BBF411E90C9310E3043E4F8]
// Created #18-12-2013 by Vincent de Lachaux
// ----------------------------------------------------
// Declarations
C_LONGINT:C283($1)

C_BOOLEAN:C305($Boo_OK)
C_LONGINT:C283($Lon_databaseEvent)
C_TEXT:C284($Dom_node; $Dom_root; $File_auto; $File_target; $Txt_version)
C_OBJECT:C1216($Obj_param)

// ----------------------------------------------------
// Initialisations
$Lon_databaseEvent:=$1

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: ($Lon_databaseEvent=On before host database startup:K74:3)
		
		//The host database has just been started. The On Startup database method method
		//of the host database has not yet been called.
		//The On Startup database method of the host database is not called while the On
		//Host Database Event database method of the component is running
		
		//______________________________________________________
	: ($Lon_databaseEvent=On after host database startup:K74:4)
		
		//The On Startup database method of the host database just finished running
		
		If (Not:C34(Is compiled mode:C492(*)))
			
			ARRAY TEXT:C222($componentsArray; 0)
			COMPONENT LIST:C1001($componentsArray)
			
			If (Find in array:C230($componentsArray; "4DPop QuickOpen")>0)
				
				quickOpenActions
				
			End if 
		End if 
		
		//______________________________________________________
	: ($Lon_databaseEvent=On before host database exit:K74:5)
		
		//The host database is closing. The On Exit database method of the host database
		//has not yet been called.
		//The On Exit database method of the host database is not called while the On Host
		//Database Event database method of the component is running
		$Boo_OK:=PHP Execute:C1058(""; "quit_4d_php")
		
		//______________________________________________________
	: ($Lon_databaseEvent=On after host database exit:K74:6)
		
		//The On Exit database method of the host database has just finished running
		$Boo_OK:=PHP Execute:C1058(""; "quit_4d_php")
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Form event activated unnecessary ("+String:C10($Lon_databaseEvent)+")")
		
		//______________________________________________________
End case 