//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : PHP_zip_archive_to
  // Database: 4DPop AppMaker
  // ID[26B6ADC57828401E8D7C88C3F9F92D46]
  // Created #16-6-2010 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_BOOLEAN:C305($0)
C_TEXT:C284($1)
C_TEXT:C284($2)

C_BOOLEAN:C305($Boo_result)
C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($File_script;$File_target;$Txt_source;$Txt_stdOut)

ARRAY TEXT:C222($tTxt_errorLabels;0)
ARRAY TEXT:C222($tTxt_errorValues;0)
ARRAY TEXT:C222($tTxt_headerHTTPName;0)
ARRAY TEXT:C222($tTxt_headerHTTPValue;0)

If (False:C215)
	C_BOOLEAN:C305(PHP_zip_archive_to ;$0)
	C_TEXT:C284(PHP_zip_archive_to ;$1)
	C_TEXT:C284(PHP_zip_archive_to ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=2;"Missing parameter"))
	
	  //Required parameters
	$Txt_source:=$1
	$File_target:=$2
	
	  //Optional parameters
	If ($Lon_parameters>=3)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
ASSERT:C1129((Count parameters:C259>0);Get localized string:C991("a file path was expected."))
ASSERT:C1129((Count parameters:C259>1);Get localized string:C991("a directory path was expected."))

$File_script:=Get 4D folder:C485(Current resources folder:K5:16)+"PHP"+Folder separator:K24:12+"zip_archive_to.php"

SET ENVIRONMENT VARIABLE:C812("ZIP_SOURCE";Convert path system to POSIX:C1106($Txt_source))
SET ENVIRONMENT VARIABLE:C812("ZIP_DESTINATION";Convert path system to POSIX:C1106($File_target))

PHP SET OPTION:C1059(PHP raw result:K64:2;True:C214)

If (PHP Execute:C1058($File_script;"";$Boo_result))
	
	$0:=$Boo_result
	
Else 
	
	PHP GET FULL RESPONSE:C1061($Txt_stdOut;$tTxt_errorLabels;$tTxt_errorValues;$tTxt_headerHTTPName;$tTxt_headerHTTPValue)
	
End if 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End