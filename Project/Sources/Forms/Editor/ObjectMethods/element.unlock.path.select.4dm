// ----------------------------------------------------
// Object method : Editor.element.unlock.path.select - (4DPop AppMaker)
// ID[35AB2E833C4E48D293B8E8CD34C0E805]
// Created #10-7-2013 by Vincent de Lachaux
// ----------------------------------------------------
// Declarations
C_LONGINT:C283($Lon_back)
C_TEXT:C284($kTxt_back; $Txt_buffer; $Txt_commonPath; $Txt_path; $Txt_structureFolderPath; $Txt_type)

// ----------------------------------------------------
// Initialisations

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: (Form event code:C388=On Mouse Enter:K2:33)
		
		OBJECT SET BORDER STYLE:C1262(*; OBJECT Get name:C1087(Object current:K67:2); Border Plain:K42:28)
		
		//______________________________________________________
	: (Form event code:C388=On Mouse Leave:K2:34)
		
		OBJECT SET BORDER STYLE:C1262(*; OBJECT Get name:C1087(Object current:K67:2); Border None:K42:27)
		
		//______________________________________________________
	: (Form event code:C388=On Clicked:K2:4)
		
		$kTxt_back:=Choose:C955(Is macOS:C1572; ":"; ".\\")
		
		GET LIST ITEM PARAMETER:C985(Form:C1466.buildApp; *; "type"; $Txt_type)
		
		Case of 
				
				//______________________________________________________
			: ($Txt_type="path.folder")
				
				$Txt_buffer:=Select folder:C670(Get localized string:C991("selectFolder"); 1)
				
				If (OK=1)
					
					<>Txt_value:=$Txt_buffer
					
				End if 
				
				//______________________________________________________
			: ($Txt_type="path.exe")
				
				$Txt_buffer:=Select document:C905(1; ""; Get localized string:C991("selectExe"); Package selection:K24:9+Use sheet window:K24:11)
				
				If (OK=1)
					
					<>Txt_value:=DOCUMENT
					
				End if 
				
				//______________________________________________________
				
			Else 
				
				$Txt_buffer:=Select document:C905(1; Replace string:C233($Txt_type; "path.file"; ""); Get localized string:C991("selectFile"); Package open:K24:8+Use sheet window:K24:11)
				
				If (OK=1)
					
					<>Txt_value:=DOCUMENT
					
				End if 
				
				//______________________________________________________
		End case 
		
		If (OK=1)
			
			_o_doc_OBJET_LOCATION(<>Txt_value; "element.unlock.path.Button"; On Load:K2:1; -1)
			
			$Txt_structureFolderPath:=Path to object:C1547(Storage:C1525.environment.databaseFolder).parentFolder
			$Txt_commonPath:=_o_doc_getCommonPath($Txt_structureFolderPath; <>Txt_value)
			
			If ($Txt_commonPath=$Txt_structureFolderPath)
				
				$Txt_path:=Replace string:C233(<>Txt_value; $Txt_commonPath; Choose:C955(Is Windows:C1573; "..\\"; "::"))
				
			Else 
				
				$Txt_structureFolderPath:=Replace string:C233($Txt_structureFolderPath; $Txt_commonPath; "")
				$Lon_back:=Length:C16($Txt_structureFolderPath)-Length:C16(Replace string:C233($Txt_structureFolderPath; Folder separator:K24:12; ""))
				
				$Txt_path:=($kTxt_back[[1]]*$Lon_back)
				
				If (Is Windows:C1573)
					
					$Txt_path:=$Txt_path+"\\"
					
				End if 
				
				$Txt_path:=$Txt_path+Replace string:C233(<>Txt_value; $Txt_commonPath; "")
				
			End if 
		End if 
		
		buildApp_SET_ELEMENT($Txt_path)
		
		//______________________________________________________
		
	Else 
		
		ASSERT:C1129(False:C215; "Form event activated unnecessary ("+String:C10(Form event code:C388)+")")
		
		//______________________________________________________
End case 