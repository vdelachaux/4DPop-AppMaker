  // ----------------------------------------------------
  // Form method : Editor
  // Created 30/05/08 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description
  //
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($Lon_event;$Lon_page)

  // ----------------------------------------------------
  // Initialisations
$Lon_page:=FORM Get current page:C276

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: (Form event:C388=On Load:K2:1)
		
		Form:C1466.refresh:=Formula:C1597(SET TIMER:C645(-1))
		Form:C1466.key:=Formula:C1597(key_UPDATE )
		Form:C1466.load:=Formula:C1597(APP_MAKER_Load_page )
		Form:C1466.page:=Formula:C1597(APP_MAKER_Go_to_page )
		
		Form:C1466.loaded:=New collection:C1472
		
		Form:C1466.buildApp:=New list:C375
		(OBJECT Get pointer:C1124(Object named:K67:5;"key.list"))->:=Form:C1466.buildApp
		
		Form:C1466.options:=New object:C1471
		Form:C1466.reveal:=New object:C1471
		Form:C1466.methods:=New object:C1471
		
		Form:C1466.preparation:=New object:C1471
		
		Form:C1466.action:=-1
		Form:C1466.refresh()
		
		  //______________________________________________________
	: (Form event:C388=On Page Change:K2:54)
		
		Form:C1466.load($Lon_page)
		
		  //______________________________________________________
	: (Form event:C388=On Timer:K2:25)
		
		SET TIMER:C645(0)
		
		$Lon_event:=Form:C1466.action
		Form:C1466.action:=0
		
		Case of 
				
				  //…………………………………………………………
			: ($Lon_event=-1)
				
				Form:C1466.load($Lon_page)
				
				  //…………………………………………………………
			: ($Lon_event=-2)
				
				Form:C1466.key()
				
				  //…………………………………………………………
			: ($Lon_event=-5)
				
				Form:C1466.key()
				
				  //…………………………………………………………
		End case 
		
		If (Form:C1466.action#0)
			
			Form:C1466.refresh()
			
		End if 
		
		  //______________________________________________________
	: (Form event:C388=On Resize:K2:27)
		
		Obj_CENTER ("icon.run";"_gabarit")
		Obj_CENTER ("tips.run";"_gabarit";Horizontally centered:K39:1)
		
		  //______________________________________________________
	: (Form event:C388=On Close Box:K2:21)
		
		CLEAR LIST:C377(Form:C1466.buildApp)
		
		CANCEL:C270
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215)
		
		  //______________________________________________________
End case 